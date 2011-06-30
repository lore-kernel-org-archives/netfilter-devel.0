From: Lutfi ODUNCUOGLU <lutfio@metu.edu.tr>
Subject: Re: Linux netfilter shuts down the server
Date: Thu, 30 Jun 2011 09:43:26 +0300
Message-ID: <4E0C1B0E.3090302@metu.edu.tr>
References: <4DE79BAF.3080201@metu.edu.tr> <4DE7A268.4080102@netfilter.org> <4DE87DEF.8020100@metu.edu.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from likya.general.services.metu.edu.tr ([144.122.144.158]:55645
	"EHLO mail.metu.edu.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab1F3Gnc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Jun 2011 02:43:32 -0400
In-Reply-To: <4DE87DEF.8020100@metu.edu.tr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Server has gone down tomorrow night as I mentioned. I got backtrace logs
with netconsole, you can see the log below.

[2024366.078239]  HAIye gelen&dusen trafik: IN=vlan194 OUT=
MAC=00:21:28:50:44:72:00:25:9e:5d:f0:db:08:00 SRC=27.0.2.83
DST=144.122.1.98 LEN=48 TOS=0x00 PREC=0x00 TTL=242 ID=13312 DF PROTO=TCP
SPT=80 DPT=2816 WINDOW=8190 RES=0x00 ACK SYN URGP=0
[2024402.995517] ------------[ cut here ]------------
[2024402.995572] kernel BUG at net/ipv4/inetpeer.c:357!
[2024402.995619] invalid opcode: 0000 [#1] SMP
[2024402.995665] last sysfs file: /sys/module/ip_tables/initstate
[2024402.995714] CPU 3
[2024402.995718] Modules linked in: netconsole xt_multiport
ip_set_hash_ipport xt_TRACE iptable_raw ip6table_raw ip6t_LOG
ip6table_mangle ip6table_filter ip6_tables sch_sfq sch_htb ipt_NETFLOW
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_LOG
xt_limit xt_tcpudp xt_CLASSIFY xt_set ip_set_list_set ip_set_bitmap_port
ip_set_hash_net ip_set_hash_ip ip_set nfnetlink iptable_filter
iptable_mangle ip_tables x_tables bonding option usb_wwan uas sr_mod
cdrom amd64_edac_mod i2c_nforce2 edac_core rtc_cmos rtc_core evdev
i2c_core rtc_lib forcedeth usbserial e1000e ehci_hcd [last unloaded:
netconsole]
[2024402.996207]
[2024402.996242] Pid: 0, comm: kworker/0:1 Tainted: G        W
2.6.37.2 #4 Sun Microsystems     Sun Fire X4140/Sun Fire X4140
[2024402.996344] RIP: 0010:[<ffffffff812a05dd>]  [<ffffffff812a05dd>]
unlink_from_pool+0x70/0x13b
[2024402.996429] RSP: 0018:ffff8800d7c637b0  EFLAGS: 00010202
[2024402.996477] RAX: ffffffff81365fd0 RBX: ffff8803739ccfc0 RCX:
ffff8800d7c63830
[2024402.996556] RDX: ffff8807fc857540 RSI: 00000000ba3caebd RDI:
00000000ba3b7a90
[2024402.996636] RBP: 0000000000000000 R08: ffffffff81365fd0 R09:
0000000000000013
[2024402.996715] R10: 0000000000000000 R11: ffffffff814c4fe0 R12:
ffff8800d7c639b8
[2024402.996795] R13: 000000007b70a043 R14: 0000000000000001 R15:
0000000080000000
[2024402.996874] FS:  00007f17fe2d97a0(0000) GS:ffff8800d7c60000(0000)
knlGS:0000000000000000
[2024402.996957] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[2024402.997007] CR2: 00007f1743ba1cfc CR3: 0000000824b63000 CR4:
00000000000006e0
[2024402.997090] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[2024402.997170] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[2024402.997250] Process kworker/0:1 (pid: 0, threadinfo
ffff880824934000, task ffff8808249287b0)
[2024402.997333] Stack:
[2024402.997369]  ffffffff814c4fe0 ffff8803739cc888 ffff8807d9a0fe48
ffff880638416700
[2024402.997454]  ffff8807f7ad7840 ffff8807d9a5f648 ffff8807cb0ee740
ffff8805c882b8c0
[2024402.997538]  ffff8807f3cbbd00 ffff8805c6943640 ffff880586789bc0
ffff88057c94a840
[2024402.997622] Call Trace:
[2024402.997660]  <IRQ>
[2024402.997700]  [<ffffffff81273e9c>] ? skb_copy_and_csum_bits+0x58/0x280
[2024402.997755]  [<ffffffff810cbdaa>] ?
__kmalloc_node_track_caller+0x5f/0xb9
[2024402.997809]  [<ffffffff810cb83a>] ? cache_alloc_refill+0x97/0x1e5
[2024402.997861]  [<ffffffff812a0729>] ? cleanup_once+0x81/0x87
[2024402.997910]  [<ffffffff812a08ac>] ? inet_getpeer+0x17d/0x19a
[2024402.997962]  [<ffffffff8127ced3>] ? dev_hard_start_xmit+0x464/0x5da
[2024402.998015]  [<ffffffff81291064>] ? sch_direct_xmit+0x87/0x17c
[2024402.998065]  [<ffffffff812a14d0>] ? ip4_frag_init+0x71/0x7a
[2024402.998116]  [<ffffffff812cdcef>] ? inet_frag_find+0x90/0x1d5
[2024402.998172]  [<ffffffffa004c0c9>] ? bond_dev_queue_xmit+0x53/0x57
[bonding]
[2024402.998226]  [<ffffffff812a1586>] ? ip_defrag+0xad/0x9c3
[2024402.998275]  [<ffffffff8127ced3>] ? dev_hard_start_xmit+0x464/0x5da
[2024402.998328]  [<ffffffffa012907e>] ? ipv4_conntrack_defrag+0x7d/0xab
[nf_defrag_ipv4]
[2024402.998412]  [<ffffffff8129b052>] ? nf_iterate+0x43/0x87
[2024402.998460]  [<ffffffff812a0a00>] ? ip_rcv_finish+0x0/0x2ea
[2024402.998510]  [<ffffffff8129b0f8>] ? nf_hook_slow+0x62/0xc3
[2024402.998559]  [<ffffffff812a0a00>] ? ip_rcv_finish+0x0/0x2ea
[2024402.998608]  [<ffffffff812a0f31>] ? ip_rcv+0x247/0x27b
[2024402.998657]  [<ffffffff8127afd2>] ? __netif_receive_skb+0x50b/0x53e
[2024402.998709]  [<ffffffff8127aeb9>] ? __netif_receive_skb+0x3f2/0x53e
[2024402.998761]  [<ffffffff8127bdac>] ? netif_receive_skb+0x67/0x6d
[2024402.998812]  [<ffffffff8127c30e>] ? napi_gro_receive+0x9c/0xa9
[2024402.998862]  [<ffffffff8127be6c>] ? napi_skb_finish+0x1c/0x31
[2024402.998921]  [<ffffffffa008e34b>] ?
nv_rx_process_optimized+0x17d/0x236 [forcedeth]
[2024402.999006]  [<ffffffffa009120b>] ? nv_napi_poll+0x555/0x565
[forcedeth]
[2024402.999059]  [<ffffffff8127c444>] ? net_rx_action+0xa2/0x204
[2024402.999111]  [<ffffffff8103b8a6>] ? __do_softirq+0xc9/0x18b
[2024402.999162]  [<ffffffff81078c87>] ? handle_IRQ_event+0x4c/0x104
[2024402.999213]  [<ffffffff8100378c>] ? call_softirq+0x1c/0x28
[2024402.999263]  [<ffffffff81004fed>] ? do_softirq+0x31/0x63
[2024402.999311]  [<ffffffff8103b743>] ? irq_exit+0x36/0x7a
[2024402.999359]  [<ffffffff8100476e>] ? do_IRQ+0x9f/0xb5
[2024402.999408]  [<ffffffff81319193>] ? ret_from_intr+0x0/0xa
[2024402.999456]  <EOI>
[2024402.999495]  [<ffffffff8100950b>] ? default_idle+0x5f/0x76
[2024402.999544]  [<ffffffff81001c22>] ? cpu_idle+0x5b/0xce
[2024402.999592] Code: 8b 7b 10 8b 70 10 39 f7 74 1c 48 8d 50 08 39 f7
48 0f 42 d0 48 89 11 48 8b 02 48 83 c1 08 48 3d d0 5f 36 81 75 da 48 39
d8 74 04 <0f> 0b eb fe 48 81 3b d0 5f 36 81 48 8d 69 f8 75 10 48 8b 41 f8
[2024402.999833] RIP  [<ffffffff812a05dd>] unlink_from_pool+0x70/0x13b
[2024402.999884]  RSP <ffff8800d7c637b0>
[2024403.000107] ---[ end trace f27be8cd4342cf81 ]---
[2024403.000173] Kernel panic - not syncing: Fatal exception in interrupt
[2024403.000245] Pid: 0, comm: kworker/0:1 Tainted: G      D W   2.6.37.2 #4
[2024403.000317] Call Trace:
[2024403.000374]  <IRQ>  [<ffffffff813169b0>] ? panic+0x92/0x196
[2024403.000468]  [<ffffffff810060aa>] ? oops_end+0xa0/0xad
[2024403.000541]  [<ffffffff810040b4>] ? do_invalid_op+0x85/0x8f
[2024403.000611]  [<ffffffff812a05dd>] ? unlink_from_pool+0x70/0x13b
[2024403.000682]  [<ffffffff810513fa>] ? hrtimer_wakeup+0x0/0x22
[2024403.000751]  [<ffffffff81051417>] ? hrtimer_wakeup+0x1d/0x22
[2024403.000821]  [<ffffffff810516b0>] ? __run_hrtimer+0x101/0x155
[2024403.000891]  [<ffffffff81051816>] ? hrtimer_run_queues+0x112/0x166
[2024403.000966]  [<ffffffff81003515>] ? invalid_op+0x15/0x20
[2024403.001041]  [<ffffffff812a05dd>] ? unlink_from_pool+0x70/0x13b
[2024403.001112]  [<ffffffff81273e9c>] ? skb_copy_and_csum_bits+0x58/0x280
[2024403.001188]  [<ffffffff810cbdaa>] ?
__kmalloc_node_track_caller+0x5f/0xb9
[2024403.001263]  [<ffffffff810cb83a>] ? cache_alloc_refill+0x97/0x1e5
[2024403.001334]  [<ffffffff812a0729>] ? cleanup_once+0x81/0x87
[2024403.001403]  [<ffffffff812a08ac>] ? inet_getpeer+0x17d/0x19a
[2024403.001474]  [<ffffffff8127ced3>] ? dev_hard_start_xmit+0x464/0x5da
[2024403.001546]  [<ffffffff81291064>] ? sch_direct_xmit+0x87/0x17c
[2024403.001616]  [<ffffffff812a14d0>] ? ip4_frag_init+0x71/0x7a
[2024403.001689]  [<ffffffff812cdcef>] ? inet_frag_find+0x90/0x1d5
[2024403.001876]  [<ffffffffa004c0c9>] ? bond_dev_queue_xmit+0x53/0x57
[bonding]
[2024403.001950]  [<ffffffff812a1586>] ? ip_defrag+0xad/0x9c3
[2024403.002018]  [<ffffffff8127ced3>] ? dev_hard_start_xmit+0x464/0x5da
[2024403.002091]  [<ffffffffa012907e>] ? ipv4_conntrack_defrag+0x7d/0xab
[nf_defrag_ipv4]
[2024403.002194]  [<ffffffff8129b052>] ? nf_iterate+0x43/0x87
[2024403.002262]  [<ffffffff812a0a00>] ? ip_rcv_finish+0x0/0x2ea
[2024403.002331]  [<ffffffff8129b0f8>] ? nf_hook_slow+0x62/0xc3
[2024403.002401]  [<ffffffff812a0a00>] ? ip_rcv_finish+0x0/0x2ea
[2024403.002470]  [<ffffffff812a0f31>] ? ip_rcv+0x247/0x27b
[2024403.002538]  [<ffffffff8127afd2>] ? __netif_receive_skb+0x50b/0x53e
[2024403.002609]  [<ffffffff8127aeb9>] ? __netif_receive_skb+0x3f2/0x53e
[2024403.002682]  [<ffffffff8127bdac>] ? netif_receive_skb+0x67/0x6d
[2024403.002752]  [<ffffffff8127c30e>] ? napi_gro_receive+0x9c/0xa9
[2024403.002822]  [<ffffffff8127be6c>] ? napi_skb_finish+0x1c/0x31
[2024403.002894]  [<ffffffffa008e34b>] ?
nv_rx_process_optimized+0x17d/0x236 [forcedeth]
[2024403.002997]  [<ffffffffa009120b>] ? nv_napi_poll+0x555/0x565
[forcedeth]
[2024403.003071]  [<ffffffff8127c444>] ? net_rx_action+0xa2/0x204
[2024403.003140]  [<ffffffff8103b8a6>] ? __do_softirq+0xc9/0x18b
[2024403.003209]  [<ffffffff81078c87>] ? handle_IRQ_event+0x4c/0x104
[2024403.003280]  [<ffffffff8100378c>] ? call_softirq+0x1c/0x28
[2024403.003349]  [<ffffffff81004fed>] ? do_softirq+0x31/0x63
[2024403.003416]  [<ffffffff8103b743>] ? irq_exit+0x36/0x7a
[2024403.003484]  [<ffffffff8100476e>] ? do_IRQ+0x9f/0xb5
[2024403.003551]  [<ffffffff81319193>] ? ret_from_intr+0x0/0xa
[2024403.003618]  <EOI>  [<ffffffff8100950b>] ? default_idle+0x5f/0x76
[2024403.003713]  [<ffffffff81001c22>] ? cpu_idle+0x5b/0xce



Thanks,

Lutfi

On 06/03/2011 09:23 AM, Lutfi ODUNCUOGLU wrote:
> On 06/02/2011 05:47 PM, Pablo Neira Ayuso wrote:
>> On 02/06/11 16:18, Lutfi ODUNCUOGLU wrote:
>>> Hello,
>>>
>>> I have a sun x1400 series server, that I use as a router. The OS is
>>> Debian Squeeze and every week my router goes down and I cannot do
>>> anything then hard booting the server. The photo of the error messages
>>> can be seen at http://metu.edu.tr/~lutfio/a.jpg. What may be the problem?
>>
>> That information is incomplete. We need to know what Linux kernel
>> version you're using, and the upper part of the backtrace would be
>> really helpful.
>> --
> Ok. I am using custom compiled 2.6.37.2 AMD 64 bit kernel. For upper
> backtrace issue when I hard boot the server, I can't find any logs about
> this error. Is there way to have this backtrace for next time?
> 
> Thanks,
> 
> Lutfi
> 
> 
> 

