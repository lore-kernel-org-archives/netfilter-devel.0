From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3 kernel 19/29] add byte threshold capability to nfacct
Date: Wed, 10 Jul 2013 22:00:53 +0200
Message-ID: <20130710200053.GC27468@breakpoint.cc>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
 <1373480727-11254-20-git-send-email-michael.zintakis@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Michael Zintakis <michael.zintakis@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40897 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754342Ab3GJUAx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 16:00:53 -0400
Content-Disposition: inline
In-Reply-To: <1373480727-11254-20-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Michael Zintakis <michael.zintakis@googlemail.com> wrote:
> * add a 'bthr' variable to each nfacct object, allowing a bytes 'threshold'
> to be stored and then reported if/when traffic breaches it.

Again, why is this needed?
Why is it useful?
