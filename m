From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH RFC 2/2] nft.8: Make use of synopfragment in synopsis
 section
Date: Mon, 28 Aug 2017 18:58:01 +0200
Message-ID: <20170828165801.GA21786@salvia>
References: <20170817133900.21946-1-phil@nwl.cc>
 <20170817133900.21946-3-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:38373 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751825AbdH1Q60 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Aug 2017 12:58:26 -0400
Content-Disposition: inline
In-Reply-To: <20170817133900.21946-3-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 17, 2017 at 03:39:00PM +0200, Phil Sutter wrote:
> This introduces an element of indirection to list common options in
> a separate place and allows to put each of the three invocation variants
> onto it's own line.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> While I think readability has increased quite a bit, I don't like how
> docbook formats these references: Having a name at the reference point
> but not at the target is kind of unintuitive.

Feel free to send a patch to convert this to use a more orthodox
markup language for manpages.
