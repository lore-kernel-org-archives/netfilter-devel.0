From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [NETFILTER][PATCH] Re: Question about the hashlimit network mask
 patch
Date: Wed, 26 Mar 2008 08:44:20 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0803260836030.22661@fbirervta.pbzchgretzou.qr>
References: <47E39230.90400@icdsoft.com> <alpine.LNX.1.00.0803211404530.10642@fbirervta.pbzchgretzou.qr> <47E3E861.9090707@icdsoft.com> <alpine.LNX.1.00.0803211805340.10642@fbirervta.pbzchgretzou.qr> <47E90678.7090405@icdsoft.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Iavor Stoev <iavor@icdsoft.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57478 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbYCZHoV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2008 03:44:21 -0400
In-Reply-To: <47E90678.7090405@icdsoft.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-03-25 15:04, Iavor Stoev wrote:
>
> xtables-1.5.3 release works flawlessly but I found a strange behavior with 
> srcmask option.
>
> If you want to use /32 as a mask it doesn't work, however /31 works fine:
>
> --- xt_hashlimit.c.orig 2008-03-25 08:59:10.000000000 -0400
> +++ xt_hashlimit.c      2008-03-25 08:59:26.000000000 -0400
> @@ -466,7 +466,7 @@
>
> static inline __be32 maskl(__be32 a, unsigned int l)
> {
> -       return htonl(ntohl(a) & ~(~(u_int32_t)0 >> l));
> +       return htonl(ntohl(a) & ~(~(u_int32_t)0 >> (l-1)));
> }
>

I hate this. It's just stupid that  x>>32  is not 0, but, surprisingly, x.

This crap is _so_ common that the networking code is *sprinkled* with 
x==32 exceptions and it happens we still fall into the trap.

So this patch is needed ... but I had submitted one that entirely got 
rid of such pitfalls anyway ("Deploy a prefix len...") but that was not 
merged unfrotunately.

====
[NETFILTER]: xt_hashlimit: add workaround for >>32 case

Hardware surprisingly does nothing when a 32-bit right-shift is
to be done. Worse yet, compilers do not even work around it.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 5418ce5..1072174 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -466,7 +466,10 @@ static inline void rateinfo_recalc(struct dsthash_ent *dh, unsigned long now)

  static inline __be32 maskl(__be32 a, unsigned int l)
  {
-	return htonl(ntohl(a) & ~(~(u_int32_t)0 >> l));
+	if (l == 32)
+		return a;
+	else
+		return htonl(ntohl(a) & ~(~(u_int32_t)0 >> l));
  }

  #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
