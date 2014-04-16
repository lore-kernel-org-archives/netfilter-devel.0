From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft PATCH v2 8/8] src: add events reporting
Date: Wed, 16 Apr 2014 18:52:37 +0200
Message-ID: <20140416165237.GA965@macbook.localnet>
References: <20140416164256.5952.95010.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49254 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbaDPQwl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:52:41 -0400
Content-Disposition: inline
In-Reply-To: <20140416164256.5952.95010.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 16, 2014 at 06:43:17PM +0200, Arturo Borrero Gonzalez wrote:
> This patch adds a basic events reporting option to nft.
> 
> The syntax is:
>  % nft monitor [new|destroy] [tables|chains|rules|sets|elements] [xml|json]
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
> v2: Move code to libnftnl. Allow multiple set_elem in a single event.
>     Rename functions. Rename options to [new|destroy].
>     Handle chain/table updates.

If Pablo has no further objections I'll apply your series.
