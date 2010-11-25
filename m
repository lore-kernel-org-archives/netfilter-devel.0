From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Xtables2 Netlink spec
Date: Thu, 25 Nov 2010 12:42:12 +0100
Message-ID: <4CEE4B94.8010307@netfilter.org>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47448 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802Ab0KYLlq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Nov 2010 06:41:46 -0500
In-Reply-To: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

I have trimmed the CC to netfilter, I don't think this deserves=20
attention to users, not yet at least.

Some quick impressions on your proposal:

On 24/11/10 23:29, Jan Engelhardt wrote:
>
> By request of Pablo, I am posting the Xtables2 Netlink interface
> specification for review. Additionally, further documentation and
> toolchain around it is available through the temporary project page a=
t
>
> 	http://jengelh.medozas.de/projects/xtables/
>
> which currently includes
>
>   * User Documentation Chapter 1: Architectural Differences
>
>   * Developer Documentation Part 1: Netlink interface (WIP)
>     This is copied below to facilitate inline replies
>
>   * Runnable Linux source tree
>
>   * Runnable userspace library (libnetfilter_xtables)
>     with small test-and-debug program
>
> --8<--
>
> Netlink interface
>
> 1 General use
>
> 1.1 Socket
>
> Xtables2 is usable through a Netlink socket of type
> NETLINK_XTABLES. No intermediate subsystem like nfnetlink is
> used, because the kernel's nfnetlink parser does not make all
> attributes available to (in-kernel) nfnetlink users.
>
> #include<sys/socket.h>
> #include<linux/netlink.h>
> #define NETFILTER_XTABLES 21
>
> nfxt_socket =3D socket(AF_NETLINK, SOCK_RAW, NETFILTER_XTABLES);
>
> The NETLINK_XTABLES constant is defined in linux/netlink.h with
> the value 21.

This has to go upon nfnetlink as other netfilter subsystems.

> 1.2 Message format
>
> All messages transmitted over the Netlink socket are to have the
> base struct nlmsghdr header, followed by a version tag to allow
> for the flexibility of data following it:
>
> struct xtnetlink_genhdr {
>          uint32_t version;
> };
>
> The version member is always 0 in the current implementation.
>
> Following the genhdr can be any number of standard Netlink
> attributes (struct nlattr plus their payload).
>
> Often, a logical tree structure is used to describe something,
> such as for example tables of chains of rules:
>
> filter
>   \__ INPUT
>   |    \__ some rule
>   \__ FORWARD
>   |    \__ rule2
>   |    \__ rule3
>   |    \__ rule4
>   \__ OUTPUT
>        \__ rule5
>        \__ rule6
>
> For this document, child objects are always =E2=80=9Cnested=E2=80=9D =
within a
> parent object, irrespective of the serialized encoding.
>
> There are different ways to encode such a tree structure into a
> serialized stream. In many Netlink protocols, children attributes
> are encapsulated (a. k. a. =E2=80=9Cnested=E2=80=9D, though we will a=
void this
> term to avoid double-use) and treated as a whole as a parent's
> opaque data. We will call this format =E2=80=9CEncapsulated Encoding=E2=
=80=9D.
>
> To encode an attribute's length, struct nlattr only has a 16-bit
> field, which means the attribute header plus payload is limited
> to 64 KB. This is easily exceedable with the encapsulated
> encoding as chains are collected rules in a chain, for example.
> The problem is aggreviated by the kernel's Netlink handler only
> allocating skbs a page size worth, which in the worst case means
> that the usable payload for attributes is around 3600 bytes only.
> In light of xt_u32's private data block being 1984 bytes already,
> that means that you won't be able to fit two -m u32 invocations
> nested in a single rule into a dump.
 >
> The Xtables2 Netlink protocol however encodes each node as a
> standalone attribute, to be called Flat Encoding, that is
> appended (a. k. a. =E2=80=9Cchained=E2=80=9D) to the data stream. Thi=
s makes it
> possible to split requests and dumps at a finer level than
> encapsulation would. Above all, it gets extensions the guarantee
> to have data blocks of a minimum guaranteed size.
 >
