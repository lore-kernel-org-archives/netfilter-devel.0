From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 11/14]: Check policy length in policy match strict mode
Date: Fri,  3 Feb 2006 14:44:15 +0100 (MET)
Message-ID: <20060203134415.2141.78756.sendpatchset@localhost.localdomain>
References: <20060203134358.2141.63426.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060203134358.2141.63426.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Check policy length in policy match strict mode

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 0140ae42a6acc87e5c63ac8367473670dcffba8e
tree 0145dfe52711bf0e7d503b3d2a2d2ac603d82ad9
parent 9da97b95715756a28bfc1a931f033db6206d7dfd
author Patrick McHardy <kaber@trash.net> Fri, 03 Feb 2006 12:46:53 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 03 Feb 2006 12:46:53 +0100

 net/ipv4/netfilter/ipt_policy.c  |    2 +-
 net/ipv6/netfilter/ip6t_policy.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_policy.c b/net/ipv4/netfilter/ipt_policy.c
index 18ca825..a48949a 100644
--- a/net/ipv4/netfilter/ipt_policy.c
+++ b/net/ipv4/netfilter/ipt_policy.c
@@ -89,7 +89,7 @@ match_policy_out(const struct sk_buff *s
 			return 0;
 	}
 
-	return strict ? 1 : 0;
+	return strict ? i == info->len : 0;
 }
 
 static int match(const struct sk_buff *skb,
diff --git a/net/ipv6/netfilter/ip6t_policy.c b/net/ipv6/netfilter/ip6t_policy.c
index afe1cc4..9f38cd0 100644
--- a/net/ipv6/netfilter/ip6t_policy.c
+++ b/net/ipv6/netfilter/ip6t_policy.c
@@ -91,7 +91,7 @@ match_policy_out(const struct sk_buff *s
 			return 0;
 	}
 
-	return strict ? 1 : 0;
+	return strict ? i == info->len : 0;
 }
 
 static int match(const struct sk_buff *skb,
