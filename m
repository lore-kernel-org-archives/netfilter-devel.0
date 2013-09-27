From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 2/2] src: snprintf: fix buffer lengths
Date: Fri, 27 Sep 2013 16:06:29 +0200
Message-ID: <20130927140629.GB10107@localhost>
References: <20130925221302.16997.17406.stgit@nfdev.cica.es>
 <20130925221308.16997.11502.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43765 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475Ab3I0OGe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:06:34 -0400
Content-Disposition: inline
In-Reply-To: <20130925221308.16997.11502.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 26, 2013 at 12:13:08AM +0200, Arturo Borrero Gonzalez wrote:
> Use 'len' instead of 'size' as length of the buffer to print.

Applied, thanks.

> While at it, fix invalid JSON offset in snprintf for sets and some
> other minor style issues, such as bad indentations.

I prefer separated patches to address each issue. Please, do so next
time.
