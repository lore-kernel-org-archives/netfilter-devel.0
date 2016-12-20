From: Phil Sutter <phil@nwl.cc>
Subject: Re: RFC: nft.8 review
Date: Tue, 20 Dec 2016 18:21:30 +0100
Message-ID: <20161220172130.GI13857@orbyte.nwl.cc>
References: <20161210102715.GA2955@orbyte.nwl.cc>
 <20161219235330.GA7565@salvia>
 <CAChgv6pVKFz3fH5yGCA+8av84=c_2Ob25hy5AcTL=YLzw+n7Aw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: mark diener <rpzrpzrpz@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:49182 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753271AbcLTRVd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Dec 2016 12:21:33 -0500
Content-Disposition: inline
In-Reply-To: <CAChgv6pVKFz3fH5yGCA+8av84=c_2Ob25hy5AcTL=YLzw+n7Aw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Mark,

On Tue, Dec 20, 2016 at 10:27:45AM -0600, mark diener wrote:
> Will the V8 NFT have byte level protocol compatibility with current
> linux kernel versions?

We were talking about nft manpage (which happens to live in section 8,
hence why I referred to it as 'nft.8'), not some version 8 (which would
still take a while to come as we're only at version 0.6 ATM).

> I am deployed on kernel  4.4.0-53-generic and would like to know when
> structural defines like RTM_NEWADDR,NLM_F_REQUEST, etc become updated
> or obsoleted.

Not sure I understand you correctly, but why should userspace exported
constants like RTM_NEWADDR or NLM_F_REQUEST become obsolete? This would
break backwards compatibility, which is generally frowned upon.

> As you can likely tell, I am not using libmnl or libnft but using
> direct NETFILTER kernel calls.
> 
> What a challenge to scan the code and reverse-engineer the byte
> sequences and understand the way the NFT virtual machine works in the
> kernel.

Sounds like you're baking your own cake here. I'd say if you decide to
reinvent the wheel, well, then you have to invent a wheel. No? ;)

Cheers, Phil
