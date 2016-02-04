From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 2/3] meta: add prandom matching
Date: Thu, 4 Feb 2016 15:46:46 +0100
Message-ID: <20160204144646.GA25780@breakpoint.cc>
References: <1454368741-16368-1-git-send-email-fw@strlen.de>
 <1454368741-16368-3-git-send-email-fw@strlen.de>
 <DB5D81F9-A143-4DE6-A315-465B72EA84B3@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:43538 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757692AbcBDOqs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Feb 2016 09:46:48 -0500
Content-Disposition: inline
In-Reply-To: <DB5D81F9-A143-4DE6-A315-465B72EA84B3@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> Am 2. Februar 2016 00:19:00 MEZ, schrieb Florian Westphal <fw@strlen.de>:
> >
> > enum datatypes {
> > 	TYPE_INVALID,
> >@@ -78,6 +79,7 @@ enum datatypes {
> > 	TYPE_ICMPV6_CODE,
> > 	TYPE_ICMPX_CODE,
> > 	TYPE_DEVGROUP,
> >+	TYPE_PROBABILITY,
> > 	__TYPE_MAX
> > 
> 
> Any reason why you chose to add this type instead of a generic floating point type?

I wanted 0.9999 be tranlated to a value close to UINT32_MAX and 0.00001
to something close to zero so that "meta random 0.999" can be translated to
something like

reg1 = prandom_u32()
reg1 <= 0xffffffee

I.e. this type cannot represent 5.2 (or whatever).

Does that answer your question?
