From: Matt Walters <mattw@parasun.com>
Subject: libipq, kernel panics/oopses, and other undesirable traits
Date: Fri, 13 Aug 2004 17:04:42 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1092441882.22731.121.camel@marx.mindlink.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Evening, all-

	I've got a fun one here.   I've been developing some userspace packet
filtering stuff with netfilter using libipq with varying levels of
success.  As long as I'm only dropping or accepting packets without
modifying them, life is peachy.  I can modify packets as well - as long
as the data rate is low.  Once the data rate reaches a certain point,
the kernel panics, dumps a stack trace, or what have you (I saw my first
double fault today, which I don't think is a very good sign -- all the
issues I'm having just scream "race condition").  Sporadically the
phrase "Debug: sleeping function called from invalid context at
include/linux/rwsem.h" will appear on the console, as well as "KERNEL:
assertion (!atomic_read(&sk->sk_rmem_alloc)) failed at
netlink/af_netlink.c (98)" -- this one almost always appears when the
application locks up and I rmmod ip_queue (which makes sense, and
hopefully points some fingers at where this issue is happening). 
Unloading the ip_queue module, restarting iptables (when it will
restart), and modprobing ip_queue allows my software to continue life
happily (until everything blows up again).

	I'd been working on the assumption that it was my code stomping on
something and causing the issue, but after sanity-checking everything
(and then sanity-checking the sanity checks), I have become convinced
that this is not the case.  On a hunch, I modified the libipq test code
(from the manpage) to copy the packet contents back from userspace
(without modifying them, of course), set up a quick pingflood (large
packets) across a gigabit network, and the kernel panicked after a dozen
or so pings made it back to the source.  The only packets being sent to
the QUEUE target are inbound or outbound ICMP, incidentally.

	I replaced the following line:
status = ipq_set_verdict(h, m->packet_id, NF_ACCEPT, 0, NULL);

	With:
status = ipq_set_verdict(h, m->packet_id, NF_ACCEPT, m->data_len,
m->payload);

	The machine in question is a Supermicro server, dual Intel e1000
gigabit NICs, dual Xeon 2.8GHz (HT enabled), 2GB of RAM.  It's a 2.6.7
kernel, I'm playing with / linking to iptables 1.2.11.

	I'm at the end of my rope on this one, and someone slapping me upside
the head would be great.

	Below is one of the stack traces that actually made it into the logs
(oh yeah - did I mention that sometimes the machine is kind of alright
after this?  mostly it locks up immediately, or locks up trying to stop
iptables though).  The trace is from one of the times that it exploded
with my application, not the test code.

	Thanks in advance for any hints, confirmations, denials, drop-kicks or
head smacks you might be able to offer.  I'm going to try compiling a
non-SMP kernel tonight or tomorrow to see if the issue persists, and I
will update the list.

-Matt

trace:

kernel: Unable to handle kernel paging request at virtual address
2f2e2d2c
kernel:  printing eip:
kernel: c0144d2b
kernel: *pde = 35c9d001
kernel: *pte = 00000000
kernel: Oops: 0000 [#1]
kernel: SMP
kernel: Modules linked in: ip_queue autofs4 ipt_state ip_conntrack
iptable_filter ip_tables sg dm_mod uhci_hcd ext3 jbd raid5 xor raid1
aic79xx sd_mod scsi_mod
kernel: CPU:    0
kernel: EIP:    0060:[<c0144d2b>]    Not tainted
kernel: EFLAGS: 00010282   (2.6.7-3)
kernel: EIP is at put_page+0x7/0x8a
kernel: eax: 2f2e2d2c   ebx: 00000001   ecx: f3b02c80   edx: 2f2e2d2c
kernel: esi: f512ea80   edi: f512ea80   ebp: f3cd6800   esp: f3bdbb20
kernel: ds: 007b   es: 007b   ss: 0068
kernel: Process trafficd (pid: 2823, threadinfo=f3bda000 task=f5b65870)
kernel: Stack: 00000000 c0288317 2f2e2d2c 001d4000 f3cd6c80 c028c9e3
f512ea80 fffffffe
kernel:        f3cd6800 0000043c f7ba6800 2b2a2928 f3b02810 fffffff4
c028cc8e f512ea80
kernel:        00000020 f512ea80 c217617c f3b02810 c2176154 c02ab25b
f512ea80 f7ba6800
kernel: Call Trace:
kernel:  [<c0288317>] skb_release_data+0x74/0x8f
kernel:  [<c028c9e3>] __skb_linearize+0xdf/0x120
kernel:  [<c028cc8e>] dev_queue_xmit+0x26a/0x27c
kernel:  [<c02ab25b>] ip_finish_output2+0xa6/0x1a7
kernel:  [<c02ab1b5>] ip_finish_output2+0x0/0x1a7
kernel:  [<c02ab1b5>] ip_finish_output2+0x0/0x1a7
kernel:  [<c0296435>] nf_hook_slow+0xc4/0xf9
kernel:  [<c02ab1b5>] ip_finish_output2+0x0/0x1a7
kernel:  [<c02a8d42>] ip_finish_output+0x1fb/0x200
kernel:  [<c02ab1b5>] ip_finish_output2+0x0/0x1a7
kernel:  [<c02a9c3b>] ip_fragment+0x635/0x748
kernel:  [<c0288405>] __kfree_skb+0xa7/0x12c
kernel:  [<c02cd32b>] icmp_rcv+0xfc/0x1c6
kernel:  [<c02a8f66>] ip_output+0x6c/0x78
kernel:  [<c02a8b47>] ip_finish_output+0x0/0x200
kernel:  [<c02ab1a0>] dst_output+0x14/0x29
kernel:  [<c0296677>] nf_reinject+0x20d/0x23c
kernel:  [<c02ab18c>] dst_output+0x0/0x29
kernel:  [<f8a3e025>] ipq_issue_verdict+0x25/0x35 [ip_queue]
kernel:  [<f8a3e841>] ipq_set_verdict+0x51/0x82 [ip_queue]
kernel:  [<f8a3e941>] ipq_receive_peer+0x4c/0x62 [ip_queue]
kernel:  [<f8a3eb0c>] ipq_rcv_sk+0x156/0x1c9 [ip_queue]
kernel:  [<c029f6c7>] netlink_data_ready+0x62/0x6a
kernel:  [<c029ed65>] netlink_sendskb+0xa4/0xa6
kernel:  [<c029f36c>] netlink_sendmsg+0x205/0x2f4
kernel:  [<c0284867>] sock_sendmsg+0x9e/0xca
kernel:  [<c028492f>] sock_recvmsg+0x9c/0xb7
kernel:  [<c01b38b0>] copy_from_user+0x52/0x7e
kernel:  [<c01b38b0>] copy_from_user+0x52/0x7e
kernel:  [<c0289d78>] verify_iovec+0x3c/0x94
kernel:  [<c02861e6>] sys_sendmsg+0x189/0x1e6
kernel:  [<c02843d1>] move_addr_to_user+0x62/0x6d
kernel:  [<c016ba55>] poll_freewait+0x38/0x40
kernel:  [<c016ba5d>] __pollwait+0x0/0xc7
kernel:  [<c01b38b0>] copy_from_user+0x52/0x7e
kernel:  [<c0286670>] sys_socketcall+0x236/0x254
kernel:  [<c0105edd>] sysenter_past_esp+0x52/0x71
kernel:
kernel: Code: 8b 02 a9 00 00 08 00 75 41 8b 02 f6 c4 08 75 22 8b 02 89
d1
