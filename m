From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 4/*]: Fix do_add_counters race, possible oops or info
 leak (CVE-2006-0039)
Date: Fri, 19 May 2006 03:21:50 +0200
Message-ID: <446D1DAE.6020108@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="02.diff"
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

[NETFILTER]: Fix do_add_counters race, possible oops or info leak (CVE-2006-0039)

Solar Designer found a race condition in do_add_counters(). The beginning
of paddc is supposed to be the same as tmp which was sanity-checked
above, but it might not be the same in reality. In case the integer
overflow and/or the race condition are triggered, paddc->num_counters
might not match the allocation size for paddc. If the check below
(t->private->number != paddc->num_counters) nevertheless passes (perhaps
this requires the race condition to be triggered), IPT_ENTRY_ITERATE()
would read kernel memory beyond the allocation size, potentially causing
an oops or leaking sensitive data (e.g., passwords from host system or
from another VPS) via counter increments. This requires CAP_NET_ADMIN.

Signed-off-by: Solar Designer <solar@openwall.com>
Signed-off-by: Kirill Korotaev <dev@openvz.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f372e5df6ab4cd1e1498489562af2095fb5aec7c
tree 11f4cb613372c0bf1e565e36bbed1104172e2731
parent 326640604c2d35b4b93808fc478e337a9f94414c
author Kirill Korotaev <dev@openvz.org> Fri, 19 May 2006 03:08:55 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 19 May 2006 03:08:55 +0200

 net/ipv4/netfilter/arp_tables.c |    2 +-
 net/ipv6/netfilter/ip6_tables.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index c2d92f9..d0d1919 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -948,7 +948,7 @@ static int do_add_counters(void __user *
 
 	write_lock_bh(&t->lock);
 	private = t->private;
-	if (private->number != paddc->num_counters) {
+	if (private->number != tmp.num_counters) {
 		ret = -EINVAL;
 		goto unlock_up_free;
 	}
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 0a67303..2e72f89 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1103,7 +1103,7 @@ do_add_counters(void __user *user, unsig
 
 	write_lock_bh(&t->lock);
 	private = t->private;
-	if (private->number != paddc->num_counters) {
+	if (private->number != tmp.num_counters) {
 		ret = -EINVAL;
 		goto unlock_up_free;
 	}
