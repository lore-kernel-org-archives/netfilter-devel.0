From: James Nurmi <jdnurmi@qwe.cc>
Subject: Re: Xtables2 A7 spec draft
Date: Mon, 7 Feb 2011 12:50:40 -0800
Message-ID: <AANLkTinaXkiL2HidUPSVnGyi-y4ZgqQxCB-uGDxdVYb_@mail.gmail.com>
References: <alpine.LNX.2.01.1102011817480.7729@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51023 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab1BGUun convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Feb 2011 15:50:43 -0500
Received: by wwa36 with SMTP id 36so5247958wwa.1
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Feb 2011 12:50:41 -0800 (PST)
In-Reply-To: <alpine.LNX.2.01.1102011817480.7729@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

(inline)

Comments are made as maintainer of GoNetlink, a 'not-C' language;
disregard as desired.

On Wed, Feb 2, 2011 at 2:04 PM, Jan Engelhardt <jengelh@medozas.de> wro=
te:
>
>
> I am posting the Xtables2 Netlink interface specification, draft 7
> for comments.
>
> Additionally, further documentation and toolchain around
> it is available through the project page at
>
> =A0 =A0 =A0 =A0http://jengelh.medozas.de/projects/xtables/
>
> =A0* User Documentation Chapter 1: Architectural Differences
> =A0* Developer Documentation Part 1: Netlink interface (WIP)
> =A0 This is copied below to facilitate inline replies
> --8<--
>
> Netlink interface
>
> 1 Concepts
>
> This section is non-normative and should instead show the flow of
> thought and give reasons as to why the specification was
> conceived the way it is, and where the component problems are.
>
> 1.1 Nesting representation
>
> The common element in Xtables is the ruleset, represented as a
> tree structure with ordering constraints at some levels:
>
> ruleset (unordered tables)
> =A0\__ table (unordered chains)
> =A0| =A0 =A0\__ chain (ordered rules)
> =A0| =A0 =A0| =A0 =A0\__ rule (ordered actions)
> =A0| =A0 =A0| =A0 =A0| =A0 =A0\__ match (unordered data)
> =A0| =A0 =A0| =A0 =A0| =A0 =A0| =A0 =A0\__ config-data
> =A0| =A0 =A0| =A0 =A0| =A0 =A0| =A0 =A0| =A0 =A0\__ bin params
> =A0| =A0 =A0| =A0 =A0| =A0 =A0| =A0 =A0\__ state-data
> =A0| =A0 =A0| =A0 =A0| =A0 =A0| =A0 =A0 =A0 =A0 \__ nlattrs
> =A0| =A0 =A0| =A0 =A0| =A0 =A0\__ match...
> =A0| =A0 =A0| =A0 =A0| =A0 =A0\__ target (unordered data)
> =A0| =A0 =A0| =A0 =A0| =A0 =A0| =A0 =A0\__ config-data
> =A0| =A0 =A0| =A0 =A0| =A0 =A0\__ target...
> =A0| =A0 =A0| =A0 =A0| =A0 =A0\__ verdict...
> =A0| =A0 =A0| =A0 =A0\__ rule...
> =A0| =A0 =A0\__ chain...
> =A0\__ table...
>
> A more concrete example, here is a small ruleset, encoded into
> XML (just one of many possible representations):
>
> <table>
> =A0<chain name=3D"INPUT">
> =A0 =A0<rule idx=3D"1">
> =A0 =A0 =A0<match acidx=3D"1" name=3D"hashlimit" rev=3D"1" csize=3D"1=
20">
> =A0 =A0 =A0 =A0<config-data>...</config-data>
> =A0 =A0 =A0 =A0<state-data>...</state-data>
> =A0 =A0 =A0</match>
> =A0 =A0 =A0<target acidx=3D"2" name=3D"TOS" rev=3D"1">
> =A0 =A0 =A0 =A0...
> =A0 =A0 =A0</target>
> =A0 =A0 =A0<verdict acidx=3D"3" name=3D"ACCEPT" />
> =A0 =A0</rule>
> =A0</chain>
> </table>
>
> There are different ways to encode such a tree structure into a
> serialized stream. In many Netlink protocols, children attributes
> are encapsulated (a. k. a. =93nested=94, though we will avoid this
> term to avoid double-use) and treated as a whole as a parent's
> opaque data. It cannot be told apart from normal data. (Like
> writing =93<chain> &lt;rule&gt; ... &lt;/rule&gt; </chain>=94 in
> XML.) We will call this format =93Encapsulated Encoding=94.
>
> To encode an attribute's length, struct nlattr only has a 16-bit
> field, which means the attribute header plus payload is limited
> to 64 KB. This is easily exceedable with the encapsulated
> encoding as chains are collected rules in a chain, for example.
> The problem is aggreviated by the kernel's Netlink handler only
> allocating sk_buffs a page size worth, which leaves few room for
> extension data. In the worst case, the usable payload for
> attributes is around 3600 bytes only. In light of xt_u32's
> private data block being 1984 bytes already, that means that you
> won't be able to fit two -m u32 invocations nested in a single
> rule into a dump.
>
> Certain voices in the community call for the obsoletion of such
> data blobs and replace them by Netlink attributes; there are no
> objections to doing so. However, the problem of size-limited
> sk_buffs applies to opaque data of any kind, and Netlink
> attributes fall within that.

