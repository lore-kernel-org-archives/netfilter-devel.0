From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] evaluate: print error for null string befort assert
 statement
Date: Mon, 27 Nov 2017 23:51:11 +0100
Message-ID: <20171127225111.GA28857@salvia>
References: <20171123185514.16711-1-harshasharmaiitr@gmail.com>
 <20171123212551.GA22063@breakpoint.cc>
 <20171127223955.GA26292@salvia>
 <20171127224803.GC23412@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harsha Sharma <harshasharmaiitr@gmail.com>,
        netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38316 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752331AbdK0WvP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Nov 2017 17:51:15 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8B9DAC0B2E
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Nov 2017 23:51:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7B90EDA391
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Nov 2017 23:51:14 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171127224803.GC23412@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 27, 2017 at 11:48:03PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Thu, Nov 23, 2017 at 10:25:51PM +0100, Florian Westphal wrote:
> > > Harsha Sharma <harshasharmaiitr@gmail.com> wrote:
> > > > Print error "Null string is not allowed" before assert statement.
> > > > For e.g.
> > > > nft add rule filter input meta iifname '""'
> > > > Error: Null String is not allowed
> > > > add rule filter input meta iifname ""
> > > 
> > > Is there any case where "" should be allowed?
> > > 
> > > If not, I'd rather change scanner.l to not recognize "" as
> > > a quoted string.
> > 
> > We'll get error reporting like this if we handle this from the
> > scanner:
> > 
> > # nft add rule x y ct label \"\"
> > Error: syntax error, unexpected junk
> > add rule x y ct label ""
> 
> Right, we'd have to add dummy empty_string rule to avoid this.
> 
> > This is just two extra lines in the validation step and it is not
> > worth to optimize an error case, ie. do it earlier. So I'm feeling
> > inclined to take this one.
> 
> Makes sense to me.
> 
> > I will mangle the error message to "Empty string is not allowed".
> > "Null" probably sounds too programmer thing.
> 
> Can you also get rid of the assert(strlen ... line?
> Its useless after this patch.

Indeed, done!
