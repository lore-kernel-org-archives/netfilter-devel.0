From: Roberto Nibali <ratz@tac.ch>
Subject: Re: [PATCH] update raw patch in POM
Date: Mon, 20 Jun 2005 10:18:52 +0200
Message-ID: <42B67BEC.1090105@tac.ch>
References: <42A57FC4.7010508@tac.ch>
	<42A5B144.3090005@tac.ch>	<42A625DA.7090807@eurodev.net>
	<42A6AB19.2040106@tac.ch>	<42A6E685.3060408@eurodev.net>
	<42AEF774.8060300@tac.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <42AEF774.8060300@tac.ch>
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

> I'm not yet done with testing, however something is not quite right now:
> 
> CPU: 2
> EIP: 0010:[<00000000>] Not tainted
> Using defaults from ksymoops -t elf32-i386 -a i386
> EFLAGS: 00010202
> eax: 00000000 ebx: c287df30 ecx: f8aa1ef4 edx: c287c001
> esi: 00000000 edi: f7b92a34 ebp: f7b92980 esp: c287deac
> ds: 0018 es: 0018 ss: 0018
> Process swapper (pid:0, stackpage=c287d000)
> Stack: c02a8f74 f8aa1e80 c287df30 f7b92a34 c01de099 f4a4d920 c287df30 00000040
>        f7b92980 f7b92800 00000000 00000001 00000001 f7b92800 f7b92a18 c01ddee9
>        f7b92980 f7b928c4 f7b92800 00000002 c0417b20 2471321d 00000000 c02ad245
> Call trace:  [<c02a8f74>] [<f8aa1e80>] [<c01de099>] [<c01ddee9>] [<c02ad245>]
> [<c011f7ad>] [<c0108e00>] [<c0105330>] [<c0105330>] [<c0105330>] [<c0105330>]
> [<c010535c>] [<c01053c2>] [<c011a859>]
> Code: Bad EIP value.

Added following code in skbuff.h, because of the strange (overwritten) stack:

nf_conntrack_put(struct nf_ct_info *nfct)
{
+        if ((((long) nfct) & 0xf8000000) && atomic_read(&nfct->master->use) <= 1
)
+                BUG();
        if (nfct && atomic_dec_and_test(&nfct->master->use))
                nfct->master->destroy(nfct->master);
}

and Pablo's debug code (which I believe is not triggered yet):

--- linux-2.4.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-06-15
23:16:43.000000000 +0200
+++ linux-2.4/net/ipv4/netfilter/ip_conntrack_core.c	2005-06-17
20:44:18.000000000 +0200
@@ -1391,6 +1391,8 @@
 		schedule();
 		goto i_see_dead_people;
 	}
+	while (atomic_read(&ip_conntrack_untracked.ct_general.use) != 1)
+		schedule();

 	kmem_cache_destroy(ip_conntrack_cachep);
 	vfree(ip_conntrack_hash);

The above results in following stack trace (at least the stack is now complete):


BUG at /home/.../include/linux/skbuff.h: 1175!
invalid operand: 0000
EFLAGS: 00010246
eax: 00000001 ebx: c2879e58 ecx: f725df1c edx: f7514a64
esi: 00000008 edi: c2879e18 ebp: c2879dfc esp: c2879df4
ds: 0018 cs: 0018 ss:0018
Process swapper (pid:0, stackpage=c2879000)
Stack: c2879e58 c2879e18 c2879e1c c02b9f51 f7514a64 00000000 f7514a64 f750b020
       00000000 f8ae7660 c2879e50 c02c6b3c 00000002 00000001 c2879e58 f7b8c800
       00000000 c02c7100 80000000 00000000 f7514a64 f750b020 787817ac c2879e70
Call trace: [<c02b9f51>][<f8ae7660>][<c02c6b3c>][<c02c7100>][<c02c706a>]
[<c02b0271>][<c01e0379>][<c01dfb76>][<c02b048e>][<c011fcbd>][<c0108f0a>]
[<c0105360>][<c0105360>][<c0105360>][<c0105360>][<c010538f>][<c0105402>]
Code: 0f 0b 97 04 80 bd 37 c0 85 c9 74 17 8b 01 f0 ff 08 0f 94 c2
Using defaults from ksymoops -t elf32-i386 -a i386


