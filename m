From: "Oleg A. Arkhanglelsky" <sysoleg@yandex.ru>
Subject: ip_conntrack_proto_gre problems?
Date: Wed, 20 Oct 2004 09:50:10 +0400 (MSD)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <4175FC92.000017.05763@camay.yandex.ru>
Reply-To: sysoleg@yandex.ru
Mime-Version: 1.0
Content-Type: text/plain;
  charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hello all,

I'm still wondering is it ip_conntrack_proto_gre related problem?
This PC is used as PPTP-server (up to 80-100 concurrent connections) and
as NAT-server. There is of course some natted GRE-connections also.
All connections is from (and to) untrusted users.

Here is a output of ksymoops:
ksymoops 2.4.9 on i686 2.4.27.  Options used
     -V (default)
     -k /proc/ksyms (default)
     -l /proc/modules (default)
     -o /lib/modules/2.4.27/ (default)
     -m /usr/src/linux/System.map (default)

Warning: You did not tell me where to find symbol information.  I will
assume that the log matches the kernel and modules that are running
right now and I'll use the default options above for symbol resolution.
If the current kernel and/or modules do not match the log, you can get
more accurate output by telling me the kernel version and where to find
map, modules, ksyms etc.  ksymoops -h explains the options.

Warning (compare_maps): ksyms_base symbol
IO_APIC_get_PCI_irq_vector_R__ver_IO_APIC_get_PCI_irq_vector not found in
System.map.  Ignoring ksyms_base entry
*pde = 00000000
Oops: 0002
CPU:    0
EIP:    0010:[<e0a232b8>]  Not tained
Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 10282
eax: d4a47bf8   ebx: d99f1180     ecx: cefd1480       edx: 00000000
esi: d526e080   edi: 00000000     ebp: 00000046       esp: c02a7f04
ds: 0018        es: 0018       ss: 0018
Process swapper (pid: 0, stackpage=c02a7000)
Stack:  e09f3939 d526e080 e09f3e16 d99f1180 e09f3d04 d526e080 e09f3920
fffffffe
        e09f3e79 d526e080 d526e080 c012048b d526e080 dffeb200 c02a7f3c
c02a7f3c
        00000000 c02c7a80 fffffffe 00000046 c011cc42 c011cb56 00000000
00000001
Call Trace:     [<e09f3939>] [<e09f3e16>] [<e09f3d04>] [<e09f3e20>]
[<e0ef3e79>]
    [<c012048b>] [<c011cc42>] [<c011cb56>] [<c011c995>] [<c01089da>]
[<c01052c0>]
    [<c010ade8>] [<c01052c0>] [<c01052e3>] [<c0105372>] [<c0105000>]
Code: 89 02 c7 41 04 00 00 00 00 c7 01 00 00 00 00 8b 83 80 00 00


>>EIP; e0a232b8 <[ip_conntrack_proto_gre]ip_ct_gre_keymap_destroy+88/c0>  
<=====

>>eax; d4a47bf8 <_end+14742374/206247dc>
>>ebx; d99f1180 <_end+196eb8fc/206247dc>
>>ecx; cefd1480 <_end+eccbbfc/206247dc>
>>esi; d526e080 <_end+14f687fc/206247dc>
>>esp; c02a7f04 <init_task_union+1f04/2000>

Trace; e09f3939 <[ip_conntrack]ip_ct_find_proto+19/40>
Trace; e09f3e16 <[ip_conntrack]destroy_conntrack+106/110>
Trace; e09f3d04 <[ip_conntrack]clean_from_lists+54/60>
Trace; e09f3e20 <[ip_conntrack]death_by_timeout+0/60>
Trace; e0ef3e79 <END_OF_CODE+2e35d6/????>
Trace; c012048b <timer_bh+17b/3a0>
Trace; c011cc42 <bh_action+22/40>
Trace; c011cb56 <tasklet_hi_action+46/70>
Trace; c011c995 <do_softirq+95/a0>
Trace; c01089da <do_IRQ+9a/a0>
Trace; c01052c0 <default_idle+0/40>
Trace; c010ade8 <call_do_IRQ+5/d>
Trace; c01052c0 <default_idle+0/40>
Trace; c01052e3 <default_idle+23/40>
Trace; c0105372 <cpu_idle+52/70>
Trace; c0105000 <_stext+0/0>

Code;  e0a232b8 <[ip_conntrack_proto_gre]ip_ct_gre_keymap_destroy+88/c0>
00000000 <_EIP>:
Code;  e0a232b8 <[ip_conntrack_proto_gre]ip_ct_gre_keymap_destroy+88/c0>  
<=====
   0:   89 02                     mov    %eax,(%edx)   <=====
Code;  e0a232ba <[ip_conntrack_proto_gre]ip_ct_gre_keymap_destroy+8a/c0>
   2:   c7 41 04 00 00 00 00      movl   $0x0,0x4(%ecx)
Code;  e0a232c1 <[ip_conntrack_proto_gre]ip_ct_gre_keymap_destroy+91/c0>
   9:   c7 01 00 00 00 00         movl   $0x0,(%ecx)
Code;  e0a232c7 <[ip_conntrack_proto_gre]ip_ct_gre_keymap_destroy+97/c0>
   f:   8b 83 80 00 00 00         mov    0x80(%ebx),%eax


2 warnings issued.  Results may not be reliable.
--

Loaded modules:
bsd_comp                4216   0  (autoclean)
ppp_deflate             3320  11  (autoclean)
zlib_inflate           18596   0  (autoclean) [ppp_deflate]
zlib_deflate           18936   0  (autoclean) [ppp_deflate]
ppp_async               6624  91  (autoclean)
ppp_generic            16964 273  (autoclean) [bsd_comp ppp_deflate
ppp_async]
slhc                    4768  14  (autoclean) [ppp_generic]
ipt_MASQUERADE          1336   2  (autoclean)
ipt_limit                920   1  (autoclean)
ipt_string              1724   1  (autoclean)
ipt_ULOG                4612   2  (autoclean)
ipt_LOG                 3936   3  (autoclean)
iptable_filter          1772   1  (autoclean)
ipt_MARK                 792   1  (autoclean)
iptable_mangle          2200   1  (autoclean)
ip_nat_proto_gre        2180   0  (unused)
ip_conntrack_pptp       7281   1  (autoclean)
ip_nat_pptp             4620   0  (unused)
ip_conntrack_proto_gre    3829   0  [ip_conntrack_pptp ip_nat_pptp]
ip_conntrack_ftp        4112   1  (autoclean)
ip_nat_ftp              3024   0  (unused)
iptable_nat            17646   4  [ipt_MASQUERADE ip_nat_proto_gre
ip_nat_pptp ip_nat_ftp]
ip_tables              12416  11  [ipt_MASQUERADE ipt_limit ipt_string
ipt_ULOG ipt_LOG iptable_filter ipt_MARK iptable_mangle iptable_nat]
ip_conntrack           20484   3  [ipt_MASQUERADE ip_conntrack_pptp
ip_nat_pptp ip_conntrack_proto_gre ip_conntrack_ftp ip_nat_ftp
iptable_nat]
dummy                    984   0  (unused)
e1000                  74992   3
e100                   32556   1

Any help would be greatly appreciated.

-- 
wbr, Oleg.
