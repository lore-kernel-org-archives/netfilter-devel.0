From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 18/33]: conntrack: add '_get' to {ip,
	nf}_conntrack_expect_find
Date: Wed, 29 Nov 2006 03:09:11 +0100 (MET)
Message-ID: <20061129020911.21082.96863.sendpatchset@localhost.localdomain>
References: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
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

[NETFILTER]: conntrack: add '_get' to {ip, nf}_conntrack_expect_find

We usually uses 'xxx_find_get' for function which increments
reference count.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit c75fb025856b71ab4a7ceb837f77932c0ccd4b5d
tree 53dfe6884b52037b1b4b3875def5c09a4a046f17
parent f47bd635aca86e2410a66822cec2c85de4a06ae4
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Tue, 28 Nov 2006 23:13:33 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 29 Nov 2006 02:32:48 +0100

 include/linux/netfilter_ipv4/ip_conntrack.h   |    2 +-
 include/net/netfilter/nf_conntrack_expect.h   |    2 +-
 net/ipv4/netfilter/ip_conntrack_core.c        |    2 +-
 net/ipv4/netfilter/ip_conntrack_helper_pptp.c |    4 ++--
 net/ipv4/netfilter/ip_conntrack_netlink.c     |    4 ++--
 net/ipv4/netfilter/ip_conntrack_standalone.c  |    2 +-
 net/ipv4/netfilter/ip_nat_helper_pptp.c       |    2 +-
 net/netfilter/nf_conntrack_expect.c           |    2 +-
 net/netfilter/nf_conntrack_netlink.c          |    4 ++--
 net/netfilter/nf_conntrack_standalone.c       |    2 +-
 10 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_conntrack.h b/include/linux/netfilter_ipv4/ip_conntrack.h
index 64e8680..61da569 100644
--- a/include/linux/netfilter_ipv4/ip_conntrack.h
+++ b/include/linux/netfilter_ipv4/ip_conntrack.h
@@ -277,7 +277,7 @@ extern struct ip_conntrack_expect *
 __ip_conntrack_expect_find(const struct ip_conntrack_tuple *tuple);
 
 extern struct ip_conntrack_expect *
