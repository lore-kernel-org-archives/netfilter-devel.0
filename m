From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] build: fix build error
Date: Mon, 16 Sep 2013 22:44:32 +0200
Message-ID: <20130916204432.GB11246@localhost>
References: <20130916182034.6685.68337.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41704 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab3IPUoh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Sep 2013 16:44:37 -0400
Content-Disposition: inline
In-Reply-To: <20130916182034.6685.68337.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 16, 2013 at 08:20:34PM +0200, Arturo Borrero Gonzalez wrote:
> This declaration was missing and is needed in case you compile libnftables
> without XML parsing support.

Applied, thanks.
