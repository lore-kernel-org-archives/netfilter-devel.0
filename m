From: Mike Smith <mikesmith1@btconnect.com>
Subject: Re: Oops in replace_in_hashes (ip_net_core.c) 2.4.19 (and 2.4.21)
Date: Tue, 22 Jul 2003 10:13:11 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <E19et8x-0006Za-IR@kashyyyk.netfilter.org>
References: <S261808AbTGAJfh/20030701093537Z+14616@vger.kernel.org> <20030721084011.8347162D3E@wlug.westbo.se> <Pine.LNX.4.52.0307211319260.16207@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: linux-net@vger.kernel.org,
 Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <Pine.LNX.4.52.0307211319260.16207@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Monday 21 Jul 2003 11:22 am, Martin Josefsson wrote:
> I'll look over it again later tonight, in the mean time could you switch
> to 2.4.21? And apply everything from submitted and pending in
> patch-o-matic from cvs (cvs instructions can be found on
> http://netfilter.org). Any eventual debugging-patches will be against that
> kernel and those patches.
>
> /Martin

Martin,

vanilla 2.4.21 oopsed last night. Hand-transcribed oops below. I want to 
apply all the cvs fixes but am a bit short of clues. Is it pom-20030107
that I want? (it is advertised as 2.4.18 thru 2.4.20...) or do I need to
do a 'cvs update -d -P' ? Sorry to be so clueless but it's the first
time I've had to do stuff like this. Help!

Oops: 0000
CPU:    0
EIP:    0010:[<c0248d99>]   Not tainted
Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 00210292
eax: c88a1fb8   ebx: c217d8f8   ecx: 00200292   edx: c98a3448
esi: c217d958   edi: 000000ea   ebp: c02edca8   esp: c02edc9c
ds: 0018   es: 0018   ss:0018
Process swapper (pid: 0, stackpage=c02ed000)
Stack: c217d860 c217d8f8 c02edd50 c02edcd0 c0247d7e c217d860 c217d8f8 00000002
       00000000 00000002 c02edd20 c032d8c0 c021ef60 c02edcf8 c02146e7 00000004
       c02edd50 00000000 c724f200 c021ef60 00000000 c724f200 00000004 c02edd40
Call Trace:    [<c0247d7e>] [<c021ef60>] [<c02146e7>] [<c021ef60>] 
[<c02149bd>]
  [<c021ef60>] [<c021ef29>] [<c021ef60>] [<c02146e7>] [<c021c696>] 
[<c02149bd>]
  [<c02149f3>] [<c021c607>] [<c021c660>] [<c021b743>] [<c02149bd>] 
[<c02149f3>]
  [<c021b465>] [<c021b5d0>] [<c020ec88>] [<c020ae1a>] [<c020efc1>] 
[<c020f05d>]
  [<c01b3f7f>] [<c020f170>] [<c011afab>] [<c010a17c>] [<c0106fb0>] 
[<c010c5f8>]
  [<c0106fb0>] [<c0106fd6>] [<c0107062>] [<c0105000>]
Code: 8b 02 89 70 04 89 43 60 89 56 04 89 32 5b 5e 5f 5d c3 90 8d

>>EIP; c0248d99 <replace_in_hashes+99/b0>   <=====
Trace; c0247d7e <ip_nat_fn+16e/1c0>
Trace; c021ef60 <ip_finish_output2+0/d0>
Trace; c02146e7 <nf_iterate+27/90>
Trace; c021ef60 <ip_finish_output2+0/d0>
Trace; c02149bd <nf_hook_slow+9d/130>
Trace; c021ef60 <ip_finish_output2+0/d0>
Trace; c021ef29 <ip_finish_output+f9/110>
Trace; c021ef60 <ip_finish_output2+0/d0>
Trace; c02146e7 <nf_iterate+27/90>
Trace; c021c696 <ip_forward_finish+36/70>
Trace; c02149bd <nf_hook_slow+9d/130>
Trace; c02149f3 <nf_hook_slow+d3/130>
Trace; c021c607 <ip_forward+1b7/210>
Trace; c021c660 <ip_forward_finish+0/70>
Trace; c021b743 <ip_rcv_finish+173/1a0>
Trace; c02149bd <nf_hook_slow+9d/130>
Trace; c02149f3 <nf_hook_slow+d3/130>
Trace; c021b465 <ip_rcv+325/360>
Trace; c021b5d0 <ip_rcv_finish+0/1a0>
Trace; c020ec88 <netif_rx+78/170>
Trace; c020ae1a <alloc_skb+da/1a0>
Trace; c020efc1 <netif_receive_skb+101/130>
Trace; c020f05d <process_backlog+6d/110>
Trace; c01b3f7f <boomerang_interrupt+12f/3a0>
Trace; c020f170 <net_rx_action+70/100>
Trace; c011afab <do_softirq+5b/b0>
Trace; c010a17c <do_IRQ+ac/c0>
Trace; c0106fb0 <default_idle+0/30>
Trace; c010c5f8 <call_do_IRQ+5/d>
Trace; c0106fb0 <default_idle+0/30>
Trace; c0106fd6 <default_idle+26/30>
Trace; c0107062 <cpu_idle+52/70>
Trace; c0105000 <_stext+0/0>
Code;  c0248d99 <replace_in_hashes+99/b0>
00000000 <_EIP>:
Code;  c0248d99 <replace_in_hashes+99/b0>   <=====
   0:   8b 02                     mov    (%edx),%eax   <=====
Code;  c0248d9b <replace_in_hashes+9b/b0>
   2:   89 70 04                  mov    %esi,0x4(%eax)
Code;  c0248d9e <replace_in_hashes+9e/b0>
   5:   89 43 60                  mov    %eax,0x60(%ebx)
Code;  c0248da1 <replace_in_hashes+a1/b0>
   8:   89 56 04                  mov    %edx,0x4(%esi)
Code;  c0248da4 <replace_in_hashes+a4/b0>
   b:   89 32                     mov    %esi,(%edx)
Code;  c0248da6 <replace_in_hashes+a6/b0>
   d:   5b                        pop    %ebx
Code;  c0248da7 <replace_in_hashes+a7/b0>
   e:   5e                        pop    %esi
Code;  c0248da8 <replace_in_hashes+a8/b0>
   f:   5f                        pop    %edi
Code;  c0248da9 <replace_in_hashes+a9/b0>
  10:   5d                        pop    %ebp
Code;  c0248daa <replace_in_hashes+aa/b0>
  11:   c3                        ret
Code;  c0248dab <replace_in_hashes+ab/b0>
  12:   90                        nop
Code;  c0248dac <replace_in_hashes+ac/b0>
  13:   8d 00                     lea    (%eax),%eax

 <0>Kernel panic: Aiee, killing interrupt handler!
