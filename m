From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Xtables2 A7 spec draft
Date: Sun, 6 Feb 2011 12:43:56 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1102061014550.6575@blackhole.kfki.hu>
References: <alpine.LNX.2.01.1102011817480.7729@obet.zrqbmnf.qr> <alpine.DEB.2.00.1102051930550.5522@blackhole.kfki.hu> <alpine.LNX.2.01.1102052130440.10056@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:34647 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab1BFLn6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Feb 2011 06:43:58 -0500
In-Reply-To: <alpine.LNX.2.01.1102052130440.10056@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 5 Feb 2011, Jan Engelhardt wrote:

> On Saturday 2011-02-05 20:33, Jozsef Kadlecsik wrote:
> >> 1.1 Nesting representation
> >> 
> >> The common element in Xtables is the ruleset, represented as a 
> >> tree structure with ordering constraints at some levels:
> >> 
> >> ruleset (unordered tables)
> >>  \__ table (unordered chains)
> >>  |    \__ chain (ordered rules)
> >>  |    |    \__ rule (ordered actions)
> >>  |    |    |    \__ match (unordered data)
> >>  |    |    |    |    \__ config-data
> >>  |    |    |    |    |    \__ bin params
> >>  |    |    |    |    \__ state-data
> >>  |    |    |    |         \__ nlattrs
> >>  |    |    |    \__ match...
> >>  |    |    |    \__ target (unordered data)
> >>  |    |    |    |    \__ config-data
> >>  |    |    |    \__ target...
> >>  |    |    |    \__ verdict...
> >>  |    |    \__ rule...
> >>  |    \__ chain...
> >>  \__ table...
> >
> >I believe the objects 'match', 'target', 'verdict' should be generalized 
> >and unified into a single entity named 'action' (or named whatever).
> 
> That is why there are already traces of the word 'action'
> in the kernel (e.g. 'struct xt_action_param').

Then I was misled by NFXTM_MATCH|TARGET|VERDICT_ENTRY. So those are there 
for backward compatibility reasons only.

> >I don't like the idea of passing binary parameters at any level: 
> >everything should be expressed in nlattrs.
> >
> >> Certain voices in the community call for the obsoletion of such 
> >> data blobs and replace them by Netlink attributes; there are no 
> >> objections to doing so. However, the problem of size-limited 
> >> sk_buffs applies to opaque data of any kind, and Netlink 
> >> attributes fall within that.
> >
> >I'm among the ones who object data blobs.
> 
> I completely agree to many of your points, but my strategy shall be
> clear: the first working code dump is _only_ supposed to 1. break up
> the table blob, 2. do NL transport with the preexisting per-extension
> blobs.

That's a good plan, indeed. With it the task is split into more easily 
manageable parts.
 
> >> The Xtables2 Netlink protocol encodes each node of information as 
> >> a standalone attribute, to be called Flat Encoding, that is 
> >> appended (a. k. a. ?chained?) to the data stream. By avoiding 
> >> encapsulated attributes, it is possible to split messages at much 
> >> finer levels, and provides for attributes that happen to use 
> >> opaque data with a maximally-sized buffer.
> >
> >Even with encapsulation, the messages can be split at any level.
> 
> I fear that won't work out so easily. Consider a Netlink message "msg
> { u32_params { atom1; atom2; ...; atomN; }}" with u32_params being an
> NLA_F_NESTED. You could split that across messages as, for example,
> "msg { u32_params { atom1; atom2; } } msg { u32_params { atom3; ...
> atomN; }}", but you would have to repeat container headers, i.e.
> u32_params. Which, given a big enough nesting level means that the
> 2nd message's space is used up by containers again.

The levels of nesting is well defined in xtables2: table, chain, rule, 
action, data. It doesn't look like a big burden. I don't count the nesting 
levels of the different data containers, because those are required 
anyway.
 
> If an analogy is needed: It is a bit like TCP segmentation vs. IP
> fragmentation. In the former, there is one TCP hdr per message, in
> the latter there is not.

