# List of reads provided
reads <- c('ATTCA', 'ATTGA', 'CATTG', 'CTTAT', 'GATTG', 'TATTT', 
           'TCATT', 'TCTTA', 'TGATT', 'TTATT', 'TTCAT', 'TTCTT', 'TTGAT')

k <- 3  # k-mer length

# Create a set to store the unique edges of the de Bruijn graph
graph <- c()

# Step 1: Find all edges and add them to the graph
for (read in reads) {
  for (i in 1:(nchar(read) - k)) {
    kmer1 <- substr(read, i, i + k - 1)
    kmer2 <- substr(read, i + 1, i + k)
    edge <- paste(kmer1, "->", kmer2)
    graph <- unique(c(graph, edge))
  }
}

# Step 2: Write the edges in Graphviz DOT format
dot_file <- file("de_bruijn_graph.dot", "w")
writeLines("digraph G {", dot_file)

for (edge in graph) {
  kmer1_kmer2 <- unlist(strsplit(edge, " -> "))
  kmer1 <- kmer1_kmer2[1]
  kmer2 <- kmer1_kmer2[2]
  writeLines(paste('    "', kmer1, '" -> "', kmer2, '";', sep=""), dot_file)
}

writeLines("}", dot_file)
close(dot_file)

cat("DOT format graph saved to 'de_bruijn_graph.dot'.\n")

# Step 5: One possible genome sequence
possible_genome <- "GATTGATTCA"
cat("Possible genome sequence:", possible_genome, "\n")
