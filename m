From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 1/2] src: add _unset functions
Date: Thu, 6 Jun 2013 12:15:08 +0200
Message-ID: <20130606101508.GA5947@localhost>
References: <20130605213713.11415.64106.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, giuseppelng@gmail.com
To: Arturo Borrero <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36468 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034Ab3FFKPT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Jun 2013 06:15:19 -0400
Content-Disposition: inline
In-Reply-To: <20130605213713.11415.64106.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

On Wed, Jun 05, 2013 at 11:37:13PM +0200, Arturo Borrero wrote:
> These functions unset the flag for the given attribute in each object and free data in some cases.
> 
> About the xor op, other option was:
> 
> 	if (x->flags & (1 << attr))
> 		x->flags ^= (1 << attr);

To unset, use:

x->flags &= ~(1 << attr)

Regards.
