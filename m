From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC PATCH] netfilter: add connlabel conntrack extension
Date: Fri, 19 Oct 2012 15:52:15 +0200
Message-ID: <20121019135215.GE18674@breakpoint.cc>
References: <1350577344-16321-1-git-send-email-fw@strlen.de>
 <20121018165104.GA15142@1984>
 <20121018203809.GA18674@breakpoint.cc>
 <20121019081959.GA11880@1984>
 <20121019085007.GC18674@breakpoint.cc>
 <20121019131533.GB30731@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:51322 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754203Ab2JSNwQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Oct 2012 09:52:16 -0400
Content-Disposition: inline
In-Reply-To: <20121019131533.GB30731@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> I just think that having some clear use case for this is important.
> 
> If you're original idea is just to attach labels to help sysadmins to
> understand what's going on through the gateway, then we can leave this
> as is and add some new specific extension for nfgrep once it comes
> into place.

No, I intend for userspace to assign labels to connections, e.g.
via NFQUEUE.

Also, labels should also be made available via ctnetlink, e.g. for
logging/accounting.

Example: Conntracks are interface agnostic, so you would be able
to provide "came in via interface X" information via connlabels.

My main problem is currently understanding what nfgrep needs.
Since you suggested to do all labelname<->number mapping in
userspace, how would the nfgrep part assign a label?

Is that also done via netfilter rules, or via some "module magic"
feature?  It would be nice to come up with something that
fits nfgrep needs, too.

Best regards,
Florian
