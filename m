From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re[2]: DoS on kernel 2.4.27+ -j LOG (fwd)
Date: Fri, 14 Jan 2005 17:31:36 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0501141722040.11870@filer.marasystems.com>
References: <Pine.LNX.4.61.0411270340420.15105@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Crazy AMD K7 <snort2004@mail.ru>
In-Reply-To: <Pine.LNX.4.61.0411270340420.15105@filer.marasystems.com>
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

On Sat, 27 Nov 2004, Crazy AMD K7 wrote:


> Code;  c022dcdc <ip_sabotage_out+2c/110>
> 00000000 <_EIP>:
> Code;  c022dcdc <ip_sabotage_out+2c/110>   <=====
>   0:   66 83 79 10 08            cmpw   $0x8,0x10(%ecx)   <=====
> Code;  c022dce1 <ip_sabotage_out+31/110>
>   5:   75 1d                     jne    24 <_EIP+0x24> c022dd00 
> <ip_sabotage_out+50/110>


I am now also experiencing this exact same problem, and it seems a handful
other people also experience this problem.

Have you found any additional clues to what may be causing this?


My oops trace:


Unable to handle kernel NULL pointer dereference at virtual address 
00000087
*pde = 00000000
Oops: 0000
CPU:    0
EIP:    0010:[<c02179f0>]    Tainted: P
Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 00010246
eax: 00000081   ebx: f2d3ae00   ecx: 00000077   edx: 00000000
esi: f7540000   edi: 00000000   ebp: c01e2640   esp: c0291b80
ds: 0018   es: 0018   ss: 0018
Process swapper (pid: 0, stackpage=c0291000)
Stack: f7540000 c01e2640 c0291be4 80000000 c02e3778 c01e2640 c01d25d6 
00000003
        c0291c04 00000000 f7540000 c01e2640 00000000 00000003 f7540000 
00000000
        c01d292a c02e3778 c0291c04 00000003 00000000 f7540000 c0291be4 
c01e2640
Call Trace:    [<c01e2640>] [<c01e2640>] [<c01d25d6>] [<c01e2640>] 
[<c01d292a>]
   [<c01e2640>] [<c01e12fb>] [<c01e2640>] [<c01f819a>] [<c01f2a7a>] 
[<c01f37d4>]
   [<c01f074a>] [<c01c6851>] [<c01f0fc2>] [<f88b8077>] [<f8876375>] 
[<c01f92e2>]
   [<c01f97d4>] [<f887b0ee>] [<c01de33e>] [<c01d296b>] [<c01de1f0>] 
[<c01ddd47>]
   [<c01de1f0>] [<c01de549>] [<c01de360>] [<c01d296b>] [<c01de360>] 
[<c01de14e>]
   [<c01de360>] [<c01ca9d8>] [<f8824767>] [<f882df1e>] [<f8822ab5>] 
[<f8822bd8>]
   [<c01cac3a>] [<c011e7a5>] [<c010a8ae>] [<c0106fd0>] [<c010ce38>] 
[<c0106fd0>]
   [<c0106ff3>] [<c0107082>] [<c0105000>]
Code: 66 83 79 10 08 0f 85 cd fe ff ff a1 0c d3 28 c0 85 c0 0f 84

>>EIP; c02179f0 <ip_sabotage_out+170/1a0>   <=====

>>ebx; f2d3ae00 <_end+32a553c0/38529620>
>>esi; f7540000 <_end+3725a5c0/38529620>
>>ebp; c01e2640 <ip_queue_xmit2+0/23f>
>>esp; c0291b80 <init_task_union+1b80/2000>

Trace; c01e2640 <ip_queue_xmit2+0/23f>
Trace; c01e2640 <ip_queue_xmit2+0/23f>
Trace; c01d25d6 <nf_iterate+76/b0>
Trace; c01e2640 <ip_queue_xmit2+0/23f>
Trace; c01d292a <nf_hook_slow+7a/190>
Trace; c01e2640 <ip_queue_xmit2+0/23f>
Trace; c01e12fb <ip_queue_xmit+49b/560>
Trace; c01e2640 <ip_queue_xmit2+0/23f>
Trace; c01f819a <tcp_v4_send_check+4a/d0>
Trace; c01f2a7a <tcp_transmit_skb+40a/6a0>
Trace; c01f37d4 <tcp_write_xmit+184/2d0>
Trace; c01f074a <__tcp_data_snd_check+ea/100>
Trace; c01c6851 <__kfree_skb+111/180>
Trace; c01f0fc2 <tcp_rcv_established+572/9c0>
Trace; f88b8077 <[ipt_confirmed].text.start+17/70>
Trace; f8876375 <[ip_tables]ipt_do_table+2e5/4c0>
Trace; c01f92e2 <tcp_v4_do_rcv+122/130>
Trace; c01f97d4 <tcp_v4_rcv+4e4/670>
Trace; f887b0ee <[iptable_nat]ip_nat_fn+8e/200>
Trace; c01de33e <ip_local_deliver_finish+14e/170>
Trace; c01d296b <nf_hook_slow+bb/190>
Trace; c01de1f0 <ip_local_deliver_finish+0/170>
Trace; c01ddd47 <ip_local_deliver+1b7/1f0>
Trace; c01de1f0 <ip_local_deliver_finish+0/170>
Trace; c01de549 <ip_rcv_finish+1e9/250>
Trace; c01de360 <ip_rcv_finish+0/250>
Trace; c01d296b <nf_hook_slow+bb/190>
Trace; c01de360 <ip_rcv_finish+0/250>
Trace; c01de14e <ip_rcv+3ce/470>
Trace; c01de360 <ip_rcv_finish+0/250>
Trace; c01ca9d8 <netif_receive_skb+148/230>
Trace; f8824767 <[bcm5700]MM_IndicateRxPackets+38b/434>
Trace; f882df1e <[bcm5700]LM_ServiceInterrupts+56/198>
Trace; f8822ab5 <[bcm5700]bcm5700_poll+131/158>
Trace; f8822bd8 <[bcm5700]bcm5700_interrupt+fc/318>
Trace; c01cac3a <net_rx_action+6a/100>
Trace; c011e7a5 <do_softirq+95/a0>
Trace; c010a8ae <do_IRQ+9e/a0>
Trace; c0106fd0 <default_idle+0/40>
Trace; c010ce38 <call_do_IRQ+5/d>
Trace; c0106fd0 <default_idle+0/40>
Trace; c0106ff3 <default_idle+23/40>
Trace; c0107082 <cpu_idle+52/70>
Trace; c0105000 <_stext+0/0>

Code;  c02179f0 <ip_sabotage_out+170/1a0>
00000000 <_EIP>:
Code;  c02179f0 <ip_sabotage_out+170/1a0>   <=====
    0:   66 83 79 10 08            cmpw   $0x8,0x10(%ecx)   <=====
Code;  c02179f5 <ip_sabotage_out+175/1a0>
    5:   0f 85 cd fe ff ff         jne    fffffed8 <_EIP+0xfffffed8>
Code;  c02179fb <ip_sabotage_out+17b/1a0>
    b:   a1 0c d3 28 c0            mov    0xc028d30c,%eax
Code;  c0217a00 <ip_sabotage_out+180/1a0>
   10:   85 c0                     test   %eax,%eax
Code;  c0217a02 <ip_sabotage_out+182/1a0>
   12:   0f 84 00 00 00 00         je     18 <_EIP+0x18>



Regards
Henrik