I'm all for of opaque data-blobs where the user is not expected to
understand the data underneath (FILE handles), but only so far as they
can be safely serialized to alternate processes for collection of
additional data (no *pointers, and only TLV styled abstractions)

>
> The Xtables2 Netlink protocol encodes each node of information as
> a standalone attribute, to be called Flat Encoding, that is
> appended (a. k. a. =93chained=94) to the data stream. By avoiding
> encapsulated attributes, it is possible to split messages at much
> finer levels, and provides for attributes that happen to use
> opaque data with a maximally-sized buffer.
>
> 1.2 Nest markers<sub:Nest-markers>
>
> Since Netlink messages do have a 32-bit quantity to store the
> messagelength, rulesets of roughly up to 4 GB are possibile,
> which is currently regarded as sufficient. The largest (while
> still being meaningful) rulesets seen to date in the industry
> weighed in at approximately 150 MB.

While managing tables/rules/etc atomically should be priority #1, I'm
not certain if optimizing the protocol for this makes a lot of sense
for either the user or kernel contexts.

>
> Whereas encapsulated attribute encoding automatically provided
> for boundaries, this is realized using dummy attributes in the
> chained approach. The start of a nesting level can be implicitly
> represented by the presence of the attribute that would have
> otherwise been used for encapsulated nesting. For declaring an
> end of a nest level, an extra attribute is needed:
>
> =95 =93chain { rule; rule; ... }=94 \Leftrightarrow CHAIN RULE RULE .=
=2E.
> =A0STOP
>
> 1.3 Attribute limitations in nfnetlink
>
> Netlink, being just a base protocol, does not specify what comes
> after the nlmsghdr, or how it is ordered. This is left up to the
> subprotocols based on Netlink. nfnetlink has two effective
> shortcomings (due to its parser) that shall be held in mind:
>
> =95 Attribute ordering is ignored and lost