> Since Netlink messages do have a 32-bit quantity to store the
> message length, rulesets of roughly up to 4 GB are possibile,
> which is currently regarded as sufficient. The largest (and
> meaningful) rulesets seen to date in the industry weighed in at
> approximately 150 MB.

You can split data into several messages and avoid this limitation.

> Whereas attribute nesting automatically provided for boundaries,
> this is realized using a dummy attribute in the chained approach.
> Certain attributes can start such a flattened nesting, and
> NFXTA_STOP terminates it.

I don't like this trailing attribute, see below.

> 2 Attributes
>
> The meaning of attributes depends upon the nesting level in which
> they appear. Their type however remains the same, such that a
> single Netlink attribute validation policy object (struct
> nla_policy) is sufficient.
>
> A table of all known attributes:
>
> +--------+-----------------+---------------+----------------+
> | Value  | Mnemonic        |    C type     | NLA type       |
> +--------+-----------------+---------------+----------------+
> +--------+-----------------+---------------+----------------+
> |   1    | NFXTA_STOP      |               | NLA_FLAG       |
> +--------+-----------------+---------------+----------------+
> |   2    | NFXTA_ERRNO     |     int       | NLA_U32        |
> +--------+-----------------+---------------+----------------+
> |   3    | NFXTA_NAME      |   char []     | NLA_NUL_STRING |
> +--------+-----------------+---------------+----------------+
> |   4    | NFXTA_CHAIN     |               | NLA_FLAG       |
> +--------+-----------------+---------------+----------------+
> |   5    | NFXTA_HOOKNUM   | unsigned int  | NLA_U32        |
> +--------+-----------------+---------------+----------------+
> |   6    | NFXTA_PRIORITY  |     int       | NLA_U32        |
> +--------+-----------------+---------------+----------------+
> |   7    | NFXTA_NFPROTO   |   uint8_t     | NLA_U32        |
> +--------+-----------------+---------------+----------------+
> |        | NFXTA_RULE      |               | NLA_FLAG       |
> +--------+-----------------+---------------+----------------+
> |        | NFXTA_OFFSET    | unsigned int  | NLA_U32        |
> +--------+-----------------+---------------+----------------+
> |        | NFXTA_LENGTH    |    size_t     | NLA_U32        |
> +--------+-----------------+---------------+----------------+
> |        | NFXTA_VERDICT   | unsigned int  | NLA_U32        |
> +--------+-----------------+---------------+----------------+
> |        | NFXTA_MATCH     |               | NLA_FLAG       |
> +--------+-----------------+---------------+----------------+
> |        | NFXTA_DATA      |               | NLA_BINARY     |
> +--------+-----------------+---------------+----------------+
> |        | NFXTA_TARGET    |               | NLA_FLAG       |
> +--------+-----------------+---------------+----------------+
> |        | NFXTA_JUMP      |   char []     | NLA_NUL_STRING |
> +--------+-----------------+---------------+----------------+
> |        | NFXTA_GOTO      |   char []     | NLA_NUL_STRING |
> +--------+-----------------+---------------+----------------+
> |        | NFXTA_REVISION  |   uint8_t     | NLA_U32        |
> +--------+-----------------+---------------+----------------+
> |        | NFXTA_SIZE      |    size_t     | NLA_U32        |
> +--------+-----------------+---------------+----------------+
> |        | NFXTA_HOOKMASK  | unsigned int  | NLA_U32        |
> +--------+-----------------+---------------+----------------+
>
>
> The kernel ignores attributes with value 0 during validation, so
> it was left unused.
>
> 2.1 Nest level terminator<sub:nfxta_stop>
>
> This attribute serves to denote the end of a nesting level as
> introduced by NFXTA_CHAIN, NFXTA_RULE, NFXTA_MATCH or
> NFXTA_TARGET. It has no data portion.
>
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> | nla_len =3D 4                   | nla_type =3D NFXTA_STOP         |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

It's not a good idea to make assumptions on the order of the TLVs in a=20
Netlink message. I mean, you should not assume that NFXTA_STOP comes=20
after one specific attribute.

