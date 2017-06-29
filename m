From: Florian Westphal <fw@strlen.de>
Subject: Re: [nft crap] ct original ip saddr ... handling
Date: Thu, 29 Jun 2017 02:39:49 +0200
Message-ID: <20170629003949.GD9307@breakpoint.cc>
References: <20170628100659.26976-1-fw@strlen.de>
 <20170628163545.GA3874@salvia>
 <20170628223139.GB9307@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37776 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751518AbdF2Akx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Jun 2017 20:40:53 -0400
Content-Disposition: inline
In-Reply-To: <20170628223139.GB9307@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > There are no shift/reduce errors, things compile fine, and all
> > > test cases work.  Its just that we break 'ct event set label':
> > > 
> > > Works:
> > > ct event set new or reply
> > > ct event set new,reply
> > > ct event set new,label
> > > fails:
> > > ct event set label ('expects COMMA')
 
> > This can be fixed, it's just a matter we need more time, right?

Actually 'event set label' is simple to fix; just add keyword_expr
to the ct_stmt_expr list.

But another problem(?) is this:

works:
ct event label or new
ct event set reply or new
doesn't work:
ct event set label or new

(not strictly related to 'label', any other keyword like tcp, ip, etc.
 has same problem, they just don't overlap with event names so would not
 work anyway).

I currently see no way to resolve this, unfortunately.
For ct statements (and meta) we need to support plain expressions as SET
argument, at least in some cases, such as:

meta set mark or 42

This is ambiguous because we have both tokens and symbolic constants.

If we can live with the 'or' not being supported for ct event mask I
think we're fine (it will work when forcing string type, i.e.
ct event set "label" or new).

Also, the 'label, new' format will work fine.
