From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] scanner: disable most rules when we expect literal
 symbol
Date: Tue, 5 Jan 2016 12:34:07 +0100
Message-ID: <20160105113407.GC1731@breakpoint.cc>
References: <1451788347-11846-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38999 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751616AbcAELeJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jan 2016 06:34:09 -0500
Content-Disposition: inline
In-Reply-To: <1451788347-11846-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> nft fails to parse certain corner-cases, for example:
> 
> nft add rule filter input meta rtclassid daddr
> 
> ... as it finds DADDR token.  However, 'daddr' might be a valid
> routing realm listed in iproute2/rt_realms, so this should be allowed.
> 
> Pablo suggested to change the start conditions in the scanner
> accordingly.
> 
> After this patch, the following rule works:
> 
> ct label & (foobar | saddr) == saddr ip saddr 1.2.3.4 rtclassid { 42, cosmos, rule}

Note that this will not work:

ct label eq foobar

(we disabled eq token, eq is expected to be name of label).

&, ==, !=, etc. will continue to work.

Not sure if thats a bug or feature -- it would be easy to just
remove the <INITIAL> from "eq" so that we continue to recognize
it as "==", but it means that its not possible to use eq, lt, gt,
and so on as usernames, rtclassids, etc etc.
