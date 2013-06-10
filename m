From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] Remove redundant TCP header checks from xt_TCPOPTSTRIP
Date: Mon, 10 Jun 2013 22:22:57 +0200
Message-ID: <20130610202257.GJ14637@breakpoint.cc>
References: <20130610035948.GA2742@gmail.com>
 <20130610181516.GA3757@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phil Oester <kernel@linuxace.com>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:57604 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752530Ab3FJUXB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Jun 2013 16:23:01 -0400
Content-Disposition: inline
In-Reply-To: <20130610181516.GA3757@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> We cannot assume nf_conntrack is loaded. We have to support stateless
> setups as well.
> 
> > In addition, there was an error in the check which was added (len
> > is being calculated incorrectly).  In my testing, ALL packets are being dropped
> > by the TCPOPTSTRIP target at present.  Revert the unnecessary/incorrect checks.
> 
> Then, we have to fix the wrong calculation. I cannot reproduce this
> here.

Its most likely due to tcp_hdr() use, it only works for local packets.
