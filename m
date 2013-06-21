From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH lnfct-ct 1/2] conntrack: snprintf: add labels in hex
 representation by default
Date: Fri, 21 Jun 2013 02:19:49 +0200
Message-ID: <20130621001949.GA9580@localhost>
References: <1371588862-3407-1-git-send-email-fw@strlen.de>
 <20130620113419.GA7070@localhost>
 <20130620222058.GK2124@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58694 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935359Ab3FUATy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jun 2013 20:19:54 -0400
Content-Disposition: inline
In-Reply-To: <20130620222058.GK2124@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 21, 2013 at 12:20:58AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > I'm not sure about the utility of this without the translation to
> > strings.
> 
> OK, no objections.  Lets just drop it until a use case shows up.

Thanks. In my experience, it's just better not to add a new interface
whose use case is unclear rather than adding it and wait for people to
(ab)use it.
