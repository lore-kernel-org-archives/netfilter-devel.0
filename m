From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Eepro, Badness in local_bh_enable
Date: Tue, 13 Jul 2004 11:59:28 +0200 (CEST)
Sender: linux-net-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0407131157470.973-100000@filer.marasystems.com>
References: <20040713092618.07882a20.leeloo@phreaker.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Kent Friis <leeloo@phreaker.net>, <linux-net@vger.kernel.org>
Return-path: <linux-net-owner@vger.kernel.org>
To: Netfilter Developers <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20040713092618.07882a20.leeloo@phreaker.net>
List-Id: netfilter-devel.vger.kernel.org

>From the trace it looks like this may be a problem with ip_conntrack.

Regards
Henrik

On Tue, 13 Jul 2004, Kent Friis wrote:

> I use an old eepro ISA card for my ADSL, and after upgrading to 2.6, from
> time to time I get the following message. It keeps working afterwards, but
> it's like everything stops (or slows down) for about half a second when it
> happens.
> 
> Running 2.6.7 on a P3-600 / Intel 440BX.
> 
> I'm not subscribed to the list, so if you need more info, e-mail is the way
> to go.
> 
> Badness in local_bh_enable at kernel/softirq.c:136
>  [<c011614c>] local_bh_enable+0x38/0x58
>  [<c026e4f1>] destroy_conntrack+0x95/0xd0
>  [<c022faab>] __kfree_skb+0xcb/0xe0
>  [<d086478e>] eepro_send_packet+0x112/0x144 [eepro]
>  [<c023bd2e>] qdisc_restart+0x4e/0xc8
>  [<c02336fd>] dev_queue_xmit+0xcd/0x1c4
>  [<c0237e60>] neigh_resolve_output+0x11c/0x174
>  [<c0246624>] ip_finish_output2+0x134/0x190
>  [<c02464f0>] ip_finish_output2+0x0/0x190
>  [<c023b261>] nf_hook_slow+0xa5/0xf0
>  [<c0244547>] ip_finish_output+0x1d3/0x1dc
>  [<c02464f0>] ip_finish_output2+0x0/0x190
>  [<c023b224>] nf_hook_slow+0x68/0xf0
>  [<c0244716>] ip_output+0x6e/0x74
>  [<c024648f>] dst_output+0x17/0x30
>  [<c0246478>] dst_output+0x0/0x30
>  [<c023b261>] nf_hook_slow+0xa5/0xf0
>  [<c02460dd>] ip_push_pending_frames+0x2f9/0x3a4
>  [<c0246478>] dst_output+0x0/0x30
>  [<c024643e>] ip_send_reply+0x19e/0x1d8
>  [<c0118c92>] __mod_timer+0x76/0x88
>  [<c02594fd>] tcp_v4_send_reset+0x111/0x130
>  [<c025a8d7>] tcp_v4_rcv+0x543/0x74c
>  [<c0241e88>] ip_local_deliver_finish+0x0/0x188
>  [<c0241e88>] ip_local_deliver_finish+0x0/0x188
>  [<c0241f6f>] ip_local_deliver_finish+0xe7/0x188
>  [<c0241e88>] ip_local_deliver_finish+0x0/0x188
>  [<c023b261>] nf_hook_slow+0xa5/0xf0
>  [<c0242010>] ip_rcv_finish+0x0/0x1e0
>  [<c0241acc>] ip_local_deliver+0x1d0/0x1d8
>  [<c0241e88>] ip_local_deliver_finish+0x0/0x188
>  [<c02421a9>] ip_rcv_finish+0x199/0x1e0
>  [<c0242010>] ip_rcv_finish+0x0/0x1e0
>  [<c023b261>] nf_hook_slow+0xa5/0xf0
>  [<c0241e4e>] ip_rcv+0x37a/0x3b4
>  [<c0242010>] ip_rcv_finish+0x0/0x1e0
>  [<c0233bb0>] netif_receive_skb+0x13c/0x16c
>  [<c0233c4d>] process_backlog+0x6d/0x100
>  [<c0233d50>] net_rx_action+0x70/0xf0
>  [<c01160aa>] __do_softirq+0x3a/0x7c
>  [<c011610e>] do_softirq+0x22/0x28
>  [<c01059cd>] do_IRQ+0xe1/0xf4
>  [<c0101f30>] default_idle+0x0/0x28
>  [<c0104308>] common_interrupt+0x18/0x20
>  [<c0101f30>] default_idle+0x0/0x28
>  [<c0101f53>] default_idle+0x23/0x28
>  [<c0101fce>] cpu_idle+0x32/0x40
>  [<c0100345>] rest_init+0x19/0x1c
>  [<c03a0573>] start_kernel+0x137/0x13c
> -
> To unsubscribe from this list: send the line "unsubscribe linux-net" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

