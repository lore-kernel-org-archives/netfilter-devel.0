From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] Expose x_tables /proc entries as 0444 not 0440
Date: Wed, 11 Nov 2015 19:40:52 +0100
Message-ID: <20151111184052.GA26909@breakpoint.cc>
References: <20151107074939.GA4003@compaq.slightly-cracked.com>
 <20151111165026.GA20549@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Philip Whineray <phil@firehol.org>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60008 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751275AbbKKSky (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Nov 2015 13:40:54 -0500
Content-Disposition: inline
In-Reply-To: <20151111165026.GA20549@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Hiding the contents from non-root users does not achieve anything
> > practical. Possible values are well-known and the specifics can
> > be inferred from a list of loaded modules on most systems.

I agree, thus
Acked-by: Florian Westphal <fw@strlen.de>
