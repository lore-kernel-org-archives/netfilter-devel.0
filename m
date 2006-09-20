From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 13/39]: ip6t_HL: remove write-only variable
Date: Wed, 20 Sep 2006 10:24:08 +0200 (MEST)
Message-ID: <20060920082459.14636.22578.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ip6t_HL: remove write-only variable

Noticed by Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit bbd34939b0f748864400c9b12ecc3f43b7dbddc8
tree 68d33bcbae9b298594ccf3f8bdbc50929d0e60ec
parent 0c081f02b0a8b3a08aa5ddc888f9af834585d431
author Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:28:52 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:28:52 +0200

 net/ipv6/netfilter/ip6t_HL.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_HL.c b/net/ipv6/netfilter/ip6t_HL.c
index e54ea92..435750f 100644
--- a/net/ipv6/netfilter/ip6t_HL.c
+++ b/net/ipv6/netfilter/ip6t_HL.c
@@ -26,7 +26,6 @@ static unsigned int ip6t_hl_target(struc
 {
 	struct ipv6hdr *ip6h;
 	const struct ip6t_HL_info *info = targinfo;
-	u_int16_t diffs[2];
 	int new_hl;
 
 	if (!skb_make_writable(pskb, (*pskb)->len))
@@ -53,11 +52,8 @@ static unsigned int ip6t_hl_target(struc
 			break;
 	}
 
-	if (new_hl != ip6h->hop_limit) {
-		diffs[0] = htons(((unsigned)ip6h->hop_limit) << 8) ^ 0xFFFF;
+	if (new_hl != ip6h->hop_limit)
 		ip6h->hop_limit = new_hl;
-		diffs[1] = htons(((unsigned)ip6h->hop_limit) << 8);
-	}
 
 	return IP6T_CONTINUE;
 }
