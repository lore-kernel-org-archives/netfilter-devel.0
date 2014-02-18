From: Vasily Averin <vvs@parallels.com>
Subject: once again about crash in fins_appropriate_src()/same_src()
Date: Tue, 18 Feb 2014 14:16:30 +0400
Message-ID: <530332FE.7040803@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org, Andrey Vagin <avagin@openvz.org>,
	Patrick McHardy <kaber@trash.net>
To: =?UTF-8?B?TWljaGFsIEt1YmXEjWVr?= <mkubecek@suse.cz>,
	Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:25882 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715AbaBRKRD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:17:03 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dear all,

I would return to problem fixed by Michal Kube=C4=8Dek
 "[nf] netfilter: use RCU safe kfree for conntrack extensions"
https://bugzilla.netfilter.org/show_bug.cgi?id=3D714

I'm not sure that problem was caused by RCU race and I afraid it can be=
 still not fixed.

Parallels got similar crash on RHEL6.u4-based kernel.
I've checked vmcore dump and found exactly the same situation:
we have zeroed struct nf_conn_nat in nat_bysource hlist, and crashed be=
casue nat->ct =3D NULL.

Our kernel did not included patch from Michal,
however I've found several strange facts:
- I've found old alive conntrack that have reference to extension with =
nf_conn_nat,
 conntrack have strange status 0xe. I.e. have NOT set any NAT bits, but=
 have CONFIRMED bit set
- our entry seems was not removed by RCU, all references in nat_bysourc=
e hlist looks correct
- last unloaded module was nf_nat -- but it is loaded back

I.e. it does not look like problem was caused by RCU race.

So I would like to ask, are you sure that problem in your cases was rea=
lly caused by RCU race?
Did you tried to find conntrack used affected nf_conn_nat?
Did you observed probably conntrack destroy on neighbor CPUs?

I believe that nf_conn_nat could be zeroyed during nf_nat module unload=
ing,=20
but I do not understand how this entry could return back into nat_byour=
ce list after module reloading.
Do you probably have some ideas?

You can find some more details about my case below.

