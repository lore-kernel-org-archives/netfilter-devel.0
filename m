From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] immediate: xml: fix name inconsistency
Date: Thu, 25 Jul 2013 22:58:03 +0200
Message-ID: <20130725205803.GA7113@localhost>
References: <20130725205411.22962.57274.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43066 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736Ab3GYU6I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jul 2013 16:58:08 -0400
Content-Disposition: inline
In-Reply-To: <20130725205411.22962.57274.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 25, 2013 at 10:54:11PM +0200, Arturo Borrero Gonzalez wrote:
> <immdata> must be <immediatedata>.
> 
> This bug was introduced at (1e8e5d4 src: xml: consolidate parsing of
> data_reg via nft_mxml_data_reg_parse).

Also applied, thanks.
