From: Patrick McHardy <kaber@trash.net>
Subject: Re: Checksum problem in tcp-window-tracking
Date: Sun, 13 Jun 2004 06:28:52 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40CBD804.7060708@trash.net>
References: <1087068742.1019.53.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
 Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1087068742.1019.53.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Martin Josefsson wrote:
> Hi Jozsef
> 
> Upgraded my kernel and started seeing lots of complaints from the
> tcp-window-tracking code.
> 
> I only get the complaints on localhost<->localhost traffic, all other
> traffic is complaint-free and working great :)
> 
> Jun 12 21:14:30 tux ip_conntrack_tcp: INVALID: bad T IN= OUT= MAC=
> SRC=127.0.0.1 DST=127.0.0.1 LEN=93 TOS=00 PREC=0x00 TTL=64 ID=6306 DF
> PROTO=TCP SPT=6667 DPT=32813 SEQ=2226635880 ACK=2237541190 WINDOW=4095
> ACK PSH URGP=0
> 
> "bad T" can only be this code from unclean()
> 
>         /* Checksum invalid?  Ignore. */
>         /* FIXME: Source route IP option packets --RR */
>         if (csum_tcpudp_magic(iph->saddr, iph->daddr,
>                               tcplen, IPPROTO_TCP,
>                               skb->ip_summed == CHECKSUM_HW
>                                 ? skb->csum
>                                 : skb_checksum(skb, iph->ihl*4, tcplen, 0))) {
>                 if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
>                         nf_log_packet(PF_INET, 0, skb, NULL, NULL,
>                                   "ip_conntrack_tcp: INVALID: "
>                                   "bad TCP checksum ");
>                 return 1;
>         }
> 
> According to tcpdump the checksum is correct (otherwise we'd have a
> serious bug in the tcp-stack :)
> 
> Any ideas?
> 

It probably fails on the outgoing path, where the meaning of skb->csum
is different. When CHECKSUM_HW on an outgoing packet is set, the device
should compute and store the checksum at skb->h.raw + skb->csum. tcp
sets CHECKSUM_HW in tcp_sendmsg() and do_tcp_sendpages() when the device
has NETIF_F_NO_CSUM set. Using skb_checksum() unconditionally should
fix it.

Regards
Patrick
