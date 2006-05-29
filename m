From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 12/17]: FTP helper: search optimization
Date: Tue, 30 May 2006 00:34:27 +0200 (MEST)
Message-ID: <20060529223426.24834.44102.sendpatchset@localhost.localdomain>
References: <20060529223404.24834.30808.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060529223404.24834.30808.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: FTP helper: search optimization

Instead of skipping search entries for the wrong direction simply index
them by direction.

Based on patch by Pablo Neira <pablo@netfilter.org>

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 782e3aa01e036825fcfc353952d5585a02eb946a
tree 3779723e9d6f995a75582dbde1fd82e37986ef4b
parent 1782413b89b52410a4df654860145bc2a27db194
author Patrick McHardy <kaber@trash.net> Tue, 30 May 2006 00:04:35 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 30 May 2006 00:04:35 +0200

 net/ipv4/netfilter/ip_conntrack_ftp.c |   77 ++++++++++++++++++---------------
 net/netfilter/nf_conntrack_ftp.c      |   77 ++++++++++++++++++---------------
 2 files changed, 86 insertions(+), 68 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_ftp.c b/net/ipv4/netfilter/ip_conntrack_ftp.c
index 3e542bf..4dcf526 100644
--- a/net/ipv4/netfilter/ip_conntrack_ftp.c
+++ b/net/ipv4/netfilter/ip_conntrack_ftp.c
@@ -56,37 +56,48 @@ static int try_eprt(const char *, size_t
 static int try_epsv_response(const char *, size_t, u_int32_t [], char);
 
 static const struct ftp_search {
-	enum ip_conntrack_dir dir;
 	const char *pattern;
 	size_t plen;
 	char skip;
 	char term;
 	enum ip_ct_ftp_type ftptype;
 	int (*getnum)(const char *, size_t, u_int32_t[], char);
-} search[] = {
-	{
-		IP_CT_DIR_ORIGINAL,
-		"PORT",	sizeof("PORT") - 1, ' ', '\r',
-		IP_CT_FTP_PORT,
-		try_rfc959,
+} search[IP_CT_DIR_MAX][2] = {
+	[IP_CT_DIR_ORIGINAL] = {
+		{
+			.pattern	=  "PORT",
+			.plen		= sizeof("PORT") - 1,
+			.skip		= ' ',
+			.term		= '\r',
+			.ftptype	= IP_CT_FTP_PORT,
+			.getnum		= try_rfc959,
+		},
+		{
+			.pattern	= "EPRT",
+			.plen		= sizeof("EPRT") - 1,
+			.skip		= ' ',
+			.term		= '\r',
+			.ftptype	= IP_CT_FTP_EPRT,
+			.getnum		= try_eprt,
+		},
 	},
-	{
-		IP_CT_DIR_REPLY,
-		"227 ",	sizeof("227 ") - 1, '(', ')',
-		IP_CT_FTP_PASV,
-		try_rfc959,
-	},
-	{
-		IP_CT_DIR_ORIGINAL,
-		"EPRT", sizeof("EPRT") - 1, ' ', '\r',
-		IP_CT_FTP_EPRT,
-		try_eprt,
-	},
-	{
-		IP_CT_DIR_REPLY,
-		"229 ", sizeof("229 ") - 1, '(', ')',
-		IP_CT_FTP_EPSV,
-		try_epsv_response,
+	[IP_CT_DIR_REPLY] = {
+		{
+			.pattern	= "227 ",
+			.plen		= sizeof("227 ") - 1,
+			.skip		= '(',
+			.term		= ')',
+			.ftptype	= IP_CT_FTP_PASV,
+			.getnum		= try_rfc959,
+		},
+		{
+			.pattern	= "229 ",
+			.plen		= sizeof("229 ") - 1,
+			.skip		= '(',
+			.term		= ')',
+			.ftptype	= IP_CT_FTP_EPSV,
+			.getnum		= try_epsv_response,
+		},
 	},
 };
 
@@ -346,17 +357,15 @@ static int help(struct sk_buff **pskb,
 	array[2] = (ntohl(ct->tuplehash[dir].tuple.src.ip) >> 8) & 0xFF;
 	array[3] = ntohl(ct->tuplehash[dir].tuple.src.ip) & 0xFF;
 
-	for (i = 0; i < ARRAY_SIZE(search); i++) {
-		if (search[i].dir != dir) continue;
-
+	for (i = 0; i < ARRAY_SIZE(search[dir]); i++) {
 		found = find_pattern(fb_ptr, (*pskb)->len - dataoff,
-				     search[i].pattern,
-				     search[i].plen,
-				     search[i].skip,
-				     search[i].term,
+				     search[dir][i].pattern,
+				     search[dir][i].plen,
+				     search[dir][i].skip,
+				     search[dir][i].term,
 				     &matchoff, &matchlen,
 				     array,
-				     search[i].getnum);
+				     search[dir][i].getnum);
 		if (found) break;
 	}
 	if (found == -1) {
@@ -366,7 +375,7 @@ static int help(struct sk_buff **pskb,
 		   this case. */
 		if (net_ratelimit())
 			printk("conntrack_ftp: partial %s %u+%u\n",
-			       search[i].pattern,
+			       search[dir][i].pattern,
 			       ntohl(th->seq), datalen);
 		ret = NF_DROP;
 		goto out;
@@ -426,7 +435,7 @@ static int help(struct sk_buff **pskb,
 	/* Now, NAT might want to mangle the packet, and register the
 	 * (possibly changed) expectation itself. */
 	if (ip_nat_ftp_hook)
-		ret = ip_nat_ftp_hook(pskb, ctinfo, search[i].ftptype,
+		ret = ip_nat_ftp_hook(pskb, ctinfo, search[dir][i].ftptype,
 				      matchoff, matchlen, exp, &seq);
 	else {
 		/* Can't expect this?  Best to drop packet now. */
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index e38a4b5..11d3be2 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -67,37 +67,48 @@ static int try_epsv_response(const char 
 			     char);
 
 static struct ftp_search {
-	enum ip_conntrack_dir dir;
 	const char *pattern;
 	size_t plen;
 	char skip;
 	char term;
 	enum ip_ct_ftp_type ftptype;
 	int (*getnum)(const char *, size_t, struct nf_conntrack_man *, char);
-} search[] = {
-	{
-		IP_CT_DIR_ORIGINAL,
-		"PORT", sizeof("PORT") - 1, ' ', '\r',
-		IP_CT_FTP_PORT,
-		try_rfc959,
+} search[IP_CT_DIR_MAX][2] = {
+	[IP_CT_DIR_ORIGINAL] = {
+		{
+			.pattern	= "PORT",
+			.plen		= sizeof("PORT") - 1,
+			.skip		= ' ',
+			.term		= '\r',
+			.ftptype	= IP_CT_FTP_PORT,
+			.getnum		= try_rfc959,
+		},
+		{
+			.pattern	= "EPRT",
+			.plen		= sizeof("EPRT") - 1,
+			.skip		= ' ',
+			.term		= '\r',
+			.ftptype	= IP_CT_FTP_EPRT,
+			.getnum		= try_eprt,
+		},
 	},
-	{
-		IP_CT_DIR_REPLY,
-		"227 ", sizeof("227 ") - 1, '(', ')',
-		IP_CT_FTP_PASV,
-		try_rfc959,
-	},
-	{
-		IP_CT_DIR_ORIGINAL,
-		"EPRT", sizeof("EPRT") - 1, ' ', '\r',
-		IP_CT_FTP_EPRT,
-		try_eprt,
-	},
-	{
-		IP_CT_DIR_REPLY,
-		"229 ", sizeof("229 ") - 1, '(', ')',
-		IP_CT_FTP_EPSV,
-		try_epsv_response,
+	[IP_CT_DIR_REPLY] = {
+		{
+			.pattern	= "227 ",
+			.plen		= sizeof("227 ") - 1,
+			.skip		= '(',
+			.term		= ')',
+			.ftptype	= IP_CT_FTP_PASV,
+			.getnum		= try_rfc959,
+		},
+		{
+			.pattern	= "229 ",
+			.plen		= sizeof("229 ") - 1,
+			.skip		= '(',
+			.term		= ')',
+			.ftptype	= IP_CT_FTP_EPSV,
+			.getnum		= try_epsv_response,
+		},
 	},
 };
 
@@ -492,17 +503,15 @@ static int help(struct sk_buff **pskb,
 	memcpy(cmd.u3.all, &ct->tuplehash[dir].tuple.src.u3.all,
 	       sizeof(cmd.u3.all));
 
-	for (i = 0; i < ARRAY_SIZE(search); i++) {
-		if (search[i].dir != dir) continue;
-
+	for (i = 0; i < ARRAY_SIZE(search[dir]); i++) {
 		found = find_pattern(fb_ptr, datalen,
-				     search[i].pattern,
-				     search[i].plen,
-				     search[i].skip,
-				     search[i].term,
+				     search[dir][i].pattern,
+				     search[dir][i].plen,
+				     search[dir][i].skip,
+				     search[dir][i].term,
 				     &matchoff, &matchlen,
 				     &cmd,
-				     search[i].getnum);
+				     search[dir][i].getnum);
 		if (found) break;
 	}
 	if (found == -1) {
@@ -512,7 +521,7 @@ static int help(struct sk_buff **pskb,
 		   this case. */
 		if (net_ratelimit())
 			printk("conntrack_ftp: partial %s %u+%u\n",
-			       search[i].pattern,
+			       search[dir][i].pattern,
 			       ntohl(th->seq), datalen);
 		ret = NF_DROP;
 		goto out;
@@ -597,7 +606,7 @@ static int help(struct sk_buff **pskb,
 	/* Now, NAT might want to mangle the packet, and register the
 	 * (possibly changed) expectation itself. */
 	if (nf_nat_ftp_hook)
-		ret = nf_nat_ftp_hook(pskb, ctinfo, search[i].ftptype,
+		ret = nf_nat_ftp_hook(pskb, ctinfo, search[dir][i].ftptype,
 				      matchoff, matchlen, exp, &seq);
 	else {
 		/* Can't expect this?  Best to drop packet now. */
