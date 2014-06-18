From: Florian Westphal <fw@strlen.de>
Subject: Re: Multiple conntrack tables
Date: Wed, 18 Jun 2014 23:30:57 +0200
Message-ID: <20140618213057.GA13029@breakpoint.cc>
References: <CAOj-5WDepb3pj3=oRms+OhWhScFJ15V-H3QuGUFjScE54-mtMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Sam Liddicott <sam@liddicott.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40296 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755408AbaFRVa6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Jun 2014 17:30:58 -0400
Content-Disposition: inline
In-Reply-To: <CAOj-5WDepb3pj3=oRms+OhWhScFJ15V-H3QuGUFjScE54-mtMg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sam Liddicott <sam@liddicott.com> wrote:
> I know that a rule in raw can prevent a packet from being processed by
> contrack..
> 
> I wonder if it could also identify which contrack table it should go in.

This is possible via conntrack zones, see
iptables-extensions(8), '--zone' option of CT target.
