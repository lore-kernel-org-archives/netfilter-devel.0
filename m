From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH 4/7] cli: Use nft_run_cmd_from_buffer()
Date: Fri, 20 Oct 2017 19:10:18 +0200
Message-ID: <20171020171018.GH32305@orbyte.nwl.cc>
References: <20171019081847.16171-1-phil@nwl.cc>
 <20171019081847.16171-5-phil@nwl.cc>
 <20171020121534.GD4068@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:53328 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753006AbdJTRKV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2017 13:10:21 -0400
Content-Disposition: inline
In-Reply-To: <20171020121534.GD4068@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 20, 2017 at 02:15:34PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Oct 19, 2017 at 10:18:44AM +0200, Phil Sutter wrote:
> > This simplifies CLI code and allows to reduce libnftables API by not
> > exporting nft_run().
> > 
> > Since nft_run_cmd_from_buffer() takes care of scanner initialization and
> > libmnl socket passed to cli_init() is present as nft_ctx field as well,
> > signature of cli_init() can be reduced to just take nft_ctx pointer as
> > single argument.
> 
> libmnl socket is indeed in nft_ctx, but we're planning a mode that
> allows to expose the mnl_socket for advanced handling. In that
> scenario, nft->nf_sock will be null.
> 
> So I would prefer we don't do changes that we have to undo once the
> advanced API is in place.

IMHO this doesn't contradict what the patch does. Right now we only have
the "simple API", and the patch changes src/cli.c to use just that. CLI
code doesn't need anything which is not fulfilled by simple API at this
point, so I'd say changing it to use advanced API should be done when we
implement features (e.g. transaction control) there.

What do you think?

Cheers, Phil
