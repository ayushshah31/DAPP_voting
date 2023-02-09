import 'package:election_eth/pages/electionInfo.dart';
import 'package:election_eth/services/functions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import '../utils/constants.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Client? httpClient;
  Web3Client? ethClient;

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);
    super.initState();
  }

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Start Election"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                filled: true,
                hintText: 'Enter Title',
                // label: Icon(Icons.search),
                prefixIcon: Icon(Icons.search),
                // suffixIcon: IconButton(icon:Icon(Icons.add),onPressed:(){} )
              ),
            ),
            SizedBox(height:20),
            ElevatedButton(
                onPressed: () async{
                  if(_controller.text.length>0){
                    await startElection(_controller.text, ethClient!);
                    print(_controller.text);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ElectionInfo(ethClient: ethClient!, electionName: _controller.text)));
                  }
                },
                child: Text("Start Election")
            )
          ]
        ),
      ),
    );
  }
}
