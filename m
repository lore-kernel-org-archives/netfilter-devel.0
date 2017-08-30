From: Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nft v2 00/18] introducing libnftables
Date: Wed, 30 Aug 2017 12:31:32 +0200
Message-ID: <20170830103132.GG20614@orbyte.nwl.cc>
References: <20170819152420.22563-1-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:44645 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751302AbdH3Kbd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Aug 2017 06:31:33 -0400
Content-Disposition: inline
In-Reply-To: <20170819152420.22563-1-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Sat, Aug 19, 2017 at 05:24:02PM +0200, Eric Leblond wrote:
> This patchset is the second version of libnftables introduction patchset.
> It addresses some remarks by Phil Sutter. Other remarks as said on the ML
> are in fact TODO points that can be adressed later.

So, what is the current status, please? Could we perhaps collect open
points and clarify who's working on what?

>From the top of my head, open points are:

* Where to keep nf_sock:
  - Either completely separate (needs init/deinit routines for
    convenience).
  - Or as part of nft_ctx (needs getter/setter for advanced usage).

* Do we want global init/deinit functions, or can we put everything into
  context init/deinit functions?

* How to handle object printing:
  - Having a library print to stdout is probably not desired.
  - Is formatting into a string for further processing by the
    application sufficient?

Anything else? Are there tasks which can be done now and nobody wants so
I could take over?

Cheers, Phil
