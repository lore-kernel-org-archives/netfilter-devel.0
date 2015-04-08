From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] monitor: fix missing space after chain name
Date: Wed, 8 Apr 2015 19:06:45 +0200
Message-ID: <20150408170645.GA26356@salvia>
References: <20150407150514.1615.70626.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48800 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932305AbbDHRCf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Apr 2015 13:02:35 -0400
Content-Disposition: inline
In-Reply-To: <20150407150514.1615.70626.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 07, 2015 at 05:05:14PM +0200, Arturo Borrero Gonzalez wrote:
> Due to change f3ff9e9 ("rule: delete extra space in rule indentation") in
> function rule_print(), a missing space happens in monitor.
> 
> before this patch:
>  % nft monitor
>  add rule ip test-table test-chainip protocol tcp
> 
> after this patch:
>  % nft monitor
>  add rule ip test-table test-chain ip protocol tcp

Applied, thanks Arturo.
