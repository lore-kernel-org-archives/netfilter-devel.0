From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2 0/3] src: trace infrastructure support
Date: Thu, 26 Nov 2015 20:53:11 +0000
Message-ID: <20151126205310.GA3993@macbook.localdomain>
References: <1448560779-28989-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39221 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbbKZUxU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Nov 2015 15:53:20 -0500
Content-Disposition: inline
In-Reply-To: <1448560779-28989-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26.11, Florian Westphal wrote:
> This is V2 of the nft trace patch set.
> 
> See the individual patches for a change vs. v1 description.
> 
> Patrick: I did a quick test w. your last public patches
> (plus a few minor changes to make it build again) and things
> seem to work fine.

Thanks, I have it running, will start making the missing adaptions now.

> What does not work correctly is decoding of vlan header.
> I think whats happening is that we cannot splice sub-byte
> sized quantities from a larger chunk.

It does work for IPv4 (version/hdrlength), but they don't cross byte
boundaries, maybe its related to that. I'll check it out.

> Other than that, things appear to work correctly.

Very nice, thanks!
