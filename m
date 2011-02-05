From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Xtables2 A7 spec draft
Date: Sat, 5 Feb 2011 22:38:06 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1102052130440.10056@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1102011817480.7729@obet.zrqbmnf.qr> <alpine.DEB.2.00.1102051930550.5522@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51940 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063Ab1BEViI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Feb 2011 16:38:08 -0500
In-Reply-To: <alpine.DEB.2.00.1102051930550.5522@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2011-02-05 20:33, Jozsef Kadlecsik wrote:
>> 1.1 Nesting representation
>> 
>> The common element in Xtables is the ruleset, represented as a 
>> tree structure with ordering constraints at some levels:
>> 
>> ruleset (unordered tables)
>>  \__ table (unordered chains)
>>  |    \__ chain (ordered rules)
>>  |    |    \__ rule (ordered actions)
>>  |    |    |    \__ match (unordered data)
>>  |    |    |    |    \__ config-data
>>  |    |    |    |    |    \__ bin params
>>  |    |    |    |    \__ state-data
>>  |    |    |    |         \__ nlattrs
>>  |    |    |    \__ match...
>>  |    |    |    \__ target (unordered data)
>>  |    |    |    |    \__ config-data
>>  |    |    |    \__ target...
>>  |    |    |    \__ verdict...
>>  |    |    \__ rule...
>>  |    \__ chain...
>>  \__ table...
>
>I believe the objects 'match', 'target', 'verdict' should be generalized 
>and unified into a single entity named 'action' (or named whatever).

That is why there are already traces of the word 'action'
in the kernel (e.g. 'struct xt_action_param').

>I don't like the idea of passing binary parameters at any level: 
>everything should be expressed in nlattrs.
>
>> Certain voices in the community call for the obsoletion of such 
>> data blobs and replace them by Netlink attributes; there are no 
>> objections to doing so. However, the problem of size-limited 
>> sk_buffs applies to opaque data of any kind, and Netlink 
>> attributes fall within that.
>
>I'm among the ones who object data blobs.

I completely agree to many of your points, but my strategy shall be
clear: the first working code dump is _only_ supposed to 1. break up
the table blob, 2. do NL transport with the preexisting per-extension
blobs.

I would hate having to come up with a "perfect" solution from the
start. That won't work, for the following reasons: 1. It makes the
task look bigger, 2. the stream of work seemingly never-ending, both
of which cause increased chance for premature give-up. And that I
absolutely want to avoid. I suppose nobody of the maintainers would
want to review a 300-patchset at once either.

Of course, the new subsystem would only be marked stable once all
desires have been met. Something like how btrfs was merged.

>> To encode an attribute's length, struct nlattr only has a 16-bit 
>> field, which means the attribute header plus payload is limited 
>> to 64 KB. This is easily exceedable with the encapsulated 
>> encoding as chains are collected rules in a chain, for example. 
>> The problem is aggreviated by the kernel's Netlink handler only 
>> allocating sk_buffs a page size worth, which leaves few room for 
>> extension data. In the worst case, the usable payload for 
>> attributes is around 3600 bytes only. In light of xt_u32's 
>> private data block being 1984 bytes already, that means that you 
>> won't be able to fit two -m u32 invocations nested in a single 
>> rule into a dump.
>
>The pagesize limit is a real problem. :-(( I don't see how could we avoid 
>the possibility to split a single rule into multiple messages, because it 
>did not simply fit into a single one.

We will have to live with it, because when transferring from
kernel->user, other methods of transportation (such as a character
device) would run into the same limitation (it would be limited
by the size of the buffer passed to read(2)).

>> The Xtables2 Netlink protocol encodes each node of information as 
>> a standalone attribute, to be called Flat Encoding, that is 
>> appended (a. k. a. ?chained?) to the data stream. By avoiding 
>> encapsulated attributes, it is possible to split messages at much 
>> finer levels, and provides for attributes that happen to use 
>> opaque data with a maximally-sized buffer.
>
>Even with encapsulation, the messages can be split at any level.

I fear that won't work out so easily. Consider a Netlink message "msg
{ u32_params { atom1; atom2; ...; atomN; }}" with u32_params being an
NLA_F_NESTED. You could split that across messages as, for example,
"msg { u32_params { atom1; atom2; } } msg { u32_params { atom3; ...
atomN; }}", but you would have to repeat container headers, i.e.
u32_params. Which, given a big enough nesting level means that the
2nd message's space is used up by containers again.

If an analogy is needed: It is a bit like TCP segmentation vs. IP
fragmentation. In the former, there is one TCP hdr per message, in
the latter there is not.

>> Whereas encapsulated attribute encoding automatically provided 
>> for boundaries, this is realized using dummy attributes in the 
>> chained approach. The start of a nesting level can be implicitly 
>> represented by the presence of the attribute that would have 
>> otherwise been used for encapsulated nesting. For declaring an 
>> end of a nest level, an extra attribute is needed:
>> 
>> ? ?chain { rule; rule; ... }? \Leftrightarrow CHAIN RULE RULE ... 
>>   STOP
>
>With encapsulation, there were no need such an extra STOP attribute - 
>except that we may have to split the encapsulated attributes into multiple 
>messages and thus the STOP attribute/marker is needed.

