From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Checksum problem in tcp-window-tracking
Date: Sun, 13 Jun 2004 22:15:16 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0406132208380.11536-100000@blackhole.kfki.hu>
References: <40CBD804.7060708@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Martin Josefsson <gandalf@wlug.westbo.se>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <40CBD804.7060708@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 13 Jun 2004, Patrick McHardy wrote:

> > I only get the complaints on localhost<->localhost traffic, all other
> > traffic is complaint-free and working great :)
> >
> > Jun 12 21:14:30 tux ip_conntrack_tcp: INVALID: bad T IN= OUT= MAC=
> > SRC=127.0.0.1 DST=127.0.0.1 LEN=93 TOS=00 PREC=0x00 TTL=64 ID=6306 DF
> > PROTO=TCP SPT=6667 DPT=32813 SEQ=2226635880 ACK=2237541190 WINDOW=4095
> > ACK PSH URGP=0
> >
> > "bad T" can only be this code from unclean()
> >
> >         /* Checksum invalid?  Ignore. */
> >         /* FIXME: Source route IP option packets --RR */
> >         if (csum_tcpudp_magic(iph->saddr, iph->daddr,
> >                               tcplen, IPPROTO_TCP,
> >                               skb->ip_summed == CHECKSUM_HW
> >                                 ? skb->csum
> >                                 : skb_checksum(skb, iph->ihl*4, tcplen, 0))) {
> >                 if (NET_RATELIMIT(ip_ct_tcp_log_invalid))
> >                         nf_log_packet(PF_INET, 0, skb, NULL, NULL,
> >                                   "ip_conntrack_tcp: INVALID: "
> >                                   "bad TCP checksum ");
> >                 return 1;
> >         }
> >
> > According to tcpdump the checksum is correct (otherwise we'd have a
> > serious bug in the tcp-stack :)
>
> It probably fails on the outgoing path, where the meaning of skb->csum
> is different. When CHECKSUM_HW on an outgoing packet is set, the device
> should compute and store the checksum at skb->h.raw + skb->csum. tcp
> sets CHECKSUM_HW in tcp_sendmsg() and do_tcp_sendpages() when the device
> has NETIF_F_NO_CSUM set. Using skb_checksum() unconditionally should
> fix it.

Thank you both the report and the explanation. I'm going to fix it
by checking the hook in order not to loose the fast path in the
hardware-checksummed case.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
