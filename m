From: Jan Engelhardt <jengelh@medozas.de>
Subject: Xtables2 Netlink spec
Date: Wed, 24 Nov 2010 23:29:56 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


By request of Pablo, I am posting the Xtables2 Netlink interface=20
specification for review. Additionally, further documentation and=20
toolchain around it is available through the temporary project page at

	http://jengelh.medozas.de/projects/xtables/

which currently includes

 * User Documentation Chapter 1: Architectural Differences

 * Developer Documentation Part 1: Netlink interface (WIP)
   This is copied below to facilitate inline replies

 * Runnable Linux source tree

 * Runnable userspace library (libnetfilter_xtables)
   with small test-and-debug program

--8<--

Netlink interface

1 General use

1.1 Socket

Xtables2 is usable through a Netlink socket of type=20
NETLINK_XTABLES. No intermediate subsystem like nfnetlink is=20
used, because the kernel's nfnetlink parser does not make all=20
attributes available to (in-kernel) nfnetlink users.

#include <sys/socket.h>
#include <linux/netlink.h>
#define NETFILTER_XTABLES 21

nfxt_socket =3D socket(AF_NETLINK, SOCK_RAW, NETFILTER_XTABLES);

The NETLINK_XTABLES constant is defined in linux/netlink.h with=20
the value 21.

1.2 Message format

All messages transmitted over the Netlink socket are to have the=20
base struct nlmsghdr header, followed by a version tag to allow=20
for the flexibility of data following it:

struct xtnetlink_genhdr {
        uint32_t version;
};

The version member is always 0 in the current implementation.

=46ollowing the genhdr can be any number of standard Netlink=20
attributes (struct nlattr plus their payload).

Often, a logical tree structure is used to describe something,=20
such as for example tables of chains of rules:

filter
 \__ INPUT
 |    \__ some rule
 \__ FORWARD
 |    \__ rule2
 |    \__ rule3
 |    \__ rule4
 \__ OUTPUT
      \__ rule5
      \__ rule6

=46or this document, child objects are always =E2=80=9Cnested=E2=80=9D =
within a=20
parent object, irrespective of the serialized encoding.

There are different ways to encode such a tree structure into a=20
serialized stream. In many Netlink protocols, children attributes=20
are encapsulated (a. k. a. =E2=80=9Cnested=E2=80=9D, though we will avo=
id this=20
term to avoid double-use) and treated as a whole as a parent's=20
opaque data. We will call this format =E2=80=9CEncapsulated Encoding=E2=
=80=9D.

To encode an attribute's length, struct nlattr only has a 16-bit=20
field, which means the attribute header plus payload is limited=20
to 64 KB. This is easily exceedable with the encapsulated=20
encoding as chains are collected rules in a chain, for example.=20
The problem is aggreviated by the kernel's Netlink handler only=20
allocating skbs a page size worth, which in the worst case means=20
that the usable payload for attributes is around 3600 bytes only.=20
In light of xt_u32's private data block being 1984 bytes already,=20
that means that you won't be able to fit two -m u32 invocations=20
nested in a single rule into a dump.

The Xtables2 Netlink protocol however encodes each node as a=20
standalone attribute, to be called Flat Encoding, that is=20
appended (a. k. a. =E2=80=9Cchained=E2=80=9D) to the data stream. This =
makes it=20
possible to split requests and dumps at a finer level than=20
encapsulation would. Above all, it gets extensions the guarantee=20
to have data blocks of a minimum guaranteed size.

Since Netlink messages do have a 32-bit quantity to store the=20
message length, rulesets of roughly up to 4 GB are possibile,=20
which is currently regarded as sufficient. The largest (and=20
meaningful) rulesets seen to date in the industry weighed in at=20
approximately 150 MB.

Whereas attribute nesting automatically provided for boundaries,=20
this is realized using a dummy attribute in the chained approach.=20
Certain attributes can start such a flattened nesting, and=20
NFXTA_STOP terminates it.

2 Attributes

The meaning of attributes depends upon the nesting level in which=20
they appear. Their type however remains the same, such that a=20
single Netlink attribute validation policy object (struct=20
nla_policy) is sufficient.

A table of all known attributes:


