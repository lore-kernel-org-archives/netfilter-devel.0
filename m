From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft PATCH] files: replace interpreter during installation
Date: Tue, 14 Jan 2014 15:16:21 +0000
Message-ID: <20140114151605.GA26466@macbook.localnet>
References: <20140113091623.10582.14579.stgit@nfdev.cica.es>
 <CAOj-5WAXqwd3eHD0bFNxa031pLcLWwXtHsOxeYbnJxFeUVMYUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Sam Liddicott <sam@liddicott.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35193 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbaANPQ0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jan 2014 10:16:26 -0500
Content-Disposition: inline
In-Reply-To: <CAOj-5WAXqwd3eHD0bFNxa031pLcLWwXtHsOxeYbnJxFeUVMYUA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 14, 2014 at 03:00:14PM +0000, Sam Liddicott wrote:
> I realise a solution is reached, but an alternative in common use is
> mentioned here for completeness;
> 
> #! /usr/bin/env nft -f
> 
> it is commonly used to invoke interpreters whose path is unknown but
> which can be expected to be on the PATH

I'm find either way. Unless there are arguments for not using env,
this seems like the simpler fix.
