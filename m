From: Joris Lambrecht <joris.lambrecht@pandora.be>
Subject: [unsubscribed] unresolved symbol nf_unregister_sockopt
Date: 24 Feb 2003 18:46:48 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1046108808.3974.8.camel@interface>
Mime-Version: 1.0
Content-Type: text/plain
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



// I am not a member of the list 

Hello, 

Recently i started using Kernel 2.4.20 on two machines wich generate the
same error/bug on ip_tables.so and others, this does not work for any
configuration. Not even when i issued a mrproper. 


Can someone please let me know if this is a bug/issue that is
patched/fixed allready ? 

I ran into quite a lot of similar posting but not one has a
solution/hint posted. In one occassion someone ran lilo after build and
it worked, though not with my setup. 

// Problem // 


interface:/usr/src/modules# depmod -e 
depmod: *** Unresolved symbols in
/lib/modules/2.4.20/kernel/net/ipv4/ip_gre.o 
depmod: nf_hook_slow 
depmod: *** Unresolved symbols in
/lib/modules/2.4.20/kernel/net/ipv4/ipip.o 
depmod: nf_hook_slow 
depmod: *** Unresolved symbols in
/lib/modules/2.4.20/kernel/net/ipv4/netfilter/ 
arp_tables.o 
depmod: nf_unregister_sockopt 
depmod: nf_register_sockopt 
depmod: *** Unresolved symbols in
/lib/modules/2.4.20/kernel/net/ipv4/netfilter/ 
arptable_filter.o 
depmod: nf_unregister_hook 
depmod: nf_register_hook 
depmod: *** Unresolved symbols in
/lib/modules/2.4.20/kernel/net/ipv4/netfilter/ 
ip_tables.o 
depmod: nf_unregister_sockopt 
depmod: nf_register_sockopt 
depmod: *** Unresolved symbols in
/lib/modules/2.4.20/kernel/net/ipv4/netfilter/ 
ipt_REJECT.o 
depmod: ip_ct_attach 
depmod: nf_hook_slow 
depmod: *** Unresolved symbols in
/lib/modules/2.4.20/kernel/net/ipv4/netfilter/ 
iptable_filter.o 
depmod: nf_unregister_hook 
depmod: nf_register_hook 
interface:/usr/src/modules# 


Should you need more information let me know what i have to supply you
with. 


Regards, 

Joris
