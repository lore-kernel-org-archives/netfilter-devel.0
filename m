From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] xml: expr: limit: fix wrong assignation when
 parsing
Date: Mon, 12 Aug 2013 11:35:41 +0200
Message-ID: <20130812093541.GA6546@localhost>
References: <20130812073523.20663.74939.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58664 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753274Ab3HLJfp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Aug 2013 05:35:45 -0400
Content-Disposition: inline
In-Reply-To: <20130812073523.20663.74939.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 12, 2013 at 09:35:23AM +0200, Arturo Borrero Gonzalez wrote:
> This assignation was wrong.
> 
> Introduced at commit e13819c
> (src: xml: consolidate common XML code via nft_mxml_num_parse).

Applied, thanks.