>>ebx; c2879e58 <_end+2395dc0/385b6fc8>
>>ecx; f725df1c <_end+36d79e84/385b6fc8>
>>edx; f7514a64 <_end+370309cc/385b6fc8>
>>edi; c2879e18 <_end+2395d80/385b6fc8>
>>ebp; c2879dfc <_end+2395d64/385b6fc8>
>>esp; c2879df4 <_end+2395d5c/385b6fc8>

Trace; c02b9f51 <nf_hook_slow+141/1c4>
Trace; f8ae7660 <END_OF_CODE+182ed/????>
Trace; c02c6b3c <ip_local_deliver+64/1c8>
Trace; c02c7100 <ip_local_deliver_finish+0/150>
Trace; c02c706a <ip_rcv+3ca/460>
Trace; c02b0271 <netif_receive_skb+16d/1a0>
Trace; c01e0379 <e1000_clean_rx_irq+3bd/440>
Trace; c01dfb76 <e1000_clean+3a/d4>
Trace; c02b048e <net_rx_action+be/174>
Trace; c011fcbd <do_softirq+7d/e0>
Trace; c0108f0a <do_IRQ+196/1a8>
Trace; c0105360 <default_idle+0/38>
Trace; c0105360 <default_idle+0/38>
Trace; c0105360 <default_idle+0/38>
Trace; c0105360 <default_idle+0/38>
Trace; c010538f <default_idle+2f/38>
Trace; c0105402 <cpu_idle+42/58>

Code;  00000000 Before first symbol
00000000 <_EIP>:
Code;  00000000 Before first symbol
   0:   0f 0b                     ud2a
Code;  00000002 Before first symbol
   2:   97                        xchg   %eax,%edi
Code;  00000003 Before first symbol
   3:   04 80                     add    $0x80,%al
Code;  00000005 Before first symbol
   5:   bd 37 c0 85 c9            mov    $0xc985c037,%ebp
Code;  0000000a Before first symbol
   a:   74 17                     je     23 <_EIP+0x23> 00000023 Before first sy
mbol
Code;  0000000c Before first symbol
   c:   8b 01                     mov    (%ecx),%eax
Code;  0000000e Before first symbol
   e:   f0 ff 08                  lock decl (%eax)
Code;  00000011 Before first symbol
  11:   0f 94 c2                  sete   %dl

<0>Kernel panic: Aiee, killing interrupt handler!

65 warnings issued.  Results may not be reliable.

I'll remove the BUG() code and have Pablo's code running alone now. After that
I'll also try the following approach, also from our southern friend Pablo:

Index: linux-2.4/net/ipv4/ip_output.c
===================================================================
--- linux-2.4.orig/net/ipv4/ip_output.c	2005-06-08 00:16:54.000000000 +0200
+++ linux-2.4/net/ipv4/ip_output.c	2005-06-15 23:42:13.000000000 +0200
@@ -166,6 +166,8 @@
 	nf_debug_ip_finish_output2(skb);
 #endif /*CONFIG_NETFILTER_DEBUG*/

+	nf_reset(skb);
+
 	if (hh) {
 		int hh_alen;


If you have other ideas, let me know. I could also need some help regarding
debugging the stack trace. It doesn't make much sense to me right now. To
reproduce I roughly use following procedure (not always successful):

1. load a lot of modules (I don't know them by heart but certainly all
   ip_conntrack* related ones)
2. set the policy of all chains in the filter table to DROP
3. generate a normal ruleset for incoming tcp traffic from host A tcp/22
   (ssh)
4. generate a notrack ruleset for incoming tcp traffic from host B
   tcp/22 (ssh)
5. log in from A in one terminal
6. log in from B in another terminal, start iptstate or
   watch -n 1 'cat /proc/net/ip_conntrack'
7. log in from B in yet another terminal and do a ruleset reconfig which
   boils down to following:

   flush all chains and rules therein
   while still_have_ip_conntrack_kernel_modules; do
        rmmod $kmod
   done
   rmmod ip_conntrack
   redo steps 1-4

8. hang and oops!

Cheers,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Rathausgasse 31, CH-5001 Aarau  tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