(GoNetlink doesn't adhere to this belief; I didn't realize there was
any standardization of this approach outside of the libnfnetlink
implementation, and so assumed I'd be screwed if I followed it.)

>
> =95 No support for more than one attribute with the same type
> =A0within a message

ditto

> 1.4 Summary of transform<sub:Summary-of-transform>
>
> Essentially there is a 1:1 transform on the XML-like tree shown
> above, to:
>
> NFXTM_CHAIN_ENTRY<name=3DINPUT,usertid=3D1>
> =A0NFXTM_RULE_ENTRY<idx=3D1,usertid=3D1>
> =A0 =A0NFXTM_MATCH_ENTRY<acidx=3D1,name=3Dhashlimit,rev=3D1,usertid=3D=
2>
> =A0 =A0 =A0NFXTM_CONFIG_DATA
> =A0 =A0 =A0 =A0NFXTM_ARB_DATA<whatever>
> =A0 =A0 =A0 =A0NFXTM_ARB_DATA<more arbitrary data>
> =A0 =A0 =A0NFXTM_STOP
> =A0 =A0 =A0NFXTM_STATE_DATA
> =A0 =A0 =A0 =A0NFXTM_ATTR_DATA<nlattrs>
> =A0 =A0 =A0 =A0NFXTM_ATTR_DATA<more nlattrs>
> =A0 =A0 =A0NFXTM_STOP
> =A0 =A0NFXTM_STOP
> =A0 =A0NFXTM_TARGET_ENTRY<acidx=3D2,name=3DTOS,rev=3D0,usertid=3D3>
> =A0 =A0 =A0...
> =A0 =A0NFXTM_STOP
> =A0 =A0NFXTM_VERDICT_ENTRY<acidx=3D3,name=3DACCEPT,usertid=3D3>
> =A0 =A0NFXTM_STOP
> =A0NFXTM_STOP
> NFXTM_STOP
>
> 1.5 Extra sequence numbers<sub:Extra-sequence-numbers>
>
> Netlink also does not specify any message ordering, though it
> does provide an nlmsg_seq field with which message order can at
> least be determined. The problem is that nothing specifies what
> nlmsg_seq should be in reply messages. It is assumed that the
> sequence number is linked, i. e. that a reply's number should be
> the same as the request's number, to do message matching (vague
> hint by netlink(7) manpage).

RFC 3549 (2.3.2.1) seems to support you in that the usage of sequence
numbers is undefined; My experience has been to expect the response to
match the request and dispatch accordingly -- since thats the 'norm',
and netlink shouldn't ever fail,  I'd actually rather see the protocol
use NLM_F_MULTI, NLM_F_ATOMIC pair, with an internal
sequence/timestamp for clients that really need an atomic state.

>
> Even if that were decidedly so, that brings along a problem. In
> NLM_F_MULTI-style dumps, all messages would have the same
> nlmsg_seq. To counter this, multi messages will have an
> NFXT-specific sequence counter (NFXTA_SEQNO) in addition,
> especially since ordering is so much more crucial in Xtables than
> it is in other parts of networking.

That, to me, is fine -- netlink is an encapsulation from my view,
MULTI is the right way to do long messages.

>
> 1.6 Improved granularity error reporting
>...

As a non-C implementation, I'd prefer constant error (class) with
flags (bitfield), but expect to rewrite a lot of constants anyhow.

> 1.7 Multi-type responses
> ...

Most RTNetlink protocols (which will be a similar user base I imagine)
make assumptions on the response type based on the query type;  In go,
for example, there is no generic, so re-decomposing a response becomes
expensive.

Personally, I would prefer that responses be limited solely to the
query I provided or an error, not something with multiple (possibly
confounding?) types.

