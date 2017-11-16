From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH v3] libnftables: Unexport enum nftables_exit_codes
Date: Thu, 16 Nov 2017 14:48:12 +0100
Message-ID: <20171116134812.GI32305@orbyte.nwl.cc>
References: <20171113123837.GZ32305@orbyte.nwl.cc>
 <20171113140816.17830-1-phil@nwl.cc>
 <20171116133332.GB2455@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:60374 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750738AbdKPNsO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Nov 2017 08:48:14 -0500
Content-Disposition: inline
In-Reply-To: <20171116133332.GB2455@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Thu, Nov 16, 2017 at 02:33:32PM +0100, Pablo Neira Ayuso wrote:
> On Mon, Nov 13, 2017 at 03:08:16PM +0100, Phil Sutter wrote:
> > Apart from SUCCESS/FAILURE, these codes were not used by library
> > functions simply because NOMEM and NONL conditions lead to calling
> > exit() instead of propagating the error condition back up the call
> > stack.
> > 
> > Instead, make nft_run_cmd_from_*() return either 0 or -1 on error.
> > Usually errno will then contain more details about what happened and/or
> > there are messages in erec.
> > 
> > Calls to exit()/return in main() are adjusted to stay compatible.
> 
> Also applied, thanks.
> 
> BTW, I think you mentioned you planned to change all
> memory_allocation_error() to pass up the error to the client
> application.
> 
> Let me know, if you don't have time for this, no worries if too busy.

I looked into it once, but didn't pursue much further. This requires
some effort, since code everywhere just assumes (e.g.) memory allocation
to succeed so there is no error path at all in many places.

OTOH, I wasn't sure whether adding this is feasible at all - if memory
allocation fails, we're usually in big trouble and error propagation
might not work anymore as well (e.g. allocation of erec items). Sure,
bugs like 'malloc(-1)' would be handled properly, of course.

Not sure about netlink errors: Ideally, the library would check this
early (e.g. during context allocation), but of course syscalls like
socket() could still fail later.

Cheers, Phil
