From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] clean up for ftp conntrack helper
Date: Thu, 15 Apr 2004 00:08:43 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <407DB66B.9090300@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090303000009020401050601"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org,
 Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------090303000009020401050601
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Harald,

I split the the array of struct ftp_search in two, one for patterns to 
match in IP_CT_DIR_ORIGINAL, and the other for IP_CT_DIR_REPLY. This way 
we save four if's conditions and we only loop twice for every direction 
(worst case).

I also move up if (found==0)  which means that pattern was not found. I 
consider that this is the general case. Am I missing anything?

Some considerations, my patch of the new expectation API must be applied 
before applying this patch. btw, this patch could have some problems with:

http://lists.netfilter.org/pipermail/netfilter-devel/2004-March/014516.html

that patch was already reviewed by Patrick and you. Anyway that one is 
simple so I have no problem in merge them to this one.

regards,
Pablo

--------------090303000009020401050601
Content-Type: text/plain;
 name="ftp_helper.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ftp_helper.patch"

--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_ftp.c	2004-04-14 21:32:58.000000000 +0200
+++ linux-2.6.3-patched/net/ipv4/netfilter/ip_conntrack_ftp.c	2004-04-14 21:32:17.000000000 +0200
@@ -51,38 +51,38 @@
 static int try_epsv_response(const char *, size_t, u_int32_t [], char);
 
 static struct ftp_search {
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
+} search[IP_CT_DIR_MAX][2] = {
+	{ 
+		{
 		"PORT",	sizeof("PORT") - 1, ' ', '\r',
 		IP_CT_FTP_PORT,
 		try_rfc959,
-	},
-	{
-		IP_CT_DIR_REPLY,
-		"227 ",	sizeof("227 ") - 1, '(', ')',
-		IP_CT_FTP_PASV,
-		try_rfc959,
-	},
-	{
-		IP_CT_DIR_ORIGINAL,
+		},
+		{
 		"EPRT", sizeof("EPRT") - 1, ' ', '\r',
 		IP_CT_FTP_EPRT,
 		try_eprt,
-	},
-	{
-		IP_CT_DIR_REPLY,
+		}
+	}
+	,
+	{ 
+		{
+		"227 ", sizeof("227 ") - 1, '(', ')',
+		IP_CT_FTP_PASV,
+		try_rfc959,
+		},
+		{
 		"229 ", sizeof("229 ") - 1, '(', ')',
 		IP_CT_FTP_EPSV,
 		try_epsv_response,
-	},
+		}
+	}
 };
 
 static int try_number(const char *data, size_t dlen, u_int32_t array[],
@@ -314,33 +314,34 @@
 	array[2] = (ntohl(ct->tuplehash[dir].tuple.src.ip) >> 8) & 0xFF;
 	array[3] = ntohl(ct->tuplehash[dir].tuple.src.ip) & 0xFF;
 
-	for (i = 0; i < ARRAY_SIZE(search); i++) {
-		if (search[i].dir != dir) continue;
+	for (i = 0; i < ARRAY_SIZE(search[dir]); i++) {
 
 		found = find_pattern(ftp_buffer, skb->len - dataoff,
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
-	if (found == -1) {
+
+	if (found == 0) { /* General case: No match */
+		ret = NF_ACCEPT;
+		goto out;
+		
+	} else if (found == -1) {
 		/* We don't usually drop packets.  After all, this is
 		   connection tracking, not packet filtering.
 		   However, it is necessary for accurate tracking in
 		   this case. */
 		if (net_ratelimit())
 			printk("conntrack_ftp: partial %s %u+%u\n",
-			       search[i].pattern,
+			       search[dir][i].pattern,
 			       ntohl(tcph.seq), datalen);
 		ret = NF_DROP;
 		goto out;
-	} else if (found == 0) { /* No match */
-		ret = NF_ACCEPT;
-		goto out;
 	}
 
 	DEBUGP("conntrack_ftp: match `%.*s' (%u bytes at %u)\n",
@@ -361,7 +362,7 @@
 	    == ct->tuplehash[dir].tuple.src.ip) {
 		exp->seq = ntohl(tcph.seq) + matchoff;
 		exp_ftp_info->len = matchlen;
-		exp_ftp_info->ftptype = search[i].ftptype;
+		exp_ftp_info->ftptype = search[dir][i].ftptype;
 		exp_ftp_info->port = array[4] << 8 | array[5];
 	} else {
 		/* Enrico Scholz's passive FTP to partially RNAT'd ftp

--------------090303000009020401050601--
