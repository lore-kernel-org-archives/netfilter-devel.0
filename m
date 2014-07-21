From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 2/2] monitor: fix how rules with intervals are printed
Date: Mon, 21 Jul 2014 14:21:52 +0200
Message-ID: <20140721122152.GB4908@salvia>
References: <20140714115646.10384.69637.stgit@nfdev.cica.es>
 <20140714115651.10384.23718.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55751 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754216AbaGUMVt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:21:49 -0400
Content-Disposition: inline
In-Reply-To: <20140714115651.10384.23718.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 14, 2014 at 01:56:52PM +0200, Arturo Borrero Gonzalez wrote:
> Previous to this patch, if we add a rule like this:
>  nft add rule filter test ip saddr { 1.1.1.1-2.2.2.2 }
> 
> The monitor operation output shows:
>  add rule ip filter test ip saddr { 0.0.0.0, 1.1.1.1, 2.2.2.3}
> 
> The fix suggested by Pablo is to call interval_map_decompose().

Also applied, thanks.
