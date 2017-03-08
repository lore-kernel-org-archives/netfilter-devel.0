From: Phil Sutter <phil@nwl.cc>
Subject: Re: [iptables PATCH] extensions: libxt_conntrack: Fix 'state'
 translation to nft
Date: Wed, 8 Mar 2017 15:02:23 +0100
Message-ID: <20170308140223.GC6028@orbyte.nwl.cc>
References: <20170307153507.14640-1-phil@nwl.cc>
 <20170307161729.GA2233@salvia>
 <20170307162055.GA4753@salvia>
 <20170307165409.GB19869@orbyte.nwl.cc>
 <20170307193158.GA19663@salvia>
 <20170307200745.GC19869@orbyte.nwl.cc>
 <20170308103652.GA3800@salvia>
 <20170308123151.GA6028@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:57361 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752867AbdCHODQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Mar 2017 09:03:16 -0500
Content-Disposition: inline
In-Reply-To: <20170308123151.GA6028@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 08, 2017 at 01:31:51PM +0100, Phil Sutter wrote:
> Oh man, I just found the cause: I was running iptables-translate as
> unprivileged user. Calling it with sudo magically makes everything work.
> 
> I'll have a look whether it's possible to communicate the received
> -EPERM back to the user.

I wonder how iptables should deal with this situation - in a regular
use-case, I guess the program will abort eventually anyway but for
iptables-translate it shouldn't really matter. So do you think it's OK
to make nft_compatible_revision() return 0 if it made it past
mnl_cb_run() and errno is EPERM?

Ideally it should warn as well, of course.

Cheers, Phil