> 2.2 Dump error code<sub:nfxta_errno>
>
> Once a NLM_F_MULTI dump operation has been started, for example
> with the NFXTM_CHAIN_DUMP request, Netlink kernel users must
> always end it successfully with NLMSG_DONE. To convey an error
> during the dump, Xtables2 will emit a NFXTA_ERRNO attribute into
> the stream (if it can), emit no further attributes for the
> request, and cause the dump to stop.
>
> 0                   1                   2                   3
> 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> | nla_len =3D 8                   | nla_type =3D NFXTA_ERRNO        |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> | int errno;                                                    |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

Isn't nlmsg_err OK for your needs?

> 2.3 Match extension<sub:nfxta_match>
>
> Invocation of a match is represented using the NFXTA_MATCH
> attribute which starts a nest level. A match attribute must
> contain two attributes:
>
> =E2=80=A2 NFXTA_NAME: the name of the target extension
>
> =E2=80=A2 NFXTA_DATA: data private to this instance of the extension
>
> 0                   1                   2                   3
> 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> | nla_len =3D 4                   | nla_type =3D NFXTA_MATCH        |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> | nla_len =3D 4 + payload         | nla_type =3D NFXTA_NAME         |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> .                                                               .
> . name of the extension, e.g. "hashlimit"                       .
> .                                                               .
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> | nla_len =3D 4 + payload         | nla_type =3D NFXTA_DATA         |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> .                                                               .
> . e.g. struct xt_hashlimit_info

This is fine during some transition period, but Netlink protocols must=20
not encapsulate structures in the payload of their TLVs.
                                 .
> .                                                               .
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> | nla_len =3D 4                   | nla_type =3D NFXTA_STOP         |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>
> 2.4 Target extension<sub:nfxta_target>
>
> Invocation of a match is represented using the NFXTA_TARGET
> attribute which starts a nest level. A target attribute must
> contain two attributes:
>
> =E2=80=A2 NFXTA_NAME: the name of the target extension
>
> =E2=80=A2 NFXTA_DATA: data private to this instance of the extension
> 0                   1                   2                   3
> 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> | nla_len =3D 4                   | nla_type =3D NFXTA_TARGET       |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> | nla_len =3D 4 + payload         | nla_type =3D NFXTA_NAME         |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> .                                                               .
> . name of the extension, e.g. "TCPMSS"                          .
> .                                                               .
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> | nla_len =3D 4 + payload         | nla_type =3D NFXTA_DATA         |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> .                                                               .
> . e.g. struct xt_tcpmss_info

same comment as above.
                                     .
