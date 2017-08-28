From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 1/2] nft.8: Fix and enhance synopsis section
Date: Mon, 28 Aug 2017 18:58:53 +0200
Message-ID: <20170828165853.GB21786@salvia>
References: <20170817133900.21946-1-phil@nwl.cc>
 <20170817133900.21946-2-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:38388 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751309AbdH1Q7R (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Aug 2017 12:59:17 -0400
Content-Disposition: inline
In-Reply-To: <20170817133900.21946-2-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 17, 2017 at 03:38:59PM +0200, Phil Sutter wrote:
> This patch addresses shortcomings in the main synopsis section
> illustrating possible invocations of nft command:
> 
> - Fix font styles to correctly put options into bold font and meta
>   characters (brackets, pipes) into normal font.
> 
> - Add missing options to synopsis line.
> 
> - Use curly braces where either one of the alternatives is required.
> 
> - Remove choice="opt" attribute since that is the default anyway.
> 
> - Note that --includepath option is allowed to be given multiple times.

I'm going to apply this.

I'm undecided with 2/2, I don't remember to have seen such
indirections in other manpages?

Thanks.
