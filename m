From: Bernhard Schmidt <berni@birkenwald.de>
Subject: OOPS with new Conntrack code
Date: Tue, 2 Jan 2007 14:54:47 +0100
Message-ID: <20070102135447.GA19013@obelix.birkenwald.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

Hi,

I'm currently running 2.6.20-rc3 to test IPv4 NAT together with IPv6
connection tracking. Whenever my PPPoE connection terminates (regular
24h disconnect or manual disconnect by killing pppd) the box OOPSes.

heimdall:~# killall -HUP pppd
heimdall:~# Oops: 0000 [#1]
Modules linked in: sit sch_red sch_htb pppoe pppox ppp_generic slhc xt_CLASSIFY ipt_TOS xt_length ipt_tos ipt_TCPMSS xt_tcpudp ipt_MASQUERADE xt_state iptabk
CPU:    0
EIP:    0060:[<ce89807c>]    Not tainted VLI
EFLAGS: 00010206   (2.6.20-rc3 #2)
EIP is at device_cmp+0x1c/0x30 [ipt_MASQUERADE]
eax: cd27e000   ebx: 00000000   ecx: cdf491e0   edx: 00000004
esi: 00000004   edi: 00000128   ebp: 00000025   esp: cd27fe98
ds: 007b   es: 007b   ss: 0068
Process pppd (pid: 1855, ti=cd27e000 task=cde26a70 task.ti=cd27e000)
Stack: ccc3f64c ccc3f684 ce823972 00000004 ce898060 ce8b9e40 ce898778 ccc83400 
       00000002 ce898052 c0119b19 ccc83400 000010d0 00001291 cd00c48c c021743c 
       ccc83400 c0216a3a ccf99be0 cd27ff21 ccf99c0c cd00c48c c0250d13 cd27ff3c 
Call Trace:
 [<ce823972>] nf_ct_iterate_cleanup+0x62/0xe0 [nf_conntrack]
 [<ce898060>] device_cmp+0x0/0x30 [ipt_MASQUERADE]
 [<ce898052>] masq_device_event+0x12/0x20 [ipt_MASQUERADE]
 [<c0119b19>] notifier_call_chain+0x19/0x30
 [<c021743c>] dev_close+0x5c/0x60
 [<c0216a3a>] dev_change_flags+0x4a/0xf0
 [<c0250d13>] devinet_ioctl+0x223/0x560
 [<c020df75>] sock_ioctl+0x195/0x1c0
 [<c028019a>] schedule+0x48a/0x4f0
 [<c020dde0>] sock_ioctl+0x0/0x1c0
 [<c014a3f9>] do_ioctl+0x19/0x50
 [<c014a60b>] vfs_ioctl+0x1db/0x1f0
 [<c014a655>] sys_ioctl+0x35/0x50
 [<c01028c0>] syscall_call+0x7/0xb
 =======================
Code: ff 31 c0 c3 8d 74 26 00 8d bc 27 00 00 00 00 56 53 89 d6 f6 80 9c 00 00 00 02 75 04 31 db eb 06 8d 98 d8 00 00 00 e8 14 b7 87 f1 <39> 73 1c 0f 94 c0 0 
EIP: [<ce89807c>] device_cmp+0x1c/0x30 [ipt_MASQUERADE] SS:ESP 0068:cd27fe98
 <0>Kernel panic - not syncing: Fatal exception in interrupt
 <0>Rebooting in 20 seconds..<4>atkbd.c: Spurious ACK on isa0060/serio0. Some program might be trying access hardware directly.
atkbd.c: Spurious ACK on isa0060/serio0. Some program might be trying access hardware directly.
atkbd.c: Spurious ACK on isa0060/serio0. Some program might be trying access hardware directly.
atkbd.c: Spurious ACK on isa0060/serio0. Some program might be trying access hardware directly.

The rules are pretty much basic, some port forwardings using DNAT, MASQUERADE 
for connections going out to ppp0, stateful filters for IPv4. An IPv6-in-IPv4
is configured as well for IPv6 connectivity.

Do you need additional information to debug this?

Regards,
Bernhard
