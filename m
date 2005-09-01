From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 2/10] symbol to load ip_conntrack or
 nf_conntrack
Date: Thu, 01 Sep 2005 18:14:07 +0900 (JST)
Message-ID: <200509010914.j819E7qZ005294@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Sep__1_18_14_07_2005_883)--"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

----Next_Part(Thu_Sep__1_18_14_07_2005_883)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


In the current, the symbol 'need_ip_conntrack' is used to autoload
ip_conntrack required by matches/targets. This change makes them possible
to autoload ip_conntrack or nf_conntrack according to compile-time choice.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Thu_Sep__1_18_14_07_2005_883)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="02-need_ct.patch"

[NETFILTER] symbol to load ip_conntrack or nf_conntrack

In the current, the symbol 'need_ip_conntrack' is used to autoload
ip_conntrack required by matches/targets. This change makes them possible
to autoload ip_conntrack or nf_conntrack according to compile-time choice.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 80387d5afee17b1f3119aa6d068f6351450bac0e
tree eec2becd0ef69929bf936a1db46c30c579b08c1f
parent 17ddaa82dcf7dd18c35fc16b5ad12690cc2c5e36
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 01 Sep 2005 03:26:03 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 01 Sep 2005 03:26:03 +0900

 include/linux/netfilter/ipv4/nf_conntrack_ipv4.h |    3 +++
 include/linux/netfilter/nf_conntrack.h           |   10 ----------
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c   |    6 +++++-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c   |    6 +++++-
 4 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/include/linux/netfilter/ipv4/nf_conntrack_ipv4.h b/include/linux/netfilter/ipv4/nf_conntrack_ipv4.h
--- a/include/linux/netfilter/ipv4/nf_conntrack_ipv4.h
+++ b/include/linux/netfilter/ipv4/nf_conntrack_ipv4.h
@@ -37,4 +37,7 @@ struct nf_conntrack_ipv4 {
 struct sk_buff *
 nf_ct_ipv4_ct_gather_frags(struct sk_buff *skb);
 
+/* call to create an explicit dependency on nf_conntrack_l3proto_ipv4. */
+extern void need_ip_conntrack(void);
+
 #endif /*_NF_CONNTRACK_IPV4_H*/
diff --git a/include/linux/netfilter/nf_conntrack.h b/include/linux/netfilter/nf_conntrack.h
--- a/include/linux/netfilter/nf_conntrack.h
+++ b/include/linux/netfilter/nf_conntrack.h
@@ -309,16 +309,6 @@ nf_conntrack_expect_event(enum ip_conntr
 			  struct nf_conntrack_expect *exp) {}
 #endif /* CONFIG_NF_CONNTRACK_EVENTS */
 
-/* eg. PROVIDES_CONNTRACK(ftp); */
-#define PROVIDES_CONNTRACK(name)                        \
-        int needs_nf_conntrack_##name;                  \
-        EXPORT_SYMBOL(needs_nf_conntrack_##name)
-
-/*. eg. NEEDS_CONNTRACK(ftp); */
-#define NEEDS_CONNTRACK(name)                                           \
-        extern int needs_nf_conntrack_##name;                           \
-        static int *need_nf_conntrack_##name __attribute_used__ = &needs_nf_conntrack_##name
-
 /* no helper, no nat */
 #define	NF_CT_F_BASIC	0
 /* for helper */
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -563,5 +563,9 @@ static void __exit fini(void)
 module_init(init);
 module_exit(fini);
 
-PROVIDES_CONNTRACK(ipv4);
+void need_ip_conntrack(void)
+{
+}
+
+EXPORT_SYMBOL(need_ip_conntrack);
 EXPORT_SYMBOL(nf_ct_ipv4_gather_frags);
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -549,4 +549,8 @@ static void __exit fini(void)
 module_init(init);
 module_exit(fini);
 
-PROVIDES_CONNTRACK(ipv6);
+void need_ip6_conntrack(void)
+{
+}
+
+EXPORT_SYMBOL(need_ip6_conntrack);

----Next_Part(Thu_Sep__1_18_14_07_2005_883)----
