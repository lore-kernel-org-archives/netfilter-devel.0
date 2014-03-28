From: Andrey Wagin <avagin@gmail.com>
Subject: The same nf_ct_gre_keymap is deleted from list twice
Date: Fri, 28 Mar 2014 23:02:05 +0400
Message-ID: <CANaxB-ySFjjYuAOJxwb5us+C=w1oES6BySgTkb0z6Qtk=3t3ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: vvs@openvz.org
To: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vc0-f180.google.com ([209.85.220.180]:58284 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaC1TCH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Mar 2014 15:02:07 -0400
Received: by mail-vc0-f180.google.com with SMTP id lf12so6146240vcb.39
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Mar 2014 12:02:06 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello All,

nf_ct_gre_keymap_flush() deletes nf_ct_gre_keymap from
net_gre->keymap_list, but doesn't clear
nfct_help_data(ct)->keymap[dir]. Then nf_ct_gre_keymap_destroy()
deletes it again. Actually both of these functions frees this object.

[  226.540793] general protection fault: 0000 [#1] SMP
[  226.541750] Modules linked in: nf_nat_pptp nf_nat_proto_gre
nf_conntrack_pptp nf_conntrack_proto_gre ip_gre ip_tunnel gre
ppp_deflate bsd_comp ppp_async crc_ccitt ppp_generic slhc xt_nat
iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat
nf_conntrack veth tun bridge stp llc ppdev microcode joydev pcspkr
serio_raw virtio_console virtio_balloon floppy parport_pc parport
pvpanic i2c_piix4 virtio_net drm_kms_helper ttm ata_generic virtio_pci
virtio_ring virtio drm i2c_core pata_acpi [last unloaded: ip_tunnel]
[  226.541776] CPU: 0 PID: 49 Comm: kworker/u4:2 Not tainted 3.14.0-rc8+ #101
[  226.541776] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  226.541776] Workqueue: netns cleanup_net
[  226.541776] task: ffff8800371e0000 ti: ffff88003730c000 task.ti:
ffff88003730c000
[  226.541776] RIP: 0010:[<ffffffff81389ba9>]  [<ffffffff81389ba9>]
__list_del_entry+0x29/0xd0
[  226.541776] RSP: 0018:ffff88003730dbd0  EFLAGS: 00010a83
[  226.541776] RAX: 6b6b6b6b6b6b6b6b RBX: ffff8800374e6c40 RCX: dead000000200200
[  226.541776] RDX: 6b6b6b6b6b6b6b6b RSI: ffff8800371e07d0 RDI: ffff8800374e6c40
[  226.541776] RBP: ffff88003730dbd0 R08: 0000000000000000 R09: 0000000000000000
[  226.541776] R10: 0000000000000001 R11: ffff88003730d92e R12: 0000000000000002
[  226.541776] R13: ffff88007a4c42d0 R14: ffff88007aef0000 R15: ffff880036cf0018
[  226.541776] FS:  0000000000000000(0000) GS:ffff88007fc00000(0000)
knlGS:0000000000000000
[  226.541776] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  226.541776] CR2: 00007f07f643f7d0 CR3: 0000000036fd2000 CR4: 00000000000006f0
[  226.541776] Stack:
[  226.541776]  ffff88003730dbe8 ffffffff81389c5d ffff8800374ffbe4
ffff88003730dc28
[  226.541776]  ffffffffa0162a43 ffffffffa01627c5 ffff88007a4c42d0
ffff88007aef0000
[  226.541776]  ffffffffa01651c0 ffff88007a4c45e0 ffff88007aef0000
ffff88003730dc40
[  226.541776] Call Trace:
[  226.541776]  [<ffffffff81389c5d>] list_del+0xd/0x30
[  226.541776]  [<ffffffffa0162a43>]
nf_ct_gre_keymap_destroy+0x283/0x2d0 [nf_conntrack_proto_gre]
[  226.541776]  [<ffffffffa01627c5>] ?
nf_ct_gre_keymap_destroy+0x5/0x2d0 [nf_conntrack_proto_gre]
[  226.541776]  [<ffffffffa0162ab7>] gre_destroy+0x27/0x70
[nf_conntrack_proto_gre]
[  226.541776]  [<ffffffffa0117de3>] destroy_conntrack+0x83/0x200 [nf_conntrack]
[  226.541776]  [<ffffffffa0117d87>] ? destroy_conntrack+0x27/0x200
[nf_conntrack]
[  226.541776]  [<ffffffffa0117d60>] ?
nf_conntrack_hash_check_insert+0x2e0/0x2e0 [nf_conntrack]
[  226.541776]  [<ffffffff81630142>] nf_conntrack_destroy+0x72/0x180
[  226.541776]  [<ffffffff816300d5>] ? nf_conntrack_destroy+0x5/0x180
[  226.541776]  [<ffffffffa011ef80>] ? kill_l3proto+0x20/0x20 [nf_conntrack]
[  226.541776]  [<ffffffffa011847e>] nf_ct_iterate_cleanup+0x14e/0x170
[nf_conntrack]
[  226.541776]  [<ffffffffa011f74b>]
nf_ct_l4proto_pernet_unregister+0x5b/0x90 [nf_conntrack]
[  226.541776]  [<ffffffffa0162409>] proto_gre_net_exit+0x19/0x30
[nf_conntrack_proto_gre]
[  226.541776]  [<ffffffff815edf89>] ops_exit_list.isra.1+0x39/0x60
[  226.541776]  [<ffffffff815eecc0>] cleanup_net+0x100/0x1d0
[  226.541776]  [<ffffffff810a608a>] process_one_work+0x1ea/0x4f0
[  226.541776]  [<ffffffff810a6028>] ? process_one_work+0x188/0x4f0
[  226.541776]  [<ffffffff810a64ab>] worker_thread+0x11b/0x3a0
[  226.541776]  [<ffffffff810a6390>] ? process_one_work+0x4f0/0x4f0
[  226.541776]  [<ffffffff810af42d>] kthread+0xed/0x110
[  226.541776]  [<ffffffff8173d4dc>] ? _raw_spin_unlock_irq+0x2c/0x40
[  226.541776]  [<ffffffff810af340>] ? kthread_create_on_node+0x200/0x200
[  226.541776]  [<ffffffff8174747c>] ret_from_fork+0x7c/0xb0
[  226.541776]  [<ffffffff810af340>] ? kthread_create_on_node+0x200/0x200
[  226.541776] Code: 00 00 55 48 8b 17 48 b9 00 01 10 00 00 00 ad de
48 8b 47 08 48 89 e5 48 39 ca 74 29 48 b9 00 02 20 00 00 00 ad de 48
39 c8 74 7a <4c> 8b 00 4c 39 c7 75 53 4c 8b 42 08 4c 39 c7 75 2b 48 89
42 08
[  226.541776] RIP  [<ffffffff81389ba9>] __list_del_entry+0x29/0xd0
[  226.541776]  RSP <ffff88003730dbd0>
[  226.612193] ---[ end trace 985ae23ddfcc357c ]---

       <idle>-0     [001] ..s.  6791.694105: nf_ct_gre_keymap_add <-exp_gre
    kworker/u4:3-48    [001] ....  6821.554100:
