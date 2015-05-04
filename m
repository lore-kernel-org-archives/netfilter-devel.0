From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3.19 176/177] netfilter: x_tables: fix cgroup matching on
 non-full sks
Date: Mon, 4 May 2015 10:46:55 +0200
Message-ID: <20150504084655.GA4571@salvia>
References: <20150502190119.666291882@linuxfoundation.org>
 <20150502190127.967512385@linuxfoundation.org>
 <554545E5.8020606@mageia.org>
 <20150503184534.GC19674@kroah.com>
 <5546911A.4000209@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Thomas Backlund <tmb@mageia.org>, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, Alexey Perevalov <a.perevalov@samsung.com>,
	netfilter-devel@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5546911A.4000209@iogearbox.net>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sun, May 03, 2015 at 11:20:26PM +0200, Daniel Borkmann wrote:
> >>In order to fix it, you also need to add:
> >>
> >> From 1d0ab253872cdd3d8e7913f59c266c7fd01771d0 Mon Sep 17 00:00:00 2001
> >>From: Eric Dumazet <edumazet@google.com>
> >>Date: Sun, 15 Mar 2015 21:12:12 -0700
> >>Subject: [PATCH] net: add sk_fullsock() helper
> >>
> >>which in turn needs this one:
> >>
> >> From 10feb428a5045d5eb18a5d755fbb8f0cc9645626 Mon Sep 17 00:00:00 2001
> >>From: Eric Dumazet <edumazet@google.com>
> >>Date: Thu, 12 Mar 2015 16:44:04 -0700
> >>Subject: [PATCH] inet: add TCP_NEW_SYN_RECV state
> >
> >I've just dropped the patch, thanks for letting me know, odd that my
> >build tests missed it.
> 
> If you're nevertheless interested in this fix, you could use this version,
> which should apply/build just fine:
> 
>   http://patchwork.ozlabs.org/patch/455546/
> 
> I believe Pablo usually sends netfilter patches in bundles to you.

Yes, I keep an internal queue netfilter patches that I consider
important to go to -stable.

I think it's better if anyone willing to get some netfilter related
patch into -stable just point that to me so I take care of it. At
least that should add one extra filter step to make sure things don't
break in this process.

Thanks.