-ip_conntrack_expect_find(const struct ip_conntrack_tuple *tuple);
+ip_conntrack_expect_find_get(const struct ip_conntrack_tuple *tuple);
 
 extern struct ip_conntrack_tuple_hash *
 __ip_conntrack_find(const struct ip_conntrack_tuple *tuple,
diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 5aa483e..2d335f0 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -53,7 +53,7 @@ struct nf_conntrack_expect *
 __nf_conntrack_expect_find(const struct nf_conntrack_tuple *tuple);
 
 struct nf_conntrack_expect *
-nf_conntrack_expect_find(const struct nf_conntrack_tuple *tuple);
+nf_conntrack_expect_find_get(const struct nf_conntrack_tuple *tuple);
 
 struct nf_conntrack_expect *
 find_expectation(const struct nf_conntrack_tuple *tuple);
diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
index 8b848aa..4d1f954 100644
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -233,7 +233,7 @@ __ip_conntrack_expect_find(const struct 
 
 /* Just find a expectation corresponding to a tuple. */
 struct ip_conntrack_expect *
-ip_conntrack_expect_find(const struct ip_conntrack_tuple *tuple)
+ip_conntrack_expect_find_get(const struct ip_conntrack_tuple *tuple)
 {
 	struct ip_conntrack_expect *i;
 	
diff --git a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
index a2af5e0..a5c057b 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
@@ -142,7 +142,7 @@ static void pptp_expectfn(struct ip_conn
 		DEBUGP("trying to unexpect other dir: ");
 		DUMP_TUPLE(&inv_t);
 
-		exp_other = ip_conntrack_expect_find(&inv_t);
+		exp_other = ip_conntrack_expect_find_get(&inv_t);
 		if (exp_other) {
 			/* delete other expectation.  */
 			DEBUGP("found\n");
@@ -176,7 +176,7 @@ static int destroy_sibling_or_exp(const 
 		ip_conntrack_put(sibling);
 		return 1;
 	} else {
-		exp = ip_conntrack_expect_find(t);
+		exp = ip_conntrack_expect_find_get(t);
 		if (exp) {
 			DEBUGP("unexpect_related of expect %p\n", exp);
 			ip_conntrack_unexpect_related(exp);
diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index 1bb8ed3..3d277aa 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -1256,7 +1256,7 @@ ctnetlink_get_expect(struct sock *ctnl, 
 	if (err < 0)
 		return err;
 
-	exp = ip_conntrack_expect_find(&tuple);
+	exp = ip_conntrack_expect_find_get(&tuple);
 	if (!exp)
 		return -ENOENT;
 
@@ -1309,7 +1309,7 @@ ctnetlink_del_expect(struct sock *ctnl, 
 			return err;
 
 		/* bump usage count to 2 */
-		exp = ip_conntrack_expect_find(&tuple);
+		exp = ip_conntrack_expect_find_get(&tuple);
 		if (!exp)
 			return -ENOENT;
 
diff --git a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
index 0213575..2df6753 100644
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c
@@ -926,7 +926,7 @@ EXPORT_SYMBOL(__ip_ct_refresh_acct);
 EXPORT_SYMBOL(ip_conntrack_expect_alloc);
 EXPORT_SYMBOL(ip_conntrack_expect_put);
 EXPORT_SYMBOL_GPL(__ip_conntrack_expect_find);
-EXPORT_SYMBOL_GPL(ip_conntrack_expect_find);
+EXPORT_SYMBOL_GPL(ip_conntrack_expect_find_get);
 EXPORT_SYMBOL(ip_conntrack_expect_related);
 EXPORT_SYMBOL(ip_conntrack_unexpect_related);
 EXPORT_SYMBOL_GPL(ip_conntrack_expect_list);
diff --git a/net/ipv4/netfilter/ip_nat_helper_pptp.c b/net/ipv4/netfilter/ip_nat_helper_pptp.c
index 329fdcd..acf55d8 100644
--- a/net/ipv4/netfilter/ip_nat_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_nat_helper_pptp.c
@@ -101,7 +101,7 @@ static void pptp_nat_expected(struct ip_
 
 	DEBUGP("trying to unexpect other dir: ");
 	DUMP_TUPLE(&t);
-	other_exp = ip_conntrack_expect_find(&t);
+	other_exp = ip_conntrack_expect_find_get(&t);
 	if (other_exp) {
 		ip_conntrack_unexpect_related(other_exp);
 		ip_conntrack_expect_put(other_exp);
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 79cfd79..aa5903e 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -68,7 +68,7 @@ __nf_conntrack_expect_find(const struct 
 
 /* Just find a expectation corresponding to a tuple. */
 struct nf_conntrack_expect *
-nf_conntrack_expect_find(const struct nf_conntrack_tuple *tuple)
+nf_conntrack_expect_find_get(const struct nf_conntrack_tuple *tuple)
 {
 	struct nf_conntrack_expect *i;
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index dc08302..7357b8f 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1284,7 +1284,7 @@ ctnetlink_get_expect(struct sock *ctnl, 
 	if (err < 0)
 		return err;
 
-	exp = nf_conntrack_expect_find(&tuple);
+	exp = nf_conntrack_expect_find_get(&tuple);
 	if (!exp)
 		return -ENOENT;
 
@@ -1339,7 +1339,7 @@ ctnetlink_del_expect(struct sock *ctnl, 
 			return err;
 
 		/* bump usage count to 2 */
-		exp = nf_conntrack_expect_find(&tuple);
+		exp = nf_conntrack_expect_find_get(&tuple);
 		if (!exp)
 			return -ENOENT;
 
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 3db24f4..be94b63 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -549,7 +549,7 @@ EXPORT_SYMBOL(__nf_conntrack_find);
 EXPORT_SYMBOL(nf_ct_unlink_expect);
 EXPORT_SYMBOL(nf_conntrack_hash_insert);
 EXPORT_SYMBOL(__nf_conntrack_expect_find);
-EXPORT_SYMBOL(nf_conntrack_expect_find);
+EXPORT_SYMBOL(nf_conntrack_expect_find_get);
 EXPORT_SYMBOL(nf_conntrack_expect_list);
 #if defined(CONFIG_NF_CT_NETLINK) || \
     defined(CONFIG_NF_CT_NETLINK_MODULE)
