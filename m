From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC ebtables-compat PATCH v2] extensions: add ebt 802_3
 extension
Date: Tue, 23 Dec 2014 14:30:48 +0100
Message-ID: <20141223133048.GB15431@salvia>
References: <20141217110642.31635.84255.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, giuseppelng@gmail.com
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34034 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbaLWN2O (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Dec 2014 08:28:14 -0500
Content-Disposition: inline
In-Reply-To: <20141217110642.31635.84255.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 17, 2014 at 12:06:56PM +0100, Arturo Borrero Gonzalez wrote:
> This patch adds the first ebtables extension to ebtables-compat.
> The original 802_3 code is adapted to the xtables environment.
> 
> I tried to mimic as much as possible the original ebtables code paths.
> 
> With this patch, ebtables-compat is able to send the 802_3 match to the kernel,
> but the kernel-to-userspace path is not tested and should be adjusted
> in follow-up patches.

Applied this to the ebtables-compat-experimental branch, just to make
it easier for you in case you have the chance to give this another
spin.

I'm aware the kernel bits for nft_compat are still missing (it would
bre great to get those scheduled for 3.20).

Thanks.
