From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: Oops with pom-20031219, kernel 2.4.22 and pptp conntrack/nat module
Date: Fri, 09 Apr 2004 18:44:30 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4076D2EE.6000205@fl.priv.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
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

Hi!

I just had the following experience with the pptp conntrack/nat modules 
which gave me an Oops:

  * loaded the following modules
      ip_nat_pptp
      ip_conntrack_pptp
      ip_nat_proto_gre
      ip_conntrack_proto_gre

  * allowed port 1723 trough with (eth1=internal, eth0=external)

      iptables -A FORWARD -m state --state NEW \
         -i eth1 -p tcp --dport 1723 -j ACCEPT

  * connected with Win2000Pro-DE-ServicePack4 to a PPTP-Server
    somewhere in the internet (details about server on request)

  * setting up the connection is no problem

  * closing the PPTP connection kills the Linux machine, see
    Oops below

Kernel (uname -a):
Linux gateway 2.4.22-grsec #2 Thu Apr 8 21:30:14 EST 2004 i686 unknown 
unknown GNU/Linux

The Oops:
ksymoops 2.4.8 on i686 2.4.20-4GB.  Options used
      -v vmlinux (specified)
      -K (specified)
      -L (specified)
      -O (specified)
      -m System.map (specified)

Unable to handle kernel NULL pointer dereference at virtual adress 0000000c
Oops: 0000
CPU:    0
EIP:    0010:[<e8c05103>]  Not tainted
Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 00010213
eax: e3fcc0e0 ebx: fffffff4 ecx: e3fcc0e0 edx: e3fcc0e0
esi: 00000000 edi: e3fcce68 ebp: 00000003 esp: c014fde4
ds: 0018 es: 0018 ss: 0018
Stack: e7de6db4 e3fcce00 e7de6d94 e8c0548c e3fcce00 00000018 33fcce00 e7de6d94
        e8c052fd e7de6d94 e7de6da8 00000018 e3fcce0d 00000003 fedd9ac1 14a989c6
        00000001 00000018 00000001 e3fcce00 c014fed8 00000003 e7de6d80 e8bca99f
Call Trace: [<e8c0548c>] [<e8c052fd>] [<e8bca99f>] [<c02fc7d0>] [<c02ecb78>]
[<c02fc7d0>] [<c02ecea0>] [<c02fc7d0>] [<e8bcd964>] [<c02fc5c9>] [<c02fc7d0>]
[<c02e6d15>] [<c02e6e49>] [<c02e6f5f>] [<c01d2653>] [<c01be5a0>] [<c01c0bf8>]
[<c01bb2c3>] [<e881e405>] [<e881e350>] [<c01bb362>]
Code: 8b 43 18 85 c0 75 16 53 e8 00 e1 ff ff 58 8b 36 39 fe 75 e9


 >>EIP; e8c05103 <END_OF_CODE+288604c3/????>   <=====

 >>esp; c014fde4 <init_task_union+1de4/2000>

Trace; e8c0548c <END_OF_CODE+2886084c/????>
Trace; e8c052fd <END_OF_CODE+288606bd/????>
Trace; e8bca99f <END_OF_CODE+28825d5f/????>
Trace; c02fc7d0 <ip_rcv_finish+0/230>
Trace; c02ecb78 <nf_iterate+58/a0>
Trace; c02fc7d0 <ip_rcv_finish+0/230>
Trace; c02ecea0 <nf_hook_slow+60/180>
Trace; c02fc7d0 <ip_rcv_finish+0/230>
Trace; e8bcd964 <END_OF_CODE+28828d24/????>
Trace; c02fc5c9 <ip_rcv+169/210>
Trace; c02fc7d0 <ip_rcv_finish+0/230>
Trace; c02e6d15 <netif_receive_skb+125/1f0>
Trace; c02e6e49 <process_backlog+69/120>
Trace; c02e6f5f <net_rx_action+5f/100>
Trace; c01d2653 <do_softirq+93/a0>
Trace; c01be5a0 <do_IRQ+a0/b0>
Trace; c01c0bf8 <call_do_IRQ+5/d>
Trace; c01bb2c3 <default_idle+23/50>
Trace; e881e405 <END_OF_CODE+284797c5/????>
Trace; e881e350 <END_OF_CODE+28479710/????>
Trace; c01bb362 <cpu_idle+52/70>

Code;  e8c05103 <END_OF_CODE+288604c3/????>
00000000 <_EIP>:
Code;  e8c05103 <END_OF_CODE+288604c3/????>   <=====
    0:   8b 43 18                  mov    0x18(%ebx),%eax   <=====
Code;  e8c05106 <END_OF_CODE+288604c6/????>
    3:   85 c0                     test   %eax,%eax
Code;  e8c05108 <END_OF_CODE+288604c8/????>
    5:   75 16                     jne    1d <_EIP+0x1d>
Code;  e8c0510a <END_OF_CODE+288604ca/????>
    7:   53                        push   %ebx
Code;  e8c0510b <END_OF_CODE+288604cb/????>
    8:   e8 00 e1 ff ff            call   ffffe10d <_EIP+0xffffe10d>
Code;  e8c05110 <END_OF_CODE+288604d0/????>
    d:   58                        pop    %eax
Code;  e8c05111 <END_OF_CODE+288604d1/????>
    e:   8b 36                     mov    (%esi),%esi
Code;  e8c05113 <END_OF_CODE+288604d3/????>
   10:   39 fe                     cmp    %edi,%esi
Code;  e8c05115 <END_OF_CODE+288604d5/????>
   12:   75 e9                     jne    fffffffd <_EIP+0xfffffffd>

   <0> Kernel panic: Aiee, killing interrupt handler!

Any hints?

-- 
MfG / Regards
Friedrich Lobenstock