+--------+-----------------+---------------+----------------+
| Value  | Mnemonic        |    C type     | NLA type       |
+--------+-----------------+---------------+----------------+
+--------+-----------------+---------------+----------------+
|   1    | NFXTA_STOP      |               | NLA_FLAG       |
+--------+-----------------+---------------+----------------+
|   2    | NFXTA_ERRNO     |     int       | NLA_U32        |
+--------+-----------------+---------------+----------------+
|   3    | NFXTA_NAME      |   char []     | NLA_NUL_STRING |
+--------+-----------------+---------------+----------------+
|   4    | NFXTA_CHAIN     |               | NLA_FLAG       |
+--------+-----------------+---------------+----------------+
|   5    | NFXTA_HOOKNUM   | unsigned int  | NLA_U32        |
+--------+-----------------+---------------+----------------+
|   6    | NFXTA_PRIORITY  |     int       | NLA_U32        |
+--------+-----------------+---------------+----------------+
|   7    | NFXTA_NFPROTO   |   uint8_t     | NLA_U32        |
+--------+-----------------+---------------+----------------+
|        | NFXTA_RULE      |               | NLA_FLAG       |
+--------+-----------------+---------------+----------------+
|        | NFXTA_OFFSET    | unsigned int  | NLA_U32        |
+--------+-----------------+---------------+----------------+
|        | NFXTA_LENGTH    |    size_t     | NLA_U32        |
+--------+-----------------+---------------+----------------+
|        | NFXTA_VERDICT   | unsigned int  | NLA_U32        |
+--------+-----------------+---------------+----------------+
|        | NFXTA_MATCH     |               | NLA_FLAG       |
+--------+-----------------+---------------+----------------+
|        | NFXTA_DATA      |               | NLA_BINARY     |
+--------+-----------------+---------------+----------------+
|        | NFXTA_TARGET    |               | NLA_FLAG       |
+--------+-----------------+---------------+----------------+
|        | NFXTA_JUMP      |   char []     | NLA_NUL_STRING |
+--------+-----------------+---------------+----------------+
|        | NFXTA_GOTO      |   char []     | NLA_NUL_STRING |
+--------+-----------------+---------------+----------------+
|        | NFXTA_REVISION  |   uint8_t     | NLA_U32        |
+--------+-----------------+---------------+----------------+
|        | NFXTA_SIZE      |    size_t     | NLA_U32        |
+--------+-----------------+---------------+----------------+
|        | NFXTA_HOOKMASK  | unsigned int  | NLA_U32        |
+--------+-----------------+---------------+----------------+


The kernel ignores attributes with value 0 during validation, so=20
it was left unused.

2.1 Nest level terminator<sub:nfxta_stop>

This attribute serves to denote the end of a nesting level as=20
introduced by NFXTA_CHAIN, NFXTA_RULE, NFXTA_MATCH or=20
NFXTA_TARGET. It has no data portion.

+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| nla_len =3D 4                   | nla_type =3D NFXTA_STOP         |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

2.2 Dump error code<sub:nfxta_errno>

Once a NLM_F_MULTI dump operation has been started, for example=20
with the NFXTM_CHAIN_DUMP request, Netlink kernel users must=20
always end it successfully with NLMSG_DONE. To convey an error=20
during the dump, Xtables2 will emit a NFXTA_ERRNO attribute into=20
the stream (if it can), emit no further attributes for the=20
request, and cause the dump to stop.

0                   1                   2                   3
0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| nla_len =3D 8                   | nla_type =3D NFXTA_ERRNO        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| int errno;                                                    |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

2.3 Match extension<sub:nfxta_match>

Invocation of a match is represented using the NFXTA_MATCH=20
attribute which starts a nest level. A match attribute must=20
contain two attributes:

=E2=80=A2 NFXTA_NAME: the name of the target extension

=E2=80=A2 NFXTA_DATA: data private to this instance of the extension

0                   1                   2                   3
0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| nla_len =3D 4                   | nla_type =3D NFXTA_MATCH        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| nla_len =3D 4 + payload         | nla_type =3D NFXTA_NAME         |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
=2E                                                               .
=2E name of the extension, e.g. "hashlimit"                       .
=2E                                                               .
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| nla_len =3D 4 + payload         | nla_type =3D NFXTA_DATA         |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
=2E                                                               .
=2E e.g. struct xt_hashlimit_info                                 .
=2E                                                               .
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| nla_len =3D 4                   | nla_type =3D NFXTA_STOP         |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

2.4 Target extension<sub:nfxta_target>

Invocation of a match is represented using the NFXTA_TARGET=20
attribute which starts a nest level. A target attribute must=20
contain two attributes:

=E2=80=A2 NFXTA_NAME: the name of the target extension

=E2=80=A2 NFXTA_DATA: data private to this instance of the extension

0                   1                   2                   3
0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| nla_len =3D 4                   | nla_type =3D NFXTA_TARGET       |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| nla_len =3D 4 + payload         | nla_type =3D NFXTA_NAME         |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
=2E                                                               .
=2E name of the extension, e.g. "TCPMSS"                          .
=2E                                                               .
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| nla_len =3D 4 + payload         | nla_type =3D NFXTA_DATA         |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
=2E                                                               .
=2E e.g. struct xt_tcpmss_info                                    .
=2E                                                               .
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| nla_len =3D 4                   | nla_type =3D NFXTA_STOP         |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

