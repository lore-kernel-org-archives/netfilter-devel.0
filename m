From: "Niki Denev" <ndenev@icdsoft.com>
Subject: Re: [NETFILTER][PATCH] Re: Question about the hashlimit network mask patch
Date: Wed, 26 Mar 2008 11:54:44 +0200
Message-ID: <2e77fc10803260254h1c6d850dq11eab0f0e78c1b66@mail.gmail.com>
References: <47E39230.90400@icdsoft.com>
	 <alpine.LNX.1.00.0803211404530.10642@fbirervta.pbzchgretzou.qr>
	 <47E3E861.9090707@icdsoft.com>
	 <alpine.LNX.1.00.0803211805340.10642@fbirervta.pbzchgretzou.qr>
	 <47E90678.7090405@icdsoft.com>
	 <alpine.LNX.1.10.0803260836030.22661@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net,
	"Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.225]:49478 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbYCZJyr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2008 05:54:47 -0400
Received: by wx-out-0506.google.com with SMTP id h31so4014744wxd.4
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2008 02:54:45 -0700 (PDT)
In-Reply-To: <alpine.LNX.1.10.0803260836030.22661@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 26, 2008 at 9:44 AM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Tuesday 2008-03-25 15:04, Iavor Stoev wrote:
> >
> > xtables-1.5.3 release works flawlessly but I found a strange behavior with
> > srcmask option.
> >
> > If you want to use /32 as a mask it doesn't work, however /31 works fine:
> >
> > --- xt_hashlimit.c.orig 2008-03-25 08:59:10.000000000 -0400
> > +++ xt_hashlimit.c      2008-03-25 08:59:26.000000000 -0400
> > @@ -466,7 +466,7 @@
> >
> > static inline __be32 maskl(__be32 a, unsigned int l)
> > {
> > -       return htonl(ntohl(a) & ~(~(u_int32_t)0 >> l));
> > +       return htonl(ntohl(a) & ~(~(u_int32_t)0 >> (l-1)));
> > }
> >
>
> I hate this. It's just stupid that  x>>32  is not 0, but, surprisingly, x.
>
> This crap is _so_ common that the networking code is *sprinkled* with
> x==32 exceptions and it happens we still fall into the trap.
>
> So this patch is needed ... but I had submitted one that entirely got
> rid of such pitfalls anyway ("Deploy a prefix len...") but that was not
> merged unfrotunately.
>
> ====
> [NETFILTER]: xt_hashlimit: add workaround for >>32 case
>
> Hardware surprisingly does nothing when a 32-bit right-shift is
> to be done. Worse yet, compilers do not even work around it.
>
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
>
> diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
> index 5418ce5..1072174 100644
> --- a/net/netfilter/xt_hashlimit.c
> +++ b/net/netfilter/xt_hashlimit.c
> @@ -466,7 +466,10 @@ static inline void rateinfo_recalc(struct dsthash_ent *dh, unsigned long now)
>
>  static inline __be32 maskl(__be32 a, unsigned int l)
>  {
> -       return htonl(ntohl(a) & ~(~(u_int32_t)0 >> l));
> +       if (l == 32)
> +               return a;
> +       else
> +               return htonl(ntohl(a) & ~(~(u_int32_t)0 >> l));
>  }
>
>  #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)

Hi Jan,

As far as i understand the maskl() function is called on every match.
wouldn't it be more appropriate(and faster) if all these checks and
bitshifts are done
in userspace by the iptables utility, so the kernel sees only the
"prepared" mask ready for AND-ing.
Of course this would require some mask_show() function in iptables to
convert it to bit count,
when we want to show the rules.

Regards,
Niki
