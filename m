From: "Oleg A Chernov" <oleg.chernov@nap.nikolaev.ua>
Subject: init_conntrack oops :-(
Date: Fri, 7 Feb 2003 08:37:07 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <003c01c2ce73$55c30400$0c0110ac@nap.nikolaev.ua>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="koi8-r"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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
I have Debian router with 2.4.18 kernel compiled myself from debian sources
with gcc 2.95.4 with the following options:


#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_MMAP is not set
# CONFIG_NETLINK_DEV is not set
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
# CONFIG_FILTER is not set
CONFIG_UNIX=y
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_INET_ECN is not set
# CONFIG_SYN_COOKIES is not set
#
#   IP: Netfilter Configuration
#
CONFIG_IP_NF_CONNTRACK=y
# CONFIG_IP_NF_FTP is not set
# CONFIG_IP_NF_IRC is not set
CONFIG_IP_NF_IPTABLES=y
# CONFIG_IP_NF_MATCH_LIMIT is not set
# CONFIG_IP_NF_MATCH_MAC is not set
# CONFIG_IP_NF_MATCH_MARK is not set
# CONFIG_IP_NF_MATCH_MULTIPORT is not set
# CONFIG_IP_NF_MATCH_TOS is not set
# CONFIG_IP_NF_MATCH_AH_ESP is not set
# CONFIG_IP_NF_MATCH_LENGTH is not set
# CONFIG_IP_NF_MATCH_TTL is not set
# CONFIG_IP_NF_MATCH_TCPMSS is not set
CONFIG_IP_NF_MATCH_STATE=y
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
CONFIG_IP_NF_NAT=y
CONFIG_IP_NF_NAT_NEEDED=y
# CONFIG_IP_NF_TARGET_MASQUERADE is not set
# CONFIG_IP_NF_TARGET_REDIRECT is not set
# CONFIG_IP_NF_MANGLE is not set
CONFIG_IP_NF_TARGET_LOG=y
# CONFIG_IP_NF_TARGET_ULOG is not set
# CONFIG_IP_NF_TARGET_TCPMSS is not set


and sometimes I get kernel oopses like this


 Feb  3 19:15:26 ns kernel: Unable to handle kernel paging request at
virtual address 012de0a0
Feb  3 19:15:26 ns kernel: *pde = 00000000
Unable to handle kernel paging request at virtual address b340000c
c01ca061
*pde = 00000000
Oops: 0000
CPU:    0
EIP:    0010:[<c01ca061>]    Not tainted
EFLAGS: 00010246
eax: 00118900   ebx: 000003d0   ecx: 00000004   edx: c7258600
esi: c7c00620   edi: c7258758   ebp: c0227ea4   esp: c0227e3c
ds: 0018   es: 0018   ss: 0018
Process swapper (pid: 0, stackpage=c0227000)
Stack: c0227ea0 c0227ea4 c7c00620 c0227f20 c7258600 c64cd5e0 c0227ea0
00000000
       c7c00620 c0227f20 ffff10ac c0228900 470310ac 00118900 c01ca54d
c0227ea4
       c0223a00 c7c00620 c0223584 c0227f10 00000000 c0282e60 c0227e9c
c0223a00
Call Trace: [<c01ca54d>] [<c019f10c>] [<c01a582c>] [<c019f407>] [<c01a582c>]
   [<c01a5692>] [<c01a582c>] [<c0199c3d>] [<c01147ea>] [<c0107ec2>]
[<c0105150>]
   [<c0105150>] [<c0105150>] [<c0105150>] [<c0105173>] [<c01051d9>]
[<c0105000>]
   [<c0105027>]
Code: a0 0c 00 40 b3 2d 01 38 89 52 3c 89 d0 05 a0 00 00 00 90 8d


>>EIP; c01ca061 <init_conntrack+159/50c>   <=====

>>eax; 00118900 Before first symbol
>>edx; c7258600 <_end+6fd39ec/85c53ec>
>>esi; c7c00620 <_end+797ba0c/85c53ec>
>>edi; c7258758 <_end+6fd3b44/85c53ec>
>>ebp; c0227ea4 <init_task_union+1ea4/2000>
>>esp; c0227e3c <init_task_union+1e3c/2000>

Trace; c01ca54d <ip_conntrack_in+139/278>
Trace; c019f10c <nf_iterate+34/90>
Trace; c01a582c <ip_rcv_finish+0/1b4>
Trace; c019f407 <nf_hook_slow+ef/188>
Trace; c01a582c <ip_rcv_finish+0/1b4>
Trace; c01a5692 <ip_rcv+16e/1a0>
Trace; c01a582c <ip_rcv_finish+0/1b4>
Trace; c0199c3d <net_rx_action+139/214>
Trace; c01147ea <do_softirq+5a/a4>
Trace; c0107ec2 <do_IRQ+96/a8>
Trace; c0105150 <default_idle+0/28>
Trace; c0105150 <default_idle+0/28>
Trace; c0105150 <default_idle+0/28>
Trace; c0105150 <default_idle+0/28>
Trace; c0105173 <default_idle+23/28>
Trace; c01051d9 <cpu_idle+41/54>
Trace; c0105000 <_stext+0/0>
Trace; c0105027 <rest_init+27/28>

Code;  c01ca061 <init_conntrack+159/50c>
00000000 <_EIP>:
Code;  c01ca061 <init_conntrack+159/50c>   <=====
   0:   a0 0c 00 40 b3            mov    0xb340000c,%al   <=====
Code;  c01ca066 <init_conntrack+15e/50c>
   5:   2d 01 38 89 52            sub    $0x52893801,%eax
Code;  c01ca06b <init_conntrack+163/50c>
   a:   3c 89                     cmp    $0x89,%al
Code;  c01ca06d <init_conntrack+165/50c>
   c:   d0 05 a0 00 00 00         rolb   0xa0
Code;  c01ca073 <init_conntrack+16b/50c>
  12:   90                        nop
Code;  c01ca074 <init_conntrack+16c/50c>
  13:   8d 00                     lea    (%eax),%eax

 <0>Kernel panic: Aiee, killing interrupt handler!


like this


Unable to handle kernel paging request at virtual address 0011ad1b
*pde = 00000000
Oops: 0002
CPU:    0
EIP:    0010:[<c01ca061>]    Not tainted
Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 00010246
eax: 0011ad1b   ebx: 0000014d   ecx: 00000004   edx: c5466900
esi: c4a687c0   edi: c5466a58   ebp: c7a77ec0   esp: c7a77e58
ds: 0018   es: 0018   ss: 0018
Process john-mmx (pid: 6033, stackpage=c7a77000)
Stack: c7a77ebc c7a77ec0 c4a687c0 c7a77f3c c5466900 c55f7ee0 c7a77ebc
00000000
       c4a687c0 c7a77f3c 98133f50 c7a72227 080110ac 0011ad1b c01ca54d
c7a77ec0
       c0223a00 c4a687c0 c0223584 c7a77f2c 00000000 c0282e60 c7a77eb8
c0223a00
Call Trace: [<c01ca54d>] [<c019f10c>] [<c01a582c>] [<c019f407>] [<c01a582c>]
   [<c01a5692>] [<c01a582c>] [<c0199c3d>] [<c01147ea>] [<c0107ec2>]
Code: 00 00 00 00 00 00 00 38 89 52 3c 89 d0 05 a0 00 00 00 90 8d


>>EIP; c01ca061 <init_conntrack+159/50c>   <=====

>>eax; 0011ad1b Before first symbol
>>edx; c5466900 <_end+51e1cec/85c53ec>
>>esi; c4a687c0 <_end+47e3bac/85c53ec>
>>edi; c5466a58 <_end+51e1e44/85c53ec>
>>ebp; c7a77ec0 <_end+77f32ac/85c53ec>
>>esp; c7a77e58 <_end+77f3244/85c53ec>

Trace; c01ca54d <ip_conntrack_in+139/278>
Trace; c019f10c <nf_iterate+34/90>
Trace; c01a582c <ip_rcv_finish+0/1b4>
Trace; c019f407 <nf_hook_slow+ef/188>
Trace; c01a582c <ip_rcv_finish+0/1b4>
Trace; c01a5692 <ip_rcv+16e/1a0>
Trace; c01a582c <ip_rcv_finish+0/1b4>
Trace; c0199c3d <net_rx_action+139/214>
Trace; c01147ea <do_softirq+5a/a4>
Trace; c0107ec2 <do_IRQ+96/a8>

Code;  c01ca061 <init_conntrack+159/50c>
00000000 <_EIP>:
Code;  c01ca061 <init_conntrack+159/50c>   <=====
   0:   00 00                     add    %al,(%eax)   <=====
Code;  c01ca063 <init_conntrack+15b/50c>
   2:   00 00                     add    %al,(%eax)
Code;  c01ca065 <init_conntrack+15d/50c>
   4:   00 00                     add    %al,(%eax)
Code;  c01ca067 <init_conntrack+15f/50c>
   6:   00 38                     add    %bh,(%eax)
Code;  c01ca069 <init_conntrack+161/50c>
   8:   89 52 3c                  mov    %edx,0x3c(%edx)
Code;  c01ca06c <init_conntrack+164/50c>
   b:   89 d0                     mov    %edx,%eax
Code;  c01ca06e <init_conntrack+166/50c>
   d:   05 a0 00 00 00            add    $0xa0,%eax
Code;  c01ca073 <init_conntrack+16b/50c>
  12:   90                        nop
Code;  c01ca074 <init_conntrack+16c/50c>
  13:   8d 00                     lea    (%eax),%eax

 <0>Kernel panic: Aiee, killing interrupt handler!


and like this


Unable to handle kernel paging request at virtual address 0006700c
*pde = 00000000
Oops: 0002
CPU:    0
EIP:    0010:[<c01ca061>]    Not tainted
EFLAGS: 00010246
eax: 0006700c   ebx: 00000248   ecx: 00000004   edx: c4b30b60
esi: c56a6660   edi: c4b30cb8   ebp: c20c1ec0   esp: c20c1e58
ds: 0018   es: 0018   ss: 0018
Process drwebd (pid: 10212, stackpage=c20c1000)
Stack: c20c1ebc c20c1ec0 c56a6660 c20c1f3c c4b30b60 c5874aa0 c20c1ebc
00000000
       c56a6660 c20c1f3c cb6bf850 c20c3612 0d0110ac 0006700c c01ca54d
c20c1ec0
       c02239c0 c56a6660 c0223584 c20c1f2c 00000000 c0282e60 c20c1eb8
c02239c0
Call Trace: [<c01ca54d>] [<c019f10c>] [<c01a582c>] [<c019f407>] [<c01a582c>]
   [<c01a5692>] [<c01a582c>] [<c0199c3d>] [<c01147ea>] [<c0107ec2>]
Code: 00 00 2e 6f 4f 40 00 38 89 52 3c 89 d0 05 a0 00 00 00 90 8d


>>EIP; c01ca061 <init_conntrack+159/50c>   <=====

>>eax; 0006700c Before first symbol
>>edx; c4b30b60 <_end+48abf4c/85c53ec>
>>esi; c56a6660 <_end+5421a4c/85c53ec>
>>edi; c4b30cb8 <_end+48ac0a4/85c53ec>
>>ebp; c20c1ec0 <_end+1e3d2ac/85c53ec>
>>esp; c20c1e58 <_end+1e3d244/85c53ec>

Trace; c01ca54d <ip_conntrack_in+139/278>
Trace; c019f10c <nf_iterate+34/90>
Trace; c01a582c <ip_rcv_finish+0/1b4>
Trace; c019f407 <nf_hook_slow+ef/188>
Trace; c01a582c <ip_rcv_finish+0/1b4>
Trace; c01a5692 <ip_rcv+16e/1a0>
Trace; c01a582c <ip_rcv_finish+0/1b4>
Trace; c0199c3d <net_rx_action+139/214>
Trace; c01147ea <do_softirq+5a/a4>
Trace; c0107ec2 <do_IRQ+96/a8>

Code;  c01ca061 <init_conntrack+159/50c>
00000000 <_EIP>:
Code;  c01ca061 <init_conntrack+159/50c>   <=====
   0:   00 00                     add    %al,(%eax)   <=====
Code;  c01ca063 <init_conntrack+15b/50c>
   2:   2e 6f                     outsl  %cs:(%esi),(%dx)
Code;  c01ca065 <init_conntrack+15d/50c>
   4:   4f                        dec    %edi
Code;  c01ca066 <init_conntrack+15e/50c>
   5:   40                        inc    %eax
Code;  c01ca067 <init_conntrack+15f/50c>
   6:   00 38                     add    %bh,(%eax)
Code;  c01ca069 <init_conntrack+161/50c>
   8:   89 52 3c                  mov    %edx,0x3c(%edx)
Code;  c01ca06c <init_conntrack+164/50c>
   b:   89 d0                     mov    %edx,%eax
Code;  c01ca06e <init_conntrack+166/50c>
   d:   05 a0 00 00 00            add    $0xa0,%eax
Code;  c01ca073 <init_conntrack+16b/50c>
  12:   90                        nop
Code;  c01ca074 <init_conntrack+16c/50c>
  13:   8d 00                     lea    (%eax),%eax

 <0>Kernel panic: Aiee, killing interrupt handler!


Searching through mail archives on netfilter.org didn't bring any results
:-( , that is why I'm writting to this maillist.
If any advanced information is required, I'll provide it and I will be very
grateful if someone helps me with this problem.


PS: Sorry for my English
