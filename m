From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2 8/8] src: add events reporting
Date: Wed, 16 Apr 2014 19:58:48 +0200
Message-ID: <20140416175848.GA4506@localhost>
References: <20140416164256.5952.95010.stgit@nfdev.cica.es>
 <20140416165237.GA965@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49318 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295AbaDPR64 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Apr 2014 13:58:56 -0400
Content-Disposition: inline
In-Reply-To: <20140416165237.GA965@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 16, 2014 at 06:52:37PM +0200, Patrick McHardy wrote:
> On Wed, Apr 16, 2014 at 06:43:17PM +0200, Arturo Borrero Gonzalez wrote:
> > This patch adds a basic events reporting option to nft.
> > 
> > The syntax is:
> >  % nft monitor [new|destroy] [tables|chains|rules|sets|elements] [xml|json]
> > 
> > Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> > ---
> > v2: Move code to libnftnl. Allow multiple set_elem in a single event.
> >     Rename functions. Rename options to [new|destroy].
> >     Handle chain/table updates.
> 
> If Pablo has no further objections I'll apply your series.

This look good to me, thanks Patrick and Arturo!