2.5 Rule<sub:nfxta_rule>

A rule is started using the NFXTA_RULE attribute, which starts a=20
nest level, and is ended with an NFXTA_STOP attribute. Rules can=20
contain:

=E2=80=A2 Zero or more match extensions (NFXTA_MATCH..NFXTA_STOP).

=E2=80=A2 Zero or more target extensions (NFXTA_TARGET..NFXTA_STOP).

=E2=80=A2 Zero or one NFXTA_VERDICT attribute that specifies the rule's=
=20
  verdict as data, which can either be NF_ACCEPT or NF_DROP.=20
  (Non-normative notes: The supplied verdict is executed if no=20
  target has reached a verdict on its own. Omission of the=20
  verdict attribute counts as XT_CONTINUE.)

0                   1                   2                   3
0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| nla_len =3D 4                   | nla_type =3D NFXTA_RULE         |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
=2E                                                               .
=2E matches, targets, verdict                                     .
=2E                                                               .
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| nla_len =3D 4                   | nla_type =3D NFXTA_STOP         |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

2.6 Chain<sub:nfxta_chain>

A chain is started using the NFXTA_CHAIN attribute, which starts=20
a nest level, and is ended with an NFXTA_STOP attribute. Chains=20
can contain:

=E2=80=A2 Zero or one of this group of three (=3D specify all three, or=
=20
  none at all), specifying that this chain is a base chain=20
  hooking in at some point:

  =E2=80=93 One NFXTA_HOOKNUM attribute for giving a hook number. This =
is=20
    (unfortunately) dependent on the chosen nfproto, so it is=20
    either NF_INET_*, NF_BR_* or NF_ARP_*.

  =E2=80=93 One NFXTA_PRIORITY attribute.

  =E2=80=93 One NFXTA_NFPROTO attribute that is NFPROTO_*.

=E2=80=A2 Zero or more rules (NFXTA_RULE..NFXTA_STOP).

Example of a fully populated chain:

0                   1                   2                   3
0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| nla_len =3D 4                   | nla_type =3D NFXTA_CHAIN        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| nla_len =3D 8                   | nla_type =3D NFXTA_HOOKNUM      |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| hook number (0..7)                                            |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| nla_len =3D 8                   | nla_type =3D NFXTA_PRIORITY     |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| priority (-2147483648..2147483647)                            |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| nla_len =3D 8                   | nla_type =3D NFXTA_NFPROTO      |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| nfproto value (2=3Dipv4, 3=3Darp, 7=3Dbridge, 10=3Dipv6, 12=3Ddecnet)=
   |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
=2E                                                               .
=2E rules                                                         .
=2E                                                               .
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| nla_len =3D 4                   | nla_type =3D NFXTA_STOP         |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

3 Message types

3.1 IDENTIFYNFXTM_IDENTIFY: Identification

=46irst and foremost a debug command. And to get something=20
(table/chain-independent) that users can glare at (they love=20
doing that).

Request:

=E2=80=A2 nlmsg_type =3D NFXTM_IDENTIFY;

Response:

=E2=80=A2 An NFXTA_NAMENFXTA_NAME attribute contains the name and versi=
on=20
  of the implementation/patchset.

=E2=80=A2 Zero or more attributes of type NFXTA_MATCH, terminated by=20
  NFXTA_STOP, giving meta information about the loaded match=20
  extensions. Per available match, a group of three attributes=20
  follows:

  =E2=80=93 One NFXTA_NAME attribute for the name of the extension

  =E2=80=93 One NFXTA_REVISION attribute to denote the version of the=20
    extension's parameter protocol

  =E2=80=93 One NFXTA_SIZE attribute for the size of its per-instance=20
    data block

=E2=80=A2 Zero or more attributes of type NFXTA_TARGET, terminated by=20
  NFXTA_STOP, giving meta information about the loaded and=20
  available target extensions:

  =E2=80=93 same attributes as with NFXTA_MATCH above

3.2 CHAIN_NEWNFXTM_CHAIN_NEW: Create new chain

Request:

=E2=80=A2 nlmsg_type =3D NFXTM_CHAIN_NEW;

=E2=80=A2 NFXTA_NAME attribute carrying the name of the new chain.

=E2=80=A2 Zero or one of this group of three:

  =E2=80=93 NFXTA_HOOKNUM

  =E2=80=93 NFXTA_PRIORITY

  =E2=80=93 NFXTA_NFPROTO

Response:

=E2=80=A2 Standard ACK.

Remarks:

