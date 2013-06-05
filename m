From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 3/5] src: xml: set errno to EINVAL when
 invalid parsing
Date: Wed, 5 Jun 2013 05:38:06 +0200
Message-ID: <20130605033806.GA25669@localhost>
References: <20130603204451.27713.51887.stgit@nfdev.cica.es>
 <20130603204453.27713.8807.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60856 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab3FEDiK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Jun 2013 23:38:10 -0400
Content-Disposition: inline
In-Reply-To: <20130603204453.27713.8807.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 03, 2013 at 10:44:54PM +0200, Arturo Borrero wrote:
> This patch sets errno to EINVAL when the XML parsing fails due to a bad format, a missing node or something.

I like this patch but it doesn't apply cleanly without the versioning
stuff.

Since the versioning looks more tricky, can you rebase this patch upon
the current tree and resend?

Thanks.
