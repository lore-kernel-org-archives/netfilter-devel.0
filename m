From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: IPv6 state match - possible bug.
Date: Wed, 15 Feb 2006 13:32:26 +0900 (JST)
Message-ID: <200602150432.k1F4WRJE027201@toshiba.co.jp>
References: <1139965907.8973.1.camel@araqiel.keine.ath.cx>
	<200602141843.k1EIhnqD012520@toshiba.co.jp>
	<1139973329.9018.2.camel@araqiel.keine.ath.cx>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Wed_Feb_15_13_32_26_2006_682)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: darktama@iinet.net.au, kaber@trash.net, laforge@gnumonks.org
In-Reply-To: <1139973329.9018.2.camel@araqiel.keine.ath.cx>
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

----Next_Part(Wed_Feb_15_13_32_26_2006_682)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

From: Ben Skeggs <darktama@iinet.net.au>
Date: Wed, 15 Feb 2006 14:15:29 +1100

> > > > checksumming with your eth0 driver might be broken.
> > > > I'm not sure why, but I saw some reports about checksum for a few weeks.
> > > Thank you!  This was indeed the problem.
> > 
> > Finally I got time to check codes for this and found bug.
> > If you have some time, could you try attached patch ?
> > I tested with sky2, but it's great if I can confirm that it works fine
> > with other device.
> I applied your patch to 2.6.16-rc3, and swapped back to the skge chip, I
> seem to have working IPv6 state matching now.  I set
> nf_conntrack_log_invalid again, and have not seen any invalid packet
> messages on dmesg at all.

Thanks for test. Harald or Patrick, please apply attached patch.
# I've added "Spotted by Ben Skeggs" to previous one.

-- Yasuyuki Kozakai

----Next_Part(Wed_Feb_15_13_32_26_2006_682)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="nfct_checksum.patch"

[NETFILTER] nf_conntrack: Fix TCP/UDP checksum handling for IPv6 packet

If skb->ip_summed is CHECKSUM_HW here, skb->csum includes checksum
of actual IPv6 header and extension headers. Then such excess
checksum must be subtruct when nf_conntrack calculates TCP/UDP checksum
with psuedo IPv6 header. Spotted by Ben Skeggs.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 7f5523d7f49865e62b683b0519408cf15a5b5624
tree e79868f93168aadd3e07e96605c351009019197f
parent 5552c28f6937d2a2b873d06c6d09b96204722dd0
author <kozakai@camellia.isl.rdc.toshiba.co.jp> Wed, 15 Feb 2006 03:16:28 +0900
committer <kozakai@camellia.isl.rdc.toshiba.co.jp> Wed, 15 Feb 2006 03:16:28 +0900

 net/netfilter/nf_conntrack_proto_tcp.c |    4 +++-
 net/netfilter/nf_conntrack_proto_udp.c |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -864,7 +864,9 @@ static int csum6(const struct sk_buff *s
 {
 	return csum_ipv6_magic(&skb->nh.ipv6h->saddr, &skb->nh.ipv6h->daddr,
 			       skb->len - dataoff, IPPROTO_TCP,
-			       skb->ip_summed == CHECKSUM_HW ? skb->csum
+			       skb->ip_summed == CHECKSUM_HW
+			       ? csum_sub(skb->csum,
+					  skb_checksum(skb, 0, dataoff, 0))
 			       : skb_checksum(skb, dataoff, skb->len - dataoff,
 					      0));
 }
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -161,7 +161,9 @@ static int csum6(const struct sk_buff *s
 {
 	return csum_ipv6_magic(&skb->nh.ipv6h->saddr, &skb->nh.ipv6h->daddr,
 			       skb->len - dataoff, IPPROTO_UDP,
-			       skb->ip_summed == CHECKSUM_HW ? skb->csum
+			       skb->ip_summed == CHECKSUM_HW
+			       ? csum_sub(skb->csum,
+					  skb_checksum(skb, 0, dataoff, 0))
 			       : skb_checksum(skb, dataoff, skb->len - dataoff,
 					      0));
 }

----Next_Part(Wed_Feb_15_13_32_26_2006_682)----
