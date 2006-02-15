From: Ben Skeggs <darktama@iinet.net.au>
Subject: Re: IPv6 state match - possible bug.
Date: Wed, 15 Feb 2006 14:15:29 +1100
Message-ID: <1139973329.9018.2.camel@araqiel.keine.ath.cx>
References: <1139891071.26079.11.camel@araqiel.keine.ath.cx>
	<200602140647.k1E6lerK011885@toshiba.co.jp>
	<1139965907.8973.1.camel@araqiel.keine.ath.cx>
	<200602141843.k1EIhnqD012520@toshiba.co.jp>
Reply-To: darktama@iinet.net.au
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200602141843.k1EIhnqD012520@toshiba.co.jp>
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

On Wed, 2006-02-15 at 03:43 +0900, Yasuyuki KOZAKAI wrote:
> Hi, Ben,
> 
> From: Ben Skeggs <darktama@iinet.net.au>
> Date: Wed, 15 Feb 2006 12:11:47 +1100
> 
> > > > > Sorry, right sysctl is
> > > > > 
> > > > >   	echo 255 > /proc/sys/net/netfilter/nf_conntrack_log_invalid
> > > > Okay, seems there is an issue somewhere..  I'm using 2.6.16-rc3, and
> > > > also had the same issue with -rc2.  iptables is version 1.3.5.
> > > > 
> > > > nf_ct_tcp: bad TCP checksum IN= OUT=
> > > > SRC=2001:0200:0000:8002:0203:47ff:fea5:3085
> > > > DST=2001:0388:c17d:0000:020f:eaff:fe70:ebf9 LEN=80 TC=0 HOPLIMIT=56
> > > > FLOWLBL=525788 PROTO=TCP SPT=80 DPT=52498 SEQ=1589838125 ACK=2289866071
> > > > WINDOW=57344 RES=0x00 ACK SYN URGP=0 OPT
> > > > (020405A0010303000101080A2DA73166049359BE)
> > > 
> > > checksumming with your eth0 driver might be broken.
> > > I'm not sure why, but I saw some reports about checksum for a few weeks.
> > Thank you!  This was indeed the problem.
> 
> Finally I got time to check codes for this and found bug.
> If you have some time, could you try attached patch ?
> I tested with sky2, but it's great if I can confirm that it works fine
> with other device.
I applied your patch to 2.6.16-rc3, and swapped back to the skge chip, I
seem to have working IPv6 state matching now.  I set
nf_conntrack_log_invalid again, and have not seen any invalid packet
messages on dmesg at all.

Thanks for checking this out for me!

Ben Skeggs.
> 
> > I swapped from my onboard Yukon (skge driver), to the nvidia card
> > (forcedeth driver) and everything seems to work correctly now.
> > 
> > Sorry for the noise!
> 
> No. Thanks a lot for this report.
> 
> -- Yasuyuki Kozakai
> plain text document attachment (nfct_checksum.patch)
> [NETFILTER] nf_conntrack: Fix TCP/UDP checksum handling for IPv6 packet
> 
> If skb->ip_summed is CHECKSUM_HW here, skb->csum includes checksum
> of actual IPv6 header and extension headers. Then such excess
> checksum must be subtruct when nf_conntrack calculates TCP/UDP checksum
> with psuedo IPv6 header.
> 
> Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
> 
> ---
> commit 7f5523d7f49865e62b683b0519408cf15a5b5624
> tree e79868f93168aadd3e07e96605c351009019197f
> parent 5552c28f6937d2a2b873d06c6d09b96204722dd0
> author <kozakai@camellia.isl.rdc.toshiba.co.jp> Wed, 15 Feb 2006 03:16:28 +0900
> committer <kozakai@camellia.isl.rdc.toshiba.co.jp> Wed, 15 Feb 2006 03:16:28 +0900
> 
>  net/netfilter/nf_conntrack_proto_tcp.c |    4 +++-
>  net/netfilter/nf_conntrack_proto_udp.c |    4 +++-
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -864,7 +864,9 @@ static int csum6(const struct sk_buff *s
>  {
>  	return csum_ipv6_magic(&skb->nh.ipv6h->saddr, &skb->nh.ipv6h->daddr,
>  			       skb->len - dataoff, IPPROTO_TCP,
> -			       skb->ip_summed == CHECKSUM_HW ? skb->csum
> +			       skb->ip_summed == CHECKSUM_HW
> +			       ? csum_sub(skb->csum,
> +					  skb_checksum(skb, 0, dataoff, 0))
>  			       : skb_checksum(skb, dataoff, skb->len - dataoff,
>  					      0));
>  }
> diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
> --- a/net/netfilter/nf_conntrack_proto_udp.c
> +++ b/net/netfilter/nf_conntrack_proto_udp.c
> @@ -161,7 +161,9 @@ static int csum6(const struct sk_buff *s
>  {
>  	return csum_ipv6_magic(&skb->nh.ipv6h->saddr, &skb->nh.ipv6h->daddr,
>  			       skb->len - dataoff, IPPROTO_UDP,
> -			       skb->ip_summed == CHECKSUM_HW ? skb->csum
> +			       skb->ip_summed == CHECKSUM_HW
> +			       ? csum_sub(skb->csum,
> +					  skb_checksum(skb, 0, dataoff, 0))
>  			       : skb_checksum(skb, dataoff, skb->len - dataoff,
>  					      0));
>  }
