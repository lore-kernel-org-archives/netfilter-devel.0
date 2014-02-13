From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH ipset 2/2] lib: don't segfault when ipset_data_get returns
 NULL
Date: Thu, 13 Feb 2014 12:31:45 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1402131226140.17109@blackhole.kfki.hu>
References: <1392197240-9389-1-git-send-email-fw@strlen.de> <1392197240-9389-2-git-send-email-fw@strlen.de> <alpine.DEB.2.10.1402131110080.16734@blackhole.kfki.hu> <20140213111732.GG25153@breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:48858 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbaBMLbt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Feb 2014 06:31:49 -0500
In-Reply-To: <20140213111732.GG25153@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 13 Feb 2014, Florian Westphal wrote:

> Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> > On Wed, 12 Feb 2014, Florian Westphal wrote:
> > 
> > > ipset_data_get returns NULL if the attribute is not available, causes when
> > > running 'ipset list':
> > > 
> > > $ ipset -N foo hash:ip
> > > $ ipset list
> > > Segmentation fault (core dumped)
> > 
> > I'm unable to reproduce it. Please give me more information on the 
> > environment: architecture, kernel, ipset userspace versions, compiler 
> > version.
> 
> latest ipset git version, net-next tree from this morning.
> 
> > >  Not sure about this patch, the missing attr is IPSET_OPT_MEMSIZE.
> > >  Is the kernel supposed to send it along (i am on latest nf tree)?
> > 
> > How do you know which attr is missing? IPSET_OPT_MEMSIZE should always be
> > sent by the kernel, look at mtype_head in ip_set_hash_gen.h.
> 
> You are right.  The attribute is there.  I bisected this down to commit
> 
> commit 2dfb973c0dcc6d22113e2370f461f1733035baaf
> Author: Vytas Dauksa <vytas.dauksa@smoothwall.net>
> Date:   Tue Dec 17 14:01:44 2013 +0000
> 
> add markmask for hash:ip,mark data type
> 
> The problem is that this commit breaks userspace abi.  Minimum fix
> that makes latest ipset userspace work again is this, most likely this
> needs to be corrected on kernel side as well (afaics its not yet in
> net-next or nf trees):

Good catch indeed! The attribute then should be moved just after 
IPSET_ATTR_MARK in include/uapi/linux/netfilter/ipset/ipset.h and run 
"make update_includes" so that include/libipset/linux_ip_set.h gets 
refreshed.

Could you prepare a patch?

Best regards,
Jozsef

> diff --git a/include/libipset/linux_ip_set.h b/include/libipset/linux_ip_set.h
> index c2bae85..d9beec5 100644
> --- a/include/libipset/linux_ip_set.h
> +++ b/include/libipset/linux_ip_set.h
> @@ -90,7 +90,6 @@ enum {
>  	IPSET_ATTR_GC,
>  	IPSET_ATTR_HASHSIZE,
>  	IPSET_ATTR_MAXELEM,
> -	IPSET_ATTR_MARKMASK,
>  	IPSET_ATTR_NETMASK,
>  	IPSET_ATTR_PROBES,
>  	IPSET_ATTR_RESIZE,
> @@ -99,6 +98,7 @@ enum {
>  	IPSET_ATTR_ELEMENTS,
>  	IPSET_ATTR_REFERENCES,
>  	IPSET_ATTR_MEMSIZE,
> +	IPSET_ATTR_MARKMASK,
>  
>  	__IPSET_ATTR_CREATE_MAX,
>  };
> @@ -140,7 +140,6 @@ enum ipset_errno {
>  	IPSET_ERR_EXIST,
>  	IPSET_ERR_INVALID_CIDR,
>  	IPSET_ERR_INVALID_NETMASK,
> -	IPSET_ERR_INVALID_MARKMASK,
>  	IPSET_ERR_INVALID_FAMILY,
>  	IPSET_ERR_TIMEOUT,
>  	IPSET_ERR_REFERENCED,
> @@ -148,6 +147,7 @@ enum ipset_errno {
>  	IPSET_ERR_IPADDR_IPV6,
>  	IPSET_ERR_COUNTER,
>  	IPSET_ERR_COMMENT,
> +	IPSET_ERR_INVALID_MARKMASK,
>  
>  	/* Type specific error codes */
>  	IPSET_ERR_TYPE_SPECIFIC = 4352,
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
