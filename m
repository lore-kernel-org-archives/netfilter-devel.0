From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] examples: nf-queue: fix api usage
Date: Sun, 25 Nov 2012 23:34:13 +0100
Message-ID: <20121125223413.GA25197@breakpoint.cc>
References: <1353858872-12348-1-git-send-email-fw@strlen.de>
 <20121125204725.GA5456@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44137 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753727Ab2KYWeP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Nov 2012 17:34:15 -0500
Content-Disposition: inline
In-Reply-To: <20121125204725.GA5456@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sun, Nov 25, 2012 at 04:54:32PM +0100, Florian Westphal wrote:
> > 1. struct nlattr *attr[NFQA_MAX+1] must be initialized.
> >    Otherwise, attr[FOO] might be non-null after parsing
> >    even if that attribute isn't present in the message.
> > 
> > 2. mnl_attr_get_payload will never return NULL (if the
> >    attribute is NULL, it returns MNL_ATTR_HDRLEN.)
> 
> Fine with me, just a question:

> > +	puts("sleep 10 seconds");
> > +	sleep(10);
> 
> Why this sleep 10 seconds? :-)

Uhhh... Nothing to see here, move along ;-)

Thanks for spotting, i applied the patch (without
this leftover debug crud...).