nf_conntrack_pptp_net_exit <-ops_exit_list.isra.1
    kworker/u4:3-48    [001] ....  6821.554102: nf_ct_gre_keymap_flush
<-nf_conntrack_pptp_net_exit
    kworker/u4:3-48    [001] ....  6821.554105: proto_gre_net_exit
<-ops_exit_list.isra.1
    kworker/u4:3-48    [001] ....  6821.554105:
nf_ct_l4proto_pernet_unregister <-proto_gre_net_exit
    kworker/u4:3-48    [001] ....  6821.554106: nf_ct_iterate_cleanup
<-nf_ct_l4proto_pernet_unregister
    kworker/u4:3-48    [001] ....  6821.554169:
nf_ct_gre_keymap_destroy <-gre_destroy
    kworker/u4:3-48    [001] ....  6821.679711: nf_ct_gre_keymap_flush
<-proto_gre_net_exit

I use the following set of commands to reproduce this bug:
systemctl stop firewalld.service
ip netns add test
ip link add name veth0 type veth peer name veth1
ip link set dev veth0 netns test
ip link set up dev veth1
ip a add 192.168.101.3/24 dev veth1
ip netns exec test ip link set up dev veth0
ip netns exec test ip a add 192.168.101.2/24 dev veth0
ip netns exec test ip r add default via 192.168.101.3
iptables -t nat -A POSTROUTING -s 192.168.101.0/24 -o eth0 -j SNAT
--to 192.168.122.39
modprobe ip_gre
modprobe ip_nat_pptp
modprobe ip_conntrack_pptp
ip netns exec test pptpserver
ip netns del test
killall -9 pppd pptp
