From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v2 3/3] src: add xt compat support
Date: Fri, 10 Apr 2015 00:34:17 +0200
Message-ID: <20150409223417.GA3205@salvia>
References: <1428598514-1915-1-git-send-email-pablo@netfilter.org>
 <1428598514-1915-3-git-send-email-pablo@netfilter.org>
 <20150409203616.GA27610@acer.localdomain>
 <20150409205135.GG20653@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	arturo.borrero.glez@gmail.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59287 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736AbbDIWaH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Apr 2015 18:30:07 -0400
Content-Disposition: inline
In-Reply-To: <20150409205135.GG20653@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 09, 2015 at 10:51:35PM +0200, Florian Westphal wrote:
> Why would I want to re-write a working nft+compat ruleset to one
> that only uses native expressions?

The fact is that we cannot push users to use nf_tables, but we can
provide good reasons to adopt the native replacements and tools to
migrate easily.

> Whats the point of providing a 'native' replacement for an existing xtables
> target if we can just use the xtables version?

Have a look a hashlimit, multiport and all of our existing combo
match/targets.  They are a mess. We're now going towards a way more
flexible and generic (lego fashion) framework that will provide all
kind of combos without relying on this kind of Frankenstein
extensions.
