From: "Vincent" <cs83152@csie.chu.edu.tw>
Subject: [kernel panic] iptables 1.2.7a + physdev patch
Date: Fri, 16 Sep 2005 18:10:58 +0800
Message-ID: <000001c5baa6$f4bf1c70$aa0ba8c0@l7.com.tw>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "'Netfilter Development Mailinglist'" <netfilter-devel@lists.netfilter.org>
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

Hello folks,

I have experiencend a kernel panic with iptables. Does anyone point any
hints for me?
Thanks in advance.

My Enviroment:
Linux Kernel : 2.6.10
Iptables: 1.2.7a

PS. I port the physdev patch from 1.2.9 back to 1.2.7a. Will this action
cause kernel panic?

Vincent

Oops: 0000 [#1]
SMP
CPU:    0
EIP:    0060:[<c025a966>]    Not tainted VLI
EFLAGS: 00010246   (2.6.10)
EIP is at target+0x24d/0x2ce
eax: c02e0001   ebx: 00000000   ecx: 00000049   edx: c02c5860
esi: dae66800   edi: e0bc22d8   ebp: d95fb200   esp: c02efb50
ds: 007b   es: 007b   ss: 0068
Process swapper (pid: 0, threadinfo=c02ee000 task=c02a9b40)
Stack: e0bc22d8 00000000 e0bc2228 00000090 d9afe020 c024d273 c02efc50
dae66800
       dae66800 00000002 e0bc22d8 00000000 00000000 e0bc1f8c e08e1040
dfc1a800
       dae66800 dae66800 00000000 0000cba0 00000000 c02efc30 d95fb200
dfc1a800
Call Trace:
 [<c024d273>] ipt_do_table+0x2c5/0x3f2
 [<c024f35c>] ipt_route_hook+0x68/0x115
 [<c027135a>] br_nf_forward_finish+0x0/0xc3
 [<c01fbd18>] nf_iterate+0x5b/0x8d
 [<c027135a>] br_nf_forward_finish+0x0/0xc3
 [<c027135a>] br_nf_forward_finish+0x0/0xc3
 [<c01fbfbe>] nf_hook_slow+0x4f/0xc1
 [<c027135a>] br_nf_forward_finish+0x0/0xc3
 [<c026cc74>] br_forward_finish+0x0/0x38
 [<c02714bd>] br_nf_forward_ip+0xa0/0x100
 [<c027135a>] br_nf_forward_finish+0x0/0xc3
 [<c01fbd18>] nf_iterate+0x5b/0x8d
 [<c026cc74>] br_forward_finish+0x0/0x38
 [<c026cc74>] br_forward_finish+0x0/0x38
 [<c01fbfbe>] nf_hook_slow+0x4f/0xc1
 [<c026cc74>] br_forward_finish+0x0/0x38
 [<c026cd2a>] __br_forward+0x40/0x44
 [<c026cc74>] br_forward_finish+0x0/0x38
 [<c026d746>] br_handle_frame_finish+0x9e/0xd3
 [<c026d6a8>] br_handle_frame_finish+0x0/0xd3
 [<c01fbffe>] nf_hook_slow+0x8f/0xc1
 [<c0270b77>] br_nf_pre_routing_finish+0xd8/0x243
 [<c026d6a8>] br_handle_frame_finish+0x0/0xd3
 [<c024d223>] ipt_do_table+0x275/0x3f2
 [<c024f35c>] ipt_route_hook+0x68/0x115
 [<c0270a9f>] br_nf_pre_routing_finish+0x0/0x243
 [<c0270a9f>] br_nf_pre_routing_finish+0x0/0x243
 [<c0270a9f>] br_nf_pre_routing_finish+0x0/0x243
 [<c01fbd18>] nf_iterate+0x5b/0x8d
 [<c0270a9f>] br_nf_pre_routing_finish+0x0/0x243
 [<c0270a9f>] br_nf_pre_routing_finish+0x0/0x243
 [<c01fbfbe>] nf_hook_slow+0x4f/0xc1
 [<c0270a9f>] br_nf_pre_routing_finish+0x0/0x243
 [<c01fbffe>] nf_hook_slow+0x8f/0xc1
 [<c026d6a8>] br_handle_frame_finish+0x0/0xd3
 [<c027117c>] br_nf_pre_routing+0x209/0x38f
 [<c0270a9f>] br_nf_pre_routing_finish+0x0/0x243
 [<c026d6a8>] br_handle_frame_finish+0x0/0xd3
 [<c01fbd18>] nf_iterate+0x5b/0x8d
 [<c026d6a8>] br_handle_frame_finish+0x0/0xd3
 [<c026d6a8>] br_handle_frame_finish+0x0/0xd3
 [<c01fbfbe>] nf_hook_slow+0x4f/0xc1
 [<c026d6a8>] br_handle_frame_finish+0x0/0xd3
 [<c026d821>] br_handle_frame+0xa6/0x15d
 [<c026d6a8>] br_handle_frame_finish+0x0/0xd3
 [<c01f3b4d>] netif_receive_skb+0x112/0x25c
 [<c01afb48>] e1000_clean_rx_irq+0x11e/0x420
 [<c01af78d>] e1000_clean+0x44/0xc2
 [<c01f3df7>] net_rx_action+0x65/0xe9
 [<c0116af6>] __do_softirq+0xa6/0xb8
 [<c0116b34>] do_softirq+0x2c/0x2e
 [<c01044ea>] do_IRQ+0x1e/0x24
 [<c01030b2>] common_interrupt+0x1a/0x20
 [<c01004ac>] default_idle+0x0/0x33
 [<c01004d9>] default_idle+0x2d/0x33
 [<c0100546>] cpu_idle+0x2d/0x3d
 [<c02f0905>] start_kernel+0x151/0x181
Code: 80 00 00 ba fb ff ff ff e9 15 fe ff ff b8 e0 57 2c c0 e8 bd cb 01
00 66 83 8b b0 01 00 00 02 b8 e0 57 2c c0 e8 04 cc 01 00 eb d8 <66> 8b
8b b0 01 00 00 89 c8 83 e0 08 31 d2
 <0>Kernel panic - not syncing: Fatal exception in interrupt
