From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH 4/4] conntrack ftp helper modification to use new infrastrure
Date: Sun, 09 Jan 2005 23:23:43 +0100
Message-ID: <41E1AEEF.9050005@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060700060605040309030907"
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------060700060605040309030907
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Attached the modifications for the ftp helper to use the functions 
provided with the new infrastructure.

Two important notes:

* I must confess that I don't see the point of using the new 
infrastructure at all for the ftp helper (no way, I didn't drive nuts, 
not yet :o) but I see that it could be useful for the amanda helper 
which does a strstr search. So, please consider this just an example, 
read and drop it to /dev/null.
* This doesn't apply on top of lastest rusty's helper simplifications.

--
Pablo

--------------060700060605040309030907
Content-Type: text/x-patch;
 name="string-ftp.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="string-ftp.patch"

===== net/ipv4/netfilter/ip_conntrack_ftp.c 1.24 vs edited =====
--- 1.24/net/ipv4/netfilter/ip_conntrack_ftp.c	2004-10-20 10:12:06 +02:00
+++ edited/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-01-09 21:57:27 +01:00
@@ -20,17 +20,17 @@
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/ip_conntrack_ftp.h>
 #include <linux/moduleparam.h>
+#include <linux/netfilter_ipv4/nf_string_match.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Rusty Russell <rusty@rustcorp.com.au>");
 MODULE_DESCRIPTION("ftp connection tracking helper");
 
-/* This is slow, but it's simple. --RR */
-static char ftp_buffer[65536];
-
 static DECLARE_LOCK(ip_ftp_lock);
 struct module *ip_conntrack_ftp = THIS_MODULE;
 
+#define FTP_BUFSIZE 64
+
 #define MAX_PORTS 8
 static int ports[MAX_PORTS];
 static int ports_c;
@@ -56,30 +56,35 @@
 	char skip;
 	char term;
 	enum ip_ct_ftp_type ftptype;
+	struct nf_string_match *sm;
 	int (*getnum)(const char *, size_t, u_int32_t[], char);
 } search[] = {
 	{
 		IP_CT_DIR_ORIGINAL,
 		"PORT",	sizeof("PORT") - 1, ' ', '\r',
 		IP_CT_FTP_PORT,
+		NULL,
 		try_rfc959,
 	},
 	{
 		IP_CT_DIR_REPLY,
 		"227 ",	sizeof("227 ") - 1, '(', ')',
 		IP_CT_FTP_PASV,
+		NULL,
 		try_rfc959,
 	},
 	{
 		IP_CT_DIR_ORIGINAL,
 		"EPRT", sizeof("EPRT") - 1, ' ', '\r',
 		IP_CT_FTP_EPRT,
+		NULL,
 		try_eprt,
 	},
 	{
 		IP_CT_DIR_REPLY,
 		"229 ", sizeof("229 ") - 1, '(', ')',
 		IP_CT_FTP_EPSV,
+		NULL,
 		try_epsv_response,
 	},
 };
@@ -188,15 +193,19 @@
 }
 
 /* Return 1 for match, 0 for accept, -1 for partial. */
