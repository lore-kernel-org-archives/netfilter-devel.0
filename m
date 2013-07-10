From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3 kernel 1/29] bugfix: pkts/bytes need to be specified
 simultaneously
Date: Wed, 10 Jul 2013 22:04:50 +0200
Message-ID: <20130710200450.GE27468@breakpoint.cc>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
 <1373480727-11254-2-git-send-email-michael.zintakis@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Michael Zintakis <michael.zintakis@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40911 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754574Ab3GJUEu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 16:04:50 -0400
Content-Disposition: inline
In-Reply-To: <1373480727-11254-2-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Michael Zintakis <michael.zintakis@googlemail.com> wrote:
> * in nfnetlink_acct.c::nfnl_acct_new enforce a check ensuring that
> packet and byte values are specified simultaneously - return -EINVAL if
> that is not the case.

Ok, I understand why it appears to be un-intuitive to have
an accounting object that shows '0 bytes in 100000 packets'.

But still, whats the point?

I could also set '1 byte in 100000 packets', no?

[ so my point is, why bother with checking this? ]
