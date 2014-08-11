From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nft-arp: remove wrong conditions
Date: Mon, 11 Aug 2014 18:44:41 +0200
Message-ID: <20140811164441.GA8422@salvia>
References: <1407539057-4781-1-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37609 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100AbaHKQoT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Aug 2014 12:44:19 -0400
Content-Disposition: inline
In-Reply-To: <1407539057-4781-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Aug 09, 2014 at 01:04:17AM +0200, Giuseppe Longo wrote:
> Removes wrong conditions in flags translating functions
> that doesn't permit to delete rule with inverse flags set.
> 
> For instance, the following command doesn't remove the rule:
> arptables-compat -D INPUT -i ! eth1 -j ACCEPT

Applied, thanks.

There's another bug in arptables-compat:

arptables: Bad rule (does a matching rule exist in that chain?)

It doesn't say that if you try to delete an unexistent rule.

Please, have a look at it and fix it, thanks.

