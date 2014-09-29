From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 3/3 v3] src: add list ruleset command
Date: Mon, 29 Sep 2014 12:38:52 +0200
Message-ID: <20140929103852.GC16284@salvia>
References: <1411749008-924-1-git-send-email-arturo.borrero.glez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47061 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbaI2Khj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Sep 2014 06:37:39 -0400
Content-Disposition: inline
In-Reply-To: <1411749008-924-1-git-send-email-arturo.borrero.glez@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 26, 2014 at 06:30:08PM +0200, Arturo Borrero Gonzalez wrote:
> This patch adds a new command to nft:
> 	% nft list ruleset [family]
> 
> Which list the entire ruleset.
> If no family is specified, all tables of all families are listed.
> 
> Users can now make several operations at ruleset level:
> 
>  % nft list ruleset > ruleset.nft
>  % nft -f ruleset.nft
>  % nft flush ruleset

Applied, thanks Arturo.

