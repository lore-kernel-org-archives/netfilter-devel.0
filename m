From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/5] netfilter: nft_ct: fix missing NFT_CT_L3PROTOCOL key
 in validity checks
Date: Thu, 6 Feb 2014 00:24:02 +0100
Message-ID: <20140205232402.GB5674@localhost>
References: <1391612619-30347-1-git-send-email-kaber@trash.net>
 <1391612619-30347-3-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51355 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbaBEXY6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Feb 2014 18:24:58 -0500
Content-Disposition: inline
In-Reply-To: <1391612619-30347-3-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 05, 2014 at 03:03:36PM +0000, Patrick McHardy wrote:
> The key was missing in the list of valid keys, add it.

Also applied, thanks.
