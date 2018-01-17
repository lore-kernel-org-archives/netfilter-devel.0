From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH RFC] libnftables: Implement JSON output support
Date: Wed, 17 Jan 2018 18:52:13 +0100
Message-ID: <20180117175212.GB25722@orbyte.nwl.cc>
References: <20180117125026.dnxtfybrcgoio72i@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:50254 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753823AbeAQRwO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Jan 2018 12:52:14 -0500
Content-Disposition: inline
In-Reply-To: <20180117125026.dnxtfybrcgoio72i@salvia>
 <20180117124406.lil7vr2ypmpkhp5d@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Wed, Jan 17, 2018 at 01:44:06PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Jan 17, 2018 at 12:51:40PM +0100, Phil Sutter wrote:
> > Although technically there already is support for JSON output via 'nft
> > export json' command, it is hardly useable since it exports all the gory
> > details of nftables VM. Also, libnftables has no control over what is
> > exported since the content comes directly from libnftnl.
> 
> I'm going to apply this:
> 
>         http://patchwork.ozlabs.org/patch/844762/
> 
> now that nft 0.8.1 is out. Basically, renaming 'nft export json' to
> 'nft export vm json' so this clearly shows this is the low-level
> representation, and we leave room for your high level json
> representation.

Ah, I had forgotten about that. Good news! :)

> > Instead, implement JSON format support for regular 'nft list' commands.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> > Note that this is incomplete and merely meant as foundation for a
> > discussion about the implementation. A few things I am not happy with:
> > 
> > * The amount of ifdef's introduced is certainly not optimal, though I
> >   don't see how this could be avoided if JSON support is to be kept
> >   optional.
> 
> Usual trick is to add a header file with function declaration like this:
> 
> #ifdef NFT_JSON
> int nft_json_parse_blah(...);
> #else
> static inline int nft_json_parse_blah(...) { return -1; }
> #endif
> 
> So all ifdef pollution remains only in that json header file. And
> place all json code in a single .c file.

OK, I'll try that approach. What do you think about the introduced
callbacks in structs datatype, expr_ops, etc.? Note that I can't branch
to json printers from regular print callback easily since that doesn't
return anything and (I guess) the full JSON tree needs to be built
before being printed (unless I implement everything manually, which is
probably not optimal, either).

> > * There is quite some code-duplication involved given that this
> >   introduces an alternative function for almost any function in the
> >   affected code path.
> 
> You mean, a new callback for each expr/datatype? We should not expose
> bitwise/byteorder and such, it's too low level.

With "affected code path" I meant functions being called for any 'nft
list' command. It is easily possible to control how low-level JSON
output will be.

> > * JSON output is completely numeric. While this is intentional as it
> >   helps applications parsing e.g. port numbers, other things like e.g.
> >   TCP header flags become a bit cryptic.
> 
> Can't we have list in json too?

Sorry, I don't get that?

On Wed, Jan 17, 2018 at 01:50:26PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Jan 17, 2018 at 01:44:06PM +0100, Pablo Neira Ayuso wrote:
> > On Wed, Jan 17, 2018 at 12:51:40PM +0100, Phil Sutter wrote:
> [...]
> > 
> > > * There is quite some code-duplication involved given that this
> > >   introduces an alternative function for almost any function in the
> > >   affected code path.
> > 
> > You mean, a new callback for each expr/datatype? We should not expose
> > bitwise/byteorder and such, it's too low level.
> 
> I'd rather see you map the abstract syntax tree that is represented
> through parser_bison.y to your json representation. I think this patch
> is mapping the tree that we obtain after the evaluation phase, which
> comes with low level expressions such as bitwise/byteorder.

I don't get your point here, either: Not sure what this has to do with
parser_bison.y - my patch handles output only for now, I didn't bother
with input yet. Or am I on the completely wrong track now?

Thanks for the quick reply though,

Phil
