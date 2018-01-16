From: Phil Sutter <phil@nwl.cc>
Subject: Re: [ANNOUNCE] nftables 0.8.1 release
Date: Tue, 16 Jan 2018 17:18:57 +0100
Message-ID: <20180116161857.GA25722@orbyte.nwl.cc>
References: <alpine.LSU.2.20.1801161547001.14457@n3.vanv.qr>
 <20180116145330.mpidpmwk6j7xtnyc@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@inai.de>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:47210 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751210AbeAPQTA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jan 2018 11:19:00 -0500
Content-Disposition: inline
In-Reply-To: <20180116145330.mpidpmwk6j7xtnyc@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 16, 2018 at 03:53:30PM +0100, Pablo Neira Ayuso wrote:
> On Tue, Jan 16, 2018 at 03:48:24PM +0100, Jan Engelhardt wrote:
> > 
> > >        nftables 0.8.1
> > >
> > >This release contains mostly incremental fixes and documentation 
> > >updates, such as fixing up ./configure --with-mini-gmp for embedded 
> > >setups that don't have libgmp.
> > 
> > Why is this now installing a libnftables.pc file when there is no 
> > library or headers to go with it? (Remember that libnftables.la is 
> > listed for "noinst_LTLIBRARIES".)
> 
> That sounds like a leftover when we were aiming to roll back/not to expose
> libnftables yet in this release.

Oh yes, sorry. I'll follow-up with a patch immediately.

Cheers, Phil
