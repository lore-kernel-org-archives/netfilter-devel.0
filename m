From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] clean up for ftp conntrack helper
Date: Thu, 15 Apr 2004 06:14:39 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <407E0C2F.6070803@trash.net>
References: <407DB66B.9090300@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090903020906070408080007"
Cc: netfilter-devel@lists.netfilter.org,
 Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <407DB66B.9090300@eurodev.net>
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
--------------090903020906070408080007
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Pablo Neira wrote:
> that patch was already reviewed by Patrick and you. Anyway that one is 
> simple so I have no problem in merge them to this one.

The patch looks good to me. I've merged it with the datalen patch and
fixed intendation/removed some newlines, I will add this after giving
it a run tomorrow.

Regards,
Patrick

> 
> regards,
> Pablo


--------------090903020906070408080007
Content-Type: text/x-patch;
 name="ftp_helper.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ftp_helper.patch"

===== net/ipv4/netfilter/ip_conntrack_ftp.c 1.18 vs edited =====
--- 1.18/net/ipv4/netfilter/ip_conntrack_ftp.c	Thu Jan 29 00:59:33 2004
+++ edited/net/ipv4/netfilter/ip_conntrack_ftp.c	Thu Apr 15 06:16:25 2004
@@ -51,38 +51,37 @@
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
-		"PORT",	sizeof("PORT") - 1, ' ', '\r',
-		IP_CT_FTP_PORT,
-		try_rfc959,
-	},
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
+} search[IP_CT_DIR_MAX][2] = {
+	{ 
+		{
+			"PORT",	sizeof("PORT") - 1, ' ', '\r',
+			IP_CT_FTP_PORT,
+			try_rfc959,
+		},
+		{
+			"EPRT", sizeof("EPRT") - 1, ' ', '\r',
+			IP_CT_FTP_EPRT,
+			try_eprt,
+		}
 	},
+	{ 
+		{
+			"227 ", sizeof("227 ") - 1, '(', ')',
+			IP_CT_FTP_PASV,
+			try_rfc959,
+		},
+		{
+			"229 ", sizeof("229 ") - 1, '(', ')',
+			IP_CT_FTP_EPSV,
+			try_epsv_response,
+		}
+	}
 };
 
 static int try_number(const char *data, size_t dlen, u_int32_t array[],
@@ -281,7 +280,7 @@
 	datalen = skb->len - dataoff;
 
 	LOCK_BH(&ip_ftp_lock);
-	skb_copy_bits(skb, dataoff, ftp_buffer, skb->len - dataoff);
+	skb_copy_bits(skb, dataoff, ftp_buffer, datalen);
 
 	old_seq_aft_nl_set = ct_ftp_info->seq_aft_nl_set[dir];
 	old_seq_aft_nl = ct_ftp_info->seq_aft_nl[dir];
@@ -314,33 +313,33 @@
 	array[2] = (ntohl(ct->tuplehash[dir].tuple.src.ip) >> 8) & 0xFF;
 	array[3] = ntohl(ct->tuplehash[dir].tuple.src.ip) & 0xFF;
 
-	for (i = 0; i < ARRAY_SIZE(search); i++) {
-		if (search[i].dir != dir) continue;
-
-		found = find_pattern(ftp_buffer, skb->len - dataoff,
-				     search[i].pattern,
-				     search[i].plen,
-				     search[i].skip,
-				     search[i].term,
+	for (i = 0; i < ARRAY_SIZE(search[dir]); i++) {
+		found = find_pattern(ftp_buffer, datalen,
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
+	if (found == 0) {
+		/* General case: No match */
+		ret = NF_ACCEPT;
+		goto out;
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
@@ -354,7 +353,7 @@
 	    == ct->tuplehash[dir].tuple.src.ip) {
 		exp->seq = ntohl(tcph.seq) + matchoff;
 		exp_ftp_info->len = matchlen;
-		exp_ftp_info->ftptype = search[i].ftptype;
+		exp_ftp_info->ftptype = search[dir][i].ftptype;
 		exp_ftp_info->port = array[4] << 8 | array[5];
 	} else {
 		/* Enrico Scholz's passive FTP to partially RNAT'd ftp

--------------090903020906070408080007--
