From: Patrick McHardy <kaber@trash.net>
Subject: Re: libipq, kernel panics/oopses, and other undesirable traits
Date: Sat, 14 Aug 2004 09:59:15 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <411DC653.1080805@trash.net>
References: <1092441882.22731.121.camel@marx.mindlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Matt Walters <mattw@parasun.com>
In-Reply-To: <1092441882.22731.121.camel@marx.mindlink.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Matt Walters wrote:
> 	Below is one of the stack traces that actually made it into the logs
> (oh yeah - did I mention that sometimes the machine is kind of alright
> after this?  mostly it locks up immediately, or locks up trying to stop
> iptables though).  The trace is from one of the times that it exploded
> with my application, not the test code.
> 
> 	Thanks in advance for any hints, confirmations, denials, drop-kicks or
> head smacks you might be able to offer.  I'm going to try compiling a
> non-SMP kernel tonight or tomorrow to see if the issue persists, and I
> will update the list.

This looks like the packet contents (ping) of a non-linear skb corrupted
the registers. Please try the ip_queue_nonlinear_skbs patch from
patch-o-matic-ng.

Regards
Patrick

> 
> -Matt
> 
> trace:
> 
> kernel: Unable to handle kernel paging request at virtual address
> 2f2e2d2c
> kernel:  printing eip:
> kernel: c0144d2b
> kernel: *pde = 35c9d001
> kernel: *pte = 00000000
> kernel: Oops: 0000 [#1]
> kernel: SMP
> kernel: Modules linked in: ip_queue autofs4 ipt_state ip_conntrack
> iptable_filter ip_tables sg dm_mod uhci_hcd ext3 jbd raid5 xor raid1
> aic79xx sd_mod scsi_mod
> kernel: CPU:    0
> kernel: EIP:    0060:[<c0144d2b>]    Not tainted
> kernel: EFLAGS: 00010282   (2.6.7-3)
> kernel: EIP is at put_page+0x7/0x8a
> kernel: eax: 2f2e2d2c   ebx: 00000001   ecx: f3b02c80   edx: 2f2e2d2c
> kernel: esi: f512ea80   edi: f512ea80   ebp: f3cd6800   esp: f3bdbb20
> kernel: ds: 007b   es: 007b   ss: 0068
> kernel: Process trafficd (pid: 2823, threadinfo=f3bda000 task=f5b65870)
> kernel: Stack: 00000000 c0288317 2f2e2d2c 001d4000 f3cd6c80 c028c9e3
> f512ea80 fffffffe
> kernel:        f3cd6800 0000043c f7ba6800 2b2a2928 f3b02810 fffffff4
> c028cc8e f512ea80
> kernel:        00000020 f512ea80 c217617c f3b02810 c2176154 c02ab25b
> f512ea80 f7ba6800
> kernel: Call Trace:
> kernel:  [<c0288317>] skb_release_data+0x74/0x8f
> kernel:  [<c028c9e3>] __skb_linearize+0xdf/0x120
> kernel:  [<c028cc8e>] dev_queue_xmit+0x26a/0x27c
> kernel:  [<c02ab25b>] ip_finish_output2+0xa6/0x1a7
> kernel:  [<c02ab1b5>] ip_finish_output2+0x0/0x1a7
> kernel:  [<c02ab1b5>] ip_finish_output2+0x0/0x1a7
> kernel:  [<c0296435>] nf_hook_slow+0xc4/0xf9
> kernel:  [<c02ab1b5>] ip_finish_output2+0x0/0x1a7
> kernel:  [<c02a8d42>] ip_finish_output+0x1fb/0x200
> kernel:  [<c02ab1b5>] ip_finish_output2+0x0/0x1a7
> kernel:  [<c02a9c3b>] ip_fragment+0x635/0x748
> kernel:  [<c0288405>] __kfree_skb+0xa7/0x12c
> kernel:  [<c02cd32b>] icmp_rcv+0xfc/0x1c6
> kernel:  [<c02a8f66>] ip_output+0x6c/0x78
> kernel:  [<c02a8b47>] ip_finish_output+0x0/0x200
> kernel:  [<c02ab1a0>] dst_output+0x14/0x29
> kernel:  [<c0296677>] nf_reinject+0x20d/0x23c
> kernel:  [<c02ab18c>] dst_output+0x0/0x29
> kernel:  [<f8a3e025>] ipq_issue_verdict+0x25/0x35 [ip_queue]
> kernel:  [<f8a3e841>] ipq_set_verdict+0x51/0x82 [ip_queue]
> kernel:  [<f8a3e941>] ipq_receive_peer+0x4c/0x62 [ip_queue]
> kernel:  [<f8a3eb0c>] ipq_rcv_sk+0x156/0x1c9 [ip_queue]
> kernel:  [<c029f6c7>] netlink_data_ready+0x62/0x6a
> kernel:  [<c029ed65>] netlink_sendskb+0xa4/0xa6
> kernel:  [<c029f36c>] netlink_sendmsg+0x205/0x2f4
> kernel:  [<c0284867>] sock_sendmsg+0x9e/0xca
> kernel:  [<c028492f>] sock_recvmsg+0x9c/0xb7
> kernel:  [<c01b38b0>] copy_from_user+0x52/0x7e
> kernel:  [<c01b38b0>] copy_from_user+0x52/0x7e
> kernel:  [<c0289d78>] verify_iovec+0x3c/0x94
> kernel:  [<c02861e6>] sys_sendmsg+0x189/0x1e6
> kernel:  [<c02843d1>] move_addr_to_user+0x62/0x6d
> kernel:  [<c016ba55>] poll_freewait+0x38/0x40
> kernel:  [<c016ba5d>] __pollwait+0x0/0xc7
> kernel:  [<c01b38b0>] copy_from_user+0x52/0x7e
> kernel:  [<c0286670>] sys_socketcall+0x236/0x254
> kernel:  [<c0105edd>] sysenter_past_esp+0x52/0x71
> kernel:
> kernel: Code: 8b 02 a9 00 00 08 00 75 41 8b 02 f6 c4 08 75 22 8b 02 89
> d1
> 
> 
> 
