From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnftables extended API proposal
Date: Wed, 10 Jan 2018 00:31:26 +0100
Message-ID: <20180109233126.5ma7analfbnndw5g@salvia>
References: <20171220222336.yqnl3g5fgeopsxuf@salvia>
 <20171222130816.GV32305@orbyte.nwl.cc>
 <20171222134906.y46spklmtsxc6zj7@salvia>
 <20171222153049.GX32305@orbyte.nwl.cc>
 <20171222203903.5lq6hw3mhxupbfuk@salvia>
 <20171223131941.GY32305@orbyte.nwl.cc>
 <20171228192141.xqwd5ccmtwe4auq2@salvia>
 <20171229145816.GF32305@orbyte.nwl.cc>
 <20180102180219.6333nnbg2hgxyxrm@salvia>
 <20180105175203.GN32305@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38680 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932165AbeAIXbb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Jan 2018 18:31:31 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 92CE311D8E4
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2018 00:31:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7E0AFDA84F
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2018 00:31:29 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180105175203.GN32305@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 05, 2018 at 06:52:03PM +0100, Phil Sutter wrote:
> Hi Pablo,
> 
> On Tue, Jan 02, 2018 at 07:02:19PM +0100, Pablo Neira Ayuso wrote:
> > On Fri, Dec 29, 2017 at 03:58:16PM +0100, Phil Sutter wrote:
> > > On Thu, Dec 28, 2017 at 08:21:41PM +0100, Pablo Neira Ayuso wrote:
> > > > On Sat, Dec 23, 2017 at 02:19:41PM +0100, Phil Sutter wrote:
> [...]
> > > > > But isn't the problem of keeping the API compatible comparable to
> > > > > the problem of keeping the JSON representation compatible?
> > > > 
> > > > Well, keeping backward compatibility is always a burden to carry on.
> > > > Even though, to me, JSON is as extensible as netlink is, ie. we can
> > > > add new keys and deprecate things without breaking backward.
> > > 
> > > Yes, the format is very flexible. But how does that help with
> > > compatibility? You'll have to support the deprecated attributes or JSON
> > > without the new attributes either way, no?
> > 
> > Probably it's my subjective judging that maintaing json layout will be
> > easier rather than a large bunch of APIs and internal object
> > representations through getter/setter.
> > 
> > Anyway, these days, we expect people to use modern languages to build
> > upper layers in the stack, right? And that seems to mix well with JSON.
> > Again core infrastructure person here talking about upper layers, so
> > take this lightly ;-).
> 
> Yeah, for firewalld at least JSON is not a disadvantage. Not sure about
> projects written in C though, but that's a different kettle of fish. :)

It seems to me many of these new control plane/orchestration software
is not done in C, so this representation can be also useful to them.

> > [...]
> > > > Oh, I can help you on that. Although you're very much closer to
> > > > firewalld usecases that I'm, so probably a draft from you on this
> > > > would be nice ;-)
> > > 
> > > I went ahead and converted my local ruleset into JSON manually (until I
> > > got bored), see attached ruleset.json. Then I wrote a schema to validate
> > > it (also attached). Please let me know if you're OK with the base
> > > format at least, i.e. everything except expressions and statements. Any
> > > feedback on the few statements and expressions I put in there is highly
> > > appreciated as well, of course! :)
> > 
> > Probably instead of having left and right, we can replace it by:
> > 
> > "match" : {
> >         "key": {
> >                 ...
> >         },
> >         "value": "lo"
> > }
> > 
> > Then, allow to place expressions as "value" when it comes from a set
> > lookup.
> 
> Yes, JSON Schema allows to define multiple possible types for an
> attribute (see #/definitions/expression/val for instance). But I don't
> follow regarding set lookup: There are other uses for an expression on
> RHS as well, no?
> 
> > > > > > Regarding asynchronism between input and output, not sure I follow.
> > > > > 
> > > > > I am grepping through tests/py/*/*.t for pattern 'ok;':
> > > > > 
> > > > > - Adjacent ranges are combined.
> > > > 
> > > > We should disable this, there was some discussion on this recently.
> > > > User should request this explicitly to happen through some knob.
> > > 
> > > I agree. While it's a nice idea, adding two adjacent ranges and later
> > > wanting to delete one of them is troublesome. Do you have a name in mind
> > > for that knob? Maybe something more generic which could cover other
> > > cases of overly intelligent nft (in the future) as well?
> > 
> > Probably "coalesce" or "merge".
> 
> So you'd prefer a specific flag just for that feature? I had a more
> generic one in mind, something like "optimize" for instance.

At this stage, I'm consider to disable range automerge before 0.8.1 is
released. So we can revisit this later on with something that users
will explicitly enable on demand.

> [...]
> > > > > - meta iif "lo" accept;ok;iif "lo" accept
> > > > >   -> Maybe less abstraction?
> > > > 
> > > > This is just dealing with something that is causing us problems, that
> > > > is, iif is handled as primary key, so we cannot reuse it in the
> > > > grammar given it results in shift-reduce conflicts.
> > > 
> > > The question is why allow both variants then? Since 'iif' is being used
> > > as fib_flag as well, using 'iif' alone should be deprecated. Or is this
> > > a case of backwards compatibility?
> > 
> > It was compromise solution, not to break syntax all of a sudden,
> > allowing old and new ways for a little while. But this one, I think it
> > was not add this.
> 
> I couldn't parse your last sentence here. :)

Sorry, I mean. 'meta iff' came first, then 'iif' was added. To avoid
breaking things, the old meta iff has been preserved.

> > > > > - tcp dport 22 iiftype ether ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:4 accept ok;tcp dport 22 ether saddr 00:0f:54:0c:11:04 ip daddr 1.2.3.4 accept
> > > > >   -> Here something is "optimized out", not sure if it should be kept in
> > > > >   JSON.
> > > > 
> > > > This is testing redudant information, that we can remove given we can
> > > > infer it.
> > > 
> > > Yeah, similar situation to the 'meta l4proto' one above. The (still)
> > > tricky part is to communicate assigned handles back to the application.
> > > Maybe we could return an exact copy of their JSON with just handle
> > > properties added?
> > 
> > Yes, that should be fine. We already have the NLM_F_ECHO in place,
> > just a matter of supporting json there.
> > 
> > BTW, a simple testsuite for this would be good too.
> 
> Sure! Maybe the existing data in tests/py could be reused (the *.payload
> files at least).

That would be fine.

Thanks!
