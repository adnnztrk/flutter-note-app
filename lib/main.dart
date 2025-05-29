import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(NotUygulamasi());
}

class NotUygulamasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Not Uygulaması',
      debugShowCheckedModeBanner: false,
      home: NotlarSayfasi(),
    );
  }
}

class NotlarSayfasi extends StatefulWidget {
  @override
  _NotlarSayfasiState createState() => _NotlarSayfasiState();
}

class _NotlarSayfasiState extends State<NotlarSayfasi> {
  List<String> notlar = []; // Notları burada tutuyoruz
  TextEditingController kontrolcu = TextEditingController();

  @override
  void initState() {
    super.initState();
    _notlariYukle();
  }

  Future<void> _notlariYukle() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notlar = prefs.getStringList('notlar') ?? [];
    });
  }

  Future<void> _notlariKaydet() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('notlar', notlar);
  }

  void notEkle(String not) {
    setState(() {
      notlar.add(not);
    });
    kontrolcu.clear();
    _notlariKaydet();
  }

  void notSil(int index) {
    setState(() {
      notlar.removeAt(index);
    });
    _notlariKaydet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text("Notlarım"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: kontrolcu,
              decoration: InputDecoration(
                hintText: 'Not girin',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (kontrolcu.text.isNotEmpty) {
                      notEkle(kontrolcu.text);
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1,
              ),
              padding: const EdgeInsets.all(8.0),
              itemCount: notlar.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPress: () async {
                    final shouldDelete = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Notu Sil'),
                        content: Text('Bu notu silmek istediğinize emin misiniz?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('Vazgeç'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text('Sil'),
                          ),
                        ],
                      ),
                    );
                    if (shouldDelete == true) {
                      notSil(index);
                    }
                  },
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notlar[index],
                            style: TextStyle(fontSize: 18),
                            maxLines: 8,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
