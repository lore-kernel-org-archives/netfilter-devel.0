From: Mike Smith <mikesmith1@btconnect.com>
Subject: Re: Oops in replace_in_hashes (ip_net_core.c) 2.4.19
Date: Mon, 21 Jul 2003 09:44:03 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <E19eWDN-0000ym-5E@kashyyyk.netfilter.org>
References: <S261808AbTGAJfh/20030701093537Z+14616@vger.kernel.org> <20030701.024732.71580915.davem@redhat.com> <1057093550.720.58.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: linux-net@vger.kernel.org,
 Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>,
 "David S. Miller" <davem@redhat.com>
In-Reply-To: <1057093550.720.58.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tuesday 01 Jul 2003 21:05 pm, Martin Josefsson wrote:
> On Tue, 2003-07-01 at 11:47, David S. Miller wrote:
> > I believe 2.4.21 has a fix for this, but the netfilter
> > experts will know better.
>
> (Dave, it's netfilter-devel@lists.netfilter.org)
> (to the rest, the original report can be found on linux-net)
>
> It looks like list-corruption.
>
> ip_conntrack_core.c:665
> byipsproto[ipsprotohash].next points into space.
>
> I can't see anything obvious right now, my eyelids are very heavy so
> I'll continue looking tomorrow.
>
> There's a small possibility that this is caused by the modify-after-free
> bug that's fixed in 2.4.21 (but unfortunately introduced some
> refcounting bugs, patches are on the way to Dave, they can be found in
> netfilter patch-o-matic as well).

Hi,

this has happened again. Hand-transcribed oops below. Is this of interest?
I'm happy to accept debug patches etc. Or shall I just move to 2.4.21?

Thanks.

Oops: 0000
CPU:    0
EIP:    0010:[<c0247b2d>]   Not tainted
Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 00210206
eax: c88a1fb8   ebx: c2a19cf0   ecx: 00200216   edx: c98a3068
esi: c2a19c90   edi: 0000017b   ebp: c02dbcfc   esp: c02dbcf0
ds: 0018   es: 0018   ss:0018
Process swapper (pid: 0, stackpage=c02db000)
Stack: c2a19bc0 c2a19c90 00000002 c02dbd20 c024625d c2a19bc0 c2a19c90 00000000
       00000002 c02dbd70 c031f0c0 c021e440 c02dbd48 c0213ea7 00000004 c02dbda0
       00000000 c5787000 c021e440 00000000 c5787000 00000004 c02dbd90 c021417d
Call Trace:    [<c024625d>] [<c021e440>] [<c0213ea7>] [<c021e440>] 
[<c021417d>]
  [<c021e440>] [<c021e409>] [<c021e440>] [<c0213ea7>] [<c021bbb6>] 
[<c021417d>]
  [<c02141b3>] [<c021bb27>] [<c021bb80>] [<c021aec3>] [<c021417d>] 
[<c02141b3>]
  [<c020a91a>] [<c021abe5>] [<c021ad50>] [<c0119b20>] [<c0119b31>] 
[<c020e90a>]
  [<c011a6ab>] [<c010a13c>] [<c0106fb0>] [<c010c5b8>] [<c0106fb0>] 
[<c0106fd6>]
  [<c0107062>] [<c0105000>]
Code: 8b 02 89 58 04 89 46 60 89 53 04 89 1a 5b 5e 5f 5d c3 90 55

>>EIP; c0247b2d <replace_in_hashes+7d/90>   <=====
Trace; c024625d <ip_nat_fn+13d/1a0>
Trace; c021e440 <ip_finish_output2+0/d0>
Trace; c0213ea7 <nf_iterate+27/90>
Trace; c021e440 <ip_finish_output2+0/d0>
Trace; c021417d <nf_hook_slow+9d/130>
Trace; c021e440 <ip_finish_output2+0/d0>
Trace; c021e409 <ip_finish_output+f9/110>
Trace; c021e440 <ip_finish_output2+0/d0>
Trace; c0213ea7 <nf_iterate+27/90>
Trace; c021bbb6 <ip_forward_finish+36/70>
Trace; c021417d <nf_hook_slow+9d/130>
Trace; c02141b3 <nf_hook_slow+d3/130>
Trace; c021bb27 <ip_forward+1b7/210>
Trace; c021bb80 <ip_forward_finish+0/70>
Trace; c021aec3 <ip_rcv_finish+173/1a0>
Trace; c021417d <nf_hook_slow+9d/130>
Trace; c02141b3 <nf_hook_slow+d3/130>
Trace; c020a91a <alloc_skb+da/1a0>
Trace; c021abe5 <ip_rcv+325/360>
Trace; c021ad50 <ip_rcv_finish+0/1a0>
Trace; c0119b20 <it_real_fn+0/60>
Trace; c0119b31 <it_real_fn+11/60>
Trace; c020e90a <net_rx_action+13a/210>
Trace; c011a6ab <do_softirq+5b/b0>
Trace; c010a13c <do_IRQ+ac/c0>
Trace; c0106fb0 <default_idle+0/30>
Trace; c010c5b8 <call_do_IRQ+5/d>
Trace; c0106fb0 <default_idle+0/30>
Trace; c0106fd6 <default_idle+26/30>
Trace; c0107062 <cpu_idle+52/70>
Trace; c0105000 <_stext+0/0>
Code;  c0247b2d <replace_in_hashes+7d/90>
00000000 <_EIP>:
Code;  c0247b2d <replace_in_hashes+7d/90>   <=====
   0:   8b 02                     mov    (%edx),%eax   <=====
Code;  c0247b2f <replace_in_hashes+7f/90>
   2:   89 58 04                  mov    %ebx,0x4(%eax)
Code;  c0247b32 <replace_in_hashes+82/90>
   5:   89 46 60                  mov    %eax,0x60(%esi)
Code;  c0247b35 <replace_in_hashes+85/90>
   8:   89 53 04                  mov    %edx,0x4(%ebx)
Code;  c0247b38 <replace_in_hashes+88/90>
   b:   89 1a                     mov    %ebx,(%edx)
Code;  c0247b3a <replace_in_hashes+8a/90>
   d:   5b                        pop    %ebx
Code;  c0247b3b <replace_in_hashes+8b/90>
   e:   5e                        pop    %esi
Code;  c0247b3c <replace_in_hashes+8c/90>
   f:   5f                        pop    %edi
Code;  c0247b3d <replace_in_hashes+8d/90>
  10:   5d                        pop    %ebp
Code;  c0247b3e <replace_in_hashes+8e/90>
  11:   c3                        ret    
Code;  c0247b3f <replace_in_hashes+8f/90>
  12:   90                        nop    
Code;  c0247b40 <place_in_hashes+0/80>
  13:   55                        push   %ebp

 <0>Kernel panic: Aiee, killing interrupt handler!
