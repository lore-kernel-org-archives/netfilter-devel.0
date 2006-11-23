From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 2/2]: conntrack: add '_get' to {ip, nf}_conntrack_expect_find
Date: Fri, 24 Nov 2006 08:15:37 +0900 (JST)
Message-ID: <200611232315.kANNFdSJ006900@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net, pablo@netfilter.org
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


# Sorry, I forgot netfilter-devel, so resend.

We usually uses 'xxx_find_get' for function which increments
reference count.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit dda5f174719c09ae88354d92a336592311768a4e
tree 219ccccc676c489e9e58b64195fcfbebf9e1e072
parent 139a3c05b435f47cfd26eba62c0e04b35bb5d9d3
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 24 Nov 2006 07:15:38 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 24 Nov 2006 07:15:38 +0900

 include/linux/netfilter_ipv4/ip_conntrack.h   |    2 +-
 include/net/netfilter/nf_conntrack.h          |    2 +-
 net/ipv4/netfilter/ip_conntrack_core.c        |    2 +-
 net/ipv4/netfilter/ip_conntrack_helper_pptp.c |    4 ++--
 net/ipv4/netfilter/ip_conntrack_netlink.c     |    4 ++--
 net/ipv4/netfilter/ip_conntrack_standalone.c  |    2 +-
 net/ipv4/netfilter/ip_nat_helper_pptp.c       |    2 +-
 net/netfilter/nf_conntrack_core.c             |    2 +-
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
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 1fbd819..69677ff 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -212,7 +212,7 @@ extern struct nf_conntrack_expect *
 __nf_conntrack_expect_find(const struct nf_conntrack_tuple *tuple);
 
 extern struct nf_conntrack_expect *
-nf_conntrack_expect_find(const struct nf_conntrack_tuple *tuple);
+nf_conntrack_expect_find_get(const struct nf_conntrack_tuple *tuple);
 
 extern void nf_ct_unlink_expect(struct nf_conntrack_expect *exp);
 
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
index 262d0d4..78bad56 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -1256,7 +1256,7 @@ ctnetlink_get_expect(struct sock *ctnl,
 	if (err < 0)
 		return err;
 
-	exp = ip_conntrack_expect_find(&tuple);
+	exp = ip_conntrack_expect_find_get(&tuple);
 	if (!exp)
 		return -ENOENT;
 
@@ -1310,7 +1310,7 @@ ctnetlink_del_expect(struct sock *ctnl,
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
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index de0567b..8c11349 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -477,7 +477,7 @@ __nf_conntrack_expect_find(const struct
 
 /* Just find a expectation corresponding to a tuple. */
 struct nf_conntrack_expect *
-nf_conntrack_expect_find(const struct nf_conntrack_tuple *tuple)
+nf_conntrack_expect_find_get(const struct nf_conntrack_tuple *tuple)
 {
 	struct nf_conntrack_expect *i;
 	
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 77a46ee..7233655 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1283,7 +1283,7 @@ ctnetlink_get_expect(struct sock *ctnl,
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
index 5954f67..2c1ad22 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -894,7 +894,7 @@ EXPORT_SYMBOL(__nf_conntrack_find);
 EXPORT_SYMBOL(nf_ct_unlink_expect);
 EXPORT_SYMBOL(nf_conntrack_hash_insert);
 EXPORT_SYMBOL(__nf_conntrack_expect_find);
-EXPORT_SYMBOL(nf_conntrack_expect_find);
+EXPORT_SYMBOL(nf_conntrack_expect_find_get);
 EXPORT_SYMBOL(nf_conntrack_expect_list);
 #if defined(CONFIG_NF_CT_NETLINK) || \
     defined(CONFIG_NF_CT_NETLINK_MODULE)
