From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 02/13] IP set core support
Date: Thu, 27 Jan 2011 09:58:49 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1101270955260.24591@blackhole.kfki.hu>
References: <1295618527-9583-1-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-2-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-3-git-send-email-kadlec@blackhole.kfki.hu> <4D3EE709.4040303@trash.net>
 <alpine.DEB.2.00.1101252226080.19648@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:49859 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab1A0I6u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Jan 2011 03:58:50 -0500
In-Reply-To: <alpine.DEB.2.00.1101252226080.19648@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 25 Jan 2011, Jozsef Kadlecsik wrote:

> On Tue, 25 Jan 2011, Patrick McHardy wrote:
> 
> > On 21.01.2011 15:01, Jozsef Kadlecsik wrote:
> > > +/* Flags at command level */
> > > +enum ipset_cmd_flags {
> > > +	IPSET_FLAG_BIT_EXIST	= 0,
> > > +	IPSET_FLAG_EXIST	= (1 << IPSET_FLAG_BIT_EXIST),
> > > +};
> > 
> > One more comment regarding this file - this duplicates the semantic
> > of the NLM_F_EXCL flag, which indicates that an error should be
> > returned if something already exists on creation.
> 
> It is exactly the NLM_F_EXCL flag, just a shorthand notation for the core:
> 
> static inline u32
> flag_exist(const struct nlmsghdr *nlh)
> {
>         return nlh->nlmsg_flags & NLM_F_EXCL ? 0 : IPSET_FLAG_EXIST;
> }

I would better leave it as is: it is an open part of ipset to pass 
command-level flags down to the sets. Currently only the IPSET_FLAG_EXIST 
flag is defined and special in the sense that it express the NLM_F_EXCL 
flag.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
