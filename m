From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 4/7] cli: Use nft_run_cmd_from_buffer()
Date: Fri, 20 Oct 2017 21:18:07 +0200
Message-ID: <20171020191807.GD1600@salvia>
References: <20171019081847.16171-1-phil@nwl.cc>
 <20171019081847.16171-5-phil@nwl.cc>
 <20171020121534.GD4068@salvia>
 <20171020171018.GH32305@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, Eric Leblond <eric@regit.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47546 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751028AbdJTTSM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2017 15:18:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C9C32C9EC4
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2017 21:18:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BA2B2DA86B
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2017 21:18:10 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171020171018.GH32305@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 20, 2017 at 07:10:18PM +0200, Phil Sutter wrote:
> On Fri, Oct 20, 2017 at 02:15:34PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Oct 19, 2017 at 10:18:44AM +0200, Phil Sutter wrote:
> > > This simplifies CLI code and allows to reduce libnftables API by not
> > > exporting nft_run().
> > > 
> > > Since nft_run_cmd_from_buffer() takes care of scanner initialization and
> > > libmnl socket passed to cli_init() is present as nft_ctx field as well,
> > > signature of cli_init() can be reduced to just take nft_ctx pointer as
> > > single argument.
> > 
> > libmnl socket is indeed in nft_ctx, but we're planning a mode that
> > allows to expose the mnl_socket for advanced handling. In that
> > scenario, nft->nf_sock will be null.
> > 
> > So I would prefer we don't do changes that we have to undo once the
> > advanced API is in place.
> 
> IMHO this doesn't contradict what the patch does. Right now we only have
> the "simple API", and the patch changes src/cli.c to use just that. CLI
> code doesn't need anything which is not fulfilled by simple API at this
> point, so I'd say changing it to use advanced API should be done when we
> implement features (e.g. transaction control) there.
> 
> What do you think?

I have no strong objection against this, I just would like we don't
lose track of the high level API, and that one will need to expose the
netlink socket. So all these calls we will end up needed the nf_sock
parameter again at some point.

I don't have any strong opinion against this, just an observation.
