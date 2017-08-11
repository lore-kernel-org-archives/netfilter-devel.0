From: Phil Sutter <phil@nwl.cc>
Subject: Re: RFC: Synopsis syntax change in nft.8
Date: Fri, 11 Aug 2017 09:41:23 +0200
Message-ID: <20170811074123.GL16375@orbyte.nwl.cc>
References: <20170810182932.GJ16375@orbyte.nwl.cc>
 <20170810215503.GA23403@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:35979 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751521AbdHKHlY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Aug 2017 03:41:24 -0400
Content-Disposition: inline
In-Reply-To: <20170810215503.GA23403@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 10, 2017 at 11:55:03PM +0200, Florian Westphal wrote:
> FWIW I am not a docbook fan so I would not mind if we switch to
> another markup system.

I'd prefer to write directly in roff as well. Doing so would also
eliminate the dependency to docbook (which I had problems with when
packaging for RHEL).

Pablo, any last word on this? :)

Thanks, Phil
