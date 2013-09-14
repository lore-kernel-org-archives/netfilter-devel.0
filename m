From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nftables 3/3] log: s/threshold/queue-threshold/
Date: Sat, 14 Sep 2013 21:10:39 +0200
Message-ID: <20130914191039.GC13409@localhost>
References: <1379083488-20752-1-git-send-email-fw@strlen.de>
 <1379083488-20752-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48393 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932323Ab3INTKo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Sep 2013 15:10:44 -0400
Content-Disposition: inline
In-Reply-To: <1379083488-20752-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 13, 2013 at 04:44:48PM +0200, Florian Westphal wrote:
> on input we expect "queue-threshold" token, so use the same
> name when printing the output.

Applied, thanks.
