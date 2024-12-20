import SwiftUI

struct QuizListView: View {
    
    @Environment(QuizzesModel.self) var quizzesModel

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                // Título grande en la parte superior
                Text("Quizzes")
                    .font(.system(size: 34, weight: .bold)) // Escalable
                    .padding(.leading)
                    .foregroundColor(.blue)

                // Contador de quizzes acertados
                HStack {
                    VStack(alignment: .leading) {
                        Text("Quizzes acertados")
                            .font(.headline)
                            .foregroundColor(.white)
                            .bold()
                        Text("\(quizzesModel.contador.count)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 40)) // Tamaño dinámico
                        .foregroundColor(.white)
                }
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(15)
                .shadow(radius: 4)
                .padding([.top, .horizontal])

                // Lista de quizzes
                List {
                    ForEach(quizzesModel.quizzes) { quiz in
                        NavigationLink(destination: QuizjugarView(quiz: quiz)) {
                            HStack(alignment: .center, spacing: 15) {
                                // Imagen adjunta del quiz en forma circular
                                if let url = quiz.attachment?.url {
                                    AsyncImage(url: url) { image in
                                        image.resizable()
                                            .scaledToFit()
                                            .frame(width: 60, height: 60) // Escalable
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                                    } placeholder: {
                                        ProgressView()
                                    }
                                } else {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.gray)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(quiz.question)
                                        .font(.headline)
                                        .foregroundColor(.blue)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(2)
                                        .padding(8)
                                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.blue.opacity(0.1)))

                                    HStack(spacing: 12) {
                                        // Foto del autor
                                        if let authorPhotoURL = quiz.author?.photo?.url {
                                            AsyncImage(url: authorPhotoURL) { phase in
                                                switch phase {
                                                case .empty:
                                                    ProgressView()
                                                case .success(let image):
                                                    image.resizable()
                                                        .scaledToFit()
                                                        .frame(width: 30, height: 30)
                                                        .clipShape(Circle())
                                                        .overlay(Circle().stroke(Color.blue, lineWidth: 1))
                                                case .failure:
                                                    Image(systemName: "person.crop.circle.fill")
                                                        .resizable()
                                                        .frame(width: 30, height: 30)
                                                        .foregroundColor(.gray)
                                                @unknown default:
                                                    EmptyView()
                                                }
                                            }
                                        } else {
                                            Image(systemName: "person.crop.circle.fill")
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Text(quiz.author?.profileName ?? "Desconocido")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                Spacer()
                                Image(systemName: quiz.favourite ? "star.fill" : "star")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.blue.opacity(0.05)))
                            .overlay(
                                RoundedRectangle(cornerRadius: 15).stroke(Color.blue.opacity(0.4), lineWidth: 1)
                            )
                            .shadow(color: Color.blue.opacity(0.2), radius: 5, x: 0, y: 3)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.white]), startPoint: .top, endPoint: .bottom))
            .onAppear {
                quizzesModel.load()
            }
        }
    }
}

