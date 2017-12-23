From: Phil Sutter <phil@nwl.cc>
Subject: Re: libnftables extended API proposal
Date: Sat, 23 Dec 2017 14:19:41 +0100
Message-ID: <20171223131941.GY32305@orbyte.nwl.cc>
References: <20171207113431.GF32305@orbyte.nwl.cc>
 <20171210215540.GA14363@salvia>
 <20171216160651.GP32305@orbyte.nwl.cc>
 <20171218230048.pwtnnezyxyhh4geu@salvia>
 <20171220123225.GS32305@orbyte.nwl.cc>
 <20171220222336.yqnl3g5fgeopsxuf@salvia>
 <20171222130816.GV32305@orbyte.nwl.cc>
 <20171222134906.y46spklmtsxc6zj7@salvia>
 <20171222153049.GX32305@orbyte.nwl.cc>
 <20171222203903.5lq6hw3mhxupbfuk@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:54978 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750820AbdLWNTn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 Dec 2017 08:19:43 -0500
Content-Disposition: inline
In-Reply-To: <20171222203903.5lq6hw3mhxupbfuk@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 22, 2017 at 09:39:03PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Dec 22, 2017 at 04:30:49PM +0100, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > On Fri, Dec 22, 2017 at 02:49:06PM +0100, Pablo Neira Ayuso wrote:
> > > On Fri, Dec 22, 2017 at 02:08:16PM +0100, Phil Sutter wrote:
> > > > On Wed, Dec 20, 2017 at 11:23:36PM +0100, Pablo Neira Ayuso wrote:
> > > > > On Wed, Dec 20, 2017 at 01:32:25PM +0100, Phil Sutter wrote:
> > > > > [...]
> > > > > > On Tue, Dec 19, 2017 at 12:00:48AM +0100, Pablo Neira Ayuso wrote:
> > > > > > > On Sat, Dec 16, 2017 at 05:06:51PM +0100, Phil Sutter wrote:
> > > [...]
> > > > > > > I wonder if firewalld could generate high level json representation
> > > > > > > instead, so it becomes a compiler/translator from its own
> > > > > > > representation to nftables abstract syntax tree. As I said, the json
> > > > > > > representation is mapping to the abstract syntax tree we have in nft.
> > > > > > > I'm refering to the high level json representation that doesn't exist
> > > > > > > yet, not the low level one for libnftnl.
> > > > > > 
> > > > > > Can you point me to some information about that high level JSON
> > > > > > representation? Seems I'm missing something here.
> > > > > 
> > > > > It doesn't exist :-), if we expose a json-based API, third party tool
> > > > > only have to generate the json high-level representation, we would
> > > > > need very few API calls for this, and anyone could generate rulesets
> > > > > for nftables, without relying on the bison parser, given the json
> > > > > representation exposes the abstract syntax tree.
> > > > 
> > > > So you're idea is to accept a whole command in JSON format from
> > > > applications? And output in JSON format as well since that is easier for
> > > > parsing than human readable text we have right now?
> > > 
> > > Just brainstorming here, we're discussing an API for third party
> > > applications. In this case, they just need to build the json
> > > representation for the ruleset they want to add. They could even embed
> > > this into a network message that they can send of the wire.
> > > 
> > > > I'm not sure about the '[ base, offset, length ]' part though:
> > > > Applications would have to care about protocol header layout including
> > > > any specialties themselves, or should libnftables provide them with
> > > > convenience functions to generate the correct JSON markup?
> > > 
> > > It depends, you may want to expose json representations for each
> > > protocol payload you support.
> > > 
> > > > For simple stuff like matching on a TCP port there's probably no
> > > > need, but correctly interpreting IPv4 ToS field is rather
> > > > error-prone I guess.
> > > 
> > > And bitfields are going to be cumbersome too, so we would indeed need
> > > a json representation for each protocol that we support, so third
> > > party applications don't need to deal with this.
> > > 
> > > > The approach seems simple at first, but application input in JSON format
> > > > has to be validated as well, so I fear we'll end up with a second parser
> > > > to avoid the first one.
> > > 
> > > There are libraries like jansson that already do the parsing for us,
> > > so we don't need to maintain our own json parser. We would still need
> > > internal code to libnftables, to navigate the json representation and
> > > create the objects.
> > 
> > Yes sure, there are libraries doing the actual parsing of JSON -
> > probably I wasn't clear enough. My point is what happens if you have a
> > parsed JSON tree (or array, however it may look like in practice). The
> > data sent by the application is either explicit enough for the
> > translation into netlink messages to be really trivial, or it is not
> > (which I prefer, otherwise applications could use libnftnl directly with
> > no drawback) - then we still have to implement a middle layer between
> > data in JSON and nftables objects. Maybe an example will do:
> > 
> > | [{
> > | 	"type": "relational",
> > | 	"left": {
> > | 		"type": "expression",
> > | 		"name": "tcp_hdr_expr",
> > | 		"value": {
> > | 			"type": "tcp_hdr_field",
> > | 			"value": "dport",
> > | 		},
> > | 	},
> > | 	"right": {
> > | 		"type": "expression",
> > | 		"name": "integer_expr",
> > | 		"value": 22,
> > | 	}
> > | }]
> 
> Probably something more simple representation, like this?
> 
> [{
>         "match": {
>                 "left": {
>                         "type": "payload",
>                         "name": "tcp",
>                         "field: "dport",
>         	},
>                 "right": {
>                         "type": "immediate",
>                         "value": 22,
>                 }
>         }
> }]
> 
> For non-matching things, we can add an "action".

