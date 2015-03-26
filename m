From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/6] netfilter: set extensions
Date: Thu, 26 Mar 2015 12:06:48 +0100
Message-ID: <20150326110648.GA3734@salvia>
References: <1427288870-26336-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>, g@salvia
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46918 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213AbbCZLC5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2015 07:02:57 -0400
Content-Disposition: inline
In-Reply-To: <1427288870-26336-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 25, 2015 at 01:07:44PM +0000, Patrick McHardy wrote:
> The following patches add so called "set extensions" to maintain optional
> per element data for nft sets and converts nf_tables to use them.
> 
> Following patches will use these set extensions to add some features from
> ipset which we are currently missing, namely timeouts and comments, as
> well as set transactions, variable sized data for concatenations and
> per-flow expressions. I'll send the next batch as soon as these have been
> merged.
> 
> Please apply, thanks!

Applied, thanks Patrick!
