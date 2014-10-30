From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2] src: add redirect support
Date: Thu, 30 Oct 2014 17:25:20 +0100
Message-ID: <20141030162520.GA2074@salvia>
References: <20141016104056.8678.71075.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33021 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758415AbaJ3QXn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:23:43 -0400
Content-Disposition: inline
In-Reply-To: <20141016104056.8678.71075.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 16, 2014 at 12:41:19PM +0200, Arturo Borrero Gonzalez wrote:
> This patch adds redirect support for nft.
> 
> The syntax is:
> 
>  % nft add rule nat prerouting redirect [port|nat_flags]

I prefer if you add a couple of valid examples to the patch
description. This won't work as the protocol is not specified.

There's also some minor issues with this patch:

% nft add rule nat prerouting redirect
Memory allocation failure

Please, address and resubmit, thanks Arturo.
