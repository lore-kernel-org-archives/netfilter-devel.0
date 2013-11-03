From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH v2] src: add fprintf API functions
Date: Sun, 3 Nov 2013 22:14:08 +0100
Message-ID: <20131103211408.GB9532@localhost>
References: <20131029224201.16047.1806.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40392 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166Ab3KCVOM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Nov 2013 16:14:12 -0500
Content-Disposition: inline
In-Reply-To: <20131029224201.16047.1806.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 29, 2013 at 11:44:25PM +0100, Arturo Borrero Gonzalez wrote:
> Now it's possible to print directly from libnftables to a file or other stream.
> In order to don't force any format, the caller must print any trailing '\n'.
> 
> The error reporting of fprintf (< 0) is respected.

Applied, thanks.
