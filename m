From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3 kernel 24/29] add packets and bytes mark capability
 to nfacct
Date: Wed, 10 Jul 2013 22:01:57 +0200
Message-ID: <20130710200157.GD27468@breakpoint.cc>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
 <1373480727-11254-25-git-send-email-michael.zintakis@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Michael Zintakis <michael.zintakis@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40901 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754051Ab3GJUB6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 16:01:58 -0400
Content-Disposition: inline
In-Reply-To: <1373480727-11254-25-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Michael Zintakis <michael.zintakis@googlemail.com> wrote:
> * add two variables to each nfacct object - 'pmark' and 'bmark', allowing
> short-term traffic accounting to be implemented by placing a "mark" against
> that object.
> 
> This enables counting of traffic (both bytes and packets) since that mark has
> been enabled/set, in addition to the main packet and byte counters.

And again.
Why not simply add a 2nd accounting object, and then send traffic to
it based on ruleset? (-m time, -m condition, -m set, etc.)?

