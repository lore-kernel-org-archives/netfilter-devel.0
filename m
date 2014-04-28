From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 0/8] nft event monitor
Date: Mon, 28 Apr 2014 16:28:28 +0200
Message-ID: <20140428142828.GA28770@localhost>
References: <20140414101634.5018.86819.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60249 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756294AbaD1O2p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:28:45 -0400
Content-Disposition: inline
In-Reply-To: <20140414101634.5018.86819.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 14, 2014 at 12:17:03PM +0200, Arturo Borrero Gonzalez wrote:
> The following series implements a basic nftables monitor via Netlink messages.
> 
> Most of the work in first patches is related to refactorization/generalization
> of code.
> 
> The final patch is the big one.
> 
> About the syntax, i'm proposing:
>  % nft monitor [added|deleted] [tables|chains|sets|elements|rules] [xml|json]
> 
> The straight-forward way of test this new feature is to simply run:
>  % nft monitor
> 
> Other examples:
>  * report new tables in XML format
>    % nft monitor added tables xml
>  * report deleted elements in standar nft syntax
>    % nft monitor deleted elements
>  * report all added/deleted rules in JSON format
>    % nft monitor rules json
> 
> Handling set/set_elems is one of the harders parts of event reporting.
> I've succesfully tested many cases (maps, named sets, anon-sets..), but I guess
> more tuning can be done in the future, with some additional use and testing
> by the community.

Series applied, thanks Arturo.