> .                                                               .
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> | nla_len =3D 4                   | nla_type =3D NFXTA_STOP         |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>
> 2.5 Rule<sub:nfxta_rule>
>
> A rule is started using the NFXTA_RULE attribute, which starts a
> nest level, and is ended with an NFXTA_STOP attribute. Rules can
> contain:
>
> =E2=80=A2 Zero or more match extensions (NFXTA_MATCH..NFXTA_STOP).
>
> =E2=80=A2 Zero or more target extensions (NFXTA_TARGET..NFXTA_STOP).
>
> =E2=80=A2 Zero or one NFXTA_VERDICT attribute that specifies the rule=
's
>    verdict as data, which can either be NF_ACCEPT or NF_DROP.
>    (Non-normative notes: The supplied verdict is executed if no
>    target has reached a verdict on its own. Omission of the
>    verdict attribute counts as XT_CONTINUE.)
>
> 0                   1                   2                   3
> 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> | nla_len =3D 4                   | nla_type =3D NFXTA_RULE         |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> .                                                               .
> . matches, targets, verdict                                     .
> .                                                               .
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> | nla_len =3D 4                   | nla_type =3D NFXTA_STOP         |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>
> 2.6 Chain<sub:nfxta_chain>
>
> A chain is started using the NFXTA_CHAIN attribute, which starts
> a nest level, and is ended with an NFXTA_STOP attribute. Chains
> can contain:
>
> =E2=80=A2 Zero or one of this group of three (=3D specify all three, =
or
>    none at all), specifying that this chain is a base chain
>    hooking in at some point:
>
>    =E2=80=93 One NFXTA_HOOKNUM attribute for giving a hook number. Th=
is is
>      (unfortunately) dependent on the chosen nfproto, so it is
>      either NF_INET_*, NF_BR_* or NF_ARP_*.
>
>    =E2=80=93 One NFXTA_PRIORITY attribute.
>
>    =E2=80=93 One NFXTA_NFPROTO attribute that is NFPROTO_*.
>
> =E2=80=A2 Zero or more rules (NFXTA_RULE..NFXTA_STOP).
>
> Example of a fully populated chain:
>
> 0                   1                   2                   3
> 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> | nla_len =3D 4                   | nla_type =3D NFXTA_CHAIN        |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> | nla_len =3D 8                   | nla_type =3D NFXTA_HOOKNUM      |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> | hook number (0..7)                                            |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> | nla_len =3D 8                   | nla_type =3D NFXTA_PRIORITY     |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> | priority (-2147483648..2147483647)                            |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> | nla_len =3D 8                   | nla_type =3D NFXTA_NFPROTO      |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> | nfproto value (2=3Dipv4, 3=3Darp, 7=3Dbridge, 10=3Dipv6, 12=3Ddecne=
t)   |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> .                                                               .
> . rules                                                         .
> .                                                               .
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> | nla_len =3D 4                   | nla_type =3D NFXTA_STOP         |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>
> 3 Message types
>
> 3.1 IDENTIFYNFXTM_IDENTIFY: Identification
>
> First and foremost a debug command. And to get something
> (table/chain-independent) that users can glare at (they love
> doing that).
>
> Request:
>
> =E2=80=A2 nlmsg_type =3D NFXTM_IDENTIFY;
>
> Response:
>
> =E2=80=A2 An NFXTA_NAMENFXTA_NAME attribute contains the name and ver=
sion
>    of the implementation/patchset.
>
> =E2=80=A2 Zero or more attributes of type NFXTA_MATCH, terminated by
>    NFXTA_STOP, giving meta information about the loaded match
>    extensions. Per available match, a group of three attributes
>    follows:
>
>    =E2=80=93 One NFXTA_NAME attribute for the name of the extension
>
>    =E2=80=93 One NFXTA_REVISION attribute to denote the version of th=
e
>      extension's parameter protocol
>
>    =E2=80=93 One NFXTA_SIZE attribute for the size of its per-instanc=
e
>      data block

We can avoid this if structures are splitted into several TLVs. You can=
=20
add new attributes and obsolete old ones.