You mean for non-EQ type relationals? I would just add a third field
below "match", e.g. '"op": "GT"' or so.

> I wonder if this can even be made more simple and more compact indeed.

I guess the more compact it becomes, the less work (less diversity) for
applications and the more work ("parsing") on libnftables side.

> > So this might be how a relational expression could be represented in
> > JSON. Note that I intentionally didn't break it down to payload_expr,
> > otherwise it had to contain TCP header offset, etc. (In this case that
> > might be preferred, but as stated above it's not the best option in
> > every case.)
> > 
> > Parsing^WInterpreting code would then probably look like:
> > 
> > | type = json_object_get(data, "type");
> > | if (!strcmp(type, "relational")) {
> > | 	left = parse_expr(json_object_get(data, "left"));
> > | 	right = parse_expr(json_object_get(data, "right"));
> > | 	expr = relational_expr_alloc(&internal_location,
> > | 				     OP_IMPLICIT, left, right);
> > | }
> >
> > I think this last part might easily become bigger than parser_bison.y
> > and scanner.l combined.
> >
> > > On our side, we would need to maintain a very simple API, basically
> > > that allows you to parse a json representation and to export it. For
> > > backward compatibility reasons, we have to keep supporting the json
> > > layout, instead of a large number of functions.
> > 
> > Yes, the API *itself* might be a lot smaller since it just takes a chunk
> > of JSON for about anything. But the middle layer (which is not exported
> > to applications) will be the relevant factor instead.
> 
> Yes, in C I guess it will be quite a bit of new boiler plate code.
> Unless we find a way to autogenerate code skeletons in some way.

Maybe use something like lex/yacc? *SCNR* ;)

> I'm not so worry about maintaining more code. Real problem is API
> in the longterm: you have to stick to them for long time (or forever
> if you want if you want to take backward compatibility seriously, we
> have a very good record on this).

But isn't the problem of keeping the API compatible comparable to
the problem of keeping the JSON representation compatible?

> And having little API mean, library can internally evolve more freely.

Either way, keeping the API or JSON representation as abstract as
possible (without losing too much functionality) is advisable I guess.

> > > I guess the question here is if this would be good for firewalld, I
> > > didn't have a look at that code, but many third party applications I
> > > have seen are basically creating iptables commands in text, so this
> > > approach would be similar, well, actually better since we would be
> > > providing a well-structured representation.
> > 
> > Yes, of course firewalld builds iptables commands, but just because
> > there is no better option. Hence the request for a better libnftables
> > API, to avoid repeating that with another command (or function call
> > to which the command's parameters are passed).
> > 
> > Firewalld is written in Python, so it won't be able to use libnftables
> > directly, anyway. At least a thin layer of wrapping code will be there,
> > even if it's just via ctypes module.
> 
> Parsing of json in python is actually rather easy, right? I remember
> to have seen code mapping XML to an object whose attributes can be
> accessed as object fields. I wonder about how hard would be to
> generate it too.

Yes, I think JSON suits interpreted languages quite well since (at
least Python) comes with datatypes resembling how JSON structures data.
E.g. something like:

| [{
| 	"foo": [ "bar", "baz" ],
| 	"feed": "babe",
| }]

In Python would translate to:

| obj = {
| 	"foo": [ "bar", "baz" ],
| 	"feed": "babe"
| }

Undeniable similarity! :)

> > From my perspective, the argument of being well-structured doesn't quite
> > hold. Of course, JSON will provide something like "here starts a
> > statement" and "here it ends", but e.g. asynchronism between input and
> > output will be reflected by it as well if not solved in common code
> > already.
> 
> I'm not sure we should expose statements and relationals in the way we
> do in nftables, it's too low level still for a high level library :-).
> We can probably provide a more simplistic json representation that is
> human readable and understandable.

Yes, I agree. The big question is who will define the JSON format. :)

> Regarding asynchronism between input and output, not sure I follow.

I am grepping through tests/py/*/*.t for pattern 'ok;':

- Adjacent ranges are combined.
- meta l4proto ipv6-icmp icmpv6 type nd-router-advert;ok;icmpv6 type nd-router-advert
  -> more abstraction needed.
- meta priority 0x87654321;ok;meta priority 8765:4321
  -> What the heck? :)
- meta iif "lo" accept;ok;iif "lo" accept
  -> Maybe less abstraction?
- tcp dport 22 iiftype ether ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:4 accept ok;tcp dport 22 ether saddr 00:0f:54:0c:11:04 ip daddr 1.2.3.4 accept
  -> Here something is "optimized out", not sure if it should be kept in
  JSON.
- reject with icmpx type port-unreachable;ok;reject
  -> This simplification should be easy (or even required) to undo in JSON.

Those are just some examples. If an application compares JSON it sent to
libnftables with what it returned, there are definitely things JSON
wouldn't "hide" (such as reordering in sets or differing number
formatting).

Cheers, Phil
