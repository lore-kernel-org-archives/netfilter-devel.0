From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 6/8]: Don't increase master refcount on expectations
Date: Tue, 06 Sep 2005 19:55:47 +0200
Message-ID: <431DD823.60404@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="06.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="06.diff"
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

[NETFILTER]: Don't increase master refcount on expectations

As it's been discussed [1][2]. We shouldn't increase the master conntrack
refcount for non-fulfilled conntracks. During the conntrack destruction,
the expectations are always killed before the conntrack itself, this
guarantees that there won't be any orphan expectation.

[1]https://lists.netfilter.org/pipermail/netfilter-devel/2005-August/020783.html
[2]https://lists.netfilter.org/pipermail/netfilter-devel/2005-August/020904.html

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 0cec535bc739cac6e928db1c5e178b6a3f72f241
tree 12979d31aecd39078a0c707cf810e15f7d87f222
parent 917240fdfb4a326d7488803be075e60e9fda6a3e
author Pablo Neira Ayuso <pablo@netfilter.org> Sun, 04 Sep 2005 19:46:35 +0200
committer Patrick McHardy <kaber@trash.net> Sun, 04 Sep 2005 19:46:35 +0200

 net/ipv4/netfilter/ip_conntrack_core.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -938,6 +938,9 @@ void ip_conntrack_unexpect_related(struc
 	write_unlock_bh(&ip_conntrack_lock);
 }
 
+/* We don't increase the master conntrack refcount for non-fulfilled
+ * conntracks. During the conntrack destruction, the expectations are 
+ * always killed before the conntrack itself */
 struct ip_conntrack_expect *ip_conntrack_expect_alloc(struct ip_conntrack *me)
 {
 	struct ip_conntrack_expect *new;
@@ -948,17 +951,14 @@ struct ip_conntrack_expect *ip_conntrack
 		return NULL;
 	}
 	new->master = me;
-	atomic_inc(&new->master->ct_general.use);
 	atomic_set(&new->use, 1);
 	return new;
 }
 
 void ip_conntrack_expect_put(struct ip_conntrack_expect *exp)
 {
-	if (atomic_dec_and_test(&exp->use)) {
-		ip_conntrack_put(exp->master);
+	if (atomic_dec_and_test(&exp->use))
 		kmem_cache_free(ip_conntrack_expect_cachep, exp);
-	}
 }
 
 static void ip_conntrack_expect_insert(struct ip_conntrack_expect *exp)
