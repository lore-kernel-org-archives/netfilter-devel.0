From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH 7/7] libnftables: Add remaining getters and setters
Date: Fri, 20 Oct 2017 18:08:25 +0200
Message-ID: <20171020160824.GG21378@orbyte.nwl.cc>
References: <20171019081847.16171-1-phil@nwl.cc>
 <20171019081847.16171-8-phil@nwl.cc>
 <20171020121853.GF4068@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:53188 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751698AbdJTQI3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2017 12:08:29 -0400
Content-Disposition: inline
In-Reply-To: <20171020121853.GF4068@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Fri, Oct 20, 2017 at 02:18:53PM +0200, Pablo Neira Ayuso wrote:
[...]
> Oh, I see. Now these structure definitions are coming back to
> include/nftables.h. I'm telling this because of what I mentioned in
> 2/7.

I have to admit, it was quite entertaining watching you following my
series through your comments. :)

> I would prefer we avoid these goes back and forth with this code.

Yes, point taken - I will recombine the changes into more sensible
chunks.

Thanks, Phil
