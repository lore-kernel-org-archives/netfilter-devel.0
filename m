From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 14/39]: xt_policy: remove dups in .family
Date: Wed, 20 Sep 2006 10:24:09 +0200 (MEST)
Message-ID: <20060920082500.14636.95503.sendpatchset@localhost.localdomain>
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

[NETFILTER]: xt_policy: remove dups in .family

sparse "defined twice" warning

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4a96b874e237df6f156bd186bf7671da3875ee6a
tree 9f3620858c365d2b6441eeee1e4c369e05962fc7
parent bbd34939b0f748864400c9b12ecc3f43b7dbddc8
author Alexey Dobriyan <adobriyan@gmail.com> Wed, 20 Sep 2006 09:28:59 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:28:59 +0200

 net/netfilter/xt_policy.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_policy.c b/net/netfilter/xt_policy.c
index e9d8137..46bde2b 100644
--- a/net/netfilter/xt_policy.c
+++ b/net/netfilter/xt_policy.c
@@ -171,7 +171,6 @@ static struct xt_match xt_policy_match[]
 		.checkentry 	= checkentry,
 		.match		= match,
 		.matchsize	= sizeof(struct xt_policy_info),
-		.family		= AF_INET,
 		.me		= THIS_MODULE,
 	},
 	{
@@ -180,7 +179,6 @@ static struct xt_match xt_policy_match[]
 		.checkentry	= checkentry,
 		.match		= match,
 		.matchsize	= sizeof(struct xt_policy_info),
-		.family		= AF_INET6,
 		.me		= THIS_MODULE,
 	},
 };
