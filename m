From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ebtables-compat-experimental5 PATCH] ebtables-compat: include
 /etc/ethertypes in tarball
Date: Mon, 17 Nov 2014 12:59:35 +0100
Message-ID: <20141117115935.GB14098@salvia>
References: <20141114220753.32270.2521.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47843 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbaKQL5d (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2014 06:57:33 -0500
Content-Disposition: inline
In-Reply-To: <20141114220753.32270.2521.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 14, 2014 at 11:08:37PM +0100, Arturo Borrero Gonzalez wrote:
> The /etc/ethertypes file was originally distributed by the ebtables tarball.
> So, let's include the file also in ebtables-compat, so users can keep using
> protocol names instead of the hex code.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
> NOTE: Should I create a make target to install the file with `make install'?

Yes, please do so.

Make sure this only happens if ENABLE_NFTABLES is set.
