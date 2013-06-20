From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH lnfct-ct 1/2] conntrack: snprintf: add labels in hex
 representation by default
Date: Fri, 21 Jun 2013 00:20:58 +0200
Message-ID: <20130620222058.GK2124@breakpoint.cc>
References: <1371588862-3407-1-git-send-email-fw@strlen.de>
 <20130620113419.GA7070@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38622 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030422Ab3FTWVB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jun 2013 18:21:01 -0400
Content-Disposition: inline
In-Reply-To: <20130620113419.GA7070@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> I'm not sure about the utility of this without the translation to
> strings.

OK, no objections.  Lets just drop it until a use case shows up.
