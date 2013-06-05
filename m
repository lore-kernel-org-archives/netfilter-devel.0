From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH v3] src: xml: add versioning
Date: Wed, 5 Jun 2013 05:30:09 +0200
Message-ID: <20130605033009.GA24974@localhost>
References: <20130603155815.19094.29178.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60408 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808Ab3FEDaR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Jun 2013 23:30:17 -0400
Content-Disposition: inline
In-Reply-To: <20130603155815.19094.29178.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 03, 2013 at 05:58:38PM +0200, Arturo Borrero wrote:
> All XML chunks now have a "version" attribute to help in future changes.

Not sure this is the best approach after reading this:

http://stackoverflow.com/questions/2014237/what-are-the-best-practices-for-versioning-xml-schemas

Can you give it some read and get back to me with more feedback
regarding the XML versioning approaches?

Thanks.