<1>[6972396.347616] BUG: unable to handle kernel NULL pointer dereferen=
ce at 000000000000003e
<1>[6972396.347733] IP: [<ffffffffa0243fa0>] nf_nat_setup_info+0x460/0x=
590 [nf_nat]
<4>[6972396.347802] PGD 0
<4>[6972396.347859] Oops: 0000 [#1] SMP
<4>[6972396.347920] last sysfs file: /sys/devices/pci0000:00/0000:00:1c=
=2E5/0000:06:00.0/net/eth1/statistics/tx_bytes
<4>[6972396.348041] CPU 0
<4>[6972396.348048] Modules linked in: ipt_REDIRECT nf_nat_ftp nf_connt=
rack_ftp ipt_MASQUERADE iptable_nat nf_nat iptable_mangle ipt_LOG xt_DS=
CP 8021q garp stp llc cls_fw sch_cbq ip_vzredir(U) vzredir(U) vzcompat(=
U) nf_conntrack_ipv4
nf_defrag_ipv4 vznetdev ip6_vzprivnet(U) ip6_vzredir(U) ip6_vznetstat(U=
) ip_vzprivnet(U) vziolimit(U) vzfs(U) vzdquota vzcpt nfs lockd fscache=
 auth_rpcgss nfs_acl sunrpc vzlinkdev(U) vzethdev vzevent vzlist(U) vzs=
tat(U) vzmon ip_vznet
stat(U) vznetstat(U) vzdev xt_length xt_hl xt_tcpmss xt_TCPMSS iptable_=
filter xt_multiport xt_limit xt_dscp ipt_REJECT ip_tables ip6t_REJECT n=
f_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter i=
p6_tables ipv6 sg mic
rocode serio_raw i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support e1000e =
i5100_edac edac_core ioatdma dca shpchp ext3 jbd mbcache sr_mod cdrom p=
ata_it8213 sd_mod crc_t10dif pata_acpi ata_generic ata_piix aacraid dm_=
mirror dm_region_hash
 dm_log dm_mod [last unloaded: nf_nat]
<4>[6972396.348586]
<4>[6972396.348586] Pid: 0, comm: swapper veid: 0 Not tainted 2.6.32-04=
2stab083.2 #1 042stab083_2 Supermicro X7DCL/X7DCL
<4>[6972396.348586] RIP: 0010:[<ffffffffa0243fa0>]  [<ffffffffa0243fa0>=
] nf_nat_setup_info+0x460/0x590 [nf_nat]
<4>[6972396.348586] RSP: 0018:ffff880028203700  EFLAGS: 00010286
<4>[6972396.348586] RAX: 0000000000000000 RBX: ffff8802d89c9b58 RCX: 00=
0000005ef7b2de
<4>[6972396.348586] RDX: 0000000000000001 RSI: ffff8800282037e0 RDI: ff=
ff880028203740
<4>[6972396.348586] RBP: ffff8800282037d0 R08: 00000000c0deecc2 R09: 00=
00000000000002
<4>[6972396.348586] R10: ffff8801345e5508 R11: ffff880028203918 R12: 00=
00000000000000
<4>[6972396.348586] R13: ffff8800282037e0 R14: ffff880028203740 R15: ff=
ff8800c350a5f0
<4>[6972396.348586] FS:  0000000000000000(0000) GS:ffff880028200000(000=
0) knlGS:0000000000000000
<4>[6972396.348586] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
<4>[6972396.348586] CR2: 000000000000003e CR3: 00000002b6ada000 CR4: 00=
000000000407f0
<4>[6972396.348586] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00=
00000000000000
<4>[6972396.348586] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00=
00000000000400
<4>[6972396.348586] Process swapper (pid: 0, veid: 0, threadinfo ffffff=
ff81a00000, task ffffffff81a8d020)
<4>[6972396.348586] Stack:
<4>[6972396.348586]  ffff880028203740 ffffffff81b1a520 000000b200b20000=
 ffff88031a6606e0
<4>[6972396.348586] <d> 0000000028203740 ffff880000000008 ffffffff81299=
af0 ffff8800851e61c0
<4>[6972396.348586] <d> 00000000f7e6a8c0 0000000000000000 16e6a8c000028=
73a 0000000000000000
<4>[6972396.348586] Call Trace:
<4>[6972396.348586]  <IRQ>
<4>[6972396.348586]  [<ffffffff81299af0>] ? swiotlb_map_page+0x0/0xf0
<4>[6972396.348586]  [<ffffffffa025e152>] masquerade_tg+0xd2/0xf0 [ipt_=
MASQUERADE]
<4>[6972396.348586]  [<ffffffffa025232b>] ipt_do_table+0x3fb/0x6b0 [ip_=
tables]
<4>[6972396.348586]  [<ffffffff8145c419>] ? dev_queue_xmit+0x169/0x560
<4>[6972396.348586]  [<ffffffff8144c8a6>] ? skb_checksum+0x56/0x2d0
<4>[6972396.348586]  [<ffffffffa0255284>] nf_nat_rule_find+0x24/0x80 [i=
ptable_nat]
<4>[6972396.348586]  [<ffffffffa0255521>] nf_nat_fn+0x111/0x260 [iptabl=
e_nat]
<4>[6972396.348586]  [<ffffffffa0255798>] nf_nat_out+0x48/0xd0 [iptable=
_nat]
<4>[6972396.348586]  [<ffffffff814841b9>] nf_iterate+0x69/0xb0
<4>[6972396.348586]  [<ffffffff81494e70>] ? ip_finish_output+0x0/0x2f0
<4>[6972396.348586]  [<ffffffff81484374>] nf_hook_slow+0x74/0x110
<4>[6972396.348586]  [<ffffffff81494e70>] ? ip_finish_output+0x0/0x2f0
<4>[6972396.348586]  [<ffffffff81490590>] ? ip_forward_finish+0x0/0x60
<4>[6972396.348586]  [<ffffffff81495204>] ip_output+0xa4/0xc0
<4>[6972396.348586]  [<ffffffff814905df>] ip_forward_finish+0x4f/0x60
<4>[6972396.348586]  [<ffffffff81490788>] ip_forward+0x198/0x430
<4>[6972396.348586]  [<ffffffff8148e8ed>] ip_rcv_finish+0x12d/0x440
<4>[6972396.348586]  [<ffffffff8148ee84>] ip_rcv+0x284/0x360
<4>[6972396.348586]  [<ffffffff8145651b>] __netif_receive_skb+0x34b/0x7=
b0
<4>[6972396.348586]  [<ffffffff81458af8>] netif_receive_skb+0x58/0x60
<4>[6972396.348586]  [<ffffffff81458c00>] napi_skb_finish+0x50/0x70
<4>[6972396.348586]  [<ffffffff8145ae69>] napi_gro_receive+0x39/0x50
<4>[6972396.348586]  [<ffffffffa013679f>] e1000_receive_skb+0x4f/0x90 [=
e1000e]
<4>[6972396.348586]  [<ffffffffa0138d30>] e1000_clean_rx_irq+0x380/0x58=
0 [e1000e]
<4>[6972396.348586]  [<ffffffffa01412ed>] e1000e_poll+0x8d/0x37c [e1000=
e]
<4>[6972396.348586]  [<ffffffff8145af90>] net_rx_action+0x110/0x300
<4>[6972396.348586]  [<ffffffff810a2265>] ? __hrtimer_start_range_ns+0x=
1a5/0x470
<4>[6972396.348586]  [<ffffffff8107ac8d>] __do_softirq+0x10d/0x250
<4>[6972396.348586]  [<ffffffff810a84f9>] ? do_timer+0x329/0x590
<4>[6972396.348586]  [<ffffffff8100c2ac>] call_softirq+0x1c/0x30
<4>[6972396.348586]  [<ffffffff8100df05>] do_softirq+0x65/0xa0
<4>[6972396.348586]  [<ffffffff8107aaad>] irq_exit+0xcd/0xd0
<4>[6972396.348586]  [<ffffffff81520465>] do_IRQ+0x75/0xf0
<4>[6972396.348586]  [<ffffffff8100ba93>] ret_from_intr+0x0/0x11
<4>[6972396.348586]  <EOI>
<4>[6972396.348586]  [<ffffffff81014967>] ? mwait_idle+0x77/0xd0
<4>[6972396.348586]  [<ffffffff8151c9fa>] ? atomic_notifier_call_chain+=
0x1a/0x20
<4>[6972396.348586]  [<ffffffff8100a026>] cpu_idle+0xb6/0x110
<4>[6972396.348586]  [<ffffffff814fc5e5>] rest_init+0x85/0x90
<4>[6972396.348586]  [<ffffffff81c32f6e>] start_kernel+0x412/0x41e
<4>[6972396.348586]  [<ffffffff81c3233a>] x86_64_start_reservations+0x1=
25/0x129
<4>[6972396.348586]  [<ffffffff81c32438>] x86_64_start_kernel+0xfa/0x10=
9
<4>[6972396.348586] Code: a0 02 00 00 4c 8b 3e 4d 85 ff 75 1b e9 10 01 =
00 00 66 2e 0f 1f 84 00 00 00 00 00 4d 8b 3f 4d 85 ff 0f 84 84 00 00 00=
 49 8b 47 20 <38> 50 3e 75 eb 8b 48 18 3b 4d a0 75 e3 0f b7 48 28 66 3b=
 4d b0
<1>[6972396.348586] RIP  [<ffffffffa0243fa0>] nf_nat_setup_info+0x460/0=
x590 [nf_nat]
<4>[6972396.348586]  RSP <ffff880028203700>
<4>[6972396.348586] CR2: 000000000000003e

find_appropriate_src()
{      =20
        hlist_for_each_entry_rcu(nat, n, &net->ipv4.nat_bysource[h], by=
source) {
                ct =3D nat->ct;            ct =3D NULL
                if (same_src(ct, tuple))  <<<< crashed on access to ct

nat =3D %r15 =3D ffff8800c350a5f0

crash> struct nf_conn_nat ffff8800c350a5f0
struct nf_conn_nat {
  bysource =3D {
    next =3D 0x0,
    pprev =3D 0xffff88001a35cb70
  },
  seq =3D {{
      correction_pos =3D 0,
      offset_before =3D 0,
      offset_after =3D 0
    }, {
      correction_pos =3D 0,
      offset_before =3D 0,
      offset_after =3D 0
    }},
  ct =3D 0x0,
  help =3D {
    nat_pptp_info =3D {
      pns_call_id =3D 0,
      pac_call_id =3D 0
    }
  },
  masq_index =3D 0
}

according nf_ct_ext is used by ct ffff880212e81d50

crash> kmem ffff8800c350a5f0
CACHE            NAME                 OBJSIZE  ALLOCATED     TOTAL  SLA=
BS  SSIZE
ffff88031fc00140 size-128                 128     183495    506280  168=
76     4k
=46REE / [ALLOCATED]
  [ffff8800c350a5c0]   <<<<< nf_conn_nat is part of nf_ct_ext sreucture

crash> search ffff8800c350a5c0
ffff880212e81e70: ffff8800c350a5c0  <<< someone have reference to our n=
f_ct_ext

crash> kmem ffff880212e81e70
CACHE            NAME                 OBJSIZE  ALLOCATED     TOTAL  SLA=
BS  SSIZE
ffff88031dc00380 nf_conntrack_ffffffff81b1a520 312   799      1944    1=
62     4k
=46REE / [ALLOCATED]
  [ffff880212e81d50] <<< it is alive conntrack
VvS: name of conntrack slab is correct, it is OpenVz specific, each net=
work namespace have own slab for conntracks.

crash> nf_conn ffff880212e81d50
struct nf_conn
      counter =3D 0x1
  src: x.x.x.x, port 59116
  dst: y.y.y.y, port 24000
  status =3D 0xe,  no NAT and NAT_DONE bits (?!?), set only IPS_SEEN_RE=
PLY, IPS_ASSURED, IPS_CONFIRMED.
  master =3D 0
  timer -- will be expired in future
  proto tcp -- seems there was some activity in this connection in past
      tcp =3D {
      seen =3D {{
          td_end =3D 0x221b933,=20
          td_maxend =3D 0x221f23b,=20
          td_maxwin =3D 0xf7d3,=20
          td_maxack =3D 0xdc9812bb,=20
          td_scale =3D 0x6,=20
          flags =3D 0x23
        }, {
          td_end =3D 0xdc9812bb,=20
          td_maxend =3D 0xdc986dfb,=20
          td_maxwin =3D 0x3908,=20
          td_maxack =3D 0x221b933,=20
          td_scale =3D 0x7,=20
          flags =3D 0x23
        }},=20
      state =3D 0x3,  <<< TCP_CONNTRACK_ESTABLISHED
      last_dir =3D 0x1,=20
      retrans =3D 0x0,=20
      last_index =3D 0x1,=20
      last_seq =3D 0xdc9812ba,=20
      last_ack =3D 0xdc9812bb,=20
      last_end =3D 0xdc9812bb,=20
      last_win =3D 0x3908
    },
  ext =3D 0xffff8800c350a5c0 -- reference to extension


crash> nf_ct_ext 0xffff8800c350a5c0
struct nf_ct_ext {
  rcu =3D {
    next =3D 0x0,
    func =3D 0x0
  },
  offset =3D "\000\060\000\030",  <<<<< \060 =3D0x30 --> nat extension =
was used
  len =3D 0x60,
  data =3D 0xffff8800c350a5d5 ""
}

hlist looks normal
crash> nf_conn_nat.bysource 0xffff8800c350a5f0
  bysource =3D {
    next =3D 0x0,
    pprev =3D 0xffff88001a35cb70
  }
crash> nf_conn_nat.bysource 0xffff88001a35cb70
  bysource =3D {
    next =3D 0xffff8800c350a5f0,
    pprev =3D 0xffff88031b2c8a08
  }
crash> hlist_head 0xffff88031b2c8a08  <<<<< hlist_head from init_net.ip=
v4.nat_bysource
struct hlist_head {
  first =3D 0xffff88001a35cb70
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
