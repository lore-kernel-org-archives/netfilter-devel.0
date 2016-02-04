From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft 2/3] meta: add prandom matching
Date: Thu, 4 Feb 2016 18:40:29 +0100
Message-ID: <20160204174029.GB13157@macbook.localdomain>
References: <1454368741-16368-1-git-send-email-fw@strlen.de>
 <1454368741-16368-3-git-send-email-fw@strlen.de>
 <DB5D81F9-A143-4DE6-A315-465B72EA84B3@trash.net>
 <20160204144646.GA25780@breakpoint.cc>
 <20160204152711.GA3853@macbook.localdomain>
 <20160204153240.GB25780@breakpoint.cc>
 <20160204160937.GA13973@breakpoint.cc>
 <20160204164243.GB13973@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48805 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbcBDRkb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Feb 2016 12:40:31 -0500
Content-Disposition: inline
In-Reply-To: <20160204164243.GB13973@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 04.02, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
>
> > > What should happen when user asks for meta random 42.23 ?
> > 
> > That still stands, where would this error be detect best?
> 
> I've also been unable to figure out where the u32 scaling has
> to be performed, netlink_linearize.c seems to be a very poor place
> for this since it would mean special-casing netlink_gen_cmp
> to check for OP_LTE and presence of EXPR_META with the meta PRANDOM
> key...?
> 
> In fact, doing the scaling via precision_type seems to
> be a lot simpler as then its applied only in this one case of the
> prandom META_TEMPLATE while keeping this detail limited to meta.c.

Yes, on second thought I agree, sorry. Maybe the work is not lost though,
what does seem to make sense is to use a float basetype and derive your
probability type from that.
