From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/03]: ctnetlink: return EEXIST instead of EINVAL for
	existing nat'ed conntracks
Date: Mon,  6 Aug 2007 15:29:05 +0200 (MEST)
Message-ID: <20070806132847.17202.3321.sendpatchset@localhost.localdomain>
References: <20070806132844.17202.50621.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070806132844.17202.50621.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ctnetlink: return EEXIST instead of EINVAL for existing nat'ed conntracks

ctnetlink must return EEXIST for existing nat'ed conntracks instead of
EINVAL. Only return EINVAL if we try to update a conntrack with NAT
handlings (that is not allowed).

Decadence:libnetfilter_conntrack/utils# ./conntrack_create_nat
TEST: create conntrack (0)(Success)
Decadence:libnetfilter_conntrack/utils# ./conntrack_create_nat
TEST: create conntrack (-1)(Invalid argument)

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 58ff363db6a293220756361af531b11acc5a46e1
tree e94a40ef6d9897c0ac86fe0eedbb9c9d59e3d2b0
parent ab3b4927a235c95684cb571b90a04cf6ea1ef7f9
author Pablo Neira Ayuso <pablo@netfilter.org> Mon, 06 Aug 2007 15:26:39 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 06 Aug 2007 15:26:39 +0200

 net/netfilter/nf_conntrack_netlink.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 6f89b10..2863e72 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1052,17 +1052,18 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	}
 	/* implicit 'else' */
 
-	/* we only allow nat config for new conntracks */
-	if (cda[CTA_NAT_SRC-1] || cda[CTA_NAT_DST-1]) {
-		err = -EINVAL;
-		goto out_unlock;
-	}
-
 	/* We manipulate the conntrack inside the global conntrack table lock,
 	 * so there's no need to increase the refcount */
 	err = -EEXIST;
-	if (!(nlh->nlmsg_flags & NLM_F_EXCL))
-		err = ctnetlink_change_conntrack(nf_ct_tuplehash_to_ctrack(h), cda);
+	if (!(nlh->nlmsg_flags & NLM_F_EXCL)) {
+		/* we only allow nat config for new conntracks */
+		if (cda[CTA_NAT_SRC-1] || cda[CTA_NAT_DST-1]) {
+			err = -EINVAL;
+			goto out_unlock;
+		}
+		err = ctnetlink_change_conntrack(nf_ct_tuplehash_to_ctrack(h),
+						 cda);
+	}
 
 out_unlock:
 	write_unlock_bh(&nf_conntrack_lock);
