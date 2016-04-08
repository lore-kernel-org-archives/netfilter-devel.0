From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH RFC nf-next 0/3] named expressions for nf_tables
Date: Fri, 8 Apr 2016 14:04:34 +0200
Message-ID: <20160408120434.GA6526@breakpoint.cc>
References: <1459961493-7494-1-git-send-email-pablo@netfilter.org>
 <20160407214942.GB731@breakpoint.cc>
 <20160408114351.GA6869@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58434 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752633AbcDHMEg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Apr 2016 08:04:36 -0400
Content-Disposition: inline
In-Reply-To: <20160408114351.GA6869@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 2) When replacing the rule, the new expression starts from no history
>    as it will be a new expression, we'll be basically reseting it.

You are right, I was only thinking of counter (where userspace can
set packets/bytes), but limit would lose its state as most of that
is internal only.

So I think #2 makes sense.

I have more concerns (sorry!) wrt user representation, I'll reply
to this in a new email.

