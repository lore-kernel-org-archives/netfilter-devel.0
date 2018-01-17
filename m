From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH RFC] libnftables: Implement JSON output support
Date: Wed, 17 Jan 2018 19:56:30 +0100
Message-ID: <20180117185630.GD25722@orbyte.nwl.cc>
References: <20180117125026.dnxtfybrcgoio72i@salvia>
 <20180117124406.lil7vr2ypmpkhp5d@salvia>
 <20180117175212.GB25722@orbyte.nwl.cc>
 <20180117184504.zkeojrwxjsbswymk@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:50386 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754472AbeAQS4c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Jan 2018 13:56:32 -0500
Content-Disposition: inline
In-Reply-To: <20180117184504.zkeojrwxjsbswymk@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 17, 2018 at 07:45:04PM +0100, Pablo Neira Ayuso wrote:
[...]
> > On Wed, Jan 17, 2018 at 01:50:26PM +0100, Pablo Neira Ayuso wrote:
> > > On Wed, Jan 17, 2018 at 01:44:06PM +0100, Pablo Neira Ayuso wrote:
> > > > On Wed, Jan 17, 2018 at 12:51:40PM +0100, Phil Sutter wrote:
> > > [...]
> > > > 
> > > > > * There is quite some code-duplication involved given that this
> > > > >   introduces an alternative function for almost any function in the
> > > > >   affected code path.
> > > > 
> > > > You mean, a new callback for each expr/datatype? We should not expose
> > > > bitwise/byteorder and such, it's too low level.
> > > 
> > > I'd rather see you map the abstract syntax tree that is represented
> > > through parser_bison.y to your json representation. I think this patch
> > > is mapping the tree that we obtain after the evaluation phase, which
> > > comes with low level expressions such as bitwise/byteorder.
> > 
> > I don't get your point here, either: Not sure what this has to do with
> > parser_bison.y - my patch handles output only for now, I didn't bother
> > with input yet. Or am I on the completely wrong track now?
> 
> Sorry, I was refering about the input support.

Ah, I see. For input, I did consider using bison BTW, but doubt it will
lead to less code than implementing everything with libjansson. And yes,
this will then be on the same level as parser_bison.y, so what is parsed
will then be fed to cmd_evaluate().

Cheers, Phil
