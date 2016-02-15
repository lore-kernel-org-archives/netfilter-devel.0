From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 2/3] meta: add prandom matching
Date: Mon, 15 Feb 2016 13:54:46 +0100
Message-ID: <20160215125446.GA23168@breakpoint.cc>
References: <1454368741-16368-1-git-send-email-fw@strlen.de>
 <1454368741-16368-3-git-send-email-fw@strlen.de>
 <DB5D81F9-A143-4DE6-A315-465B72EA84B3@trash.net>
 <20160204144646.GA25780@breakpoint.cc>
 <20160204152711.GA3853@macbook.localdomain>
 <20160204153240.GB25780@breakpoint.cc>
 <20160204160937.GA13973@breakpoint.cc>
 <20160204164243.GB13973@breakpoint.cc>
 <20160204174029.GB13157@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:36930 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752903AbcBOMys (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Feb 2016 07:54:48 -0500
Content-Disposition: inline
In-Reply-To: <20160204174029.GB13157@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:

Hi Patrick

> On 04.02, Florian Westphal wrote:
> > In fact, doing the scaling via precision_type seems to
> > be a lot simpler as then its applied only in this one case of the
> > prandom META_TEMPLATE while keeping this detail limited to meta.c.
> 
> Yes, on second thought I agree, sorry. Maybe the work is not lost though,
> what does seem to make sense is to use a float basetype and derive your
> probability type from that.

I can do this.
However, I don't currently see any other type that could be derived from
that.  Would you be OK with leaving things as-is and adding a float
type later on once a use case presents itself?

I would re-word the commit message to mention the 'missing' float base type.

Thanks!
