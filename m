From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 3/8]: Rename misnamed function
Date: Fri, 16 Sep 2005 00:44:44 +0200
Message-ID: <4329F95C.1090601@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="03.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Content-Disposition: inline;
 filename="03.diff"
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

[NETFILTER]: Rename misnamed function

Both __ip_conntrack_expect_find and ip_conntrack_expect_find_get take
a reference to the expectation, the difference is that callers of
__ip_conntrack_expect_find must hold ip_conntrack_lock.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 1305f20c8446e6e944924a93eaf90e1896abf788
tree 174c9c8184ec0cdb3de92530ba3b1ae22d308191
parent 66479fa28dab1e923dd946ae1eafe7cbf89fa9a1
author Patrick McHardy <kaber@trash.net> Thu, 15 Sep 2005 22:40:37 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 15 Sep 2005 22:40:37 +0200

 include/linux/netfilter_ipv4/ip_conntrack.h  |    2 +-
 net/ipv4/netfilter/ip_conntrack_core.c       |    2 +-
 net/ipv4/netfilter/ip_conntrack_netlink.c    |    4 ++--
 net/ipv4/netfilter/ip_conntrack_standalone.c |    4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_conntrack.h b/include/linux/netfilter_ipv4/ip_conntrack.h
--- a/include/linux/netfilter_ipv4/ip_conntrack.h
+++ b/include/linux/netfilter_ipv4/ip_conntrack.h
@@ -384,7 +384,7 @@ extern struct ip_conntrack_expect *
 __ip_conntrack_expect_find(const struct ip_conntrack_tuple *tuple);
 
 extern struct ip_conntrack_expect *
-ip_conntrack_expect_find_get(const struct ip_conntrack_tuple *tuple);
+ip_conntrack_expect_find(const struct ip_conntrack_tuple *tuple);
 
 extern struct ip_conntrack_tuple_hash *
 __ip_conntrack_find(const struct ip_conntrack_tuple *tuple,
diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -233,7 +233,7 @@ __ip_conntrack_expect_find(const struct 
 
 /* Just find a expectation corresponding to a tuple. */
 struct ip_conntrack_expect *
-ip_conntrack_expect_find_get(const struct ip_conntrack_tuple *tuple)
+ip_conntrack_expect_find(const struct ip_conntrack_tuple *tuple)
 {
 	struct ip_conntrack_expect *i;
 	
diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -1270,7 +1270,7 @@ ctnetlink_get_expect(struct sock *ctnl, 
 	if (err < 0)
 		return err;
 
-	exp = ip_conntrack_expect_find_get(&tuple);
+	exp = ip_conntrack_expect_find(&tuple);
 	if (!exp)
 		return -ENOENT;
 
@@ -1318,7 +1318,7 @@ ctnetlink_del_expect(struct sock *ctnl, 
 			return err;
 
 		/* bump usage count to 2 */
-		exp = ip_conntrack_expect_find_get(&tuple);
+		exp = ip_conntrack_expect_find(&tuple);
 		if (!exp)
 			return -ENOENT;
 
diff --git a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c
@@ -993,11 +993,11 @@ EXPORT_SYMBOL(ip_ct_refresh_acct);
 
 EXPORT_SYMBOL(ip_conntrack_expect_alloc);
 EXPORT_SYMBOL(ip_conntrack_expect_put);
-EXPORT_SYMBOL_GPL(ip_conntrack_expect_find_get);
+EXPORT_SYMBOL_GPL(__ip_conntrack_expect_find);
+EXPORT_SYMBOL_GPL(ip_conntrack_expect_find);
 EXPORT_SYMBOL(ip_conntrack_expect_related);
 EXPORT_SYMBOL(ip_conntrack_unexpect_related);
 EXPORT_SYMBOL_GPL(ip_conntrack_expect_list);
-EXPORT_SYMBOL_GPL(__ip_conntrack_expect_find);
 EXPORT_SYMBOL_GPL(ip_ct_unlink_expect);
 
 EXPORT_SYMBOL(ip_conntrack_tuple_taken);
