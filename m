From: Crazy AMD K7 <snort2004@mail.ru>
Subject: Re[2]: DoS on kernel 2.4.27+ -j LOG (fwd)
Date: Sat, 27 Nov 2004 03:41:05 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411270340420.15105@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Developers <netfilter-devel@lists.netfilter.org>
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



---------- Forwarded message ----------
Date: Sat, 27 Nov 2004 04:28:19 +0300
From: Crazy AMD K7 <snort2004@mail.ru>
To: Henrik Nordstrom <hno@marasystems.com>
Subject: Re[2]: DoS on kernel 2.4.27+ -j LOG

Hello Henrik,

> Can you please decode this using ksymoops.

ksymoops 2.4.4 on i686 2.4.27.  Options used
      -V (default)
      -k /proc/ksyms (default)
      -l /proc/modules (default)
      -o /lib/modules/2.4.27/ (default)
      -m /boot/System.map-2.4.27 (default)

Warning: You did not tell me where to find symbol information.  I will
assume that the log matches the kernel and modules that are running
right now and I'll use the default options above for symbol resolution.
If the current kernel and/or modules do not match the log, you can get
more accurate output by telling me the kernel version and where to find
map, modules, ksyms etc.  ksymoops -h explains the options.

No modules in ksyms, skipping objects
Warning (read_lsmod): no symbols in lsmod, is /proc/modules a valid lsmod file?
Unable to handle kernel paging request ar virtual address 5d5f2739
c022dcdc
*pde = 00000000
Oops: 0000
CPU: 0
EIP:     0010:[<c022dcdc>]   Not tained
Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 00010246
eax: 00000081   ebx: db99cc00   ecx: 5d5f2729   edx: 00000000
esi: c01f7500   edi: 00000000   ebp: c01f7500   esp: deae384c
ds: 0018   es: 0018   ss: 0018
Process snort (pid: 687, stackpage=deae3000)
Stack: deae38a8 c02edb78 00000000 c01ebbc3 00000003 deae38e8 00000000 dfa0b004
        c01f7500 df596078 dfa0b004 00000003 c01f7500 c01ebf3e c02edb78 deae38e8
        00000003 00000000 dfa0b004 deae38a8 c01f7500 80000000 00000000 c0283610
Call Trace:    [<c01ebbc3>] [<c01f7500>] [<c01f7500>] [<c01ebf3e>] [<c01f7500>]
   [<c010821c>] [<c010a4e8>] [<c01f6441>] [<c01f7500>] [<c01e1dc5>] [<c020c319>]
   [<c01e0c4b>] [<c01e0ddd>] [<c0201d71>] [<c020b56d>] [<c02065e9>] [<c0201d71>]
   [<c02070a1>] [<c02043e9>] [<c01f37a0>] [<c0204827>] [<c01e4905>] [<c01e0a71>]
   [<c01be3bd>] [<c022d070>] [<c01e1dc5>] [<c01be6a7>] [<c01be675>] [<c01e1dc5>]
   [<c020c319>] [<c020c26e>] [<c020c7c4>] [<c021cbe8>] [<c01f37a0>] [<c021eefc>]
   [<c01f3857>] [<c01f37a0>] [<c01f37a0>] [<c01ebf3e>] [<c01f37a0>] [<co1ebf70>]
   [<c022d070>] [<c021ef7c>] [<c01f38d0>] [<c01f342c>] [<c01f37a0>] [<c022d070>]
   [<c01f13ed>] [<c01f38d0>] [<c01f38d0>] [<c01f3a3b>] [<c010821c>] [<c022ab20>]
   [<c022d720>] [<c01f38d0>] [<c022dc9b>] [<c01ebbc3>] [<c01f38d0>] [<c01f38d0>]
   [<c01ebf3e>] [<c01f38d0>] [<c022ab20>] [<c01f376d>] [<c01f38d0>] [<c022ab20>]
   [<c0227eec>] [<c022ab20>] [<c01e0a71>] [<c01e4caf>] [<c01bdef8>] [<c01e4d4d>]
   [<c01e4e6c>] [<c0108079>] [<c011762b>] [<c010821c>] [<c010a4e8>]
Code: 66 83 79 10 08 75 1d a1 2c 33 28 c0 85 c0 74 14 8b 0d 20 33

