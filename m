From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: problem: [PATCH] iptable_REJECT doesn't constructs the tcp
 reset packet cleanly
Date: Tue, 11 Dec 2012 01:58:02 +0100
Message-ID: <20121211005802.GA14525@1984>
References: <CAAFTS2WV4PbnKREaNZNHMSezTPuG-QcUWONd_MnB54KQVks33w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu,
	kaber@trash.net, linux-kernel@vger.kernel.org
To: Mukund Jampala <jbmukund@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59759 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955Ab2LKA6I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Dec 2012 19:58:08 -0500
Content-Disposition: inline
In-Reply-To: <CAAFTS2WV4PbnKREaNZNHMSezTPuG-QcUWONd_MnB54KQVks33w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Mukund,

On Mon, Dec 10, 2012 at 12:48:49PM -0800, Mukund Jampala wrote:
> problem description:
> The problem occurs when iptables constructs the tcp reset packet.
> It doesn't initialize the pointer to the tcp header within the skb.
> When the skb is passed to the ixgbe driver for transmit, the ixgbe
> driver attempts to access the tcp header and crashes.
> Currently, other drivers (such as our 1G e1000e or igb drivers) don't
> access the tcp header on transmit unless the TSO option is turned on.
> See bottom of the email for the patch
> 
> Crash logs:
> <4>nf_conntrack: falling back to vmalloc.
> <4>nf_ct_ftp: Maximum expected value 0 is out of range 1-10, using default 1
> <6>nf_ct_ftp: Maximum expected value 1
> <7>xt_session: session_table_iphash_set: Updating table "session"
> limit from 1000 to 0 and hash size from  1024 to 16384
> <4>xt_session: TS is shut down by configuration data, ts count: 0 len : 0
> <6>entering kxp_ha_port_info
> <6>kxp_ha_port_info, rc = 0
> <6>warning: `netdbg' uses 32-bit capabilities (legacy support in use)
> <4>netlink: 8 bytes leftover after parsing attributes.
> <1>BUG: unable to handle kernel NULL pointer dereference at 0000000d
> <1>IP: [<d081621c>] ixgbe_xmit_frame_ring+0x8cc/0x2260 [ixgbe]
> <4>*pdpt = 0000000085e5d001 *pde = 0000000000000000
> <0>Oops: 0000 [#1] SMP
> <0>last sysfs file:
> /sys/devices/pci0000:00/0000:00:05.0/0000:0b:00.0/0000:0c:09.0/0000:0d:00.0/net/eth15/queues/rx-0/rps_cpus
> <4>Modules linked in: nf_nat_ftp nf_conntrack_ftp sm bwdriver
> vpn_src_get xt_condition xt_duplicate xt_statistic xt_localroute
> xt_RANGEMAP xt_block xt_dos xt_ddos xt_ipsd xt_psd xt_ips xt_MWAN
> xt_LBDNAT slb_probe xt_ipspoof xt_connclassify xt_CONNCLASSIFY
> xt_ALARM xt_session xt_PKTCACHE xt_IPPRECEDENCE xt_EXPIRES xt_policy
> xt_POLICY xt_schedule xt_STP xt_MASTER xt_master xt_classify xt_ifset
> xt_addrpairs iptable_app clstrio clb(P) kxp(P) cls_fw cls_route
> cls_rsvp cls_rsvp6 cls_tcindex cls_u32 sch_cbq sch_dsmark sch_gred
> sch_htb sch_ingress sch_prio sch_red sch_sfq sch_tbf sch_teql
> arpt_ARPPROXY arpt_REPLY arpt_mangle arptable_filter arp_tables
> ipt_REJECT ipt_REDIRECT xt_recent ipt_NETMAP ipt_MASQUERADE ipt_LOG
> xt_iprange ipt_ah ipt_addrtype xt_TRACE xt_TCPMSS xt_tcpmss xt_state
> xt_rateest xt_RATEEST xt_pkttype xt_physdev xt_multiport xt_mark
> xt_mac xt_limit xt_length xt_ipv4options xt_helper xt_hashlimit xt_esp
> xt_DSCP xt_dscp xt_conntrack xt_connmark xt_connbytes xt_comment
> xt_CLASSIFY nf_conntrack_netlink iptable_raw nf_nat_snmp_basic
> nf_nat_tftp nf_conntrack_tftp nf_nat_pptp nf_nat_proto_gre
> nf_conntrack_pptp nf_conntrack_proto_gre nf_nat_irc nf_conntrack_irc
> iptable_filter iptable_nat iptable_mangle nf_nat ip_tables
> nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack compat_xtables
> ip_set_list_set ip_set_hash_netport ip_set_hash_net
> ip_set_hash_ipportip ip_set_hash_ipportnet ip_set_hash_ipport
> ip_set_hash_ip ip_set_bitmap_port ip_set_bitmap_ipmac ip_set_bitmap_ip
> xt_set ip_set nfnetlink ip6table_filter ip6t_ipv6header ebt_arpreply
> 8021q garp ip_gre ebt_mark_m ebt_mark ebt_redirect ebt_dnat ebt_ip
> ebt_arp ebt_snat ebt_vlan ebt_log ebt_fpath ebtable_broute
> ebtable_filter ebtable_nat ebtables bridge stp llc alarm_panic(P)
> alarm(P) tun sled_drv pppoe pppox ppp_deflate ppp_mppe ppp_async
> ppp_generic crc_ccitt slhc plcm_drv e1000e ixgbe mdio igbvf igb
> pkp_drv(P) usb_storage [last unloaded: nf_conntrack_ftp]
> <4>
> <4>Pid: 0, comm: swapper Tainted: P            2.6.35.12 #1 Greencity/Thurley
> <4>EIP: 0060:[<d081621c>] EFLAGS: 00010246 CPU: 16
> <4>EIP is at ixgbe_xmit_frame_ring+0x8cc/0x2260 [ixgbe]
> <4>EAX: c7628820 EBX: 00000007 ECX: 00000000 EDX: 00000000
> <4>ESI: 00000008 EDI: c6882180 EBP: dfc6b000 ESP: ced95c48
> <4> DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> <0>Process swapper (pid: 0, ti=ced94000 task=ced73bd0 task.ti=ced94000)
> <0>Stack:
> <4> cbec7418 c779e0d8 c77cc888 c77cc8a8 0903010a 00000000 c77c0008 00000002
> <4><0> cd4997c0 00000010 dfc6b000 00000000 d0d176c9 c77cc8d8 c6882180 cbec7318
> <4><0> 00000004 00000004 cbec7230 cbec7110 00000000 cbec70c0 c779e000 00000002
> <0>Call Trace:
> <4> [<d0d176c9>] ? 0xd0d176c9
> <4> [<d0d18a4d>] ? 0xd0d18a4d
> <4> [<411e243e>] ? dev_hard_start_xmit+0x218/0x2d7
> <4> [<411f03d7>] ? sch_direct_xmit+0x4b/0x114
> <4> [<411f056a>] ? __qdisc_run+0xca/0xe0
> <4> [<411e28b0>] ? dev_queue_xmit+0x2d1/0x3d0
> <4> [<411e8120>] ? neigh_resolve_output+0x1c5/0x20f
> <4> [<411e94a1>] ? neigh_update+0x29c/0x330
> <4> [<4121cf29>] ? arp_process+0x49c/0x4cd
> <4> [<411f80c9>] ? nf_hook_slow+0x3f/0xac
> <4> [<4121ca8d>] ? arp_process+0x0/0x4cd
> <4> [<4121ca8d>] ? arp_process+0x0/0x4cd
> <4> [<4121c6d5>] ? T.901+0x38/0x3b
> <4> [<4121c918>] ? arp_rcv+0xa3/0xb4
> <4> [<4121ca8d>] ? arp_process+0x0/0x4cd
> <4> [<411e1173>] ? __netif_receive_skb+0x32b/0x346
> <4> [<411e19e1>] ? netif_receive_skb+0x5a/0x5f
> <4> [<411e1ea9>] ? napi_skb_finish+0x1b/0x30
> <4> [<d0816eb4>] ? ixgbe_xmit_frame_ring+0x1564/0x2260 [ixgbe]
> <4> [<41013468>] ? lapic_next_event+0x13/0x16
> <4> [<410429b2>] ? clockevents_program_event+0xd2/0xe4
> <4> [<411e1b03>] ? net_rx_action+0x55/0x127
> <4> [<4102da1a>] ? __do_softirq+0x77/0xeb
> <4> [<4102dab1>] ? do_softirq+0x23/0x27
> <4> [<41003a67>] ? do_IRQ+0x7d/0x8e
> <4> [<41002a69>] ? common_interrupt+0x29/0x30
> <4> [<41007bcf>] ? mwait_idle+0x48/0x4d
> <4> [<4100193b>] ? cpu_idle+0x37/0x4c
> <0>Code: df 09 d7 0f 94 c2 0f b6 d2 e9 e7 fb ff ff 31 db 31 c0 e9 38
> ff ff ff 80 78 06 06 0f 85 3e fb ff ff 8b 7c 24 38 8b 8f b8 00 00 00
> <0f> b6 51 0d f6 c2 01 0f 85 27 fb ff ff 80 e2 02 75 0d 8b 6c 24
> <0>EIP: [<d081621c>] ixgbe_xmit_frame_ring+0x8cc/0x2260 [ixgbe] SS:ESP
> 0068:ced95c48
> <0>CR2: 000000000000000d
> <0>Starting kdump
> 
> # gdb build/objs/ixgbe_main.o
> GNU gdb (GDB) 7.2
> Copyright (C) 2010 Free Software Foundation, Inc.
> License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
> This is free software: you are free to change and redistribute it.
> There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
> and "show warranty" for details.
> This GDB was configured as "--host=i686-build_pc-linux-gnu
> --target=i686-nptl-linux-gnu".
> For bug reporting instructions, please see:
> <http://www.gnu.org/software/gdb/bugs/>...
> Reading symbols from
> /home/mjampala/Workspace//ixgbe/build/objs/ixgbe_main.o...done.
> (gdb) list *(ixgbe_xmit_frame_ring+0x8cc)
> 0x421c is in ixgbe_xmit_frame_ring
> (/home/mjampala/Workspace//ixgbe/build/objs/ixgbe_main.c:7403).
> 7398                    return;
> 7399
> 7400            th = tcp_hdr(skb);
> 7401
> 7402            /* skip this packet since the socket is closing */
> 7403            if (th->fin)
> 7404                    return;
> 7405
> 7406            /* sample on all syn packets or once every atr sample count */
> 7407            if (!th->syn && (ring->atr_count < ring->atr_sample_rate))
> 
> lspci:
> 00:00.0 Class 0600: 8086:3406
> 00:01.0 Class 0604: 8086:3408
> 00:03.0 Class 0604: 8086:340a
> 00:04.0 Class 0604: 8086:340b
> 00:05.0 Class 0604: 8086:340c
> 00:06.0 Class 0604: 8086:340d
> 00:07.0 Class 0604: 8086:340e
> 00:08.0 Class 0604: 8086:340f
> 00:09.0 Class 0604: 8086:3410
> 00:0a.0 Class 0604: 8086:3411
> 00:13.0 Class 0800: 8086:342d
> 00:14.0 Class 0800: 8086:342e
> 00:14.1 Class 0800: 8086:3422
> 00:14.2 Class 0800: 8086:3423
> 00:14.3 Class 0800: 8086:3438
> 00:16.0 Class 0880: 8086:3430
> 00:16.1 Class 0880: 8086:3431
> 00:16.2 Class 0880: 8086:3432
> 00:16.3 Class 0880: 8086:3433
> 00:16.4 Class 0880: 8086:3429
> 00:16.5 Class 0880: 8086:342a
> 00:16.6 Class 0880: 8086:342b
> 00:16.7 Class 0880: 8086:342c
> 00:1a.0 Class 0c03: 8086:3a37
> 00:1a.7 Class 0c03: 8086:3a3c
> 00:1c.0 Class 0604: 8086:3a40
> 00:1c.4 Class 0604: 8086:3a48
> 00:1c.5 Class 0604: 8086:3a4a
> 00:1d.0 Class 0c03: 8086:3a34
> 00:1d.1 Class 0c03: 8086:3a35
> 00:1d.2 Class 0c03: 8086:3a36
> 00:1d.7 Class 0c03: 8086:3a3a
> 00:1e.0 Class 0604: 8086:244e
> 00:1f.0 Class 0601: 8086:3a16
> 00:1f.2 Class 0106: 8086:3a22
> 00:1f.3 Class 0c05: 8086:3a30
> 22:00.0 Class 1000: 177d:0010
> 17:00.0 Class 0604: 10b5:8624
> 18:04.0 Class 0604: 10b5:8624
> 18:05.0 Class 0604: 10b5:8624
> 18:06.0 Class 0604: 10b5:8624
> 18:08.0 Class 0604: 10b5:8624
> 18:09.0 Class 0604: 10b5:8624
> 1f:00.0 Class 0200: 8086:10c9
> 1f:00.1 Class 0200: 8086:10c9
> 1d:00.0 Class 0200: 8086:10c9
> 1d:00.1 Class 0200: 8086:10c9
> 1b:00.0 Class 0200: 8086:10c9
> 1b:00.1 Class 0200: 8086:10c9
> 19:00.0 Class 0200: 8086:10c9
> 19:00.1 Class 0200: 8086:10c9
> 0b:00.0 Class 0604: 10b5:8624
> 0c:04.0 Class 0604: 10b5:8624
> 0c:05.0 Class 0604: 10b5:8624
> 0c:06.0 Class 0604: 10b5:8624
> 0c:08.0 Class 0604: 10b5:8624
> 0c:09.0 Class 0604: 10b5:8624
> 13:00.0 Class 0200: 8086:10c9
> 13:00.1 Class 0200: 8086:10c9
> 11:00.0 Class 0200: 8086:10c9
> 11:00.1 Class 0200: 8086:10c9
> 0f:00.0 Class 0200: 8086:10c9
> 0f:00.1 Class 0200: 8086:10c9
> 0d:00.0 Class 0200: 8086:10c9
> 0d:00.1 Class 0200: 8086:10c9
> 08:00.0 Class 0200: 8086:10fb
> 08:00.1 Class 0200: 8086:10fb
> 03:00.0 Class 0200: 8086:10d3
> 02:00.0 Class 0300: 18ca:0027
> ff:00.0 Class 0600: 8086:2c70
> ff:00.1 Class 0600: 8086:2d81
> ff:02.0 Class 0600: 8086:2d90
> ff:02.1 Class 0600: 8086:2d91
> ff:02.2 Class 0600: 8086:2d92
> ff:02.3 Class 0600: 8086:2d93
> ff:02.4 Class 0600: 8086:2d94
> ff:02.5 Class 0600: 8086:2d95
> ff:03.0 Class 0600: 8086:2d98
> ff:03.1 Class 0600: 8086:2d99
> ff:03.2 Class 0600: 8086:2d9a
> ff:03.4 Class 0600: 8086:2d9c
> ff:04.0 Class 0600: 8086:2da0
> ff:04.1 Class 0600: 8086:2da1
> ff:04.2 Class 0600: 8086:2da2
> ff:04.3 Class 0600: 8086:2da3
> ff:05.0 Class 0600: 8086:2da8
> ff:05.1 Class 0600: 8086:2da9
> ff:05.2 Class 0600: 8086:2daa
> ff:05.3 Class 0600: 8086:2dab
> ff:06.0 Class 0600: 8086:2db0
> ff:06.1 Class 0600: 8086:2db1
> ff:06.2 Class 0600: 8086:2db2
> ff:06.3 Class 0600: 8086:2db3
> fe:00.0 Class 0600: 8086:2c70
> fe:00.1 Class 0600: 8086:2d81
> fe:02.0 Class 0600: 8086:2d90
> fe:02.1 Class 0600: 8086:2d91
> fe:02.2 Class 0600: 8086:2d92
> fe:02.3 Class 0600: 8086:2d93
> fe:02.4 Class 0600: 8086:2d94
> fe:02.5 Class 0600: 8086:2d95
> fe:03.0 Class 0600: 8086:2d98
> fe:03.1 Class 0600: 8086:2d99
> fe:03.2 Class 0600: 8086:2d9a
> fe:03.4 Class 0600: 8086:2d9c
> fe:04.0 Class 0600: 8086:2da0
> fe:04.1 Class 0600: 8086:2da1
> fe:04.2 Class 0600: 8086:2da2
> fe:04.3 Class 0600: 8086:2da3
> fe:05.0 Class 0600: 8086:2da8
> fe:05.1 Class 0600: 8086:2da9
> fe:05.2 Class 0600: 8086:2daa
> fe:05.3 Class 0600: 8086:2dab
> fe:06.0 Class 0600: 8086:2db0
> fe:06.1 Class 0600: 8086:2db1
> fe:06.2 Class 0600: 8086:2db2
> fe:06.3 Class 0600: 8086:2db3
> 
> 
> Solution: set the skb->trasport_header to a valid data offset in ipt
> reject module
> 
> diff -up net/ipv4/netfilter/ipt_REJECT.c{.orig,}
> --- net/ipv4/netfilter/ipt_REJECT.c.orig	2012-12-10 12:08:37.000000000 -0800
> +++ net/ipv4/netfilter/ipt_REJECT.c	2012-12-10 12:10:08.000000000 -0800
> @@ -79,6 +79,8 @@ static void send_reset(struct sk_buff *o
>  	niph->saddr	= oiph->daddr;
>  	niph->daddr	= oiph->saddr;
> 
> +
> +	skb_reset_transport_header(nskb);
>  	tcph = (struct tcphdr *)skb_put(nskb, sizeof(struct tcphdr));
>  	memset(tcph, 0, sizeof(*tcph));
>  	tcph->source	= oth->dest;
> 
> Please let me know if you have any concerns with the patch.

This is a good and extensive diagnosing, thanks a lot.

Regarding your patch format, please, use git format-patch for your
upcoming contributions and add the Signed-off-by tag to your patches.
It makes

But for this time, I'll do the formatting myself and will take this
into the nf tree.