Right now, a chain can only be promoted to a base chain during=20
creation (as far as the userspace view goes; when the kernel=20
exactly installs the nf_hook_ops is not of concern to userspace),=20
and it can only be demoted by deleting it. Should a=20
NFXTM_CHAIN_PROMOTE be split off the NFXTM_CHAIN_NEW=20
functionality?

3.3 CHAIN_DELNFXTM_CHAIN_DEL: Delete a chain

Request:

=E2=80=A2 nlmsg_type =3D NFXTM_CHAIN_DEL;

=E2=80=A2 NFXTA_NAME attribute carrying the name of the chain to delete

Response:

=E2=80=A2 Standard ACK.

3.4 CHAIN_MOVENFXTM_CHAIN_MOVE: Rename a chain

Request:

=E2=80=A2 nlmsg_type =3D NFXTM_CHAIN_MOVE;

=E2=80=A2 Two NFXTA_NAME attributes (order is important):

  =E2=80=93 First one specifies the current name of the chain

  =E2=80=93 Second one specifies the new name of the chain

0                   1                   2                   3
0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| nlmsg_len =3D at least 24                                       |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| nlmsg_type =3D NFXTM_CHAIN_MOVE | nlmsg_flags =3D NLM_F_REQUEST   |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| nlmsg_seq =3D whatever                                          |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| nlmsg_pid =3D whatever                                          |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| nla_len =3D at least 4          | nla_type =3D NFXTA_NAME         |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
=2E                                                               .
=2E old name                                                      .
=2E                                                               .
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| nla_len =3D at least 4          | nla_type =3D NFXTA_NAME         |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
=2E                                                               .
=2E new name                                                      .
=2E                                                               .
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

3.5 CHAIN_DUMPNFXTM_CHAIN_DUMP: Chain dump

Request:

=E2=80=A2 nlmsg_type =3D NFXTM_CHAIN_DUMP;

=E2=80=A2 NFXTA_NAMENFXTA_NAME attribute specifying the name of the cha=
in=20
  to dump

Response:

=E2=80=A2 Zero or one of this group of three:

  =E2=80=93 NFXTA_HOOKNUMNFXTA_HOOKNUM, NFXTA_PRIORITYNFXTA_PRIORITY,=20
    NFXTA_NFPROTONFXTA_NFPROTO.

=E2=80=A2 Zero or more NFXTA_RULE attributes as per section [sub:nfxta_=
rule]
  .

Errors:

=E2=80=A2 If an error occurs during dump, an NFXTA_ERRNO attribute is=20
  emitted into the stream and the dump will immediately terminate=20
  with a standard NLMSG_DONE message. No NFXTA_STOP attributes=20
  will be emitted if the dump stopped in the middle of a nesting=20
  level.

3.6 TABLE_DUMPNFXTM_TABLE_DUMP: Table dump

Returns an atomic snapshot of the table.

Request:

=E2=80=A2 nlmsg_type =3D NFXTM_TABLE_DUMP;

Response:

=E2=80=A2 Zero or more NFXTA_CHAINNFXTA_CHAIN attributes as described i=
n=20
  section [sub:nfxta_chain].

3.7 CHAIN_SPLICENFXTM_CHAIN_SPLICE: Add/delete rules

The NFXTM_CHAIN_SPLICE request does a bulk deletion of zero or=20
more consecutive rules, followed by a bulk insertion of zero or=20
more consecutive rules, all done in an atomic fashion. It=20
operates similar to Perl's splice function on arrays. The request=20
message needs to have at least the first three attributes.

Request:

=E2=80=A2 NFXTA_NAMENFXTA_NAME: Name of the chain to modify.

=E2=80=A2 NFXTA_OFFSETNFXTA_OFFSET: Index of entry where operation shou=
ld=20
  start.

=E2=80=A2 NFXTA_LENGTHNFXTA_LENGTH: Number of entries starting from=20
  offset that should be removed. May be zero or more.

=E2=80=A2 Zero or more NFXTA_RULENFXTA_RULE as per section [sub:nfxta_r=
ule]
  .

Response:

=E2=80=A2 Standard ACK.

=E2=80=A2 Desired: detailed error code and origin of error (result of=20
  running ->check in extensions)

3.8 TABLE_REPLACENFXTM_TABLE_REPLACE

Atomic exchange of an entire table.

Request:

=E2=80=A2 nlmsg_type =3D NFXTM_TABLE_REPLACE;

=E2=80=A2 Zero or more NFXTA_CHAINNFXTA_CHAIN attributes as per section=
 [sub:nfxta_chain]
  .

Response:

=E2=80=A2 Standard ACK.

=E2=80=A2 Desired: detailed error code and origin of error (result of=20
  running ->check in extensions)