>>EIP; c022dcdc <ip_sabotage_out+2c/110>   <=====
Trace; c01ebbc3 <nf_iterate+33/90>
Trace; c01f7500 <ip_queue_xmit2+0/1f7>
Trace; c01f7500 <ip_queue_xmit2+0/1f7>
Trace; c01ebf3e <nf_hook_slow+ae/140>
Trace; c01f7500 <ip_queue_xmit2+0/1f7>
Trace; c010821c <do_IRQ+9c/b0>
Trace; c010a4e8 <call_do_IRQ+5/d>
Trace; c01f6441 <ip_queue_xmit+461/4b0>
Trace; c01f7500 <ip_queue_xmit2+0/1f7>
Trace; c01e1dc5 <skb_checksum+45/240>
Trace; c020c319 <tcp_v4_do_rcv+29/100>
Trace; c01e0c4b <kfree_skbmem+b/60>
Trace; c01e0ddd <__kfree_skb+13d/150>
Trace; c0201d71 <tcp_clean_rtx_queue+221/320>
Trace; c020b56d <tcp_v4_send_check+6d/b0>
Trace; c02065e9 <tcp_transmit_skb+549/670>
Trace; c0201d71 <tcp_clean_rtx_queue+221/320>
Trace; c02070a1 <tcp_write_xmit+151/290>
Trace; c02043e9 <__tcp_data_snd_check+49/d0>
Trace; c01f37a0 <ip_local_deliver_finish+0/130>
Trace; c0204827 <tcp_rcv_established+137/8d0>
Trace; c01e4905 <netif_rx+75/160>
Trace; c01e0a71 <alloc_skb+d1/190>
Trace; c01be3bd <rtl8139_rx_interrupt+1ad/2a0>
Trace; c022d070 <br_nf_pre_routing_finish+0/1f0>
Trace; c01e1dc5 <skb_checksum+45/240>
Trace; c01be6a7 <rtl8139_interrupt+d7/120>
Trace; c01be675 <rtl8139_interrupt+a5/120>
Trace; c01e1dc5 <skb_checksum+45/240>
Trace; c020c319 <tcp_v4_do_rcv+29/100>
Trace; c020c26e <tcp_v4_checksum_init+7e/100>
Trace; c020c7c4 <tcp_v4_rcv+3d4/620>
Trace; c021cbe8 <ipt_do_table+308/450>
Trace; c01f37a0 <ip_local_deliver_finish+0/130>
Trace; c021eefc <ipt_hook+1c/20>
Trace; c01f3857 <ip_local_deliver_finish+b7/130>
Trace; c01f37a0 <ip_local_deliver_finish+0/130>
Trace; c01f37a0 <ip_local_deliver_finish+0/130>
Trace; c01ebf3e <nf_hook_slow+ae/140>
Trace; c01f37a0 <ip_local_deliver_finish+0/130>
Trace; c022d070 <br_nf_pre_routing_finish+0/1f0>
Trace; c021ef7c <ipt_route_hook+1c/20>
Trace; c01f38d0 <ip_rcv_finish+0/1a0>
Trace; c01f342c <ip_local_deliver+17c/190>
Trace; c01f37a0 <ip_local_deliver_finish+0/130>
Trace; c022d070 <br_nf_pre_routing_finish+0/1f0>
Trace; c01f13ed <ip_route_input+3d/130>
Trace; c01f38d0 <ip_rcv_finish+0/1a0>
Trace; c01f38d0 <ip_rcv_finish+0/1a0>
Trace; c01f3a3b <ip_rcv_finish+16b/1a0>
Trace; c010821c <do_IRQ+9c/b0>
Trace; c022ab20 <br_handle_frame_finish+0/110>
Trace; c022d720 <br_nf_pre_routing+330/350>
Trace; c01f38d0 <ip_rcv_finish+0/1a0>
Trace; c022dc9b <ip_sabotage_in+1b/30>
Trace; c01ebbc3 <nf_iterate+33/90>
Trace; c01f38d0 <ip_rcv_finish+0/1a0>
Trace; c01f38d0 <ip_rcv_finish+0/1a0>
Trace; c01ebf3e <nf_hook_slow+ae/140>
Trace; c01f38d0 <ip_rcv_finish+0/1a0>
Trace; c022ab20 <br_handle_frame_finish+0/110>
Trace; c01f376d <ip_rcv+32d/360>
Trace; c01f38d0 <ip_rcv_finish+0/1a0>
Trace; c022ab20 <br_handle_frame_finish+0/110>
Trace; c0227eec <packet_rcv+ec/260>
Trace; c022ab20 <br_handle_frame_finish+0/110>
Trace; c01e0a71 <alloc_skb+d1/190>
Trace; c01e4caf <netif_receive_skb+17f/1b0>
Trace; c01bdef8 <rtl8139_start_xmit+68/100>
Trace; c01e4d4d <process_backlog+6d/120>
Trace; c01e4e6c <net_rx_action+6c/100>
Trace; c0108079 <handle_IRQ_event+39/60>
Trace; c011762b <do_softirq+4b/90>
Trace; c010821c <do_IRQ+9c/b0>
Trace; c010a4e8 <call_do_IRQ+5/d>
Code;  c022dcdc <ip_sabotage_out+2c/110>
00000000 <_EIP>:
Code;  c022dcdc <ip_sabotage_out+2c/110>   <=====
    0:   66 83 79 10 08            cmpw   $0x8,0x10(%ecx)   <=====
Code;  c022dce1 <ip_sabotage_out+31/110>
    5:   75 1d                     jne    24 <_EIP+0x24> c022dd00 <ip_sabotage_out+50/110>
Code;  c022dce3 <ip_sabotage_out+33/110>
    7:   a1 2c 33 28 c0            mov    0xc028332c,%eax
Code;  c022dce8 <ip_sabotage_out+38/110>
    c:   85 c0                     test   %eax,%eax
Code;  c022dcea <ip_sabotage_out+3a/110>
    e:   74 14                     je     24 <_EIP+0x24> c022dd00 <ip_sabotage_out+50/110>
Code;  c022dcec <ip_sabotage_out+3c/110>
   10:   8b 0d 20 33 00 00         mov    0x3320,%ecx

  <0>Kernel panic: Aiee, killing interrupt handler!

2 warnings issued.  Results may not be reliable.


Thank you.
Pasha
