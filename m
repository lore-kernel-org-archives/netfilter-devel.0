From: Scott Parlane <scott.parlane@alliedtelesis.co.nz>
Subject: [PATCH] netfilter: ftp helper: Support \n and \r terminators for PORT
Date: Wed, 11 Apr 2018 12:11:47 +1200
Message-ID: <20180411001147.29187-1-scott.parlane@alliedtelesis.co.nz>
Cc: Scott Parlane <scott.parlane@alliedtelesis.co.nz>
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The current code requires \r as the terminator directly
after the last digit, and RFC959 indicates CRLF as the
the terminator.

However, we have seen in the wild a client sending
packets with only \n

Signed-off-by: Scott Parlane <scott.parlane@alliedtelesis.co.nz>
---
 net/netfilter/nf_conntrack_ftp.c | 40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index b666959f17..e15bf351f6 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -56,21 +56,23 @@ unsigned int (*nf_nat_ftp_hook)(struct sk_buff *skb,
 EXPORT_SYMBOL_GPL(nf_nat_ftp_hook);
 
 static int try_rfc959(const char *, size_t, struct nf_conntrack_man *,
-		      char, unsigned int *);
+		      char, char, unsigned int *);
 static int try_rfc1123(const char *, size_t, struct nf_conntrack_man *,
-		       char, unsigned int *);
+		       char, char, unsigned int *);
 static int try_eprt(const char *, size_t, struct nf_conntrack_man *,
-		    char, unsigned int *);
+		    char, char, unsigned int *);
 static int try_epsv_response(const char *, size_t, struct nf_conntrack_man *,
-			     char, unsigned int *);
+			     char, char, unsigned int *);
 
 static struct ftp_search {
 	const char *pattern;
 	size_t plen;
 	char skip;
 	char term;
+	char alt_term;
 	enum nf_ct_ftp_type ftptype;
-	int (*getnum)(const char *, size_t, struct nf_conntrack_man *, char, unsigned int *);
+	int (*getnum)(const char *, size_t, struct nf_conntrack_man *, char,
+		      char, unsigned int *);
 } search[IP_CT_DIR_MAX][2] = {
 	[IP_CT_DIR_ORIGINAL] = {
 		{
@@ -78,6 +80,7 @@ static struct ftp_search {
 			.plen		= sizeof("PORT") - 1,
 			.skip		= ' ',
 			.term		= '\r',
+			.alt_term	= '\n',
 			.ftptype	= NF_CT_FTP_PORT,
 			.getnum		= try_rfc959,
 		},
@@ -119,7 +122,7 @@ get_ipv6_addr(const char *src, size_t dlen, struct in6_addr *dst, u_int8_t term)
 }
 
 static int try_number(const char *data, size_t dlen, u_int32_t array[],
-		      int array_size, char sep, char term)
+		      int array_size, char sep, char term, char alt_term)
 {
 	u_int32_t i, len;
 
@@ -136,7 +139,9 @@ static int try_number(const char *data, size_t dlen, u_int32_t array[],
 			/* Unexpected character; true if it's the
 			   terminator (or we don't care about one)
 			   and we're finished. */
-			if ((*data == term || !term) && i == array_size - 1)
+			if ((*data == term || (alt_term &&
+					       *data == alt_term) || !term) &&
+			    i == array_size - 1)
 				return len;
 
 			pr_debug("Char %u (got %u nums) `%u' unexpected\n",
@@ -152,12 +157,12 @@ static int try_number(const char *data, size_t dlen, u_int32_t array[],
 /* Returns 0, or length of numbers: 192,168,1,1,5,6 */
 static int try_rfc959(const char *data, size_t dlen,
 		      struct nf_conntrack_man *cmd, char term,
-		      unsigned int *offset)
+		      char alt_term, unsigned int *offset)
 {
 	int length;
 	u_int32_t array[6];
 
-	length = try_number(data, dlen, array, 6, ',', term);
+	length = try_number(data, dlen, array, 6, ',', term, alt_term);
 	if (length == 0)
 		return 0;
 
@@ -179,7 +184,7 @@ static int try_rfc959(const char *data, size_t dlen,
  */
 static int try_rfc1123(const char *data, size_t dlen,
 		       struct nf_conntrack_man *cmd, char term,
-		       unsigned int *offset)
+		       char alt_term, unsigned int *offset)
 {
 	int i;
 	for (i = 0; i < dlen; i++)
@@ -191,7 +196,7 @@ static int try_rfc1123(const char *data, size_t dlen,
 
 	*offset += i;
 
-	return try_rfc959(data + i, dlen - i, cmd, 0, offset);
+	return try_rfc959(data + i, dlen - i, cmd, 0, 0, offset);
 }
 
 /* Grab port: number up to delimiter */
@@ -222,7 +227,7 @@ static int get_port(const char *data, int start, size_t dlen, char delim,
 
 /* Returns 0, or length of numbers: |1|132.235.1.2|6275| or |2|3ffe::1|6275| */
 static int try_eprt(const char *data, size_t dlen, struct nf_conntrack_man *cmd,
-		    char term, unsigned int *offset)
+		    char term, char alt_term, unsigned int *offset)
 {
 	char delim;
 	int length;
@@ -251,7 +256,8 @@ static int try_eprt(const char *data, size_t dlen, struct nf_conntrack_man *cmd,
 		u_int32_t array[4];
 
 		/* Now we have IP address. */
-		length = try_number(data + 3, dlen - 3, array, 4, '.', delim);
+		length = try_number(data + 3, dlen - 3, array, 4, '.', delim,
+				    0);
 		if (length != 0)
 			cmd->u3.ip = htonl((array[0] << 24) | (array[1] << 16)
 					   | (array[2] << 8) | array[3]);
@@ -271,7 +277,7 @@ static int try_eprt(const char *data, size_t dlen, struct nf_conntrack_man *cmd,
 /* Returns 0, or length of numbers: |||6446| */
 static int try_epsv_response(const char *data, size_t dlen,
 			     struct nf_conntrack_man *cmd, char term,
-			     unsigned int *offset)
+			     char alt_term, unsigned int *offset)
 {
 	char delim;
 
@@ -289,12 +295,13 @@ static int try_epsv_response(const char *data, size_t dlen,
 static int find_pattern(const char *data, size_t dlen,
 			const char *pattern, size_t plen,
 			char skip, char term,
+			char alt_term,
 			unsigned int *numoff,
 			unsigned int *numlen,
 			struct nf_conntrack_man *cmd,
 			int (*getnum)(const char *, size_t,
 				      struct nf_conntrack_man *, char,
-				      unsigned int *))
+				      char, unsigned int *))
 {
 	size_t i = plen;
 
@@ -337,7 +344,7 @@ static int find_pattern(const char *data, size_t dlen,
 	pr_debug("Skipped up to `%c'!\n", skip);
 
 	*numoff = i;
-	*numlen = getnum(data + i, dlen - i, cmd, term, numoff);
+	*numlen = getnum(data + i, dlen - i, cmd, term, alt_term, numoff);
 	if (!*numlen)
 		return -1;
 
@@ -461,6 +468,7 @@ skip_nl_seq:
 				     search[dir][i].plen,
 				     search[dir][i].skip,
 				     search[dir][i].term,
+				     search[dir][i].alt_term,
 				     &matchoff, &matchlen,
 				     &cmd,
 				     search[dir][i].getnum);
-- 
2.16.1
