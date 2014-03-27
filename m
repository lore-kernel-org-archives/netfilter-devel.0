From: Andrey Wagin <avagin@gmail.com>
Subject: NULL pointer dereference in nf_nat_setup_info
Date: Thu, 27 Mar 2014 11:55:01 +0400
Message-ID: <CANaxB-yk3Tn7ftED8EBqb_JhM9qD4D0B+x7nO_FPYugXtg0P8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, vvs@openvz.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:47504 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbaC0HzD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Mar 2014 03:55:03 -0400
Received: by mail-vc0-f171.google.com with SMTP id lg15so3753294vcb.16
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Mar 2014 00:55:02 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi All,


[  637.033447] nf_conntrack: automatic helper assignment is deprecated
and it will be removed soon. Use the iptables CT target to attach
helpers instead.
[  637.037222] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000010
[  637.038011] IP: [<ffffffffa01466e4>] nf_nat_setup_info+0x1f4/0x380 [nf_nat]
[  637.038011] PGD 79fa6067 PUD 799f0067 PMD 0
[  637.038011] Oops: 0002 [#1] SMP
[  637.038011] Dumping ftrace buffer:
[  637.038011] ---------------------------------
...
[  637.038011]   pptpcm-1232    1.Ns1 289566916us : nf_nat_ipv4_out <-nf_iterate
[  637.038011]   pptpcm-1232    1.Ns1 289566917us : nf_nat_ipv4_fn
<-nf_nat_ipv4_out
[  637.038011]   pptpcm-1232    1.Ns1 289566918us : nf_nat_setup_info
<-xt_snat_target_v0
[  637.038011]   pptpcm-1232    1.Ns1 289566918us :
nf_ct_invert_tuplepr <-nf_nat_setup_info
[  637.038011]   pptpcm-1232    1.Ns1 289566918us :
__nf_ct_l4proto_find <-nf_ct_invert_tuplepr
[  637.038011]   pptpcm-1232    1.Ns1 289566919us : nf_ct_invert_tuple
<-nf_ct_invert_tuplepr
[  637.038011]   pptpcm-1232    1.Ns1 289566920us :
nf_nat_ipv4_in_range <-in_range.isra.9
[  637.038011]   pptpcm-1232    1.Ns1 289566921us :
nf_ct_invert_tuplepr <-get_unique_tuple
[  637.038011]   pptpcm-1232    1.Ns1 289566921us :
__nf_ct_l4proto_find <-nf_ct_invert_tuplepr
[  637.038011]   pptpcm-1232    1.Ns1 289566921us : nf_ct_invert_tuple
<-nf_ct_invert_tuplepr
[  637.038011]   pptpcm-1232    1.Ns1 289566921us :
nf_conntrack_tuple_taken <-get_unique_tuple
[  637.038011]   pptpcm-1232    1.Ns1 289566922us :
nf_ct_invert_tuplepr <-nf_nat_setup_info
[  637.038011]   pptpcm-1232    1.Ns1 289566922us :
__nf_ct_l4proto_find <-nf_ct_invert_tuplepr
[  637.038011]   pptpcm-1232    1.Ns1 289566923us : nf_ct_invert_tuple
<-nf_ct_invert_tuplepr
[  637.038011]   pptpcm-1232    1.Ns1 289566923us :
nf_conntrack_alter_reply <-nf_nat_setup_info
[  637.038011]   pptpcm-1232    1.Ns1 289566923us :
__nf_ct_try_assign_helper <-nf_conntrack_alter_reply
[  637.038011]   pptpcm-1232    1.Ns1 289566924us :
__nf_ct_ext_add_length <-nf_nat_setup_info
[  637.038011] ---------------------------------
[  637.038011] Modules linked in: ppp_deflate bsd_comp xt_nat
iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 veth
ppp_async crc_ccitt ppp_generic slhc nf_nat_pptp nf_nat_proto_gre
nf_conntrack_pptp nf_conntrack_proto_gre nf_nat nf_conntrack ip_gre
ip_tunnel gre tun cfg80211 rfkill bridge stp llc ppdev virtio_balloon
virtio_console joydev microcode serio_raw pcspkr pvpanic i2c_piix4
parport_pc parport floppy virtio_net virtio_pci virtio_ring
drm_kms_helper ttm virtio drm i2c_core ata_generic pata_acpi [last
unloaded: iptable_raw]
[  637.038011] CPU: 1 PID: 1232 Comm: pptpcm Not tainted 3.14.0-rc8+ #98
[  637.038011] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  637.038011] task: ffff880079a74c80 ti: ffff88007b22e000 task.ti:
ffff88007b22e000
[  637.038011] RIP: 0010:[<ffffffffa01466e4>]  [<ffffffffa01466e4>]
nf_nat_setup_info+0x1f4/0x380 [nf_nat]
[  637.038011] RSP: 0018:ffff88007fd03a08  EFLAGS: 00010246
[  637.038011] RAX: 0000000000000000 RBX: ffff88007af4d950 RCX: 0000000000004746
[  637.038011] RDX: ffff88007ac00920 RSI: 23c0000000000000 RDI: ffffffffa0149100
[  637.038011] RBP: ffff88007fd03aa8 R08: ffffffff8230cda0 R09: 0000000000000000
[  637.038011] R10: ffff880079a74c80 R11: fffe7ff44e230478 R12: 0000000000002600
[  637.038011] R13: ffffffff81cdaec0 R14: ffff88007fd03ab8 R15: 0000000000000000
[  637.038011] FS:  00007fa8314a1740(0000) GS:ffff88007fd00000(0000)
knlGS:0000000000000000
[  637.038011] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  637.038011] CR2: 0000000000000010 CR3: 000000007a82b000 CR4: 00000000000006e0
[  637.038011] Stack:
[  637.038011]  000000000265a8c0 0000000000000000 39021e0a0002deb4
0000000000000000
[  637.038011]  0006bb0600000000 00000000277aa8c0 0000000000000000
39021e0a0002deb4
[  637.038011]  0000000000000000 0006bb0600000000 0000000039021e0a
0000000000000000
[  637.038011] Call Trace:
[  637.038011]  <IRQ>
[  637.038011]  [<ffffffffa018c155>] xt_snat_target_v0+0x65/0x68 [xt_nat]
[  637.038011]  [<ffffffff816b23d3>] ipt_do_table+0x2d3/0x6c0
[  637.038011]  [<ffffffff81150759>] ? ring_buffer_event_data+0x9/0x10
[  637.038011]  [<ffffffffa01871b7>] nf_nat_ipv4_fn+0x1b7/0x310 [iptable_nat]
[  637.038011]  [<ffffffff81650fd0>] ? ip_fragment+0x8e0/0x8e0
[  637.038011]  [<ffffffff81650fd0>] ? ip_fragment+0x8e0/0x8e0
[  637.038011]  [<ffffffffa01874e8>] nf_nat_ipv4_out+0x48/0xf0 [iptable_nat]
[  637.038011]  [<ffffffff8163f30a>] nf_iterate+0xca/0x180
[  637.038011]  [<ffffffff81650fd0>] ? ip_fragment+0x8e0/0x8e0
[  637.038011]  [<ffffffff8163f494>] nf_hook_slow+0xd4/0x270
[  637.038011]  [<ffffffff81650fd0>] ? ip_fragment+0x8e0/0x8e0
[  637.038011]  [<ffffffff816530c2>] ip_output+0x92/0x110
[  637.038011]  [<ffffffff8164d958>] ip_forward_finish+0xa8/0x4b0
[  637.038011]  [<ffffffff8164df51>] ip_forward+0x1f1/0x560
[  637.038011]  [<ffffffff8164b270>] ip_rcv_finish+0x160/0x710
[  637.038011]  [<ffffffff8164c1d8>] ip_rcv+0x298/0x3d0
[  637.038011]  [<ffffffff816068f2>] __netif_receive_skb_core+0x992/0xd00
[  637.038011]  [<ffffffff8160609b>] ? __netif_receive_skb_core+0x13b/0xd00
[  637.038011]  [<ffffffff81606c78>] __netif_receive_skb+0x18/0x60
[  637.038011]  [<ffffffff81606d7e>] process_backlog+0xbe/0x1a0
[  637.038011]  [<ffffffff8160865a>] net_rx_action+0x15a/0x280
[  637.038011]  [<ffffffff8108d83d>] __do_softirq+0x12d/0x300
[  637.038011]  [<ffffffff816513b8>] ? ip_finish_output+0x3e8/0x930
[  637.038011]  [<ffffffff817582bc>] do_softirq_own_stack+0x1c/0x30
[  637.038011]  <EOI>
[  637.038011]  [<ffffffff8108daed>] do_softirq+0x7d/0x90
[  637.038011]  [<ffffffff8108dbcb>] __local_bh_enable_ip+0xcb/0xe0
[  637.038011]  [<ffffffff816513e1>] ip_finish_output+0x411/0x930
[  637.038011]  [<ffffffff81651216>] ? ip_finish_output+0x246/0x930
[  637.038011]  [<ffffffff81653098>] ip_output+0x68/0x110
[  637.038011]  [<ffffffff81652439>] ip_local_out+0x29/0x90
[  637.038011]  [<ffffffff81652901>] ip_queue_xmit+0x1e1/0x630
[  637.038011]  [<ffffffff81652725>] ? ip_queue_xmit+0x5/0x630
[  637.038011]  [<ffffffff8166b827>] tcp_transmit_skb+0x467/0xa90
[  637.038011]  [<ffffffff8166d562>] tcp_connect+0x812/0xa40
[  637.038011]  [<ffffffff810fef0e>] ? getnstimeofday+0xe/0x30
[  637.038011]  [<ffffffff810fef96>] ? ktime_get_real+0x16/0x50
[  637.038011]  [<ffffffff815fe43b>] ? secure_tcp_sequence_number+0x5b/0xa0
[  637.038011]  [<ffffffff81671602>] tcp_v4_connect+0x2b2/0x4e0
[  637.038011]  [<ffffffff81691083>] __inet_stream_connect+0xa3/0x400
[  637.038011]  [<ffffffff815ec6e3>] ? lock_sock_nested+0x33/0xa0
[  637.038011]  [<ffffffff810dfe4d>] ? trace_hardirqs_on+0xd/0x10
[  637.038011]  [<ffffffff8108db75>] ? __local_bh_enable_ip+0x75/0xe0
[  637.038011]  [<ffffffff81691418>] inet_stream_connect+0x38/0x50
[  637.038011]  [<ffffffff815e9977>] SYSC_connect+0xc7/0x100
[  637.038011]  [<ffffffff810fe989>] ? current_kernel_time+0x69/0xd0
[  637.038011]  [<ffffffff810dfd75>] ? trace_hardirqs_on_caller+0x105/0x1d0
[  637.038011]  [<ffffffff810dfe4d>] ? trace_hardirqs_on+0xd/0x10
[  637.038011]  [<ffffffff815ead2e>] SyS_connect+0xe/0x10
[  637.038011]  [<ffffffff817568e9>] system_call_fastpath+0x16/0x1b
[  637.038011] Code: b8 0d 00 00 41 29 cc 4c 0f af e0 e8 97 5f 60 e1
48 8b 93 38 01 00 00 49 c1 ec 20 48 85 d2 74 77 0f b6 42 11 84 c0 74
6f 48 01 d0 <48> 89 58 10 49 8b 95 b0 0d 00 00 4a 8d 14 e2 48 8b 0a 48
89 50
[  637.038011] RIP  [<ffffffffa01466e4>] nf_nat_setup_info+0x1f4/0x380 [nf_nat]
[  637.038011]  RSP <ffff88007fd03a08>
[  637.038011] CR2: 0000000000000010
[  637.038011] ---[ end trace faf2baaa3ece119f ]---

