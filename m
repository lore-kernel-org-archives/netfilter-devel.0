From: Patrick McHardy <kaber@trash.net>
Subject: Re: Proposed netmap patch
Date: Sat, 16 Jul 2005 20:18:48 +0200
Message-ID: <42D94F88.7040502@trash.net>
References: <57F9959B46E0FA4D8BA88AEDFBE582907446@pxtbenexd01.pxt.primeexalia.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060306060703050705050804"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Gary W. Smith" <gary@primeexalia.com>
In-Reply-To: <57F9959B46E0FA4D8BA88AEDFBE582907446@pxtbenexd01.pxt.primeexalia.com>
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

This is a multi-part message in MIME format.
--------------060306060703050705050804
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Gary W. Smith schrieb:
> Signed-off-by: Gary Wayne Smith <gary.w.smith@primeexalia.com>

Applied, thanks. I've slightly modified it to break lines at 80
characters and changed the assertion to expect packets in LOCAL_OUT
as well.

Regards
Patrick

--------------060306060703050705050804
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: Make NETMAP target usable in OUTPUT

Signed-off-by: Gary Wayne Smith <gary.w.smith@primeexalia.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 420d86533d641723c1224eb6aed796fb5ea6c0d3
tree 4d03301180389c82220aba920703f68276f00d61
parent 01f7dc836da6aa4434d293671442bbc6d115d02f
author Patrick McHardy <kaber@trash.net> Sat, 16 Jul 2005 20:17:13
committer Gary Wayne Smith <gary.w.smith@primeexalia.com> Sat, 16 Jul 2005 20:17:13

 net/ipv4/netfilter/ipt_NETMAP.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_NETMAP.c b/net/ipv4/netfilter/ipt_NETMAP.c
--- a/net/ipv4/netfilter/ipt_NETMAP.c
+++ b/net/ipv4/netfilter/ipt_NETMAP.c
@@ -46,7 +46,8 @@ check(const char *tablename,
 		DEBUGP(MODULENAME":check: size %u.\n", targinfosize);
 		return 0;
 	}
-	if (hook_mask & ~((1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_POST_ROUTING))) {
+	if (hook_mask & ~((1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_POST_ROUTING) |
+	                  (1 << NF_IP_LOCAL_OUT))) {
 		DEBUGP(MODULENAME":check: bad hooks %x.\n", hook_mask);
 		return 0;
 	}
@@ -76,12 +77,13 @@ target(struct sk_buff **pskb,
 	struct ip_nat_range newrange;
 
 	IP_NF_ASSERT(hooknum == NF_IP_PRE_ROUTING
-		     || hooknum == NF_IP_POST_ROUTING);
+		     || hooknum == NF_IP_POST_ROUTING
+		     || hooknum == NF_IP_LOCAL_OUT);
 	ct = ip_conntrack_get(*pskb, &ctinfo);
 
 	netmask = ~(mr->range[0].min_ip ^ mr->range[0].max_ip);
 
-	if (hooknum == NF_IP_PRE_ROUTING)
+	if (hooknum == NF_IP_PRE_ROUTING || hooknum == NF_IP_LOCAL_OUT)
 		new_ip = (*pskb)->nh.iph->daddr & ~netmask;
 	else
 		new_ip = (*pskb)->nh.iph->saddr & ~netmask;

--------------060306060703050705050804--
