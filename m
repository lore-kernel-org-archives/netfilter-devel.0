From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 3/5]: Wait until all references to ip_conntrack_untracked
 are dropped on unload
Date: Fri, 22 Jul 2005 09:35:51 +0200
Message-ID: <42E0A1D7.20601@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="03.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

[NETFILTER]: Wait until all references to ip_conntrack_untracked are dropped on unload

Fixes a crash when unloading ip_conntrack.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit dd51c6e4ab8df9819d686b0a88a6d7ec8b3d2b28
tree 1b8d3369a5ffff34a263c2c4fbb206d948178a30
parent ca30527af14847bab487c91df56f99df3c7ad1b2
author Patrick McHardy <kaber@trash.net> Fri, 22 Jul 2005 09:23:28 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 22 Jul 2005 09:23:28 +0200

 net/ipv4/netfilter/ip_conntrack_core.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -1111,6 +1111,9 @@ void ip_conntrack_cleanup(void)
 		schedule();
 		goto i_see_dead_people;
 	}
+	/* wait until all references to ip_conntrack_untracked are dropped */
+	while (atomic_read(&ip_conntrack_untracked.ct_general.use) > 1)
+		schedule();
 
 	kmem_cache_destroy(ip_conntrack_cachep);
 	kmem_cache_destroy(ip_conntrack_expect_cachep);