> ...
> 3 Attributes
>
> The meaning of attributes depends upon the message and logical
> nesting level in which they appear. Their type however remains
> the same, such that a single Netlink attribute validation policy
> object (struct nla_policy) can be used for all message types.
>
> A table of all known attributes:
>
>
> +--------+-------------------+---------------+-----------------+-----=
---------------------------------+
> | Value =A0| Mnemonic =A0 =A0 =A0 =A0 =A0| =A0 =A0C type =A0 =A0 | NL=
A type =A0 =A0 =A0 =A0| Notes =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0|
> +--------+-------------------+---------------+-----------------+-----=
---------------------------------+
> +--------+-------------------+---------------+-----------------+-----=
---------------------------------+
> | =A0 1 =A0 =A0| NFXTA_SEQNO =A0 =A0 =A0 | unsigned int =A0| NLA_U32 =
=A0 =A0 =A0 =A0 | Section [sub:Extra-sequence-numbers] |
> +--------+-------------------+---------------+-----------------+-----=
---------------------------------+
> | =A0tba =A0 | NFXTA_ERRNO =A0 =A0 =A0 | =A0 =A0 int =A0 =A0 =A0 | NL=
A_U32 =A0 =A0 =A0 =A0 | Generic system errno (Exxx) =A0 =A0 =A0 =A0 =A0=
|
> +--------+-------------------+---------------+-----------------+-----=
---------------------------------+
> | =A0... =A0 | NFXTA_XTERRNO =A0 =A0 | =A0 =A0 int =A0 =A0 =A0 | NLA_=
U32 =A0 =A0 =A0 =A0 | NFXT errno (NFXTE_*) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 |
> +--------+-------------------+---------------+-----------------+-----=
---------------------------------+
> | =A0 =A0 =A0 =A0| NFXTA_ERRSTR =A0 =A0 =A0| =A0 char [] =A0 =A0 | NL=
A_NUL_STRING =A0| Arbitrary =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0|
> +--------+-------------------+---------------+-----------------+-----=
---------------------------------+
> | =A0 =A0 =A0 =A0| NFXTA_USERTID =A0 =A0 | unsigned int =A0| NLA_U32 =
=A0 =A0 =A0 =A0 | Arbitrary, retained verbatim =A0 =A0 =A0 =A0 |
> +--------+-------------------+---------------+-----------------+-----=
---------------------------------+
> | =A0 =A0 =A0 =A0| NFXTA_CHAIN_NAME =A0| =A0 char [] =A0 =A0 | NLA_NU=
L_STRING =A0| =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0|
> +--------+-------------------+---------------+-----------------+-----=
---------------------------------+
> | =A0 =A0 =A0 =A0| NFXTA_RULE_IDX =A0 =A0| unsigned int =A0| NLA_U32 =
=A0 =A0 =A0 =A0 | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0|
> +--------+-------------------+---------------+-----------------+-----=
---------------------------------+
> | =A0 =A0 =A0 =A0| NFXTA_ACTION_IDX =A0| unsigned int =A0| NLA_U32 =A0=
 =A0 =A0 =A0 | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0|
> +--------+-------------------+---------------+-----------------+-----=
---------------------------------+
> | =A0 =A0 =A0 =A0| NFXTA_NAME =A0 =A0 =A0 =A0| =A0 char [] =A0 =A0 | =
NLA_NUL_STRING =A0| =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0|
> +--------+-------------------+---------------+-----------------+-----=
---------------------------------+
> | =A0 =A0 =A0 =A0| NFXTA_REVISION =A0 =A0| =A0 uint8_t =A0 =A0 | NLA_=
U32 =A0 =A0 =A0 =A0 | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0|
> +--------+-------------------+---------------+-----------------+-----=
---------------------------------+
> | =A0 =A0 =A0 =A0| NFXTA_HOOKNUM =A0 =A0 | unsigned int =A0| NLA_U32 =
=A0 =A0 =A0 =A0 | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0|
> +--------+-------------------+---------------+-----------------+-----=
---------------------------------+
> | =A0 =A0 =A0 =A0| NFXTA_PRIORITY =A0 =A0| =A0 =A0 int =A0 =A0 =A0 | =
NLA_U32 =A0 =A0 =A0 =A0 | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0|
> +--------+-------------------+---------------+-----------------+-----=
---------------------------------+
> | =A0 =A0 =A0 =A0| NFXTA_NFPROTO =A0 =A0 | =A0 uint8_t =A0 =A0 | NLA_=
U32 =A0 =A0 =A0 =A0 | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0|
> +--------+-------------------+---------------+-----------------+-----=
---------------------------------+
> | =A0 =A0 =A0 =A0| NFXTA_OFFSET =A0 =A0 =A0| unsigned int =A0| NLA_U3=
2 =A0 =A0 =A0 =A0 | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0|
> +--------+-------------------+---------------+-----------------+-----=
---------------------------------+
> | =A0 =A0 =A0 =A0| NFXTA_LENGTH =A0 =A0 =A0| =A0 =A0size_t =A0 =A0 | =
NLA_U32 =A0 =A0 =A0 =A0 | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0|
> +--------+-------------------+---------------+-----------------+-----=
---------------------------------+
> | =A0 =A0 =A0 =A0| NFXTA_HOOKMASK =A0 =A0| unsigned int =A0| NLA_U32 =
=A0 =A0 =A0 =A0 | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0|
> +--------+-------------------+---------------+-----------------+-----=
---------------------------------+
> | =A0 =A0 =A0 =A0| NFXTA_SIZE =A0 =A0 =A0 =A0| =A0 =A0size_t =A0 =A0 =
| NLA_U32 =A0 =A0 =A0 =A0 | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|
> +--------+-------------------+---------------+-----------------+-----=
---------------------------------+
> | =A0 =A0 =A0 =A0| NFXTA_NEW_NAME =A0 =A0| =A0 char [] =A0 =A0 | NLA_=
NUL_STRING =A0| =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0|
> +--------+-------------------+---------------+-----------------+-----=
---------------------------------+


