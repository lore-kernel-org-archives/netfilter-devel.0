From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v2 00/18] introducing libnftables
Date: Thu, 31 Aug 2017 12:19:47 +0200
Message-ID: <20170831101947.GA13113@salvia>
References: <20170819152420.22563-1-eric@regit.org>
 <20170830103132.GG20614@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, Eric Leblond <eric@regit.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:37057 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751355AbdHaKUM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Aug 2017 06:20:12 -0400
Content-Disposition: inline
In-Reply-To: <20170830103132.GG20614@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 30, 2017 at 12:31:32PM +0200, Phil Sutter wrote:
> Hi,
> 
> On Sat, Aug 19, 2017 at 05:24:02PM +0200, Eric Leblond wrote:
> > This patchset is the second version of libnftables introduction patchset.
> > It addresses some remarks by Phil Sutter. Other remarks as said on the ML
> > are in fact TODO points that can be adressed later.
> 
> So, what is the current status, please? Could we perhaps collect open
> points and clarify who's working on what?
> 
> From the top of my head, open points are:
> 
> * Where to keep nf_sock:
>   - Either completely separate (needs init/deinit routines for
>     convenience).
>   - Or as part of nft_ctx (needs getter/setter for advanced usage).

Eric needs the simple API for non-netlink users, we can add an
explicit call like this:

        err = nft_ctx_netlink_open(ctx);

Then, we call:

        nft_run_cmd_from_buffer(ctx, ...);

with no nf_sock as parameter.

Please, don't update the code all over the place to pass nft->nf_sock
to lower layers, just update nft_run_cmd_from_buffer() function not to
take nf_sock explicitly.

So we make sure we don't have to undo things to reuse code when adding
the advanced API later on. The advanced API will expose netlink
details indeed, so it will not ever call nft_ctx_netlink_open().

> * Do we want global init/deinit functions, or can we put everything into
>   context init/deinit functions?

No, we agreed this is now done from ctx allocation/release.

> * How to handle object printing:
>   - Having a library print to stdout is probably not desired.
>   - Is formatting into a string for further processing by the
>     application sufficient?

I would prefer strict typing in APIs, so we restrict/know what people
are going to do with them.

Having a second look at what Eric sent, I was wrong, we can use void *ctx.
However, I would prefer we have APIs for each kind of thing that people
would need, ie. one API for file descriptor printing and another for
buffer printing with specific typing, not void * for this.

There is no comments so far on how we can integrate the monitor mode
with this simple API. Even if this is not done now, I would like we
have something in mind.

More side comments:

* Eric also mentioned about json. It should be easy to add this since
  json representation is already there in the parser, we would only
  need to expose the high level nft abstract syntax tree in json
  format.

* Eric already clarified a problem with set concatenations, but I'm
  still not sure / don't understand what the problem is.