[Some regards IP fragmentation as a design mistake. Making it possible in 
IPv6 was actually a sin.]

> >> Whereas encapsulated attribute encoding automatically provided 
> >> for boundaries, this is realized using dummy attributes in the 
> >> chained approach. The start of a nesting level can be implicitly 
> >> represented by the presence of the attribute that would have 
> >> otherwise been used for encapsulated nesting. For declaring an 
> >> end of a nest level, an extra attribute is needed:
> >> 
> >> ? ?chain { rule; rule; ... }? \Leftrightarrow CHAIN RULE RULE ... 
> >>   STOP
> >
> >With encapsulation, there were no need such an extra STOP attribute - 
> >except that we may have to split the encapsulated attributes into multiple 
> >messages and thus the STOP attribute/marker is needed.
> 
> Can you give an example of potential messages? The current spec
> already lists
> 
>       NFXTM_STATE_DATA
>         NFXTM_ATTR_DATA<nlattrs>
>         NFXTM_ATTR_DATA<more nlattrs>
>       NFXTM_STOP

In my opinion the basic atomic element is a rule and our main issue is how 
to split a rule into multiple messages. It could be expressed with the 
NFXTM_STOP attribute, but I'd prefer an attribute flag value:

NFXTM_ACTION_ENTRY
  NFXTM_ACTION_FLAGS (MATCH|TARGET|VERDICT, COMPLETE)
    NFXTM_CONFIG_DATA
      NFXTM_ARB_DATA
      ...
    NFXTM_STATE_DATA
      NFXTM_ATTR_DATA
      ...

If the action entry is not flagged as complete, expect messages with 
additional config, state data entries. The config and state data are 
unordered, so there's no ordering issue here.
 
> >> 1.3 Attribute limitations in nfnetlink
> >> 
> >> Netlink, being just a base protocol, does not specify what comes 
> >> after the nlmsghdr, or how it is ordered. This is left up to the 
> >> subprotocols based on Netlink. nfnetlink has two effective 
> >> shortcomings (due to its parser) that shall be held in mind:
> >> 
> >> ? Attribute ordering is ignored and lost
> >
> >Even if netlink does not state that attribute ordering is kept, it does 
> >not state either that attributes may be reordered. Netling as transport 
> >protocol does not care about the attributes.
> 
> Indeed Netlink is fine. The beef is with nfnetlink, which, due to its
> use of "struct nlattr *tb[]" basically forfeits attribute ordering.
>
> >So we can say that for xtables2, the attribute order in the netlink
> >messages is fixed, period.
> 
> Yeah, but Pablo refused to accept patches which don't use nfnetlink,
> or which rely on attribute order.
>
> >> ? No support for more than one attribute with the same type 
> >>   within a message
> >
> >Oh no, you can put as many attributes with the same type as you like (and 
> >fit) into a single nested attribute!
> 
> Not just nested attributes. Attributes with the same type can be put
> anywhere as long as you don't use a parser that utilizes the "struct
> nlattr *tb[indexed_by_attr_type]" scheme. nfnetlink does use tb
> however.

Nfnetlink parses the attributes at the toplevel only. And at toplevel you 
don't rely on ordered attributes: tables, chains are unordered.

So you don't need to add anything to netlink/nfnetlink: you can use 
ordered attributes by nesting them, at the level where ordering is 
required.
  
