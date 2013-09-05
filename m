From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables tool v2 PATCH 2/4] src: Ensure given base chain type
 is a valid one
Date: Thu, 5 Sep 2013 11:03:30 +0200
Message-ID: <20130905090330.GA5349@localhost>
References: <1378288222-13182-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1378288222-13182-3-git-send-email-tomasz.bursztyka@linux.intel.com>
 <20130904104550.GB8768@localhost>
 <522719A2.3@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44940 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757674Ab3IEJDe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:03:34 -0400
Content-Disposition: inline
In-Reply-To: <522719A2.3@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 04, 2013 at 02:29:38PM +0300, Tomasz Bursztyka wrote:
> Hi Pablo,
> 
> >>It verifies at command line parsing that given type is "filter", "nat",
> >>>or "route".
> >The kernel will just bail out if we pass an invalid chain type.
> 
> Sure, however I thought it would be nice to avoid one useless kernel
> call. (and the error is still possible to locate at that point)

I was trying to avoid the need for updating nft if we ever have a new
chain type, but that's unlikely to happen and users get better error
reporting with this patch.

I have applied it, thanks.
