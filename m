From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 5/7]: Missing owner-field initialization in ip6table_raw
Date: Tue, 21 Jun 2005 01:04:22 +0200
Message-ID: <42B74B76.1070805@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="05.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="05.diff"
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

[NETFILTER]: Missing owner-field initialization in ip6table_raw

I missed this one when fixing up iptable_raw.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 2976a51fd8ab66770b1b3083ffaa41bd05d70e1e
tree 1aff9696e4fe8368fc9bf5ac4bcb8c89982e91ad
parent 9b4be665b104791bd5605849391ed7123e14edd8
author Patrick McHardy <kaber@trash.net> Mon, 20 Jun 2005 18:50:47
committer Patrick McHardy <kaber@trash.net> Mon, 20 Jun 2005 18:50:47

 net/ipv6/netfilter/ip6table_raw.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -129,13 +129,15 @@ static struct nf_hook_ops ip6t_ops[] = {
 	  .hook = ip6t_hook, 
 	  .pf = PF_INET6,
 	  .hooknum = NF_IP6_PRE_ROUTING,
-	  .priority = NF_IP6_PRI_FIRST
+	  .priority = NF_IP6_PRI_FIRST,
+	  .owner = THIS_MODULE,
 	},
 	{
 	  .hook = ip6t_hook, 
 	  .pf = PF_INET6, 
 	  .hooknum = NF_IP6_LOCAL_OUT,
-	  .priority = NF_IP6_PRI_FIRST
+	  .priority = NF_IP6_PRI_FIRST,
+	  .owner = THIS_MODULE,
 	},
 };
 