-static int find_pattern(const char *data, size_t dlen,
+static int find_pattern(const struct sk_buff *skb, size_t dlen,
 			const char *pattern, size_t plen,
 			char skip, char term,
 			unsigned int *numoff,
 			unsigned int *numlen,
 			u_int32_t array[6],
+			struct nf_string_match *sm,
 			int (*getnum)(const char *, size_t, u_int32_t[], char))
 {
-	size_t i;
+	size_t i, size;
+	unsigned char *data = NULL;
+	unsigned int offset = 0;
+	unsigned char __data[FTP_BUFSIZE];
 
 	DEBUGP("find_pattern `%s': dlen = %u\n", pattern, dlen);
 	if (dlen == 0)
@@ -209,33 +218,31 @@
 		else return 0;
 	}
 
-	if (strnicmp(data, pattern, plen) != 0) {
-#if 0
-		size_t i;
-
-		DEBUGP("ftp: string mismatch\n");
-		for (i = 0; i < plen; i++) {
-			DEBUGP("ftp:char %u `%c'(%u) vs `%c'(%u)\n",
-				i, data[i], data[i],
-				pattern[i], pattern[i]);
-		}
-#endif
+	if (!nf_string_match_search(skb, sm, &offset))
 		return 0;
-	}
 
+	if ((size = (skb->len - offset - 1)) > (FTP_BUFSIZE - 1))
+		size = FTP_BUFSIZE - 1;
+			
+	data = skb_header_pointer(skb, offset, size, __data);
+	BUG_ON(data == NULL);
+	
 	DEBUGP("Pattern matches!\n");
 	/* Now we've found the constant string, try to skip
 	   to the 'skip' character */
-	for (i = plen; data[i] != skip; i++)
+	for (i = plen; i < size && data[i] != skip; i++)
 		if (i == dlen - 1) return -1;
 
 	/* Skip over the last character */
 	i++;
 
+	if (i >= size)
+		return -1;
+
 	DEBUGP("Skipped up to `%c'!\n", skip);
 
 	*numoff = i;
-	*numlen = getnum(data + i, dlen - i, array, term);
+	*numlen = getnum(data + i, size - i, array, term);
 	if (!*numlen)
 		return -1;
 
@@ -249,7 +256,7 @@
 {
 	unsigned int dataoff, datalen;
 	struct tcphdr _tcph, *th;
-	char *fb_ptr;
+	char *fb_ptr, __fb_ptr;
 	u_int32_t old_seq_aft_nl;
 	int old_seq_aft_nl_set, ret;
 	u_int32_t array[6] = { 0 };
@@ -283,15 +290,14 @@
 	datalen = skb->len - dataoff;
 
 	LOCK_BH(&ip_ftp_lock);
-	fb_ptr = skb_header_pointer(skb, dataoff,
-				    skb->len - dataoff, ftp_buffer);
+	fb_ptr = skb_header_pointer(skb, skb->len - 1, 1, &__fb_ptr);
 	BUG_ON(fb_ptr == NULL);
 
 	old_seq_aft_nl_set = ct_ftp_info->seq_aft_nl_set[dir];
 	old_seq_aft_nl = ct_ftp_info->seq_aft_nl[dir];
 
 	DEBUGP("conntrack_ftp: datalen %u\n", datalen);
-	if (fb_ptr[datalen - 1] == '\n') {
+	if (*fb_ptr == '\n') {
 		DEBUGP("conntrack_ftp: datalen %u ends in \\n\n", datalen);
 		if (!old_seq_aft_nl_set
 		    || after(ntohl(th->seq) + datalen, old_seq_aft_nl)) {
@@ -321,13 +327,14 @@
 	for (i = 0; i < ARRAY_SIZE(search); i++) {
 		if (search[i].dir != dir) continue;
 
-		found = find_pattern(fb_ptr, skb->len - dataoff,
+		found = find_pattern(skb, skb->len - dataoff,
 				     search[i].pattern,
 				     search[i].plen,
 				     search[i].skip,
 				     search[i].term,
 				     &matchoff, &matchlen,
 				     array,
+				     search[i].sm,
 				     search[i].getnum);
 		if (found) break;
 	}
@@ -419,6 +426,8 @@
 				ports[i]);
 		ip_conntrack_helper_unregister(&ftp[i]);
 	}
+	for (i = 0; i < 4; i++)
+		nf_string_match_destroy(search[i].sm);
 }
 
 static int __init init(void)
@@ -428,6 +437,16 @@
 
 	if (ports_c == 0)
 		ports[ports_c++] = FTP_PORT;
+
+	for (i = 0; i < 4; i++) {
+		search[i].sm = nf_string_match_create(search[i].pattern,
+						      search[i].plen);
+		if (!search[i].sm) {
+			int k;
+			for (k = i - 1; k > 0; k--)
+				nf_string_match_destroy(search[k].sm);
+		}
+	}
 
 	for (i = 0; i < ports_c; i++) {
 		ftp[i].tuple.src.u.tcp.port = htons(ports[i]);

--------------060700060605040309030907--