> Encapsulating all the attrs in a nested attribute just to work around
> nfnetlink's use of tb[] would beg the question of why one is using
> nfnetlink in the first place then.
> 
> >> Even if that were decidedly so, that brings along a problem. In 
> >> NLM_F_MULTI-style dumps, all messages would have the same 
> >> nlmsg_seq. To counter this, multi messages will have an 
> >> NFXT-specific sequence counter (NFXTA_SEQNO) in addition, 
> >> especially since ordering is so much more crucial in Xtables than 
> >> it is in other parts of networking.
> >
> >...but yes, for dumping an additional attribute is required to make sure 
> >the ordering is kept. Actually, two attributes: one at the rule level, and 
> >one at the "action" level in the given rule.
> 
> NFXTM_TABLE_DUMP<nlmsg_seqno=7> would yield:
> 
> NFXTM_CHAIN_ENTRY<nlmsg_seqno=7,nfxt_seqno=0, name=INPUT,usertid=1>
>   NFXTM_RULE_ENTRY<nlmsg_seqno=7,nfxt_seqno=1, idx=1,usertid=1>
>     NFXTM_MATCH_ENTRY<(7,2), acidx=1,name=hashlimit,rev=1,usertid=2>
>       NFXTM_CONFIG_DATA<(7,3)>
>         NFXTM_ARB_DATA<(7,4) custom data>
>         NFXTM_ARB_DATA<(7,5) more custom data>
>       NFXTM_STOP<(7,6)>
>       NFXTM_STATE_DATA<(7,7)>
>         NFXTM_ATTR_DATA<(7,8) nlattrs>
>         NFXTM_ATTR_DATA<(7,9) more nlattrs>
>       NFXTM_STOP<(7,10>)
>     NFXTM_STOP<(7,11)>
>     NFXTM_TARGET_ENTRY<(7,12), acidx=2,name=TOS,rev=0,usertid=3>
>       ...
>     NFXTM_STOP<(7,95)>
>     NFXTM_VERDICT_ENTRY<(7,96), acidx=3,name=ACCEPT,usertid=3>
>     NFXTM_STOP<(7,97)>
>   NFXTM_STOP<(7,98)>
> NFXTM_STOP<(7,99)>
> 
> So I think I am fine with one extra seqno (NFXTA_SEQNO).

I regard NFXTA_ACTION_IDX as a second attribute besides NFXTA_SEQNO, which
is needed to reconstruct the proper order when receiving a full rule in
multiple messages.

> >> 1.6 Improved granularity error reporting
> >> 
> >> ? General/standard (integer) error codes
> >> ? General Xtables2 error codes (largely replaces EINVAL sites)
> >> ? Free-form string. Standalone, or in addition to the above.
> >> It is impossible to provision error numbers for extensions, 
> >>   especially those that are out-of-tree.
> >>
> >> The three error types will be conveyed by three distinct 
> >> attributes: NFXTA_ERRNO (generic error codes), NFXTA_XTERRNO (xt2 
> >> error codes), and NFXTA_ERRSTR (free-form string).
> >
> >I hammer the issue further :-). With properly separated error number 
> >domains, the three type can be expressed in a single error attribute.
> 
> That would mean that NFXTE_* codes would have to start at -4096
> and go from there. Possible to work, but it does not feel right.
> 
> Currently the kernel has pointer values (-4095U)..(-1U) reserved for
> error codes - no object will ever reside at those virtaddrs. Should
> the kernel ever have a need for more than 4095 system errno codes,
> the virtaddr limit of 0xfffff000 for mappings could simply be changed
> to, say, 0xffff0000. But then you would run into the problem that
> NFXTE error values suddenly overlap with system error codes.
> Thus, keeping system error codes and NFXTE error codes separate
> seems a sensible thing to do.

The highest system error code currently is 132. I think we have got plenty 
of time to exhaust the rest and overflow 4095 :-).
 
> >I'm still not convinced about the usefulness of the error string.
> 
> Extensions shipped with the kernel are already provisioned for; the
> error string was really only meant for extensions living outside the
> kernel (those just can't be ignored).
> 
> I guess per-extension error codes are possible. (That just came to
> mind.)
> 
> >As netlink sends back the original 
> >message in the error message, the userspace can fully decode every 
> >attribute (since it itself encoded it) too.
> 
> Generally just the original message header - not the entire message.
> But in synchronous operations - in other words, most cases -
> even that is not necessary: because we know what we constructed,
> we don't need to rely on the replica inside the error message.

Netlink sends back the entire message, not just the header. (Unless you 
handle error messages manually and force netlink not to send them.)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