Can you give an example of potential messages? The current spec
already lists

      NFXTM_STATE_DATA
        NFXTM_ATTR_DATA<nlattrs>
        NFXTM_ATTR_DATA<more nlattrs>
      NFXTM_STOP


>> 1.3 Attribute limitations in nfnetlink
>> 
>> Netlink, being just a base protocol, does not specify what comes 
>> after the nlmsghdr, or how it is ordered. This is left up to the 
>> subprotocols based on Netlink. nfnetlink has two effective 
>> shortcomings (due to its parser) that shall be held in mind:
>> 
>> ? Attribute ordering is ignored and lost
>
>Even if netlink does not state that attribute ordering is kept, it does 
>not state either that attributes may be reordered. Netling as transport 
>protocol does not care about the attributes.

Indeed Netlink is fine. The beef is with nfnetlink, which, due to its
use of "struct nlattr *tb[]" basically forfeits attribute ordering.

>So we can say that for xtables2, the attribute order in the netlink
>messages is fixed, period.

Yeah, but Pablo refused to accept patches which don't use nfnetlink,
or which rely on attribute order.


>> ? No support for more than one attribute with the same type 
>>   within a message
>
>Oh no, you can put as many attributes with the same type as you like (and 
>fit) into a single nested attribute!

Not just nested attributes. Attributes with the same type can be put
anywhere as long as you don't use a parser that utilizes the "struct
nlattr *tb[indexed_by_attr_type]" scheme. nfnetlink does use tb
however.

Encapsulating all the attrs in a nested attribute just to work around
nfnetlink's use of tb[] would beg the question of why one is using
nfnetlink in the first place then.

>> Even if that were decidedly so, that brings along a problem. In 
>> NLM_F_MULTI-style dumps, all messages would have the same 
>> nlmsg_seq. To counter this, multi messages will have an 
>> NFXT-specific sequence counter (NFXTA_SEQNO) in addition, 
>> especially since ordering is so much more crucial in Xtables than 
>> it is in other parts of networking.
>
>...but yes, for dumping an additional attribute is required to make sure 
>the ordering is kept. Actually, two attributes: one at the rule level, and 
>one at the "action" level in the given rule.

NFXTM_TABLE_DUMP<nlmsg_seqno=7> would yield:

NFXTM_CHAIN_ENTRY<nlmsg_seqno=7,nfxt_seqno=0, name=INPUT,usertid=1>
  NFXTM_RULE_ENTRY<nlmsg_seqno=7,nfxt_seqno=1, idx=1,usertid=1>
    NFXTM_MATCH_ENTRY<(7,2), acidx=1,name=hashlimit,rev=1,usertid=2>
      NFXTM_CONFIG_DATA<(7,3)>
        NFXTM_ARB_DATA<(7,4) custom data>
        NFXTM_ARB_DATA<(7,5) more custom data>
      NFXTM_STOP<(7,6)>
      NFXTM_STATE_DATA<(7,7)>
        NFXTM_ATTR_DATA<(7,8) nlattrs>
        NFXTM_ATTR_DATA<(7,9) more nlattrs>
      NFXTM_STOP<(7,10>)
    NFXTM_STOP<(7,11)>
    NFXTM_TARGET_ENTRY<(7,12), acidx=2,name=TOS,rev=0,usertid=3>
      ...
    NFXTM_STOP<(7,95)>
    NFXTM_VERDICT_ENTRY<(7,96), acidx=3,name=ACCEPT,usertid=3>
    NFXTM_STOP<(7,97)>
  NFXTM_STOP<(7,98)>
NFXTM_STOP<(7,99)>

So I think I am fine with one extra seqno (NFXTA_SEQNO).


>> 1.6 Improved granularity error reporting
>> 
>> ? General/standard (integer) error codes
>> ? General Xtables2 error codes (largely replaces EINVAL sites)
>> ? Free-form string. Standalone, or in addition to the above.
>> It is impossible to provision error numbers for extensions, 
>>   especially those that are out-of-tree.
>>
>> The three error types will be conveyed by three distinct 
>> attributes: NFXTA_ERRNO (generic error codes), NFXTA_XTERRNO (xt2 
>> error codes), and NFXTA_ERRSTR (free-form string).
>
>I hammer the issue further :-). With properly separated error number 
>domains, the three type can be expressed in a single error attribute.

That would mean that NFXTE_* codes would have to start at -4096
and go from there. Possible to work, but it does not feel right.

Currently the kernel has pointer values (-4095U)..(-1U) reserved for
error codes - no object will ever reside at those virtaddrs. Should
the kernel ever have a need for more than 4095 system errno codes,
the virtaddr limit of 0xfffff000 for mappings could simply be changed
to, say, 0xffff0000. But then you would run into the problem that
NFXTE error values suddenly overlap with system error codes.
Thus, keeping system error codes and NFXTE error codes separate
seems a sensible thing to do.

>I'm still not convinced about the usefulness of the error string.

Extensions shipped with the kernel are already provisioned for; the
error string was really only meant for extensions living outside the
kernel (those just can't be ignored).

I guess per-extension error codes are possible. (That just came to
mind.)

>As netlink sends back the original 
>message in the error message, the userspace can fully decode every 
>attribute (since it itself encoded it) too.

Generally just the original message header - not the entire message.
But in synchronous operations - in other words, most cases -
even that is not necessary: because we know what we constructed,
we don't need to rely on the replica inside the error message.

