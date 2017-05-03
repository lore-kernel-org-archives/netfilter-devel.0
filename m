From: dalin liu <kendodada@gmail.com>
Subject: .nf_ct_iterate_cleanup panic
Date: Wed, 3 May 2017 18:40:49 +0800
Message-ID: <CAHp8Fza4+-yF=FXtz6srQPggjvxrgexY-LgzmC9mUeyu2sZnHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:37910 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751063AbdECKkv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 May 2017 06:40:51 -0400
Received: by mail-wm0-f46.google.com with SMTP id r190so52852848wme.1
        for <netfilter-devel@vger.kernel.org>; Wed, 03 May 2017 03:40:50 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

kernel version: 4.4.56

In my linux box,when some PPPoE link are disconnected,
nf_ct_iterate_cleanup will be called.nf_ct_iterate_cleanup may have
access to the wrong conntrack address:

<1>[927268.772583] BUG: unable to handle kernel paging request at
ffff88a0050402c7
<1>[927268.785578] IP: [<ffffffff818c7472>] nf_ct_iterate_cleanup+0xa2/0x230
<4>[927268.792969] PGD 0
<4>[927268.800512] Oops: 0000 [#1] SMP
<4>[927268.808463] Modules linked in: ipmi_watchdog iptable_raw xt_CT
nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_ftp nf_conntrack_sip
nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_ftp
ip_set_hash_netiface ip_set_hash_net ip_set_hash_ip xt_set ip_set
ixgbe(O) vxlan igb(O) e1000e(O)
<4>[927268.862764] CPU: 46 PID: 6186 Comm: pppd Tainted: G           O
   4.4.56 #58
<4>[927268.882176] Hardware name: Supermicro Super Server/X10DRL-i,
BIOS 2.0a 08/25/2016
<4>[927268.903142] task: ffff880472611c40 ti: ffff880223ed8000
task.ti: ffff880223ed8000
<4>[927268.925685] RIP: 0010:[<ffffffff818c7472>]
[<ffffffff818c7472>] nf_ct_iterate_cleanup+0xa2/0x230
<4>[927268.949862] RSP: 0018:ffff880223edbc28  EFLAGS: 00010246
<4>[927268.962330] RAX: ffffc90001eb1000 RBX: ffffffff8193a8d0 RCX:
ffff8801f4a668a8
<4>[927268.988124] RDX: 0000000000000001 RSI: 0000000000000200 RDI:
ffffffff82007af4
<4>[927269.015332] RBP: ffff880223edbc78 R08: ffff88047fc43f08 R09:
0000000000000101
<4>[927269.043272] R10: 0000000000000000 R11: 0000000000000000 R12:
0000000000006c89
<4>[927269.072536] R13: ffffffff820ac780 R14: ffff88a005040290 R15:
ffff8801f56f2a80
<4>[927269.102576] FS:  00007f1d30a3d720(0000)
GS:ffff88047fc40000(0000) knlGS:0000000000000000
<4>[927269.132067] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[927269.147159] CR2: ffff88a0050402c7 CR3: 000000046e37e000 CR4:
00000000001406e0
<4>[927269.177840] Stack:
<4>[927269.192958]  ffff880223edbc38 0000000000000000 000000000000013d
ffffffff0013593d
<4>[927269.223469]  ffff880223edbc88 0000000000000002 ffff880223edbd20
00000000fffffff0
<4>[927269.253778]  ffffffff820b7050 0000000000000000 ffff880223edbc88
ffffffff8193a940
<4>[927269.283402] Call Trace:
<4>[927269.297585]  [<ffffffff8193a940>] masq_device_event+0x30/0x40
<4>[927269.311561]  [<ffffffff8108de0b>] notifier_call_chain+0x4b/0x70
<4>[927269.325391]  [<ffffffff8108df01>] raw_notifier_call_chain+0x11/0x20
<4>[927269.338999]  [<ffffffff81870c9b>] call_netdevice_notifiers_info+0x3b/0x70
<4>[927269.352544]  [<ffffffff81870d31>] call_netdevice_notifiers+0x11/0x20
<4>[927269.365945]  [<ffffffff818782ef>] __dev_notify_flags+0x5f/0xb0
<4>[927269.379318]  [<ffffffff81878a54>] dev_change_flags+0x54/0x70
<4>[927269.392522]  [<ffffffff8191bf31>] devinet_ioctl+0x5a1/0x670
<4>[927269.405462]  [<ffffffff8191cd16>] inet_ioctl+0x66/0x80
<4>[927269.418095]  [<ffffffff8185b776>] sock_ioctl+0x66/0x260
<4>[927269.430430]  [<ffffffff81176301>] do_vfs_ioctl+0x81/0x4d0
<4>[927269.442515]  [<ffffffff81176797>] SyS_ioctl+0x47/0x80
<4>[927269.454330]  [<ffffffff819ad997>] entry_SYSCALL_64_fastpath+0x12/0x6a
<4>[927269.465924] Code: 00 00 0f 83 54 01 00 00 49 8b 85 80 0c 00 00
4e 8b 34 f0 41 f6 c6 01 74 12 e9 3e 01 00 00 4d 8b 36 41 f6 c6 01 0f
85 31 01 00 00 <41> 80 7e 37 00 75 ec 4d 8d 7e f0 4c 89 e6 4c 89 ff ff
d3 85 c0
<1>[927269.506749] RIP  [<ffffffff818c7472>] nf_ct_iterate_cleanup+0xa2/0x230
<4>[927269.519054]  RSP <ffff880223edbc28>
<4>[927269.531071] CR2: ffff88a0050402c7
<4>[927269.552110] ---[ end trace 01e3243232603b17 ]---
<0>[927270.934341] Kernel panic - not syncing: Fatal exception in interrupt

----------------------------
103c: 0f 85 31 01 00 00     jne    1173 <nf_ct_iterate_cleanup+0x1d3>
if (NF_CT_DIRECTION(h) != IP_CT_DIR_ORIGINAL)
1042: 41 80 7e 37 00       cmpb   $0x0,0x37(%r14)
1047: 75 ec                 jne    1035 <nf_ct_iterate_cleanup+0x95>
