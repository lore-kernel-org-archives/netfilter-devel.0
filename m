From: Phil Sutter <phil@nwl.cc>
Subject: Re: libnftables extended API proposal
Date: Wed, 10 Jan 2018 11:39:57 +0100
Message-ID: <20180110103957.GI14358@orbyte.nwl.cc>
References: <20171222134906.y46spklmtsxc6zj7@salvia>
 <20171222153049.GX32305@orbyte.nwl.cc>
 <20171222203903.5lq6hw3mhxupbfuk@salvia>
 <20171223131941.GY32305@orbyte.nwl.cc>
 <20171228192141.xqwd5ccmtwe4auq2@salvia>
 <20171229145816.GF32305@orbyte.nwl.cc>
 <20180102180219.6333nnbg2hgxyxrm@salvia>
 <20180105175203.GN32305@orbyte.nwl.cc>
 <20180109233126.5ma7analfbnndw5g@salvia>
 <CAChgv6raigk1r2J31km7qtRWDavMFpaKRM6LjEOuNQr6+paFoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: mark diener <rpzrpzrpz@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:58276 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753835AbeAJKj7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Jan 2018 05:39:59 -0500
Content-Disposition: inline
In-Reply-To: <CAChgv6raigk1r2J31km7qtRWDavMFpaKRM6LjEOuNQr6+paFoA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Mark,

On Tue, Jan 09, 2018 at 10:46:14PM -0600, mark diener wrote:
> Why don't you just put a JSON layer above the c-based libnftl 0.9 ?
> 
> That way, whatever is working in C-based API can then get JSON support
> and disrupt the apple cart.
> 
> Call it libnftljson-0.9.so, which is then dependent on libnftl-0.9.so
> 
> But keep the c-based api the c-based api
> and the JSON calling translater-to-c api a different optional library.

I'm not sure I follow. The reason we started working on this libnftables
in the first place was that everyone considered libnftnl way too
low-level for direct use in applications.

Are you suggesting to basically reimplement libnftables with JSON
interfacing in both directions?

Cheers, Phil
