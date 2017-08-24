From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 1/4] scanner: Fix for memleak due to unclosed file pointer
Date: Thu, 24 Aug 2017 19:14:10 +0200
Message-ID: <20170824171413.31737-2-phil@nwl.cc>
References: <20170824171413.31737-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:54685 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753416AbdHXROi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2017 13:14:38 -0400
In-Reply-To: <20170824171413.31737-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When including a file, it is opened by fopen() and therefore needs to be
closed after scanning has finished using fclose(), otherwise valgrind
will report a memleak.

This patch changes struct input_descriptor to track the opened FILE
pointer instead of the file descriptor so the pointer is available for
closing in scanner_destroy().

While at it, change erec_print() to work on the open FILE pointer so it
doesn't have to call fileno() in beforehand. And as a little bonus, use
C99 initializer of the buffer to get rid of the call to memset().

Note that it is necessary to call erec_print_list() prior to destroying
the scanner, otherwise it will start manipulating an already freed FILE
pointer (and therefore crash the program).

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/nftables.h |  2 +-
 src/erec.c         | 11 +++++------
 src/main.c         |  2 +-
 src/scanner.l      |  3 ++-
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index c992d30235670..b55e144021870 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -113,7 +113,7 @@ struct input_descriptor {
 	const char			*name;
 	union {
 		const char		*data;
-		int			fd;
+		FILE			*fp;
 	};
 	unsigned int			lineno;
 	unsigned int			column;
diff --git a/src/erec.c b/src/erec.c
index b5964465fbf3d..f62bc78ccdfab 100644
--- a/src/erec.c
+++ b/src/erec.c
@@ -118,7 +118,7 @@ void erec_print(FILE *f, const struct error_record *erec,
 	const struct location *loc = erec->locations, *iloc;
 	const struct input_descriptor *indesc = loc->indesc, *tmp;
 	const char *line = NULL; /* silence gcc */
-	char buf[1024];
+	char buf[1024] = {};
 	char *pbuf = NULL;
 	unsigned int i, end;
 	int l, ret;
@@ -131,14 +131,13 @@ void erec_print(FILE *f, const struct error_record *erec,
 		*strchrnul(line, '\n') = '\0';
 		break;
 	case INDESC_FILE:
-		memset(buf, 0, sizeof(buf));
-		orig_offset = lseek(indesc->fd, 0, SEEK_CUR);
-		lseek(indesc->fd, loc->line_offset, SEEK_SET);
-		ret = read(indesc->fd, buf, sizeof(buf) - 1);
+		orig_offset = ftell(indesc->fp);
+		fseek(indesc->fp, loc->line_offset, SEEK_SET);
+		ret = fread(buf, 1, sizeof(buf) - 1, indesc->fp);
 		if (ret > 0)
 			*strchrnul(buf, '\n') = '\0';
 		line = buf;
-		lseek(indesc->fd, orig_offset, SEEK_SET);
+		fseek(indesc->fp, orig_offset, SEEK_SET);
 		break;
 	case INDESC_INTERNAL:
 	case INDESC_NETLINK:
diff --git a/src/main.c b/src/main.c
index 3519377b6e2c6..21bd74aa5fcf1 100644
--- a/src/main.c
+++ b/src/main.c
@@ -428,8 +428,8 @@ int main(int argc, char * const *argv)
 	if (nft_run(&nft, nf_sock, scanner, &state, &msgs) != 0)
 		rc = NFT_EXIT_FAILURE;
 out:
-	scanner_destroy(scanner);
 	erec_print_list(stderr, &msgs, nft.debug_mask);
+	scanner_destroy(scanner);
 	xfree(buf);
 	cache_release(&nft.cache);
 	iface_cache_release();
diff --git a/src/scanner.l b/src/scanner.l
index d50e2b6710654..25e4eb1c70ec1 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -634,7 +634,7 @@ static struct error_record *scanner_push_file(void *scanner, const char *filenam
 		state->indesc->location = *loc;
 	state->indesc->type	= INDESC_FILE;
 	state->indesc->name	= xstrdup(filename);
-	state->indesc->fd	= fileno(f);
+	state->indesc->fp	= f;
 	init_pos(state);
 	return NULL;
 }
@@ -866,6 +866,7 @@ void scanner_destroy(struct parser_state *scanner)
 		if (inpdesc && inpdesc->name) {
 			xfree(inpdesc->name);
 			inpdesc->name = NULL;
+			fclose(inpdesc->fp);
 		}
 		yypop_buffer_state(scanner);
 	} while (state->indesc_idx--);
-- 
2.13.1

