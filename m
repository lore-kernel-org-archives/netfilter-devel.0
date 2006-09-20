From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 09/39]: x_tables: small check_entry & module_refcount
	cleanup
Date: Wed, 20 Sep 2006 10:24:02 +0200 (MEST)
Message-ID: <20060920082454.14636.23144.sendpatchset@localhost.localdomain>
References: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
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

[NETFILTER]: x_tables: small check_entry & module_refcount cleanup

While standard_target has target->me == NULL, module_put() should be
called for it as for others, because there were try_module_get() before.

Signed-off-by: Dmitry Mishin <dim@openvz.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ac65877cea178bc9100074a0f778e01761be8634
tree eb19de08a1671d1a4cbec06b4cd10fcc97156236
parent 488390a83da9b1bee0eabf6bf31d9fd1bca88b7d
author Dmitry Mishin <dim@openvz.org> Wed, 20 Sep 2006 09:28:30 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:28:30 +0200

 net/ipv4/netfilter/arp_tables.c |    2 +-
 net/ipv4/netfilter/ip_tables.c  |    2 +-
 net/ipv6/netfilter/ip6_tables.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index aaeaa9c..85f0d73 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -485,7 +485,7 @@ static inline int check_entry(struct arp
 	if (t->u.kernel.target == &arpt_standard_target) {
 		if (!standard_check(t, size)) {
 			ret = -EINVAL;
-			goto out;
+			goto err;
 		}
 	} else if (t->u.kernel.target->checkentry
 		   && !t->u.kernel.target->checkentry(name, e, target, t->data,
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index a0f3680..38e1e4f 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -573,7 +573,7 @@ check_entry(struct ipt_entry *e, const c
 	if (t->u.kernel.target == &ipt_standard_target) {
 		if (!standard_check(t, size)) {
 			ret = -EINVAL;
-			goto cleanup_matches;
+			goto err;
 		}
 	} else if (t->u.kernel.target->checkentry
 		   && !t->u.kernel.target->checkentry(name, e, target, t->data,
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 73d477c..4ab368f 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -610,7 +610,7 @@ check_entry(struct ip6t_entry *e, const 
 	if (t->u.kernel.target == &ip6t_standard_target) {
 		if (!standard_check(t, size)) {
 			ret = -EINVAL;
-			goto cleanup_matches;
+			goto err;
 		}
 	} else if (t->u.kernel.target->checkentry
 		   && !t->u.kernel.target->checkentry(name, e, target, t->data,
