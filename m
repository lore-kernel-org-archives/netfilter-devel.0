From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 7/9]: Wait for untracked references in nf_conntrack
	module unload
Date: Sun, 04 Dec 2005 22:01:24 +0100
Message-ID: <20051204210124.24032.98517.sendpatchset@localhost.localdomain>
References: <20051204210116.24032.9802.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David S. Miller <davem@davemloft.net>
In-Reply-To: <20051204210116.24032.9802.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Wait for untracked references in nf_conntrack module unload

Noticed by Pablo Neira <pablo@eurodev.net>.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 96c75906027f008ed3a4058a606938901e9c6d99
tree 87b8bb22d35f61383fbb5f4ee6164a16cc256bb3
parent aea6c7fa24378c7f38026177c0b524719789b4be
author Patrick McHardy <kaber@trash.net> Sun, 04 Dec 2005 17:22:02 +0100
committer Patrick McHardy <kaber@trash.net> Sun, 04 Dec 2005 17:22:02 +0100

 net/netfilter/nf_conntrack_core.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 1da6783..a99285d 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1383,6 +1383,9 @@ void nf_conntrack_cleanup(void)
 		schedule();
 		goto i_see_dead_people;
 	}
+	/* wait until all references to nf_conntrack_untracked are dropped */
+	while (atomic_read(&nf_conntrack_untracked.ct_general.use) > 1)
+		schedule();
 
 	for (i = 0; i < NF_CT_F_NUM; i++) {
 		if (nf_ct_cache[i].use == 0)
