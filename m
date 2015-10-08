From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] rule: fix printing of rule comments
Date: Thu, 8 Oct 2015 18:18:05 +0200
Message-ID: <20151008161805.GA4330@salvia>
References: <20151008092724.23737.63936.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <aborrero@cica.es>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41084 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756805AbbJHQLJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Oct 2015 12:11:09 -0400
Content-Disposition: inline
In-Reply-To: <20151008092724.23737.63936.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 08, 2015 at 11:27:24AM +0200, Arturo Borrero Gonzalez wrote:
> From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> 
> Several fixes:
>  * handles are printed last
>  * simplify space games (an extra space was being printed)
>  * comments are shown with `nft monitor' as well (missing before this patch)

Applied, thanks Arturo!
