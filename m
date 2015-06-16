From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] parser_bison: allow to use mark as datatype for maps
 and sets
Date: Tue, 16 Jun 2015 17:49:24 +0200
Message-ID: <20150616154924.GL20951@acer.localdomain>
References: <1434469933-6402-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, exa.exa@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56406 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbbFPPt1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2015 11:49:27 -0400
Content-Disposition: inline
In-Reply-To: <1434469933-6402-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16.06, Pablo Neira Ayuso wrote:
> Update the grammar to accept a MARK token as datatype.
> 
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1012
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> @Patrick: I think you prefer this update rather than renaming this to
> packetmark. This comes in response to this patch proposal:
> http://patchwork.ozlabs.org/patch/485058/

Yes, I think this is preferrable since the mark type can be used for
things besides packet marking, f.i. conntracks.
