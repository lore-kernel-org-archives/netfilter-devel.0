From: "webmaster @ elnportal.it" <webmaster@elnportal.it>
Subject: Possible BUG or similar
Date: Sun, 22 Jan 2006 20:46:17 +0100
Message-ID: <001101c61f8c$83959a60$0201a8c0@gorionstable>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

I'm running fedora core 4 on two A64 PC.

Kernel 2.6.16-rc1 installed for using ipsec 01 output, input ecc hook to do 
snat.

Openswan with 4 tunnels up and running.

If I use the first tunnel (ping) all goes correctly, but if i try to ping 
from one other tunnel (on the same  pc or the other) the kernel oops

Jan 22 20:23:17 router kernel: Unable to handle kernel NULL pointer 
dereference at 000000000000009c RIP:
Jan 22 20:23:17 router kernel: <ffffffff80345195>{xfrm4_output_finish+293}
Jan 22 20:23:17 router kernel: PGD 35377067 PUD 0
Jan 22 20:23:17 router kernel: Oops: 0000 [6]
Jan 22 20:23:17 router kernel: CPU 0
Jan 22 20:23:17 router kernel: Modules linked in: af_key deflate 
zlib_deflate twofish serpent blowfish sha256 crypto_null ae$
Jan 22 20:23:17 router kernel: Pid: 9481, comm: ping Not tainted 2.6.16-rc1 
#2
Jan 22 20:23:17 router kernel: RIP: 0010:[<ffffffff80345195>] 
<ffffffff80345195>{xfrm4_output_finish+293}
Jan 22 20:23:17 router kernel: RSP: 0018:ffff810030c19a78  EFLAGS: 00010297
Jan 22 20:23:17 router kernel: RAX: 0000000000000000 RBX: ffff810032242c3c 
RCX: 0000000000000001
Jan 22 20:23:17 router kernel: RDX: 0000000000000001 RSI: 0000000000000449 
RDI: ffff81003cba4d80
Jan 22 20:23:17 router kernel: RBP: ffff81003cba4d80 R08: 0000000000001d4b 
R09: ffffffff804ac460
Jan 22 20:23:17 router kernel: R10: 000000000000001a R11: ffff810032242878 
R12: 0000000000000000
Jan 22 20:23:17 router kernel: R13: 0000000000000040 R14: 0000000000000040 
R15: ffff810038dff9c0
Jan 22 20:23:17 router kernel: FS:  00002aeb6a96fd00(0000) 
GS:ffffffff804ba000(0000) knlGS:0000000000000000
Jan 22 20:23:17 router kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
000000008005003b
Jan 22 20:23:17 router kernel: CR2: 000000000000009c CR3: 0000000038565000 
CR4: 00000000000006e0
Jan 22 20:23:17 router kernel: Process ping (pid: 9481, threadinfo 
ffff810030c18000, task ffff81003ba90180)
Jan 22 20:23:17 router kernel: Stack: ffffffff80345070 0000000080000000 
00000002804ac450 ffffffff80307864
Jan 22 20:23:17 router kernel:        ffff81003cba4d80 ffff810032242c3c 
ffff81003ed74a40 ffff81003868f0c0
Jan 22 20:23:17 router kernel:        0000000000000040 0000000000000040
Jan 22 20:23:17 router kernel: Call Trace: 
<ffffffff80345070>{xfrm4_output_finish+0}
Jan 22 20:23:17 router kernel:        <ffffffff80307864>{nf_hook_slow+100} 
<ffffffff803454b4>{xfrm4_output+84}
Jan 22 20:23:17 router kernel: 
<ffffffff8031289f>{ip_push_pending_frames+895} 
<ffffffff8032cf95>{raw_sendmsg+1685}
Jan 22 20:23:17 router kernel: 
<ffffffff803484e9>{xfrm_state_get_afinfo+73} 
<ffffffff8034a16c>{xfrm_state_find+2588}
Jan 22 20:23:17 router kernel:        <ffffffff802e28fa>{sock_sendmsg+266} 
<ffffffff80127e3d>{try_to_wake_up+301}
Jan 22 20:23:17 router kernel: 
<ffffffff80140a10>{autoremove_wake_function+0} 
<ffffffff80357f99>{_read_unlock_irq+9}
Jan 22 20:23:17 router kernel:        <ffffffff80151f46>{filemap_nopage+390} 
<ffffffff802e1935>{move_addr_to_kernel+37}
Jan 22 20:23:17 router kernel:        <ffffffff802e2f9a>{sys_sendmsg+586} 
<ffffffff80357ea9>{_spin_lock_irqsave+9}
Jan 22 20:23:17 router kernel: 
<ffffffff80140bb9>{remove_wait_queue+25} 
<ffffffff80357ea9>{_spin_lock_irqsave+9}
Jan 22 20:23:17 router kernel:        <ffffffff80203a81>{__up_read+33} 
<ffffffff80359583>{do_page_fault+1139}
Jan 22 20:23:17 router kernel:        <ffffffff802e4f29>{release_sock+25} 
<ffffffff80357f59>{_spin_unlock_irq+9}
Jan 22 20:23:17 router kernel:        <ffffffff8010ab12>{system_call+126}
Jan 22 20:23:17 router kernel:
Jan 22 20:23:17 router kernel: Code: 41 80 bc 24 9c 00 00 00 00 74 57 48 8d 
4d 58 48 8b 75 38 0f
Jan 22 20:23:17 router kernel: RIP 
<ffffffff80345195>{xfrm4_output_finish+293} RSP <ffff810030c19a78>
Jan 22 20:23:17 router kernel: CR2: 000000000000009c
Jan 22 20:24:42 router rmmod: ERROR: Module xfrm4_tunnel is in use


here u can see my configurations files for openswan (the same on both 
machines)

version 2.0

config setup
        nat_traversal=yes
        interfaces="ipsec0=eth0"
        plutodebug=all
        virtual_private=%v4:10.0.0.0/26,%v4:10.1.0.0/27 (different on the 
two openswan GW)

conn %default
        keyingtries=0
        disablearrivalcheck=no

conn roadwarrior-l2tp
        type=transport
        left=PUB_IP2
        leftprotoport=17/1701
        right=%any
        rightprotoport=17/1701
        pfs=no
        authby=secret
        auto=add

conn R
        left=PUB_IP_1
        leftsubnet=10.0.1.0/24
        leftnexthop=PUB_GW_IP1
        right=PUB_IP2
        rightsubnet=10.0.0.0/26
        rightnexthop=PUB_GW_IP2
        compress=yes
        authby=secret
        auto=start

conn B
        left=PUB_IP_1
        leftsubnet=10.2.0.0/27
        leftnexthop=PUB_GW_IP1
        right=PUB_IP2
        rightsubnet=10.1.0.0/24
        rightnexthop=PUB_GW_IP2
        compress=yes
        authby=secret
        auto=start

include /etc/ipsec.d/examples/no_oe.conf

10.0.1.0/24, 10.2.0.0/27 --- PUB_GW1 --- PUB_IP1 === PUB_IP2 --- PUB_GW2 ---  
10.0.0.0/26, 10.1.0.0/24

ty 
