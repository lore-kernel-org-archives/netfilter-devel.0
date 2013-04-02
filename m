From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] src: get and set NFT_*_ATTR_FAMILY
Date: Tue, 2 Apr 2013 13:35:26 +0200
Message-ID: <20130402113526.GB9973@localhost>
References: <20130331011519.15604.62461.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46247 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756204Ab3DBLiF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:38:05 -0400
Content-Disposition: inline
In-Reply-To: <20130331011519.15604.62461.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Mar 31, 2013 at 03:15:19AM +0200, Arturo Borrero wrote:
> This patch adds support to get and set the attribute NFT_{TABLE|CHAIN|RULE}_ATTR_FAMILY easily.
> 
> I found this very useful when parsing a XML table|chain|rule (future patch).

Applied, thanks Arturo.
