From: Gergely Madarasz <gorgo@broadband.hu>
Subject: conntrack oops
Date: Sat, 24 Jul 2004 11:39:55 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040724093955.GC1703@thunderchild.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

I've got a serious problem with my firewall. I'm using 2.4.26 patched only
with execshield. At least twice a month it oopses somewhere in the
conntrack code. It used to be worse with 2.4.25, at that time a wc -l
/proc/net/ip_conntrack was often enough to kill the machine. With 2.4.26
it seems more stable, but still not stable enough. I'm using several
bridge and vlan over bridge interfaces. The latest oops follows. Please
look at it, and tell me if you need anything else to trace this problem
down, thanks :)


Oops: 0000
CPU:    0
EIP:    0060:[<c02416d5>]    Not tainted
Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 00010286
eax: 00000000   ebx: d1c29f00   ecx: c035d488   edx: 00000000
esi: 00000003   edi: c02d9e54   ebp: c02d9e20   esp: c02d9df4
ds: 0068   es: 0068   ss: 0068
Process swapper (pid: 0, stackpage=c02d9000)
Stack: c02d9e50 c02d9e54 f6cdd680 eae96c80 eae96c88 01f16250 d1c29f00 e9116350
       c024b83c 01f16250 0011bbcb c02d9ed0 c02418dd c02d9e54 c02d4520 f6cdd680
       c02d9ec0 c0383c60 c0212c30 00000000 c02d9e4c c02d4520 f70cd0b0 f7eca600
Call Trace:    [<c024b83c>] [<c02418dd>] [<c0212c30>] [<c020aa1c>] [<c0212c30>]
  [<c0212c30>] [<c020ad6f>] [<c0212c30>] [<c0212ab6>] [<c0212c30>] [<c02028de>]
  [<c0202989>] [<c0202abf>] [<c011d10d>] [<c0108f0b>] [<c01052b0>] [<c01052b0>]
  [<c01052b0>] [<c01052b0>] [<c01052d9>] [<c0105342>] [<c0105000>] [<c010504f>]
Code: 83 78 18 00 74 15 8d 43 2c 50 e8 1c ea ed ff 89 c2 83 c4 04


>>EIP; c02416d5 <init_conntrack+30d/3dc>   <=====

>>ebx; d1c29f00 <_end+11890650/38544750>
>>ecx; c035d488 <irq_stat+8/1000>
>>edi; c02d9e54 <init_task_union+1e54/2000>
>>ebp; c02d9e20 <init_task_union+1e20/2000>
>>esp; c02d9df4 <init_task_union+1df4/2000>

Trace; c024b83c <ip_recent_ctrl+360/4f8>
Trace; c02418dd <ip_conntrack_in+139/270>
Trace; c0212c30 <ip_rcv_finish+0/1d9>
Trace; c020aa1c <nf_iterate+30/84>
Trace; c0212c30 <ip_rcv_finish+0/1d9>
Trace; c0212c30 <ip_rcv_finish+0/1d9>
Trace; c020ad6f <nf_hook_slow+d7/194>
Trace; c0212c30 <ip_rcv_finish+0/1d9>
Trace; c0212ab6 <ip_rcv+366/3ac>
Trace; c0212c30 <ip_rcv_finish+0/1d9>
Trace; c02028de <netif_receive_skb+16e/198>
Trace; c0202989 <process_backlog+81/124>
Trace; c0202abf <net_rx_action+93/144>
Trace; c011d10d <do_softirq+7d/dc>
Trace; c0108f0b <do_IRQ+db/ec>
Trace; c01052b0 <default_idle+0/34>
Trace; c01052b0 <default_idle+0/34>
Trace; c01052b0 <default_idle+0/34>
Trace; c01052b0 <default_idle+0/34>
Trace; c01052d9 <default_idle+29/34>
Trace; c0105342 <cpu_idle+3e/54>
Trace; c0105000 <_stext+0/0>
Trace; c010504f <rest_init+4f/50>

Code;  c02416d5 <init_conntrack+30d/3dc>
00000000 <_EIP>:
Code;  c02416d5 <init_conntrack+30d/3dc>   <=====
   0:   83 78 18 00               cmpl   $0x0,0x18(%eax)   <=====
Code;  c02416d9 <init_conntrack+311/3dc>
   4:   74 15                     je     1b <_EIP+0x1b>
Code;  c02416db <init_conntrack+313/3dc>
   6:   8d 43 2c                  lea    0x2c(%ebx),%eax
Code;  c02416de <init_conntrack+316/3dc>
   9:   50                        push   %eax
Code;  c02416df <init_conntrack+317/3dc>
   a:   e8 1c ea ed ff            call   ffedea2b <_EIP+0xffedea2b>
Code;  c02416e4 <init_conntrack+31c/3dc>
   f:   89 c2                     mov    %eax,%edx
Code;  c02416e6 <init_conntrack+31e/3dc>
  11:   83 c4 04                  add    $0x4,%esp

 <0>Kernel panic: Aiee, killing interrupt handler!


-- 
Madarasz Gergely   
gorgo@broadband.hu
