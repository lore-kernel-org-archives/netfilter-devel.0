From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH FIX] NFQUEUE: fix --queue-bypass regression
Date: Tue, 29 Oct 2013 13:02:25 +0100
Message-ID: <20131029120225.GA7786@localhost>
References: <20131028134233.GZ13405@imap.eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel <netfilter-devel@vger.kernel.org>,
	Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58716 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093Ab3J2MCf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Oct 2013 08:02:35 -0400
Content-Disposition: inline
In-Reply-To: <20131028134233.GZ13405@imap.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 28, 2013 at 02:42:33PM +0100, Holger Eitzenberger wrote:
> Hi Pablo,
> 
> Florian reported a regression when using the --queue-bypass with v3 of
> the target.
> 
> Regression is in since 8746ddcf12bb26 ("netfilter: xt_NFQUEUE:
> introduce CPU fanout").
> 
> The attached patch fixes that for me.

Applied, thanks Holger.
