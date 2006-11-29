From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 11/33]: nf_conntrack: reduce timer updates in
	__nf_ct_refresh_acct()
Date: Wed, 29 Nov 2006 03:09:01 +0100 (MET)
Message-ID: <20061129020900.21082.34544.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: reduce timer updates in __nf_ct_refresh_acct()

Only update the conntrack timer if there's been at least HZ jiffies since
the last update. Reduces the number of del_timer/add_timer cycles from one
per packet to one per connection per second (plus once for each state change
of a connection)

Should handle timer wraparounds and connection timeout changes.

Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5a564daecd5e2cf14dfc657b5fcdb91218324e90
tree cdce6d1b1abbfbedd9b018d97889af766a35bd54
parent 4bbe725325797bfbe6366209b9e974fe4ef0e83b
author Martin Josefsson <gandalf@wlug.westbo.se> Tue, 28 Nov 2006 23:13:05 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 28 Nov 2006 23:57:09 +0100

 net/netfilter/nf_conntrack_core.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 355b330..3e7c0a9 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -864,9 +864,14 @@ void __nf_ct_refresh_acct(struct nf_conn
 		ct->timeout.expires = extra_jiffies;
 		event = IPCT_REFRESH;
 	} else {
-		/* Need del_timer for race avoidance (may already be dying). */
-		if (del_timer(&ct->timeout)) {
-			ct->timeout.expires = jiffies + extra_jiffies;
+		unsigned long newtime = jiffies + extra_jiffies;
+
+		/* Only update the timeout if the new timeout is at least
+		   HZ jiffies from the old timeout. Need del_timer for race
+		   avoidance (may already be dying). */
+		if (newtime - ct->timeout.expires >= HZ
+		    && del_timer(&ct->timeout)) {
+			ct->timeout.expires = newtime;
 			add_timer(&ct->timeout);
 			event = IPCT_REFRESH;
 		}
