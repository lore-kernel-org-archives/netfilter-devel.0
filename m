From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] utils: nft_fprintf: prevent an empty buffer
 from being printed
Date: Tue, 16 Sep 2014 19:30:45 +0200
Message-ID: <20140916173045.GB21918@salvia>
References: <20140912194125.9222.51509.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57258 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000AbaIPR3p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Sep 2014 13:29:45 -0400
Content-Disposition: inline
In-Reply-To: <20140912194125.9222.51509.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 12, 2014 at 09:41:25PM +0200, Arturo Borrero Gonzalez wrote:
> If the snprintf_cb() printed 0 characters, no \0 exists in the buffer.
> Also, in that case fprintf() is meant to print nothing, so we can just exit.
> 
> This patch addresses new cases of textual output by libnftnl with trash.

Also applied, thanks.

