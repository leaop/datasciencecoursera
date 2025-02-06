getwd()

list.files() 
features <- read.table("features.txt", col.names = c("Index", "Feature"))
activity_labels <- read.table("activity_labels.txt", col.names = c("ActivityID", "Activity"))

subject_train <- read.table("subject_train.txt", col.names = "Subject")
subject_test <- read.table("subject_test.txt", col.names = "Subject")

y_train <- read.table("y_train.txt", col.names = "ActivityID")
y_test <- read.table("y_test.txt", col.names = "ActivityID")

X_train <- read.table("X_train.txt")
X_test <- read.table("X_test.txt")

# Definir nomes das colunas para os dados de treino e teste
colnames(X_train) <- features$Feature
colnames(X_test) <- features$Feature

# Unir os conjuntos de treino e teste
X_data <- rbind(X_train, X_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

# Filtrar apenas as colunas com "mean()" e "std()"
selected_columns <- grep("mean\\(\\)|std\\(\\)", features$Feature)
X_data <- X_data[, selected_columns]

# Substituir IDs das atividades por nomes descritivos
y_data$ActivityID <- factor(y_data$ActivityID, levels = activity_labels$ActivityID, labels = activity_labels$Activity)

# Criar conjunto de dados final combinando sujeito, atividade e medições filtradas
final_data <- cbind(subject_data, y_data, X_data)

install.packages("dplyr")  # Apenas necessário se ainda não estiver instalado
library(dplyr)

str(final_data)
head(final_data)

# Criar um segundo conjunto de dados com a média de cada variável para cada atividade e sujeito
tidy_data <- final_data %>%
  group_by(Subject, ActivityID) %>%
  summarise(across(everything(), mean))

# Salvar o conjunto de dados final como um arquivo CSV
write.table(tidy_data, "tidy_data.txt", row.names = FALSE)

# Exibir a estrutura dos dados finais
str(tidy_data)

print("Script concluído! O arquivo 'tidy_data.txt' foi salvo no diretório.")