W/r/t the NUL_STRING's -- is there a good reason to use a NUL'd
strings for NAME/etc, given the length is known? Wouldn't it make more
sense to simply require a byte string and apply the null internally? I
see this frequently in Netlink, and imagine it's a kernel consistency
thing?

>
>
> The kernel ignores attributes with value 0 during validation, so
> it was left unused.
>
> 4 Error types<sec:Error-types>
>
>
> +--------+---------------------+-------------------------------------=
------+
> | Value =A0| Mnemonic =A0 =A0 =A0 =A0 =A0 =A0| Description =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 |
> +--------+---------------------+-------------------------------------=
------+
> +--------+---------------------+-------------------------------------=
------+
> | =A0 0 =A0 =A0| NFXTE_SUCCESS =A0 =A0 =A0 | No error =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|
> +--------+---------------------+-------------------------------------=
------+
> | =A0 1 =A0 =A0| NFXTE_CHAIN_EXIST =A0 | Chain already exists =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|
> +--------+---------------------+-------------------------------------=
------+
> | =A0 2 =A0 =A0| NFXTE_CHAIN_NOENT =A0 | Chain does not exist =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|
> +--------+---------------------+-------------------------------------=
------+
> | =A0 3 =A0 =A0| NFXTE_RULESET_LOOP =A0| Ruleset contains a loop =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 |
> +--------+---------------------+-------------------------------------=
------+
> | =A0 4 =A0 =A0| NFXTE_EXT_HOOKMASK =A0| Rule invoked from incompatib=
le hook =A0 =A0 =A0 |
> +--------+---------------------+-------------------------------------=
------+
> | =A0 =A0 =A0 =A0| NFXTE_PROMO_STATUS =A0| Promotion/demotion state a=
lready achieved |
> +--------+---------------------+-------------------------------------=
------+
>
>
> 5 Message types
> ...

My biggest concern here seems as already pointed out -- the use of
STOP && deep nesting in messages;  Every time a STOP occurs in an
internal message, it's semantically equivalent to the completion of an
NF_F_MULTI no?

I see the advantage of a trivial protocol, but wouldn't it be much
simpler to have a 'bigger' protocol (table/chain/rule) with an
optional ATOMIC guarantee?

I don't see anywhere else guaranteeing tables/matches/rules will be
managed (as a set) with atomicity [I'm probably wrong], so doing it in
the protocol feels awkward.

There area  LOT of definitions of atomicity, ordering, etc within this
area, making me feel like doing that 'up one level' and in smaller
pieces might make for more manageable interface

Still, this all looks like phenomenal progress, and I look forward to
seeing it move on.

James
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
