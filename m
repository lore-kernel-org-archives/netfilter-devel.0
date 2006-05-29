From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 13/17]: amanda helper: convert to textsearch
	infrastructure
Date: Tue, 30 May 2006 00:34:28 +0200 (MEST)
Message-ID: <20060529223428.24834.87406.sendpatchset@localhost.localdomain>
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

[NETFILTER]: amanda helper: convert to textsearch infrastructure

When a port number within a packet is replaced by a differently sized
number only the packet is resized, but not the copy of the data.
Following port numbers are rewritten based on their offsets within
the copy, leading to packet corruption.

Convert the amanda helper to the textsearch infrastructure to avoid
the copy entirely.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 66a750bcda3b4d3ed7e7b93e190a464fa5ed4dc6
tree 46e3a8dd2788ff0c0f345e15fee05b9bf966342a
parent 782e3aa01e036825fcfc353952d5585a02eb946a
author Patrick McHardy <kaber@trash.net> Tue, 30 May 2006 00:08:27 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 30 May 2006 00:08:27 +0200

 net/ipv4/netfilter/Kconfig               |    2 
 net/ipv4/netfilter/ip_conntrack_amanda.c |  143 ++++++++++++++++++++----------
 2 files changed, 96 insertions(+), 49 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 3d560de..d859754 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -142,6 +142,8 @@ config IP_NF_TFTP
 config IP_NF_AMANDA
 	tristate "Amanda backup protocol support"
 	depends on IP_NF_CONNTRACK
+	select TEXTSEARCH
+	select TEXTSEARCH_KMP
 	help
 	  If you are running the Amanda backup package <http://www.amanda.org/>
 	  on this machine or machines that will be MASQUERADED through this
diff --git a/net/ipv4/netfilter/ip_conntrack_amanda.c b/net/ipv4/netfilter/ip_conntrack_amanda.c
index a604b1c..0a7bd7f 100644
--- a/net/ipv4/netfilter/ip_conntrack_amanda.c
+++ b/net/ipv4/netfilter/ip_conntrack_amanda.c
@@ -17,33 +17,29 @@
  *	this value.
  *
  */
-
-#include <linux/in.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/netfilter.h>
-#include <linux/ip.h>
 #include <linux/moduleparam.h>
+#include <linux/textsearch.h>
+#include <linux/skbuff.h>
+#include <linux/in.h>
+#include <linux/ip.h>
 #include <linux/udp.h>
-#include <net/checksum.h>
-#include <net/udp.h>
 
+#include <linux/netfilter.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/ip_conntrack_amanda.h>
 
 static unsigned int master_timeout = 300;
+static char *ts_algo = "kmp";
 
 MODULE_AUTHOR("Brian J. Murrell <netfilter@interlinx.bc.ca>");
 MODULE_DESCRIPTION("Amanda connection tracking module");
 MODULE_LICENSE("GPL");
 module_param(master_timeout, uint, 0600);
 MODULE_PARM_DESC(master_timeout, "timeout for the master connection");
