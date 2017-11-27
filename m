From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] evaluate: print error for null string befort assert
 statement
Date: Mon, 27 Nov 2017 23:48:03 +0100
Message-ID: <20171127224803.GC23412@breakpoint.cc>
References: <20171123185514.16711-1-harshasharmaiitr@gmail.com>
 <20171123212551.GA22063@breakpoint.cc>
 <20171127223955.GA26292@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
        Harsha Sharma <harshasharmaiitr@gmail.com>,
        netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:45310 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751771AbdK0WtM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Nov 2017 17:49:12 -0500
Content-Disposition: inline
In-Reply-To: <20171127223955.GA26292@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Nov 23, 2017 at 10:25:51PM +0100, Florian Westphal wrote:
> > Harsha Sharma <harshasharmaiitr@gmail.com> wrote:
> > > Print error "Null string is not allowed" before assert statement.
> > > For e.g.
> > > nft add rule filter input meta iifname '""'
> > > Error: Null String is not allowed
> > > add rule filter input meta iifname ""
> > 
> > Is there any case where "" should be allowed?
> > 
> > If not, I'd rather change scanner.l to not recognize "" as
> > a quoted string.
> 
> We'll get error reporting like this if we handle this from the
> scanner:
> 
> # nft add rule x y ct label \"\"
> Error: syntax error, unexpected junk
> add rule x y ct label ""

Right, we'd have to add dummy empty_string rule to avoid this.

> This is just two extra lines in the validation step and it is not
> worth to optimize an error case, ie. do it earlier. So I'm feeling
> inclined to take this one.

Makes sense to me.

> I will mangle the error message to "Empty string is not allowed".
> "Null" probably sounds too programmer thing.

Can you also get rid of the assert(strlen ... line?
Its useless after this patch.

Thanks!
