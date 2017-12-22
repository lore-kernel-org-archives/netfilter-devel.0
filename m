From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnftables extended API proposal
Date: Fri, 22 Dec 2017 14:49:06 +0100
Message-ID: <20171222134906.y46spklmtsxc6zj7@salvia>
References: <20171204184604.GA1556@salvia>
 <20171205134317.GE32305@orbyte.nwl.cc>
 <20171207000545.GA27739@salvia>
 <20171207113431.GF32305@orbyte.nwl.cc>
 <20171210215540.GA14363@salvia>
 <20171216160651.GP32305@orbyte.nwl.cc>
 <20171218230048.pwtnnezyxyhh4geu@salvia>
 <20171220123225.GS32305@orbyte.nwl.cc>
 <20171220222336.yqnl3g5fgeopsxuf@salvia>
 <20171222130816.GV32305@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60348 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751770AbdLVNtL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Dec 2017 08:49:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 03CB1E3A00
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Dec 2017 14:49:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E5503123951
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Dec 2017 14:49:09 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171222130816.GV32305@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Phil,

On Fri, Dec 22, 2017 at 02:08:16PM +0100, Phil Sutter wrote:
> On Wed, Dec 20, 2017 at 11:23:36PM +0100, Pablo Neira Ayuso wrote:
> > On Wed, Dec 20, 2017 at 01:32:25PM +0100, Phil Sutter wrote:
> > [...]
> > > On Tue, Dec 19, 2017 at 12:00:48AM +0100, Pablo Neira Ayuso wrote:
> > > > On Sat, Dec 16, 2017 at 05:06:51PM +0100, Phil Sutter wrote:
[...]
> > > > I wonder if firewalld could generate high level json representation
> > > > instead, so it becomes a compiler/translator from its own
> > > > representation to nftables abstract syntax tree. As I said, the json
> > > > representation is mapping to the abstract syntax tree we have in nft.
> > > > I'm refering to the high level json representation that doesn't exist
> > > > yet, not the low level one for libnftnl.
> > > 
> > > Can you point me to some information about that high level JSON
> > > representation? Seems I'm missing something here.
> > 
> > It doesn't exist :-), if we expose a json-based API, third party tool
> > only have to generate the json high-level representation, we would
> > need very few API calls for this, and anyone could generate rulesets
> > for nftables, without relying on the bison parser, given the json
> > representation exposes the abstract syntax tree.
> 
> So you're idea is to accept a whole command in JSON format from
> applications? And output in JSON format as well since that is easier for
> parsing than human readable text we have right now?

Just brainstorming here, we're discussing an API for third party
applications. In this case, they just need to build the json
representation for the ruleset they want to add. They could even embed
this into a network message that they can send of the wire.

> I'm not sure about the '[ base, offset, length ]' part though:
> Applications would have to care about protocol header layout including
> any specialties themselves, or should libnftables provide them with
> convenience functions to generate the correct JSON markup?

It depends, you may want to expose json representations for each
protocol payload you support.

> For simple stuff like matching on a TCP port there's probably no
> need, but correctly interpreting IPv4 ToS field is rather
> error-prone I guess.

And bitfields are going to be cumbersome too, so we would indeed need
a json representation for each protocol that we support, so third
party applications don't need to deal with this.

> The approach seems simple at first, but application input in JSON format
> has to be validated as well, so I fear we'll end up with a second parser
> to avoid the first one.

There are libraries like jansson that already do the parsing for us,
so we don't need to maintain our own json parser. We would still need
internal code to libnftables, to navigate the json representation and
create the objects.

On our side, we would need to maintain a very simple API, basically
that allows you to parse a json representation and to export it. For
backward compatibility reasons, we have to keep supporting the json
layout, instead of a large number of functions.

I guess the question here is if this would be good for firewalld, I
didn't have a look at that code, but many third party applications I
have seen are basically creating iptables commands in text, so this
approach would be similar, well, actually better since we would be
providing a well-structured representation.
