From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/04]: netfilter: xt_u32 bug correction
Date: Tue, 14 Aug 2007 18:40:14 +0200 (MEST)
Message-ID: <20070814164006.14668.26611.sendpatchset@localhost.localdomain>
References: <20070814164004.14668.43960.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070814164004.14668.43960.sendpatchset@localhost.localdomain>
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

[NETFILTER]: netfilter: xt_u32 bug correction

An extraneous ";" makes xt_u32 match useless

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4cbeda3b69e71c535ea820f5a94f4232598e3eea
tree e104d542dfa81fbec1656bce46a32bd0d3cdf10c
parent 39d3520c92cf7a28c07229ca00cc35a1e8026c77
author Eric Dumazet <dada1@cosmosbay.com> Tue, 14 Aug 2007 18:35:02 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 14 Aug 2007 18:35:02 +0200

 net/netfilter/xt_u32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_u32.c b/net/netfilter/xt_u32.c
index 74f9b14..bec4279 100644
--- a/net/netfilter/xt_u32.c
+++ b/net/netfilter/xt_u32.c
@@ -36,7 +36,7 @@ static bool u32_match_it(const struct xt_u32 *data,
 		at  = 0;
 		pos = ct->location[0].number;
 
-		if (skb->len < 4 || pos > skb->len - 4);
+		if (skb->len < 4 || pos > skb->len - 4)
 			return false;
 
 		ret   = skb_copy_bits(skb, pos, &n, sizeof(n));
