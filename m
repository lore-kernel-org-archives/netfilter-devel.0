From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] TPROXY cleanups
Date: Mon, 6 Oct 2008 16:39:21 +0400
Message-ID: <20081006123921.GA23796@x200.localdomain>
References: <20081006121943.GA13547@x200.localdomain> <20081006122603.GA18559@sch.bme.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: kaber@trash.net, hidden@sch.bme.hu, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:40863 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbYJFMgm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 08:36:42 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1009083nfc.21
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Oct 2008 05:36:41 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20081006122603.GA18559@sch.bme.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 06, 2008 at 02:26:03PM +0200, KOVACS Krisztian wrote:
> On h, okt 06, 2008 at 04:19:44 +0400, Alexey Dobriyan wrote:
> > * drop version.h -- unneeded and file will be needlessly rebuilt.
> > * make tproxy_core unloadable
> > * use "in" device outright, -- target and match are only in PRE_ROUTING,
> >   so should avoid dereference.

> > @@ -89,7 +88,11 @@ static int __init nf_tproxy_init(void)
> >  	return 0;
> >  }
> >  
> > +static void __exit nf_tproxy_exit(void)
> > +{
> > +}
> >  module_init(nf_tproxy_init);
> > +module_exit(nf_tproxy_exit);
> 
> Please don't do this. The module was made unloadable because it attaches a
> function pointer to skb's and removing the module while there's an skb in
> flight would cause a kernel crash.

Have you actually seen it?

xt_TPROXY will pin it because it uses a symbol from it, so it won't
dissapear.

Anyway, banning rmmod is absolutely wrong thing regardless.
