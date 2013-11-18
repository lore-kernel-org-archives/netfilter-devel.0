From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] nftables: delete debian/
Date: Mon, 18 Nov 2013 14:15:21 +0100
Message-ID: <20131118131521.GA31481@localhost>
References: <20131114154438.9679.72477.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49107 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185Ab3KRNPa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Nov 2013 08:15:30 -0500
Content-Disposition: inline
In-Reply-To: <20131114154438.9679.72477.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 14, 2013 at 04:44:38PM +0100, Arturo Borrero Gonzalez wrote:
> The data there is quite old (2008-2009) and seem unmaintained.
> Some files like 'control' and 'rules' are inaccurate or completely wrong.
> 
> Also, the debian/ dir makes harder for Debian folks to build a package
> for this tool. I think its better to give them the job.
> 
> As the very first release of nftables seems to be nearer than ever, lets do
> some house-cleaning.

Indeed. I remember we already discussed this many times before with
debian devs. Applied, thanks Arturo.
