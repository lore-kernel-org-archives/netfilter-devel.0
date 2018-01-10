From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH] Don't merge adjacent/overlapping ranges by default
Date: Wed, 10 Jan 2018 12:57:25 +0100
Message-ID: <20180110115725.GO32305@orbyte.nwl.cc>
References: <20180110104221.3565-1-phil@nwl.cc>
 <20180110115100.z3hbazlk4w7lekga@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:58518 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934213AbeAJL50 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Jan 2018 06:57:26 -0500
Content-Disposition: inline
In-Reply-To: <20180110115100.z3hbazlk4w7lekga@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Wed, Jan 10, 2018 at 12:51:00PM +0100, Pablo Neira Ayuso wrote:
[...]
> I would disable this by default by now, no option.
> 
> Then, revisit this later on to see if it's worth adding this, thanks!

Should I drop everything that's needed to make it optional or just
remove the option from src/main.c?

Cheers, Phil
