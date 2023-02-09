import 'package:election_eth/services/functions.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

class ElectionInfo extends StatefulWidget {
  final Web3Client ethClient;
  String electionName;
  ElectionInfo({Key? key, required this.ethClient, required this.electionName}){print(this.electionName);}

  @override
  State<ElectionInfo> createState() => _ElectionInfoState();
}

class _ElectionInfoState extends State<ElectionInfo> {

  final TextEditingController _addCandidateController = TextEditingController();
  final TextEditingController _authorizeCandidateController = TextEditingController();

  late int totalCandidates ;
  bool gotCandidates = false ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCandidateNum(widget.ethClient).then((value) {
      setState(() {
        gotCandidates = true;
        totalCandidates = value[0].toInt();
      });
    });
    print(widget.electionName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.electionName),
        centerTitle: true,
        actions: [IconButton(onPressed: (){
          // (context as Element).reassemble();
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> super.widget));
          }, icon: const Icon(Icons.refresh))],
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    FutureBuilder<List>(
                      future: getCandidateNum(widget.ethClient),
                      builder: (context, snapshot) {
                        if(snapshot.hasData) {
                          return Text(snapshot.data![0].toString(), style: const TextStyle(
                              fontSize: 50, fontWeight: FontWeight.bold),);
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                    const Text("Total Candidates")
                  ],
                ),
                Column(
                  children: [
                    FutureBuilder<List>(
                        future: getTotalVotes(widget.ethClient),
                        builder: (context, snapshot) {
                          if(snapshot.hasData) {
                            return Text(snapshot.data![0].toString(), style: TextStyle(
                                fontSize: 50, fontWeight: FontWeight.bold),);
                          } else {
                            return CircularProgressIndicator();
                          }
                        }
                    ),
                    const Text("Total Votes")
                  ],
                ),
              ]
            ),
            const SizedBox(height:15,),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: _addCandidateController,
                    decoration: InputDecoration(hintText: 'Enter Candidate name'),
                  ),
                ),
                ElevatedButton(
                    onPressed: (){
                      addCandidate(_addCandidateController.text, widget.ethClient);
                      _addCandidateController.clear();
                    },
                    child: const Text("Add Candidate"))
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: _authorizeCandidateController,
                    decoration: const InputDecoration(hintText: 'Authorize Voter address'),
                  ),
                ),
                ElevatedButton(
                    onPressed: (){
                      authorizeVoter(_authorizeCandidateController.text, widget.ethClient);
                      _addCandidateController.clear();
                    },
                    child: const Text("Authorize"))
              ],
            ),
            const Divider(thickness: 3),
            gotCandidates?
            Expanded(
              // height: 350,
              child: ListView.builder(
                itemCount: totalCandidates,
                itemBuilder: (context,i){
                  return FutureBuilder(
                    future: getCandidates(i, widget.ethClient),
                      builder: (context,snapshot){
                        return snapshot.hasData?
                        // Row(
                        //   children: [
                        //     Text(snapshot.data![0].toString(),style: const TextStyle(fontSize: 20),),
                        //     ElevatedButton(onPressed: (){print("Vote for $i ");}, child: const Text("Vote"))
                        //   ]
                        // )
                        ListTile(
                          title: Text("Name: ${snapshot.data![0]}"),
                          subtitle: Text("Votes: ${snapshot.data![1]}"),
                          trailing: ElevatedButton(
                              onPressed: () async{
                                print("Vote for $i ");
                                await vote(i, widget.ethClient);
                              },
                              child: const Text("Vote")),
                        )
                            :Container();
                      }
                  );
                },

              ),
            ) : const CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
