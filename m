From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2] netfilter: ip6t_NPT: Fix translation for non-multiple
 of 32 prefix lengths
Date: Wed, 3 Apr 2013 12:21:28 +0200
Message-ID: <20130403102128.GA4224@localhost>
References: <bba4b68de747f6d3d580232a15592f6ba0fc6722.1364673589.git.mschiffer@universe-factory.net>
 <cf3234de124418a6954f079e473c3e01ea96952f.1364674922.git.mschiffer@universe-factory.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Matthias Schiffer <mschiffer@universe-factory.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53144 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757409Ab3DCKW2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Apr 2013 06:22:28 -0400
Content-Disposition: inline
In-Reply-To: <cf3234de124418a6954f079e473c3e01ea96952f.1364674922.git.mschiffer@universe-factory.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 30, 2013 at 09:23:12PM +0100, Matthias Schiffer wrote:
> The bitmask used for the prefix mangling was being calculated incorrectly,
> leading to the wrong part of the address being replaced when the prefix length
> wasn't a multiple of 32.

Applied, thanks Matthias.

> Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>
> ---
> Hi, this patch should to 3.9 and, if possible, 3.8-stable.

Will do.
