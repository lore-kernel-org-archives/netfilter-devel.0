From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2/4]: Don't exclude local packets from MASQUERADING
Date: Mon, 15 Aug 2005 00:43:51 +0200
Message-ID: <42FFC927.8030801@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
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

[NETFILTER]: Don't exclude local packets from MASQUERADING

Increases consistency in source-address selection.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 17bfdaf02646cc6fafa9fa661e4c6e8775a9af3a
tree 6818c5239c4c5a2deefdb328525e2e9c2bdfdd72
parent 5f234544ded29913154a728719cfcf3cbceb9667
author Patrick McHardy <kaber@trash.net> Mon, 15 Aug 2005 00:32:08 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 15 Aug 2005 00:32:08 +0200

 net/ipv4/netfilter/ipt_MASQUERADE.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -86,11 +86,6 @@ masquerade_target(struct sk_buff **pskb,
 
 	IP_NF_ASSERT(hooknum == NF_IP_POST_ROUTING);
 
-	/* FIXME: For the moment, don't do local packets, breaks
-	   testsuite for 2.3.49 --RR */
-	if ((*pskb)->sk)
-		return NF_ACCEPT;
-
 	ct = ip_conntrack_get(*pskb, &ctinfo);
 	IP_NF_ASSERT(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED
 	                    || ctinfo == IP_CT_RELATED + IP_CT_IS_REPLY));
