import 'package:flutter/material.dart';
import 'package:bootcamp91/product/project_texts.dart';
import 'package:bootcamp91/services/auth_service.dart'; // AuthService'i ekleyin
import 'package:bootcamp91/services/cafe_service.dart'; // CafeService'i ekleyin

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final AuthService _authService = AuthService(); // AuthService örneği oluştur
  final CafeService _cafeService = CafeService(); // CafeService örneği oluştur

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(kToolbarHeight + 70), // AppBar yüksekliği
        child: AppBar(
          title: Text(ProjectTexts().projectName),
          automaticallyImplyLeading: false, // Geri butonunu gizler

          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'logout') {
                  _authService
                      .signOut(context); // AuthService'ten çıkış yapma çağrısı
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: Colors.black,
                        ),
                        SizedBox(width: 8.0),
                        Text('Çıkış Yap'),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ],

          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60.0), // TextField için yükseklik
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Kafe ara',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                ),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<Cafe>>(
        stream: _cafeService.getCafes(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu'));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          List<Cafe> cafes = snapshot.data!;
          return ListView.builder(
            itemCount: cafes.length,
            itemBuilder: (context, index) {
              Cafe cafe = cafes[index];
              return GestureDetector(
                onTap: () {
                  // Buraya kafe tıklanınca yapılacak işlemleri ekleyebilirsiniz
                  // Örneğin, Navigator kullanarak detay sayfasına geçiş yapabilirsiniz
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CafeDetailScreen(cafe: cafe),
                    ),
                  );
                },
                child: Card(
                  color: Colors.white,
                  elevation: 5,
                  margin: EdgeInsets.symmetric(
                      vertical: 8.0), // Kartlar arası boşluk
                  child: Container(
                    height: 150, // Kartın yüksekliğini arttır
                    padding: EdgeInsets.all(16.0), // Kartın iç kenar boşluğu
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Center(
                            child: Image.network(cafe.logoUrl),
                          ),
                        ),
                        SizedBox(
                            height: 8.0), // Logo ile kafe ismi arası boşluk
                        Text(
                          cafe.name,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center, // İsmi ortala
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CafeDetailScreen extends StatelessWidget {
  final Cafe cafe;

  const CafeDetailScreen({Key? key, required this.cafe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cafe.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(cafe.logoUrl),
            SizedBox(height: 16.0),
            Text(
              cafe.name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