> =E2=80=A2 Zero or more attributes of type NFXTA_TARGET, terminated by
>    NFXTA_STOP, giving meta information about the loaded and
>    available target extensions:
>
>    =E2=80=93 same attributes as with NFXTA_MATCH above
>
> 3.2 CHAIN_NEWNFXTM_CHAIN_NEW: Create new chain
>
> Request:
>
> =E2=80=A2 nlmsg_type =3D NFXTM_CHAIN_NEW;
>
> =E2=80=A2 NFXTA_NAME attribute carrying the name of the new chain.
>
> =E2=80=A2 Zero or one of this group of three:
>
>    =E2=80=93 NFXTA_HOOKNUM
>
>    =E2=80=93 NFXTA_PRIORITY
>
>    =E2=80=93 NFXTA_NFPROTO
>
> Response:
>
> =E2=80=A2 Standard ACK.
>
> Remarks:
>
> Right now, a chain can only be promoted to a base chain during
> creation (as far as the userspace view goes; when the kernel
> exactly installs the nf_hook_ops is not of concern to userspace),
> and it can only be demoted by deleting it. Should a
> NFXTM_CHAIN_PROMOTE be split off the NFXTM_CHAIN_NEW
> functionality?
>
> 3.3 CHAIN_DELNFXTM_CHAIN_DEL: Delete a chain
>
> Request:
>
> =E2=80=A2 nlmsg_type =3D NFXTM_CHAIN_DEL;
>
> =E2=80=A2 NFXTA_NAME attribute carrying the name of the chain to dele=
te
>
> Response:
>
> =E2=80=A2 Standard ACK.
>
> 3.4 CHAIN_MOVENFXTM_CHAIN_MOVE: Rename a chain
>
> Request:
>
> =E2=80=A2 nlmsg_type =3D NFXTM_CHAIN_MOVE;
>
> =E2=80=A2 Two NFXTA_NAME attributes (order is important):
>
>    =E2=80=93 First one specifies the current name of the chain
>
>    =E2=80=93 Second one specifies the new name of the chain
>
> 0                   1                   2                   3
> 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> | nlmsg_len =3D at least 24                                       |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> | nlmsg_type =3D NFXTM_CHAIN_MOVE | nlmsg_flags =3D NLM_F_REQUEST   |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> | nlmsg_seq =3D whatever                                          |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> | nlmsg_pid =3D whatever                                          |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> | nla_len =3D at least 4          | nla_type =3D NFXTA_NAME         |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> .                                                               .
> . old name                                                      .
> .                                                               .
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> | nla_len =3D at least 4          | nla_type =3D NFXTA_NAME         |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> .                                                               .
> . new name                                                      .
> .                                                               .
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>
> 3.5 CHAIN_DUMPNFXTM_CHAIN_DUMP: Chain dump
>
> Request:
>
> =E2=80=A2 nlmsg_type =3D NFXTM_CHAIN_DUMP;
>
> =E2=80=A2 NFXTA_NAMENFXTA_NAME attribute specifying the name of the c=
hain
>    to dump
>
> Response:
>
> =E2=80=A2 Zero or one of this group of three:
>
>    =E2=80=93 NFXTA_HOOKNUMNFXTA_HOOKNUM, NFXTA_PRIORITYNFXTA_PRIORITY=
,
>      NFXTA_NFPROTONFXTA_NFPROTO.
>
> =E2=80=A2 Zero or more NFXTA_RULE attributes as per section [sub:nfxt=
a_rule]
>    .
>
> Errors:
>
> =E2=80=A2 If an error occurs during dump, an NFXTA_ERRNO attribute is
>    emitted into the stream and the dump will immediately terminate
>    with a standard NLMSG_DONE message. No NFXTA_STOP attributes
>    will be emitted if the dump stopped in the middle of a nesting
>    level.
>
> 3.6 TABLE_DUMPNFXTM_TABLE_DUMP: Table dump
>
> Returns an atomic snapshot of the table.
>
> Request:
>
> =E2=80=A2 nlmsg_type =3D NFXTM_TABLE_DUMP;
>
> Response:
>
> =E2=80=A2 Zero or more NFXTA_CHAINNFXTA_CHAIN attributes as described=
 in
>    section [sub:nfxta_chain].
>
> 3.7 CHAIN_SPLICENFXTM_CHAIN_SPLICE: Add/delete rules
>
> The NFXTM_CHAIN_SPLICE request does a bulk deletion of zero or
> more consecutive rules, followed by a bulk insertion of zero or
> more consecutive rules, all done in an atomic fashion. It
> operates similar to Perl's splice function on arrays. The request
> message needs to have at least the first three attributes.
>
> Request:
>
> =E2=80=A2 NFXTA_NAMENFXTA_NAME: Name of the chain to modify.
>
> =E2=80=A2 NFXTA_OFFSETNFXTA_OFFSET: Index of entry where operation sh=
ould
>    start.
>
> =E2=80=A2 NFXTA_LENGTHNFXTA_LENGTH: Number of entries starting from
>    offset that should be removed. May be zero or more.
>
> =E2=80=A2 Zero or more NFXTA_RULENFXTA_RULE as per section [sub:nfxta=
_rule]
>    .
>
> Response:
>
> =E2=80=A2 Standard ACK.
>
> =E2=80=A2 Desired: detailed error code and origin of error (result of
>    running ->check in extensions)
>
> 3.8 TABLE_REPLACENFXTM_TABLE_REPLACE
>
> Atomic exchange of an entire table.
>
> Request:
>
> =E2=80=A2 nlmsg_type =3D NFXTM_TABLE_REPLACE;
>
> =E2=80=A2 Zero or more NFXTA_CHAINNFXTA_CHAIN attributes as per secti=
on [sub:nfxta_chain]
>    .
>
> Response:
>
> =E2=80=A2 Standard ACK.
>
> =E2=80=A2 Desired: detailed error code and origin of error (result of
>    running ->check in extensions)

That's all by now. Quite exhaustive, thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
