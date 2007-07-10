From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Patch for geoip to make it work with Linux kernel 2.6.22.x
Date: Tue, 10 Jul 2007 18:58:41 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707101839320.11053@fbirervta.pbzchgretzou.qr>
References: <twig.1177771162.67234@bugmachine.ca>
	<006801c7c309$2b8532a0$010210ac@BJERKESET.COM>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: jix@bugmachine.ca, netfilter-devel@lists.netfilter.org
To: Svein Olav Bjerkeset <svein.olav@bjerkeset.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <006801c7c309$2b8532a0$010210ac@BJERKESET.COM>
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


On Jul 10 2007 17:44, Svein Olav Bjerkeset wrote:
>
> After upgrading to kernel 2.6.22, I found that the geoip patchlet did not
> compile.
> I have made a patch that works on my system with kernel 2.6.22.
>[...]
> You can download the patch by using the following URL:
> http://bjerkeset.com/patches/geoip-match-2.6.22.patch.gz

>diff -urN geoip-20061206/linux-2.6/net/ipv4/netfilter/ipt_geoip.c geoip/linux-2.6/net/ipv4/netfilter/ipt_geoip.c
>--- geoip-20061206/linux-2.6/net/ipv4/netfilter/ipt_geoip.c	2006-12-06 03:47:46.000000000 +0100
>+++ geoip/linux-2.6/net/ipv4/netfilter/ipt_geoip.c	2007-07-10 17:17:11.599991698 +0200
>@@ -110,7 +110,11 @@
> {
>    const struct ipt_geoip_info *info = matchinfo;
>    const struct geoip_info *node; /* This keeps the code sexy */
>+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,22)
>+   const struct iphdr *iph = ip_hdr(skb);
>+#else
>    const struct iphdr *iph = skb->nh.iph;
>+#endif
>    u_int32_t ip, j;
>    u_int8_t i;
> 
>@@ -276,7 +280,10 @@
> }
> 
> static struct ipt_match geoip_match = {

ipt_match is not defined anymore, and hence should have thrown a compile error
right away.

>-   .name    = "geoip",
>+   .name       = "geoip",
>+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,21)
>+   .family     = AF_INET,
>+#endif

.family and is required when using xt_register_match.
xt_register_match exists since at least 2.6.18.

>    .match      = &match,
> #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,17)
>    .matchsize  = sizeof (struct ipt_geoip_info),
>@@ -288,12 +295,20 @@
> 
> static int __init init(void)
> {
>+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,21)
>+   return xt_register_match(&geoip_match);
>+#else
>    return ipt_register_match(&geoip_match);
>+#endif
> }
> 
> static void __exit fini(void)
> {
>+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,21)
>+  xt_unregister_match(&geoip_match);
>+#else
>   ipt_unregister_match(&geoip_match);
>+#endif
>   return;
> }
> 



	Jan
-- 
