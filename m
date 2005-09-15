From: Nuutti Kotivuori <naked@iki.fi>
Subject: Re: netfilter QUEUE target and packet socket interactions buggy or
	not
Date: Thu, 15 Sep 2005 11:50:19 +0300
Message-ID: <8764t290l0.fsf@aka.i.naked.iki.fi>
References: <87fysa9bqt.fsf@aka.i.naked.iki.fi>
	<20050912.151120.104514011.davem@davemloft.net>
	<87br2xap9o.fsf@aka.i.naked.iki.fi>
	<877jdl9r1u.fsf@aka.i.naked.iki.fi> <4326FF69.9060004@trash.net>
	<873bo8akvk.fsf@aka.i.naked.iki.fi>
	<87irx396xk.fsf@aka.i.naked.iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Nuutti Kotivuori wrote:
> But also, if it is that particular spot that causes this exact crash -
> the problem should go away if selinux is disabled, even though the bug
> still exists (socket being freed before skb stops referencing it).

The setup crashes even with selinux disabled. The crash is different,
and is preceded by kernel messages. Here it is:

...
ip_queue: full at 1024 entries, dropping packet(s).
printk: 158 messages suppressed.
ip_queue: full at 1024 entries, dropping packet(s).
printk: 153 messages suppressed.
ip_queue: full at 1024 entries, dropping packet(s).
printk: 152 messages suppressed.
<1>Unable to handle kernel NULL pointer dereference at virtual address 000000a4
 printing eip:
f8890da9
*pde = 2e4db001
Oops: 0000 [#1]
SMP
Modules linked in: arpt_mangle arptable_filter arp_tables iptable_filter ip_tables ip_queue parport_pc lp parport netconsole netdump autofs4 i2c_dev i2c_core sunrpc dm_mod button poll_napi+0x64/0x84
 [<c027eb58>] netpoll_poll+0x30/0x35
 [<c027ecfb>] netpoll_send_skb+0x8f/0x98
 [<f88b5156>] write_msg+0x156/0x16d [netconsole]
 [<f88b5000>] write_msg+0x0/0x16d [netconsole]
 [<c01217c7>] __call_console_drivers+0x36/0x40
 [<c01218df>] call_console_drivers+0xb6/0xd8
 [<c0121bd3>] release_console_sem+0x43/0xa9
 [<c0121b1d>] vprintk+0x136/0x14a
 [<c01219e4>] printk+0xe/0x11
 [<f88f1413>] ipq_enqueue_packet+0xd1/0x143 [ip_queue]
 [<c027cd21>] nf_queue+0x148/0x201
 [<c028a676>] ip_local_deliver_finish+0x0/0x188
 [<c027ce46>] nf_hook_slow+0x6c/0xb4
 [<c028a676>] ip_local_deliver_finish+0x0/0x188
 [<c028a66f>] ip_local_deliver+0x1d9/0x1e0
 [<c028a676>] ip_local_deliver_finish+0x0/0x188
 [<c028ab5c>] ip_rcv+0x35e/0x3ff
 [<c0274569>] netif_receive_skb+0x1f1/0x21f
 [<f8890e27>] tg3_rx+0x2a3/0x3a0 [tg3]
 [<f8890fbd>] tg3_poll+0x99/0x11a [tg3]
 [<c02746f5>] net_rx_action+0x61/0xd8
 [<c0125a5c>] __do_softirq+0x4c/0xb1
 [<c010806d>] do_softirq+0x4f/0x56
 =======================
 [<c0107983>] do_IRQ+0x125/0x130
 [<c02c7d34>] common_interrupt+0x18/0x20
 [<c0104018>] default_idle+0x0/0x2c
 [<c0104041>] default_idle+0x29/0x2c
 [<c010409d>] cpu_idle+0x26/0x3b
 [<c0384784>] start_kernel+0x194/0x198
Code: 01 6b 60 01 e8 3b 83 ac 00 00 00 89 83 a8 00 00 00 76 0e 89 ea 89 d8 b9 9a 0d 89 f8 e8

-- Naked
