From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnftables extended API proposal
Date: Tue, 2 Jan 2018 19:02:19 +0100
Message-ID: <20180102180219.6333nnbg2hgxyxrm@salvia>
References: <20171218230048.pwtnnezyxyhh4geu@salvia>
 <20171220123225.GS32305@orbyte.nwl.cc>
 <20171220222336.yqnl3g5fgeopsxuf@salvia>
 <20171222130816.GV32305@orbyte.nwl.cc>
 <20171222134906.y46spklmtsxc6zj7@salvia>
 <20171222153049.GX32305@orbyte.nwl.cc>
 <20171222203903.5lq6hw3mhxupbfuk@salvia>
 <20171223131941.GY32305@orbyte.nwl.cc>
 <20171228192141.xqwd5ccmtwe4auq2@salvia>
 <20171229145816.GF32305@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50164 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751034AbeABSCY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Jan 2018 13:02:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AF957249C2
        for <netfilter-devel@vger.kernel.org>; Tue,  2 Jan 2018 19:02:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8EA4DDA3A3
        for <netfilter-devel@vger.kernel.org>; Tue,  2 Jan 2018 19:02:22 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171229145816.GF32305@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Phil,

On Fri, Dec 29, 2017 at 03:58:16PM +0100, Phil Sutter wrote:
> On Thu, Dec 28, 2017 at 08:21:41PM +0100, Pablo Neira Ayuso wrote:
> > On Sat, Dec 23, 2017 at 02:19:41PM +0100, Phil Sutter wrote:
[...]
> > Yes, that would place a bit more work on the library, but I think we
> > should provide a high level representation that makes it easy for
> > people to express things. People should not deal with bitfield
> > handling, that's very tricky. Just have a look at commits that I and
> > Florian made to fix this. We don't want users to fall into this trap
> > by creating incorrect expressions, or worse, making them feel our
> > library does not work (even if it's their own mistake to build
> > incorrect expressions).
> 
> I wonder if it made sense to provide JSON generating helpers. Maybe even
> just for sample purposes.

If you add them, I prefer you keep them private internally, not
exposed through API.

[...]
> > > But isn't the problem of keeping the API compatible comparable to
> > > the problem of keeping the JSON representation compatible?
> > 
> > Well, keeping backward compatibility is always a burden to carry on.
> > Even though, to me, JSON is as extensible as netlink is, ie. we can
> > add new keys and deprecate things without breaking backward.
> 
> Yes, the format is very flexible. But how does that help with
> compatibility? You'll have to support the deprecated attributes or JSON
> without the new attributes either way, no?

Probably it's my subjective judging that maintaing json layout will be
easier rather than a large bunch of APIs and internal object
representations through getter/setter.

Anyway, these days, we expect people to use modern languages to build
upper layers in the stack, right? And that seems to mix well with JSON.
Again core infrastructure person here talking about upper layers, so
take this lightly ;-).

[...]
> > Oh, I can help you on that. Although you're very much closer to
> > firewalld usecases that I'm, so probably a draft from you on this
> > would be nice ;-)
> 
> I went ahead and converted my local ruleset into JSON manually (until I
> got bored), see attached ruleset.json. Then I wrote a schema to validate
> it (also attached). Please let me know if you're OK with the base
> format at least, i.e. everything except expressions and statements. Any
> feedback on the few statements and expressions I put in there is highly
> appreciated as well, of course! :)

Probably instead of having left and right, we can replace it by:

"match" : {
        "key": {
                ...
        },
        "value": "lo"
}

Then, allow to place expressions as "value" when it comes from a set
lookup.

> > > > Regarding asynchronism between input and output, not sure I follow.
> > > 
> > > I am grepping through tests/py/*/*.t for pattern 'ok;':
> > > 
> > > - Adjacent ranges are combined.
> > 
> > We should disable this, there was some discussion on this recently.
> > User should request this explicitly to happen through some knob.
> 
> I agree. While it's a nice idea, adding two adjacent ranges and later
> wanting to delete one of them is troublesome. Do you have a name in mind
> for that knob? Maybe something more generic which could cover other
> cases of overly intelligent nft (in the future) as well?

Probably "coalesce" or "merge".

> > > - meta l4proto ipv6-icmp icmpv6 type nd-router-advert;ok;icmpv6 type nd-router-advert
> > >   -> more abstraction needed.
> > 
> > Not sure what you mean.
> 
> I meant 'icmpv6 ...' should imply 'meta l4proto ipv6-icmp', but that's
> the case already. Maybe this is a similar case as the combining of
> adjacent ranges in that it's a good thing per se but might not suit
> users' preferences.

This is an implicit dependency, right? I think this test just makes sure
that we handle an explicit dependencies - in case the user decides to be
too verbose - just fine.

> > > - meta priority 0x87654321;ok;meta priority 8765:4321
> > >   -> What the heck? :)
> > 
> > This is testing that we accept basetypes, given classid is an integer
> > basetype.
> 
> Ah, I see.
> 
> > > - meta iif "lo" accept;ok;iif "lo" accept
> > >   -> Maybe less abstraction?
> > 
> > This is just dealing with something that is causing us problems, that
> > is, iif is handled as primary key, so we cannot reuse it in the
> > grammar given it results in shift-reduce conflicts.
> 
> The question is why allow both variants then? Since 'iif' is being used
> as fib_flag as well, using 'iif' alone should be deprecated. Or is this
> a case of backwards compatibility?

It was compromise solution, not to break syntax all of a sudden,
allowing old and new ways for a little while. But this one, I think it
was not add this.

> Anyway, this won't be an issue in JSON at least.
> 
> > > - tcp dport 22 iiftype ether ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:4 accept ok;tcp dport 22 ether saddr 00:0f:54:0c:11:04 ip daddr 1.2.3.4 accept
> > >   -> Here something is "optimized out", not sure if it should be kept in
> > >   JSON.
> > 
> > This is testing redudant information, that we can remove given we can
> > infer it.
> 
> Yeah, similar situation to the 'meta l4proto' one above. The (still)
> tricky part is to communicate assigned handles back to the application.
> Maybe we could return an exact copy of their JSON with just handle
> properties added?

Yes, that should be fine. We already have the NLM_F_ECHO in place,
just a matter of supporting json there.

BTW, a simple testsuite for this would be good too.

Thanks!

P.S: Happy new year BTW.