-
-static const char *conns[] = { "DATA ", "MESG ", "INDEX " };
-
-/* This is slow, but it's simple. --RR */
-static char *amanda_buffer;
-static DEFINE_SPINLOCK(amanda_buffer_lock);
+module_param(ts_algo, charp, 0400);
+MODULE_PARM_DESC(ts_algo, "textsearch algorithm to use (default kmp)");
 
 unsigned int (*ip_nat_amanda_hook)(struct sk_buff **pskb,
 				   enum ip_conntrack_info ctinfo,
@@ -52,12 +48,48 @@ unsigned int (*ip_nat_amanda_hook)(struc
 				   struct ip_conntrack_expect *exp);
 EXPORT_SYMBOL_GPL(ip_nat_amanda_hook);
 
+enum amanda_strings {
+	SEARCH_CONNECT,
+	SEARCH_NEWLINE,
+	SEARCH_DATA,
+	SEARCH_MESG,
+	SEARCH_INDEX,
+};
+
+static struct {
+	char			*string;
+	size_t			len;
+	struct ts_config	*ts;
+} search[] = {
+	[SEARCH_CONNECT] = {
+		.string	= "CONNECT ",
+		.len	= 8,
+	},
+	[SEARCH_NEWLINE] = {
+		.string	= "\n",
+		.len	= 1,
+	},
+	[SEARCH_DATA] = {
+		.string	= "DATA ",
+		.len	= 5,
+	},
+	[SEARCH_MESG] = {
+		.string	= "MESG ",
+		.len	= 5,
+	},
+	[SEARCH_INDEX] = {
+		.string = "INDEX ",
+		.len	= 6,
+	},
+};
+
 static int help(struct sk_buff **pskb,
                 struct ip_conntrack *ct, enum ip_conntrack_info ctinfo)
 {
+	struct ts_state ts;
 	struct ip_conntrack_expect *exp;
-	char *data, *data_limit, *tmp;
-	unsigned int dataoff, i;
+	unsigned int dataoff, start, stop, off, i;
+	char pbuf[sizeof("65535")], *tmp;
 	u_int16_t port, len;
 	int ret = NF_ACCEPT;
 
@@ -77,29 +109,34 @@ static int help(struct sk_buff **pskb,
 		return NF_ACCEPT;
 	}
 
-	spin_lock_bh(&amanda_buffer_lock);
-	skb_copy_bits(*pskb, dataoff, amanda_buffer, (*pskb)->len - dataoff);
-	data = amanda_buffer;
-	data_limit = amanda_buffer + (*pskb)->len - dataoff;
-	*data_limit = '\0';
-
-	/* Search for the CONNECT string */
-	data = strstr(data, "CONNECT ");
-	if (!data)
+	memset(&ts, 0, sizeof(ts));
+	start = skb_find_text(*pskb, dataoff, (*pskb)->len,
+			      search[SEARCH_CONNECT].ts, &ts);
+	if (start == UINT_MAX)
 		goto out;
-	data += strlen("CONNECT ");
+	start += dataoff + search[SEARCH_CONNECT].len;
 
-	/* Only search first line. */	
-	if ((tmp = strchr(data, '\n')))
-		*tmp = '\0';
+	memset(&ts, 0, sizeof(ts));
+	stop = skb_find_text(*pskb, start, (*pskb)->len,
+			     search[SEARCH_NEWLINE].ts, &ts);
+	if (stop == UINT_MAX)
+		goto out;
+	stop += start;
 
-	for (i = 0; i < ARRAY_SIZE(conns); i++) {
-		char *match = strstr(data, conns[i]);
-		if (!match)
+	for (i = SEARCH_DATA; i <= SEARCH_INDEX; i++) {
+		memset(&ts, 0, sizeof(ts));
+		off = skb_find_text(*pskb, start, stop, search[i].ts, &ts);
+		if (off == UINT_MAX)
 			continue;
-		tmp = data = match + strlen(conns[i]);
-		port = simple_strtoul(data, &data, 10);
-		len = data - tmp;
+		off += start + search[i].len;
+
+		len = min_t(unsigned int, sizeof(pbuf) - 1, stop - off);
+		if (skb_copy_bits(*pskb, off, pbuf, len))
+			break;
+		pbuf[len] = '\0';
+
+		port = simple_strtoul(pbuf, &tmp, 10);
+		len = tmp - pbuf;
 		if (port == 0 || len > 5)
 			break;
 
@@ -125,8 +162,7 @@ static int help(struct sk_buff **pskb,
 		exp->mask.dst.u.tcp.port = 0xFFFF;
 
 		if (ip_nat_amanda_hook)
-			ret = ip_nat_amanda_hook(pskb, ctinfo,
-						 tmp - amanda_buffer,
+			ret = ip_nat_amanda_hook(pskb, ctinfo, off - dataoff,
 						 len, exp);
 		else if (ip_conntrack_expect_related(exp) != 0)
 			ret = NF_DROP;
@@ -134,12 +170,11 @@ static int help(struct sk_buff **pskb,
 	}
 
 out:
-	spin_unlock_bh(&amanda_buffer_lock);
 	return ret;
 }
 
 static struct ip_conntrack_helper amanda_helper = {
-	.max_expected = ARRAY_SIZE(conns),
+	.max_expected = 3,
 	.timeout = 180,
 	.me = THIS_MODULE,
 	.help = help,
@@ -155,26 +190,36 @@ static struct ip_conntrack_helper amanda
 
 static void __exit ip_conntrack_amanda_fini(void)
 {
+	int i;
+
 	ip_conntrack_helper_unregister(&amanda_helper);
-	kfree(amanda_buffer);
+	for (i = 0; i < ARRAY_SIZE(search); i++)
+		textsearch_destroy(search[i].ts);
 }
 
 static int __init ip_conntrack_amanda_init(void)
 {
-	int ret;
-
-	amanda_buffer = kmalloc(65536, GFP_KERNEL);
-	if (!amanda_buffer)
-		return -ENOMEM;
-
-	ret = ip_conntrack_helper_register(&amanda_helper);
-	if (ret < 0) {
-		kfree(amanda_buffer);
-		return ret;
+	int ret, i;
+
+	ret = -ENOMEM;
+	for (i = 0; i < ARRAY_SIZE(search); i++) {
+		search[i].ts = textsearch_prepare(ts_algo, search[i].string,
+						  search[i].len,
+						  GFP_KERNEL, TS_AUTOLOAD);
+		if (search[i].ts == NULL)
+			goto err;
 	}
+	ret = ip_conntrack_helper_register(&amanda_helper);
+	if (ret < 0)
+		goto err;
 	return 0;
 
-
+err:
+	for (; i >= 0; i--) {
+		if (search[i].ts)
+			textsearch_destroy(search[i].ts);
+	}
+	return ret;
 }
 
 module_init(ip_conntrack_amanda_init);
