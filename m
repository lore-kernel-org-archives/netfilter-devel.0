From: "Sumit Pandya" <sumit@elitecore.com>
Subject: OOPS: Kernel-2.4.26
Date: Fri, 31 Dec 2004 17:30:47 +0530
Message-ID: <HGEFKOBCHAIJDIEJLAKDAEOLCAAA.sumit@elitecore.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

Dev,
	We are running 2.4.26 kernel with few patch-o-metic applied. Mainly which
concern to conntrack are nfnetlink-ctnetlink, ip_{conntrack|nat}_pptp,
arptables, brnf and TPROXY.
	We also patched the kernel for orphaned expectations resolution from link
http://bugme.osdl.org/show_bug.cgi?id=1764

Still we get OOPS of similar behaviour.
# /sbin/lsmod
ip_nat_proto_gre        1472   0  (unused)
ip_nat_h323             2880   0  (unused)
ip_nat_talk             2592   0  (unused)
ip_nat_tftp             2208   0  (unused)
ip_nat_pptp             2528   0  (unused)
ip_nat_irc              2912   0  (unused)
ip_nat_ftp              3424   0  (unused)
ip_conntrack_h323       2688   1
ip_conntrack_talk       2624   2
ip_conntrack_tftp       2272   1
ip_conntrack_pptp       3136   1
ip_conntrack_proto_gre    2240   0  [ip_nat_pptp ip_conntrack_pptp]
ip_conntrack_irc        4032   1
ip_conntrack_ftp        4544   1
ipt_mac                  736   1  (autoclean)
cls_fw                  2592   1  (autoclean)
ipt_MARK                 864 208  (autoclean)
sch_sfq                 3872 104  (autoclean)
cls_u32                 4804   1  (autoclean)
sch_htb                19008   2  (autoclean)
imq                     1880   2
ipt_multiport            800   8  (autoclean)
ipt_IMQ                  864   3  (autoclean)
iptable_nat            18324   9  (autoclean) [ip_nat_proto_gre ip_nat_h323
ip_nat_talk ip_nat_tftp ip_nat_pptp ip_nat_irc ip_nat_ftp]
ip_conntrack           27648   8  (autoclean) [ip_nat_h323 ip_nat_talk
ip_nat_tftp ip_nat_pptp ip_nat_irc ip_nat_ftp ip_conntrack_h323
ip_conntrack_talk ip_conntrack_tftp ip_conntrack_pptp ip_conntrack_proto_gre
ip_conntrack_irc ip_conntrack_ftp iptable_nat]
iptable_filter          1824   1  (autoclean)
iptable_mangle          2304   1  (autoclean)
ip_tables              11968   9  [ipt_mac ipt_MARK ipt_multiport ipt_IMQ
iptable_nat iptable_filter iptable_mangle]
e1000                  66600   2  (autoclean)
aic79xx               163340   6

# ksymoops < oops.txt
Unable to handle kernel NULL pointer dereference at virtual address 000000b0
*pde = 00000000
Oops: 0000
CPU:    0
EIP:    0010:[<f88ace90>]    Tainted: P
Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 00010203
eax: f6b4869c   ebx: f7a4ded4   ecx: 00000000   edx: 00000001
esi: f7a4d9bc   edi: f6b48600   ebp: c02a7eb8   esp: c02a7ea0
ds: 0018   es: 0018   ss: 0018
Process swapper (pid: 0, stackpage=c02a7000)
Stack: 00000006 f7541a44 f6d554bc f6b48600 f6b48600 00000000 c02a7ee8
f88acfcc
       f6b48600 00000001 c02a7ee8 f88acf5c f6b48600 00000001 c026e6c8
f6b48600
       f88ad090 00000000 c02a7f08 f88ad129 f6b48600 00000002 f6b48600
c02a7f08
Call Trace:    [<f88acfcc>] [<f88acf5c>] [<f88ad090>] [<f88ad129>]
[<c011e6d6>]
  [<c011eb53>] [<c011e35c>] [<c011b79d>] [<c011b6a4>] [<c011b47b>]
[<c010a12c>]
  [<c0106fa0>] [<c0106fa0>] [<c0106fc6>] [<c0107052>] [<c0105000>]
Code: 8b 81 b0 00 00 00 ff 08 0f 94 c2 84 d2 74 10 8b 81 b0 00 00

>>EIP; f88ace90 <[ip_conntrack]ip_conntrack_remove_expectations+30/80>
<=====
Trace; f88acfcc <[ip_conntrack]destroy_conntrack+5c/120>
Trace; f88acf5c <[ip_conntrack]clean_from_lists+7c/90>
Trace; f88ad090 <[ip_conntrack]death_by_timeout+0/b0>
Trace; f88ad129 <[ip_conntrack]death_by_timeout+99/b0>
Trace; c011e6d6 <del_timer+3d6/e80>
Trace; c011eb53 <del_timer+853/e80>
Trace; c011e35c <del_timer+5c/e80>
Trace; c011b79d <tasklet_kill+9d/d0>
Trace; c011b6a4 <__tasklet_hi_schedule+124/150>
Trace; c011b47b <do_softirq+5b/b0>
Trace; c010a12c <enable_irq+17c/190>
Trace; c0106fa0 <default_idle+0/d0>
Trace; c0106fa0 <default_idle+0/d0>
Trace; c0106fc6 <default_idle+26/d0>
Trace; c0107052 <default_idle+b2/d0>
Trace; c0105000 <empty_zero_page+1000/2f80>
Code;  f88ace90 <[ip_conntrack]ip_conntrack_remove_expectations+30/80>
00000000 <_EIP>:
Code;  f88ace90 <[ip_conntrack]ip_conntrack_remove_expectations+30/80>
<=====
   0:   8b 81 b0 00 00 00         mov    0xb0(%ecx),%eax   <=====
Code;  f88ace96 <[ip_conntrack]ip_conntrack_remove_expectations+36/80>
   6:   ff 08                     decl   (%eax)
Code;  f88ace98 <[ip_conntrack]ip_conntrack_remove_expectations+38/80>
   8:   0f 94 c2                  sete   %dl
Code;  f88ace9b <[ip_conntrack]ip_conntrack_remove_expectations+3b/80>
   b:   84 d2                     test   %dl,%dl
Code;  f88ace9d <[ip_conntrack]ip_conntrack_remove_expectations+3d/80>
   d:   74 10                     je     1f <_EIP+0x1f> f88aceaf
<[ip_conntrack]ip_conntrack_remove_expectations+4f/80>
Code;  f88ace9f <[ip_conntrack]ip_conntrack_remove_expectations+3f/80>
   f:   8b 81 b0 00 00 00         mov    0xb0(%ecx),%eax

 <0>Kernel panic: Aiee, killing interrupt handler!
