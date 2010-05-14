From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter problem
Date: Fri, 14 May 2010 12:59:32 +0200
Message-ID: <4BED2D14.3030405@trash.net>
References: <4BECF572.3030601@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: senthilkumaar2021 <senthilkumaar2021@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42352 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab0ENK7e (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 May 2010 06:59:34 -0400
In-Reply-To: <4BECF572.3030601@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

senthilkumaar2021 wrote:
> Hi
> 
> I am getting the following kernel panic error in kernel 2.6.30.5 while
> running the squid t proxy in bridge mode
> 
> I have used the following iptables 1.4.3 and ebtables rules
> 
> The panic occurs once in 10 -15 hrs
> 
> iptable and ebtables are
> 
> iptables -t mangle -N DIVERT
> iptables -t mangle -A DIVERT -j MARK --set-mark 1
> iptables -t mangle -A DIVERT -j ACCEPT
> 
> iptables -t mangle -A PREROUTING -p tcp -m socket -j DIVERT
> iptables -t mangle -A PREROUTING -p tcp --dport 80 -j TPROXY
> --tproxy-mark 0x1/0x1 --on-port 3129
> 
> ebtables -t broute -A BROUTING -i $CLIENT_IFACE -p ipv4 --ip-proto tcp
> --ip-dport 80 -j redirect --redirect-target DROP
> 
> ebtables -t broute -A BROUTING -i $INET_IFACE -p ipv4 --ip-proto tcp
> --ip-sport 80 -j redirect --redirect-target DROP
> 
> [<ffffffffa03933c2>] ? nf_nat_fn+0x138/0x14e [iptable_nat]
> [<ffffffffa0393585>] ? nf_nat_in+0x2f/0x6e [iptable_nat]
> [<ffffffffa027edaa>] ? br_nf_pre_routing_finish+0x0/0x2c4 [bridge]
> [<ffffffffa027edfa>] br_nf_pre_routing_finish+0x50/0x2c4 [bridge]
> [<ffffffffa027edaa>] ? br_nf_pre_routing_finish+0x0/0x2c4 [bridge]
> [<ffffffff81339a50>] ? nf_hook_slow+0x68/0xc8
> [<ffffffffa027edaa>] ? br_nf_pre_routing_finish+0x0/0x2c4 [bridge]
> [<ffffffffa027f616>] br_nf_pre_routing+0x5a8/0x5c7 [bridge]
> [<ffffffff813399ab>] nf_iterate+0x48/0x85
> [<ffffffffa027a931>] ? br_handle_frame_finish+0x0/0x154 [bridge]
> [<ffffffff81339a50>] nf_hook_slow+0x68/0xc8
> [<ffffffffa027a931>] ? br_handle_frame_finish+0x0/0x154 [bridge]
> [<ffffffffa027ac36>] br_handle_frame+0x1b1/0x1db [bridge]
> [<ffffffff8131d54b>] netif_receive_skb+0x316/0x434
> [<ffffffff8131dbfb>] napi_gro_receive+0x6e/0x83
> [<ffffffffa0125bfe>] e1000_receive_skb+0x5c/0x65 [e1000e]
> [<ffffffffa0125de8>] e1000_clean_rx_irq+0x1e1/0x28f [e1000e]
> [<ffffffffa012730e>] e1000_clean+0x99/0x24a [e1000e]
> [<ffffffff813bcfc5>] ? _spin_unlock_irqrestore+0x2c/0x43
> [<ffffffff8131ba62>] net_rx_action+0xb8/0x1b4
> [<ffffffff8104ed43>] __do_softirq+0x99/0x152
> [<ffffffff8101284c>] call_softirq+0x1c/0x30
> [<ffffffff81013a02>] do_softirq+0x52/0xb9
> [<ffffffff8104e969>] irq_exit+0x53/0x8d
> [<ffffffff81013d1a>] do_IRQ+0x135/0x157
> [<ffffffff81011f93>] ret_from_intr+0x0/0x2e
> <EOI> [<ffffffff81017e20>] ? mwait_idle+0x9e/0xc7
> [<ffffffff81017e17>] ? mwait_idle+0x95/0xc7
> [<ffffffff813bfd20>] ? atomic_notifier_call_chain+0x13/0x15
> [<ffffffff810102f4>] ? enter_idle+0x27/0x29
> 
> 
> Please help me in fixing the issue

Please send the full panic output.
