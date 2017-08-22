From: Phil Sutter <phil@nwl.cc>
Subject: Re: [PATH nft v2 15/18] libnftables: set max_errors to 1 in library
Date: Tue, 22 Aug 2017 17:04:35 +0200
Message-ID: <20170822150435.GB15994@orbyte.nwl.cc>
References: <20170819152420.22563-1-eric@regit.org>
 <20170819152420.22563-16-eric@regit.org>
 <20170821083746.GI2982@salvia>
 <1503342769.9868.9.camel@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:56573 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932329AbdHVPEh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Aug 2017 11:04:37 -0400
Content-Disposition: inline
In-Reply-To: <1503342769.9868.9.camel@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Mon, Aug 21, 2017 at 09:12:49PM +0200, Eric Leblond wrote:
> On Mon, 2017-08-21 at 10:37 +0200, Pablo Neira Ayuso wrote:
> > On Sat, Aug 19, 2017 at 05:24:17PM +0200, Eric Leblond wrote:
[...]
> > I remember you mentioned there's a problem with memory in the parser.
> > I would help to fix this, I'd appreciate if you can describe the
> > problem so we can address it here.
> 
> Here it my understanding: the max_errors system is causing the parser
> to continue instead of failing or finishing. As a result the internal
> memory releasing functions of bison are not called due to the
> intermediate state. At the end, in case of task with n errors, all 0
> ... n-1 state are left unfreed when the parsing is finished.

I'm currently trying to reproduce the issue by calling 'nft -f' with a
rule set file containing a number of errors, but somehow valgrind
doesn't show differences between max_errors of 1 and 10. Do you have a
test case or some instructions how to trigger the problem?

Thanks, Phil
