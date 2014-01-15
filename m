From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] tests: xml: delete comments
Date: Wed, 15 Jan 2014 14:12:14 +0100
Message-ID: <20140115131214.GA22148@localhost>
References: <20140115111218.25584.60794.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54302 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbaAONMT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 08:12:19 -0500
Content-Disposition: inline
In-Reply-To: <20140115111218.25584.60794.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 15, 2014 at 12:12:18PM +0100, Arturo Borrero Gonzalez wrote:
> In libmxml > 2.6, comments are not ignored when building the XML tree,
> so these comments produce errors and test fail.

Doesn't have libmxml any way to accept comments?

> Delete the comment lines, so parsing test pass with libmxml 2.7 and 2.8.
> 
> By now, this is the only issue I found when working with libmxml > 2.6.

Kevin mentioned a different error, please investigate it. Thanks.
