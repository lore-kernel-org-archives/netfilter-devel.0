From: Nuutti Kotivuori <naked@iki.fi>
Subject: Re: netfilter QUEUE target and packet socket interactions buggy or
	not
Date: Wed, 14 Sep 2005 15:10:19 +0300
Message-ID: <87mzmf97f8.fsf@aka.i.naked.iki.fi>
References: <87fysa9bqt.fsf@aka.i.naked.iki.fi>
	<20050912.151120.104514011.davem@davemloft.net>
	<87br2xap9o.fsf@aka.i.naked.iki.fi>
	<877jdl9r1u.fsf@aka.i.naked.iki.fi> <4326FF69.9060004@trash.net>
	<873bo8akvk.fsf@aka.i.naked.iki.fi> <43279058.1080200@trash.net>
	<87y86082zu.fsf@aka.i.naked.iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <87y86082zu.fsf@aka.i.naked.iki.fi> (Nuutti Kotivuori's message
	of "Wed, 14 Sep 2005 11:31:17 +0300")
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
> Patrick McHardy wrote:
>> I've attached the patch.
>
> Thank you. I should know if it makes a difference within a few hours.

Same crash with the patch. I will try something else. But in any case,
here is the backtrace:

Unable to handle kernel NULL pointer dereference at virtual address 00000018
 printing eip:
c01a387f
*pde = 366b6001
Oops: 0000 [#1]
SMP
Modules linked in: arpt_mangle arptable_filter arp_tables iptable_filter ip_tables ip_queue parport_pc lp parport netconsole netdump autofs4 i2c_dev i2c_core
sunrpc dm_mod button batteryEIP is at selinux_ip_postroute_last+0x6a/0x1de
eax: 00000000   ebx: 00000000   ecx: f742fbb0   edx: 00000003
esi: f6e68e80   edi: c0455780   ebp: 00000004   esp: f742fb8c
ds: 007b   es: 007b   ss: 0068
Process dispatcher (pid: 2632, threadinfo=f742f000 task=f602a030)
Stack: 00000000 e8723280 00000000 e9180880 00000002 f88a965a 37f3c49e 00000000
       00000206 000000f3 f88a983c c026f163 e9672a80 f7fd8268 c02c3188 000000ce
        __kfree_skb+0xf4/0xf7
 [<c02c3188>] packet_rcv+0x2ca/0x2d4
 [<c0273ca8>] dev_queue_xmit_nit+0xc1/0xd3
 [<c01a3a02>] selinux_ipv4_postroute_last+0xf/0x13
 [<c028d11f>] ip_finish_output2+0x0/0x16d
 [<c027cb23>] nf_iterate+0x40/0x81
 [<c028d11f>] ip_finish_output2+0x0/0x16d
 [<c027ce21>] nf_hook_slow+0x47/0xb4
 [<c028d11f>] ip_finish_output2+0x0/0x16d
 [<c028d116>] ip_finish_output+0x1a5/0x1ae
 [<c028d11f>] ip_finish_output2+0x0/0x16d
 [<c028cf66>] dst_output+0xf/0x1a
 [<c027cfdb>] nf_reinject+0x14d/0x1a9
 [<f891401e>] ipq_issue_verdict+0x1e/0x2b [ip_queue]
 [<f8914676>] ipq_set_verdict+0x53/0x5a [ip_queue]
 [<f891472c>] ipq_receive_peer+0x3d/0x46 [ip_queue]
 [<f891487d>] ipq_rcv_sk+0xfc/0x175 [ip_queue]
 [<c0285b11>] netlink_data_ready+0x14/0x44
 [<c028525b>] netlink_sendskb+0x52/0x6c
 [<c028592c>] netlink_sendmsg+0x254/0x263
 [<c011dcf5>] __wake_up+0x29/0x3c
 [<c026b92d>] sock_sendmsg+0xdb/0xf7
 [<c0285ae9>] netlink_recvmsg+0x1ae/0x1c2
 [<c0111c12>] mark_offset_tsc+0x285/0x303
 [<c010741a>] handle_IRQ_event+0x25/0x4f
 [<c026ba64>] sock_recvmsg+0xef/0x10c
 [<c011f6ee>] autoremove_wake_function+0x0/0x2d
 [<c02709ba>] verify_iovec+0x76/0xc2
 [<c026d07c>] sys_sendmsg+0x1ee/0x23b
 [<c026b4fe>] move_addr_to_user+0x67/0x7f
 [<c01335b7>] get_futex_key+0x39/0x108
 [<c0133b04>] unqueue_me+0x73/0x79
 [<c014b9b5>] find_extend_vma+0x12/0x4f
 [<c01335b7>] get_futex_key+0x39/0x108
 [<c026d465>] sys_socketcall+0x1c1/0x1dd
 [<c0125351>] sys_gettimeofday+0x53/0xac
 [<c02c7377>] syscall_call+0x7/0xb
 [<c02c007b>] unix_release_sock+0x15a/0x201
Code: 89 d3 83 c3 2c 0f 84 8c 01 00 00 8b 44 24 7c 31 c9 8d 54 24 24 e8 df 29 00 00 85 c0 0f 85 75

-- Naked
