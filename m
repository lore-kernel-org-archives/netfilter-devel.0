From: Benoit Boissinot <benoit.boissinot@ens-lyon.org>
Subject: Re: 2.6.11-rc2-mm1 - compile fix
Date: Mon, 24 Jan 2005 21:24:09 +0100
Message-ID: <20050124202409.GG1847@ens-lyon.fr>
References: <20050124021516.5d1ee686.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261619AbVAXU1A@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Content-Disposition: inline
In-Reply-To: <20050124021516.5d1ee686.akpm@osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jan 24, 2005 at 02:15:16AM -0800, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.11-rc1/2.6.11-rc1-mm1/
> 
> 
> - Lots of updates and fixes all over the place.
> 
> - On my test box there is no flashing cursor on the vga console.  Known bug,
>   please don't report it.
> 
>   Binary searching shows that the bug was introduced by
>   cleanup-vc-array-access.patch but that patch is, unfortunately, huge.
> 
> 

The patch below fixes the compilation of the tftp nat module

net/ipv4/netfilter/ip_nat_tftp.o(.bss+0x0):net/ipv4/netfilter/ip_nat_tftp.c:44: multiple definition of `ip_nat_tftp_hook'
net/ipv4/netfilter/ip_conntrack_tftp.o(.bss+0x0):net/ipv4/netfilter/ip_conntrack_tftp.c:49: first defined here
make[3]: *** [net/ipv4/netfilter/built-in.o] Error 1
make[2]: *** [net/ipv4/netfilter] Error 2
make[1]: *** [net/ipv4] Error 2
make: *** [net] Error 2

Signed-off-by: Benoit Boissinot <benoit.boissinot@ens-lyon.org>


--- linux-clean/include/linux/netfilter_ipv4/ip_conntrack_tftp.h	2005-01-24 12:44:29.000000000 +0100
+++ linux-test/include/linux/netfilter_ipv4/ip_conntrack_tftp.h	2005-01-24 21:11:05.000000000 +0100
@@ -13,8 +13,8 @@ struct tftphdr {
 #define TFTP_OPCODE_ACK		4
 #define TFTP_OPCODE_ERROR	5
 
-unsigned int (*ip_nat_tftp_hook)(struct sk_buff **pskb,
-				 enum ip_conntrack_info ctinfo,
-				 struct ip_conntrack_expect *exp);
+extern unsigned int (*ip_nat_tftp_hook)(struct sk_buff **pskb,
+					enum ip_conntrack_info ctinfo,
+					struct ip_conntrack_expect *exp);
 
 #endif /* _IP_CT_TFTP */