I use the following set of commands to reproduce this bug:

[root@localhost ~]# cat /etc/ppp/peers/pptpserver
pty "pptp X.X.X.X --nolaunchpppd"
name test
password 1q2w3e
remotename PPTP
[root@localhost ~]# systemctl stop firewalld.service
[root@localhost ~]# modprobe ip_gre
[root@localhost ~]# modprobe ip_nat_pptp
[root@localhost ~]# modprobe ip_conntrack_pptp
[root@localhost ~]# pppd call pptpserver
[root@localhost ~]#
[root@localhost ~]# ip netns add test
[root@localhost ~]# ip link add name veth0 type veth peer name veth1
[root@localhost ~]# ip link set dev veth0 netns test
[root@localhost ~]# ip link set up dev veth1
[root@localhost ~]# ip a add 192.168.101.3/24 dev veth1
[root@localhost ~]# ip netns exec test ip link set up dev veth0
[root@localhost ~]# ip netns exec test ip a add 192.168.101.2/24 dev veth0
[root@localhost ~]# ip netns exec test ip r add default via 192.168.101.3
[root@localhost ~]# iptables -t nat -A POSTROUTING -s 192.168.101.0/24
-o eth0 -j SNAT --to 192.168.122.39
[root@localhost ~]# ip netns exec test bash
[root@localhost ~]# pppd call pptpserver
[root@localhost ~]# cat /proc/self/net/nf_conntrack
ipv4     2 udp      17 25 src=0.0.0.0 dst=255.255.255.255 sport=68
dport=67 [UNREPLIED] src=255.255.255.255 dst=0.0.0.0 sport=67 dport=68
mark=0 zone=0 use=2
ipv4     2 gre      47 29 timeout=30, stream_timeout=180
src=192.168.101.2 dst=10.30.2.57 srckey=0x0 dstkey=0x983 [UNREPLIED]
src=10.30.2.57 dst=192.168.101.2 srckey=0x983 dstkey=0x0 mark=0 zone=0
use=2
[root@localhost ~]# cat /proc/self/net/nf_conntrack
ipv4     2 udp      17 2 src=0.0.0.0 dst=255.255.255.255 sport=68
dport=67 [UNREPLIED] src=255.255.255.255 dst=0.0.0.0 sport=67 dport=68
mark=0 zone=0 use=2
ipv4     2 gre      47 6 timeout=30, stream_timeout=180
src=192.168.101.2 dst=10.30.2.57 srckey=0x0 dstkey=0xb01 [UNREPLIED]
src=10.30.2.57 dst=192.168.101.2 srckey=0xb01 dstkey=0x0 mark=0 zone=0
use=2
[root@localhost ~]# cat /proc/self/net/nf_conntrack
[root@localhost ~]# pppd call pptpserver

And here is a place where the kernel oopses:
        if (maniptype == NF_NAT_MANIP_SRC) {
                unsigned int srchash;

                srchash = hash_by_src(net, nf_ct_zone(ct),
                                      &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
                spin_lock_bh(&nf_nat_lock);
                /* nf_conntrack_alter_reply might re-allocate extension aera */
                nat = nfct_nat(ct);
                nat->ct = ct;
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                hlist_add_head_rcu(&nat->bysource,
                                   &net->ct.nat_bysource[srchash]);
                spin_unlock_bh(&nf_nat_lock);
        }

I have seen this bug on 3.13.6-200.fc20.x86_64 too.

Thanks,
Andrey
