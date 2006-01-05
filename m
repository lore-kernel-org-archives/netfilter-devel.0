From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH] use HOPLIMIT metric as TTL of TCP reset sent by REJECT
 [was: Re: please fix TARPIT]
Date: Thu, 05 Jan 2006 17:08:48 +0900 (JST)
Message-ID: <200601050808.k0588nH1012513@toshiba.co.jp>
References: <20051221.221552.70499588.davem@davemloft.net>
	<Pine.LNX.4.61.0601030833560.23554@yvahk01.tjqt.qr>
	<43BA5E7C.1090008@trash.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Jan__5_17_08_48_2006_401)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <43BA5E7C.1090008@trash.net>
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

----Next_Part(Thu_Jan__5_17_08_48_2006_401)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi,

From: Patrick McHardy <kaber@trash.net>
Date: Tue, 03 Jan 2006 12:22:36 +0100

> Jan Engelhardt wrote:
> >>Recently it was reported that the TARPIT target depends upon the
> >>sysctl_ip_default_ttl symbol which is not exported any longer.
> > 
> > 
> > How about just adding the EXPORT_SYMBOL back. And that all wrapped up in a 
> > nice POM patch. Problem gone. (For the short term.)
> 
> The fix is trivial, so I fixed it the right way (well, without
> testing).

Should ipt_REJECT use metric, too ? ip6_REJECT has already use it.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

BTW, I'm not familiar with TARPIT, but ipt_REJECT seems to have the codes
to fix the other issues David pointed out.

-- Yasuyuki Kozakai

----Next_Part(Thu_Jan__5_17_08_48_2006_401)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="01-reject-ttl.patch"

[NETFILTER] use HOPLIMIT metric as TTL of TCP reset sent by REJECT

HOPLIMIT metric is appropriate to TCP reset sent by REJECT target
than hard-coded max TTL. Thanks to David S. Miller for hint.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit e290cc6158560638d4bd446075322b999485d064
tree 200689991a2cc57710642400db47c649be20c00f
parent 67dbb4ea33731415fe09c62149a34f472719ac1d
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 29 Dec 2005 00:41:51 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 29 Dec 2005 00:41:51 +0900

 net/ipv4/netfilter/ipt_REJECT.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index f057025..6693526 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -203,7 +203,7 @@ static void send_reset(struct sk_buff *o
 						sizeof(struct tcphdr), 0));
 
 	/* Adjust IP TTL, DF */
-	nskb->nh.iph->ttl = MAXTTL;
+	nskb->nh.iph->ttl = dst_metric(nskb->dst, RTAX_HOPLIMIT);
 	/* Set DF, id = 0 */
 	nskb->nh.iph->frag_off = htons(IP_DF);
 	nskb->nh.iph->id = 0;

----Next_Part(Thu_Jan__5_17_08_48_2006_401)----
