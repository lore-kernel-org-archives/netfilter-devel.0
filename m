From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC][PATCH] nftables: add slash to chain syntax
Date: Wed, 4 Dec 2013 15:05:47 +0100
Message-ID: <20131204140547.GA9643@localhost>
References: <20131130232022.GA23206@home>
 <20131130232248.GA23209@home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35394 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755768Ab3LDOFv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Dec 2013 09:05:51 -0500
Content-Disposition: inline
In-Reply-To: <20131130232248.GA23209@home>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Nov 30, 2013 at 03:22:48PM -0800, Phil Oester wrote:
> <v2: attach the patch this time...>
> 
> The current syntax when handling chains seems counterintuitive to me.  I would
> expect that "add chain" would have the name of the chain directly after the
> keyword "chain".  But instead, the name of the table is there, with the chain
> after.  I think a better syntax might be this:
> 
>         add chain <table>/<chain>

Frankly, I prefer to leave the syntax as is in that regard.

But there are a couple of syntax aspect that would be worth discussing
before this is set in stone, eg. the `=>' in verdict maps.

The > symbol in the bash shell, if not escaped, results in a
redirection. We could replace it by ':', so the maps will look like:

add rule ip filter OUTPUT tcp dport vmap { \
        22 : jump chain1, \
        23 : jump chain2, \
}

Just in case we consider it worth to make it easier to run nft
commands from the bash shell.
