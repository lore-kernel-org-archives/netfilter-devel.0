From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ebtables-compat PATCH 1/2] ebtables-compat: add watchers support
Date: Wed, 11 Feb 2015 16:16:29 +0100
Message-ID: <20150211151629.GA5217@salvia>
References: <20150209121612.13393.90335.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, giuseppelng@gmail.com
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36154 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388AbbBKPNP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2015 10:13:15 -0500
Content-Disposition: inline
In-Reply-To: <20150209121612.13393.90335.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 09, 2015 at 01:16:12PM +0100, Arturo Borrero Gonzalez wrote:
> ebtables watchers are targets which always return EBT_CONTINUE.

Patch 1/2 and 2/2 applied, thanks.

I'm going to merge the ebtables-compat branch to master, so we can
include this in the next release.
