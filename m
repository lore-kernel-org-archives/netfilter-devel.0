From: Jan Engelhardt <jengelh@medozas.de>
Subject: Xtables2 A7 spec draft
Date: Wed, 2 Feb 2011 23:04:01 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1102011817480.7729@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38380 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754043Ab1BBWEC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Feb 2011 17:04:02 -0500
Received: from localhost (localhost [127.0.0.1])
	by borg.medozas.de (Postfix) with ESMTP id 29704673C
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Feb 2011 23:04:01 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



I am posting the Xtables2 Netlink interface specification, draft 7
for comments.

Additionally, further documentation and toolchain around
it is available through the project page at

	http://jengelh.medozas.de/projects/xtables/

 * User Documentation Chapter 1: Architectural Differences
 * Developer Documentation Part 1: Netlink interface (WIP)
   This is copied below to facilitate inline replies
--8<--

Netlink interface

1 Concepts

This section is non-normative and should instead show the flow of=20
thought and give reasons as to why the specification was=20
conceived the way it is, and where the component problems are.

1.1 Nesting representation

The common element in Xtables is the ruleset, represented as a=20
tree structure with ordering constraints at some levels:

ruleset (unordered tables)
 \__ table (unordered chains)
 |    \__ chain (ordered rules)
 |    |    \__ rule (ordered actions)
 |    |    |    \__ match (unordered data)
 |    |    |    |    \__ config-data
 |    |    |    |    |    \__ bin params
 |    |    |    |    \__ state-data
 |    |    |    |         \__ nlattrs
 |    |    |    \__ match...
 |    |    |    \__ target (unordered data)
 |    |    |    |    \__ config-data
 |    |    |    \__ target...
 |    |    |    \__ verdict...
 |    |    \__ rule...
 |    \__ chain...
 \__ table...

A more concrete example, here is a small ruleset, encoded into=20
XML (just one of many possible representations):

<table>
  <chain name=3D"INPUT">
    <rule idx=3D"1">
      <match acidx=3D"1" name=3D"hashlimit" rev=3D"1" csize=3D"120">
        <config-data>...</config-data>
        <state-data>...</state-data>
      </match>
      <target acidx=3D"2" name=3D"TOS" rev=3D"1">
        ...
      </target>
      <verdict acidx=3D"3" name=3D"ACCEPT" />
    </rule>
  </chain>
</table>

There are different ways to encode such a tree structure into a=20
serialized stream. In many Netlink protocols, children attributes=20
are encapsulated (a. k. a. =E2=80=9Cnested=E2=80=9D, though we will avo=
id this=20
term to avoid double-use) and treated as a whole as a parent's=20
opaque data. It cannot be told apart from normal data. (Like=20
writing =E2=80=9C<chain> &lt;rule&gt; ... &lt;/rule&gt; </chain>=E2=80=9D=
 in=20
XML.) We will call this format =E2=80=9CEncapsulated Encoding=E2=80=9D.

To encode an attribute's length, struct nlattr only has a 16-bit=20
field, which means the attribute header plus payload is limited=20
to 64 KB. This is easily exceedable with the encapsulated=20
encoding as chains are collected rules in a chain, for example.=20
The problem is aggreviated by the kernel's Netlink handler only=20
allocating sk_buffs a page size worth, which leaves few room for=20
extension data. In the worst case, the usable payload for=20
attributes is around 3600 bytes only. In light of xt_u32's=20
private data block being 1984 bytes already, that means that you=20
won't be able to fit two -m u32 invocations nested in a single=20
rule into a dump.

Certain voices in the community call for the obsoletion of such=20
data blobs and replace them by Netlink attributes; there are no=20
objections to doing so. However, the problem of size-limited=20
sk_buffs applies to opaque data of any kind, and Netlink=20
attributes fall within that.

The Xtables2 Netlink protocol encodes each node of information as=20
a standalone attribute, to be called Flat Encoding, that is=20
appended (a. k. a. =E2=80=9Cchained=E2=80=9D) to the data stream. By av=
oiding=20
encapsulated attributes, it is possible to split messages at much=20
finer levels, and provides for attributes that happen to use=20
opaque data with a maximally-sized buffer.

1.2 Nest markers<sub:Nest-markers>

Since Netlink messages do have a 32-bit quantity to store the=20
message length, rulesets of roughly up to 4 GB are possibile,=20
which is currently regarded as sufficient. The largest (while=20
still being meaningful) rulesets seen to date in the industry=20
weighed in at approximately 150 MB.

Whereas encapsulated attribute encoding automatically provided=20
for boundaries, this is realized using dummy attributes in the=20
chained approach. The start of a nesting level can be implicitly=20
represented by the presence of the attribute that would have=20
otherwise been used for encapsulated nesting. For declaring an=20
end of a nest level, an extra attribute is needed:

=E2=80=A2 =E2=80=9Cchain { rule; rule; ... }=E2=80=9D \Leftrightarrow C=
HAIN RULE RULE ...=20
  STOP

1.3 Attribute limitations in nfnetlink

Netlink, being just a base protocol, does not specify what comes=20
after the nlmsghdr, or how it is ordered. This is left up to the=20
subprotocols based on Netlink. nfnetlink has two effective=20
shortcomings (due to its parser) that shall be held in mind:

=E2=80=A2 Attribute ordering is ignored and lost

=E2=80=A2 No support for more than one attribute with the same type=20
  within a message

struct nlattr **tb;
nla_for_each_attr(attr, head, ...)
        tb[nla_type(attr)] =3D attr;

This kills the idea of being able to do, for example, a table=20
replace, in a single Netlink request message. This is like having=20
to split an XML file at every tag simply because two tags can=20
carry the same attribute. So Netlink requests have to be broken=20
down into many many tiny parts and extra state has to be kept=20
around in the kernel.

put_header(msg, NFXTM_TABLE_REPLACE);
foreach (rule)
        put(msg, rule);
send(sock, msg);

will become

put_header(msg, NFXTM_TABLE_REPLACE);
send(sock, msg);
foreach (rule) {
        clean(msg);
        put_header(msg, NFXTM_RULE_DATA);
        put(msg, rule);
        send(sock, msg);
}
clean(msg);
put_header(msg, NFXTM_COMMIT);
send(sock, msg);

or worse. In other words, the fact that the kernel side will use=20
a temporary table (an implementation detail) will be exposed to=20
userspace, which is bad too.

1.4 Summary of transform<sub:Summary-of-transform>

Essentially there is a 1:1 transform on the XML-like tree shown=20
above, to:

NFXTM_CHAIN_ENTRY<name=3DINPUT,usertid=3D1>
  NFXTM_RULE_ENTRY<idx=3D1,usertid=3D1>
    NFXTM_MATCH_ENTRY<acidx=3D1,name=3Dhashlimit,rev=3D1,usertid=3D2>
      NFXTM_CONFIG_DATA
        NFXTM_ARB_DATA<whatever>
        NFXTM_ARB_DATA<more arbitrary data>
      NFXTM_STOP
      NFXTM_STATE_DATA
        NFXTM_ATTR_DATA<nlattrs>
        NFXTM_ATTR_DATA<more nlattrs>
      NFXTM_STOP
    NFXTM_STOP
    NFXTM_TARGET_ENTRY<acidx=3D2,name=3DTOS,rev=3D0,usertid=3D3>
      ...
    NFXTM_STOP
    NFXTM_VERDICT_ENTRY<acidx=3D3,name=3DACCEPT,usertid=3D3>
    NFXTM_STOP
  NFXTM_STOP
NFXTM_STOP

1.5 Extra sequence numbers<sub:Extra-sequence-numbers>

Netlink also does not specify any message ordering, though it=20
does provide an nlmsg_seq field with which message order can at=20
least be determined. The problem is that nothing specifies what=20
nlmsg_seq should be in reply messages. It is assumed that the=20
sequence number is linked, i. e. that a reply's number should be=20
the same as the request's number, to do message matching (vague=20
hint by netlink(7) manpage).

Even if that were decidedly so, that brings along a problem. In=20
NLM_F_MULTI-style dumps, all messages would have the same=20
nlmsg_seq. To counter this, multi messages will have an=20
NFXT-specific sequence counter (NFXTA_SEQNO) in addition,=20
especially since ordering is so much more crucial in Xtables than=20
it is in other parts of networking.

1.6 Improved granularity error reporting

Xtables extensions as of Linux 2.6.37 can only return system=20
error codes back to userspace in case there is a problem. The=20
most common occurrences are, for example, ENOMEM (=E2=80=9CMemory=20
allocation failure=E2=80=9D / =E2=80=9COut of memory=E2=80=9D), and the=
 dreaded EINVAL (=E2=80=9C
Invalid argument=E2=80=9D). Best practices at the moment are to printk =
a=20
string to the kernel log for further information detailing the=20
circumstances about the cause of EINVAL. In the light of this=20
overload of EINVAL, an improved error reporting scheme is sought.=20
(Other networking subsystems also suffer from this problem.)

By suggestion of Jozsef Kadlecsik, the Xtables2 protocol reports=20
three kinds of errors:

=E2=80=A2 General/standard (integer) error codes, where there is no poi=
nt=20
  (or cannot be) to specify the nature of the error exactly. Like=20
  in the example, ENOMEM: it is needles to report which new data=20
  field could not be allocated.

=E2=80=A2 General Xtables2 error codes (largely replaces EINVAL sites) =
in=20
  integer form, similar to errno. Use cases include:

  =E2=80=93 chain for a requested operation does not exist

  =E2=80=93 an extension is used from a hook it is not supposed to be

=E2=80=A2 Free-form string. Standalone, or in addition to the above.
It is impossible to provision error numbers for extensions,=20
  especially those that are out-of-tree. The problems that=20
  forcing a component to reuse another component's error code=20
  space can be seen in the overuse of EINVAL. We are aware that=20
  raw strings in kernel modules can hinder internationalization,=20
  but it is seen as the better choice over awkward error codes=20
  that convey nothing. It is also expected that strings do not=20
  change that often.

The three error types will be conveyed by three distinct=20
attributes: NFXTA_ERRNO (generic error codes), NFXTA_XTERRNO (xt2=20
error codes), and NFXTA_ERRSTR (free-form string).

  Error pointer

Once a table/chain splice request has been finalized,=20
xt_check_{match,target} is run, which can return:

=E2=80=A2 chain name, rule index, match/target index, NFXTE_*/custom=20
  string

  Line number

I noticed Jozsef has added a line number attribute in ipset=20
version 5 to facilitate locating errors for users. For its=20
apparent value, such attribute is also specified for xtnetlink:

A request message can contain a =E2=80=9Cping attribute=E2=80=9D, NFXTA=
_USERTID,=20
which xtnetlink may keep track of and which may be reported back=20
verbatim in case an error occured. It may be used to represent=20
the source line, or any other number.

=E2=80=A2 For the tree example in section 1, the ruleset file would be =
=E2=80=9C
  -A INPUT \
-m hashlimit ... \
-j TOS ... -j ACCEPT=E2=80=9D.

1.7 Multi-type responses

Using multi-type responses provides for a seemingly shorter reply=20
(in at least one case) than not doing so:

=E2=80=A2 \RightarrowNFXTM_CHAIN_DUMP<NFXTA_NAME>
\LeftarrowNFXTM_RULE_START<>
\LeftarrowNFXTM_EMATCH<NFXTA_NAME, NFXTA_REVISION, NFXTA_DATA>
\LeftarrowNFXTM_EMATCH<NFXTA_NAME, NFXTA_REVISION, NFXTA_DATA>
\LeftarrowNFXTM_ETARGET<NFXTA_NAME, NFXTA_REVISION, NFXTA_DATA>
\LeftarrowNFXTM_ETARGET<NFXTA_NAME, NFXTA_REVISION, NFXTA_DATA>
\LeftarrowNFXTM_RULE_END<>
\LeftarrowNFXTM_RULE_START<>
\LeftarrowNFXTM_ETARGET<NFXTA_VERDICT>
\LeftarrowNFXTM_RULE_END<>
\LeftarrowNLMSG_DONE

=E2=80=A2 \RightarrowCHAIN_DUMP<NFXTA_NAME>
\LeftarrowCHAIN_DUMP<NFXTA_RULE_START>
\LeftarrowCHAIN_DUMP<NFXTA_MATCH_START>
\LeftarrowCHAIN_DUMP<NFXTA_NAME, NFXTA_REVISION, NFXTA_DATA>
\LeftarrowCHAIN_DUMP<NFXTA_MATCH_END>
\LeftarrowCHAIN_DUMP<NFXTA_MATCH_START>
\LeftarrowCHAIN_DUMP<NFXTA_NAME, NFXTA_REVISION, NFXTA_DATA>
\LeftarrowCHAIN_DUMP<NFXTA_MATCH_END>
\LeftarrowCHAIN_DUMP<NFXTA_TARGET_START>
\LeftarrowCHAIN_DUMP<NFXTA_NAME, NFXTA_REVISION, NFXTA_DATA>
\LeftarrowCHAIN_DUMP<NFXTA_TARGET_END>
\LeftarrowCHAIN_DUMP<NFXTA_TARGET_START>
\LeftarrowCHAIN_DUMP<NFXTA_NAME, NFXTA_REVISION, NFXTA_DATA>
\LeftarrowCHAIN_DUMP<NFXTA_TARGET_END>
\LeftarrowCHAIN_DUMP<NFXTA_RULE_END>
\LeftarrowCHAIN_DUMP<NFXTA_RULE_START>
\LeftarrowCHAIN_DUMP<NFXTA_TARGET_START>
\LeftarrowCHAIN_DUMP<NFXTA_VERDICT>
\LeftarrowCHAIN_DUMP<NFXTA_TARGET_END>
\LeftarrowCHAIN_DUMP<NFXTA_RULE_END>
\LeftarrowNLMSG_DONE

2 General use

2.1 Socket

Xtables2 is made available through an nfnetlink socket.=20
Specifically, this is a Netlink socket of type NETLINK_NETFILTER,=20
with which messages are exchanged that are tagged having Xtables=20
as the subsystem.

#include <sys/socket.h>
#include <linux/netlink.h>

struct nlmsghdr nlmsg;
int nf_socket =3D socket(AF_NETLINK, SOCK_RAW,=20
NETFILTER_NETFILTER);
nlmsg.nlmsg_type =3D (NFNL_SUBSYS_XTABLES << 8) | xt_msg_type;

2.2 Message format

All messages transmitted over the Netlink socket are to have the=20
base struct nlmsghdr header, followed by a struct nfgenmsg header=20
as mandated by nfnetlink. The .nfgen_family member is always set=20
to NFPROTO_UNSPEC. The .version member denotes the format of the=20
byte stream following nfgenmsg; this is currently version 0. The=20
=2Eres_id member is unused.

3 Attributes

The meaning of attributes depends upon the message and logical=20
nesting level in which they appear. Their type however remains=20
the same, such that a single Netlink attribute validation policy=20
object (struct nla_policy) can be used for all message types.

A table of all known attributes:


+--------+-------------------+---------------+-----------------+-------=
-------------------------------+
| Value  | Mnemonic          |    C type     | NLA type        | Notes =
                               |
+--------+-------------------+---------------+-----------------+-------=
-------------------------------+
+--------+-------------------+---------------+-----------------+-------=
-------------------------------+
|   1    | NFXTA_SEQNO       | unsigned int  | NLA_U32         | Sectio=
n [sub:Extra-sequence-numbers] |
+--------+-------------------+---------------+-----------------+-------=
-------------------------------+
|  tba   | NFXTA_ERRNO       |     int       | NLA_U32         | Generi=
c system errno (Exxx)          |
+--------+-------------------+---------------+-----------------+-------=
-------------------------------+
|  ...   | NFXTA_XTERRNO     |     int       | NLA_U32         | NFXT e=
rrno (NFXTE_*)                 |
+--------+-------------------+---------------+-----------------+-------=
-------------------------------+
|        | NFXTA_ERRSTR      |   char []     | NLA_NUL_STRING  | Arbitr=
ary                            |
+--------+-------------------+---------------+-----------------+-------=
-------------------------------+
|        | NFXTA_USERTID     | unsigned int  | NLA_U32         | Arbitr=
ary, retained verbatim         |
+--------+-------------------+---------------+-----------------+-------=
-------------------------------+
|        | NFXTA_CHAIN_NAME  |   char []     | NLA_NUL_STRING  |       =
                               |
+--------+-------------------+---------------+-----------------+-------=
-------------------------------+
|        | NFXTA_RULE_IDX    | unsigned int  | NLA_U32         |       =
                               |
+--------+-------------------+---------------+-----------------+-------=
-------------------------------+
|        | NFXTA_ACTION_IDX  | unsigned int  | NLA_U32         |       =
                               |
+--------+-------------------+---------------+-----------------+-------=
-------------------------------+
|        | NFXTA_NAME        |   char []     | NLA_NUL_STRING  |       =
                               |
+--------+-------------------+---------------+-----------------+-------=
-------------------------------+
|        | NFXTA_REVISION    |   uint8_t     | NLA_U32         |       =
                               |
+--------+-------------------+---------------+-----------------+-------=
-------------------------------+
|        | NFXTA_HOOKNUM     | unsigned int  | NLA_U32         |       =
                               |
+--------+-------------------+---------------+-----------------+-------=
-------------------------------+
|        | NFXTA_PRIORITY    |     int       | NLA_U32         |       =
                               |
+--------+-------------------+---------------+-----------------+-------=
-------------------------------+
|        | NFXTA_NFPROTO     |   uint8_t     | NLA_U32         |       =
                               |
+--------+-------------------+---------------+-----------------+-------=
-------------------------------+
|        | NFXTA_OFFSET      | unsigned int  | NLA_U32         |       =
                               |
+--------+-------------------+---------------+-----------------+-------=
-------------------------------+
|        | NFXTA_LENGTH      |    size_t     | NLA_U32         |       =
                               |
+--------+-------------------+---------------+-----------------+-------=
-------------------------------+
|        | NFXTA_HOOKMASK    | unsigned int  | NLA_U32         |       =
                               |
+--------+-------------------+---------------+-----------------+-------=
-------------------------------+
|        | NFXTA_SIZE        |    size_t     | NLA_U32         |       =
                               |
+--------+-------------------+---------------+-----------------+-------=
-------------------------------+
|        | NFXTA_NEW_NAME    |   char []     | NLA_NUL_STRING  |       =
                               |
+--------+-------------------+---------------+-----------------+-------=
-------------------------------+


The kernel ignores attributes with value 0 during validation, so=20
it was left unused.

4 Error types<sec:Error-types>


+--------+---------------------+---------------------------------------=
----+
| Value  | Mnemonic            | Description                           =
    |
+--------+---------------------+---------------------------------------=
----+
+--------+---------------------+---------------------------------------=
----+
|   0    | NFXTE_SUCCESS       | No error                              =
    |
+--------+---------------------+---------------------------------------=
----+
|   1    | NFXTE_CHAIN_EXIST   | Chain already exists                  =
    |
+--------+---------------------+---------------------------------------=
----+
|   2    | NFXTE_CHAIN_NOENT   | Chain does not exist                  =
    |
+--------+---------------------+---------------------------------------=
----+
|   3    | NFXTE_RULESET_LOOP  | Ruleset contains a loop               =
    |
+--------+---------------------+---------------------------------------=
----+
|   4    | NFXTE_EXT_HOOKMASK  | Rule invoked from incompatible hook   =
    |
+--------+---------------------+---------------------------------------=
----+
|        | NFXTE_PROMO_STATUS  | Promotion/demotion state already achie=
ved |
+--------+---------------------+---------------------------------------=
----+


5 Message types


+------+-----------------------+----------------+----------------------=
-----------------------+
| ID   | Mnemonic              |      Dir       | Notes                =
                       |
+------+-----------------------+----------------+----------------------=
-----------------------+
+------+-----------------------+----------------+----------------------=
-----------------------+
|  0   | NFXTM_STOP            |     both       | End of logical nestin=
g level or transaction |
+------+-----------------------+----------------+----------------------=
-----------------------+
|  1   | NFXTM_ERROR           | k\rightarrowu  | Kills transactions (b=
ut not dumps)          |
+------+-----------------------+----------------+----------------------=
-----------------------+
|  2   | NFXTM_ABORT           | u\rightarrowk  | Abort transaction    =
                       |
+------+-----------------------+----------------+----------------------=
-----------------------+
| tba  | NFXTM_CHAIN_NEW       | u\rightarrowk  |                      =
                       |
+------+-----------------------+----------------+----------------------=
-----------------------+
| ...  | NFXTM_CHAIN_DEL       | u\rightarrowk  |                      =
                       |
+------+-----------------------+----------------+----------------------=
-----------------------+
|      | NFXTM_CHAIN_MOVE      | u\rightarrowk  |                      =
                       |
+------+-----------------------+----------------+----------------------=
-----------------------+
|      | NFXTM_CHAIN_PROMOTE   | u\rightarrowk  |                      =
                       |
+------+-----------------------+----------------+----------------------=
-----------------------+
|      | NFXTM_CHAIN_DEMOTE    | u\rightarrowk  |                      =
                       |
+------+-----------------------+----------------+----------------------=
-----------------------+
|      | NFXTM_TABLE_DUMP      | u\rightarrowk  | Dump start           =
                       |
+------+-----------------------+----------------+----------------------=
-----------------------+
|      | NFXTM_CHAIN_ENTRY     |     both       | Nest start           =
                       |
+------+-----------------------+----------------+----------------------=
-----------------------+
|      | NFXTM_RULE_ENTRY      |     both       | Nest start           =
                       |
+------+-----------------------+----------------+----------------------=
-----------------------+
|      | NFXTM_MATCH_ENTRY     |     both       | Nest start           =
                       |
+------+-----------------------+----------------+----------------------=
-----------------------+
|      | NFXTM_TARGET_ENTRY    |     both       | Nest start           =
                       |
+------+-----------------------+----------------+----------------------=
-----------------------+
|      | NFXTM_VERDICT_ENTRY   |     both       | Nest start           =
                       |
+------+-----------------------+----------------+----------------------=
-----------------------+
|      | NFXTM_JUMP_ENTRY      |     both       | Nest start           =
                       |
+------+-----------------------+----------------+----------------------=
-----------------------+
|      | NFXTM_GOTO_ENTRY      |     both       | Nest start           =
                       |
+------+-----------------------+----------------+----------------------=
-----------------------+
|      | NFXTM_CONFIG_DATA     |     both       | Nest start           =
                       |
+------+-----------------------+----------------+----------------------=
-----------------------+
|      | NFXTM_STATE_DATA      |     both       | Nest start           =
                       |
+------+-----------------------+----------------+----------------------=
-----------------------+
|      | NFXTM_ARB_DATA        |     both       | Arbitrary data       =
                       |
+------+-----------------------+----------------+----------------------=
-----------------------+
|      | NFXTM_ATTR_DATA       |     both       | Attribute list       =
                       |
+------+-----------------------+----------------+----------------------=
-----------------------+
|      | NFXTM_CHAIN_SPLICE    | u\rightarrowk  | Transaction start, ne=
st start               |
+------+-----------------------+----------------+----------------------=
-----------------------+
|      | NFXTM_TABLE_REPLACE   | u\rightarrowk  | Transaction start, ne=
st start               |
+------+-----------------------+----------------+----------------------=
-----------------------+
|      | NFXTM_IDENTIFY        |     both       | Dump start           =
                       |
+------+-----------------------+----------------+----------------------=
-----------------------+
|      | NFXTM_IDMATCH_ENTRY   | k\rightarrowu  |                      =
                       |
+------+-----------------------+----------------+----------------------=
-----------------------+
|      | NFXTM_IDTARGET_ENTRY  | k\rightarrowu  |                      =
                       |
+------+-----------------------+----------------+----------------------=
-----------------------+
|      | NFXTM_EVENT           | k\rightarrowu  |                      =
                       |
+------+-----------------------+----------------+----------------------=
-----------------------+


5.1 End of nest level / transaction commit

NFXTM_STOP is used to end a nesting level as started by, for=20
example, NFXTM_RULE_ENTRY.

It is also used to finish (commit) a transaction, such as with=20
NFXTM_TABLE_REPLACE.

Request NFXTM_STOP:

=E2=80=A2 No attributes.

Response:

=E2=80=A2 Standard Netlink ACK.

5.2 Error report

xtnetlink uses NFXTM_ERROR to report back detailed errors on=20
actions.

Possible attributes:

=E2=80=A2 NFXTA_ERRNO: generic error, using system-level errno codes=20
  (ENOMEM, etc.)

=E2=80=A2 NFXTA_XTERRNO: xtnetlink error, see section [sec:Error-types]

=E2=80=A2 NFXTA_ERRSTR: free-form error string provided by extensions

=E2=80=A2 NFXTA_USERTID: user token received earlier is echoed back for=
=20
  reference (may be used for things like line numbers)

=E2=80=A2 NFXTA_CHAIN_NAME: name of chain whose processing caused the=20
  error

=E2=80=A2 NFXTA_RULE_IDX: index to rule (0-based) that caused the error

=E2=80=A2 NFXTA_ACTION_IDX: index to match/target/verdict (0-based) in=20
  the particular rule that caused the error

(RFC:) Should outstanding transaction be terminated?

When NFXTM_ERROR is sent in an NLM_F_MULTI dump stream, an=20
NLMSG_DONE message will still follow.

5.3 Transaction termination

NFXTM_ABORT can be used to abort a transaction as started by, for=20
example, NFXTM_TABLE_REPLACE.

Request NFXTM_ABORT:

=E2=80=A2 No attributes.

Response:

=E2=80=A2 Standard Netlink ACK.

5.4 Chain creation

Request NFXTM_CHAIN_NEW:

=E2=80=A2 Attribute NFXTA_NAME: name of the new chain.

Response:

=E2=80=A2 Standard Netlink ACK, or NFXTM_ERROR:

  =E2=80=93 ENOMEM: Out of memory

  =E2=80=93 NFXTE_CHAIN_EXIST: Chain already exists

5.5 Chain deletion

Request NFXTM_CHAIN_DEL with attributes:

=E2=80=A2 NFXTA_NAME attribute carrying the name of the chain to delete

Response:

=E2=80=A2 Standard Netlink ACK, or NFXTM_ERROR:

  =E2=80=93 NFXTE_CHAIN_NOENT: Chain does not exist.

Notes:

The chain is automatically demoted.

5.6 Chain renaming

Request:

=E2=80=A2 Type: NFXTM_CHAIN_MOVE

=E2=80=A2 Attributes: NFXTA_NAME (old name), NFXTA_NEW_NAME (new chain=20
  name).

Response:

=E2=80=A2 Standard Netlink ACK, or NFXTA_ERROR:

  =E2=80=93 NFXTE_CHAIN_NOENT: Source chain does not exist

  =E2=80=93 NFXTE_CHAIN_EXIST: Target chain already exists

5.7 Promotion to base chain

Sets the specified chain up as an entrypoint from the Netfilter=20
proper. (It does this by creating an appropriate nf_hook.)

Request:

=E2=80=A2 Type: NFXTM_CHAIN_PROMOTE

=E2=80=A2 Attributes: NFXTA_NAME, NFXTA_HOOKNUM (NF_INET_*/NF_ARP_*/
  NF_BR_*), NFXTA_PRIORITY, NFXTA_NFPROTO (one of the NFPROTO_*=20
  constants)

Response:

=E2=80=A2 Standard Netlink ACK, or NFXTA_ERROR:

  =E2=80=93 NFXTE_CHAIN_NOENT: The specified chain does not exist.

  =E2=80=93 NFXTE_PROMO_STATUS: Already promoted.

  =E2=80=93 NFXTE_RULESET_LOOP: There is a loop in the rule tree, which=
=20
    is not allowed.

  =E2=80=93 NFXTE_EXT_HOOKMASK: One or more extensions are used from a=20
    hook that they do not support being invoked from.

Example:

=E2=80=A2 Turn the chain named =E2=80=9Cfilter/ipv6/INPUT=E2=80=9D into=
 the equivalent of=20
  the classic INPUT hook in the filter table: NFXTA_NAME=3D=E2=80=9C
  filter/ipv6/INPUT=E2=80=9D, NFXTA_HOOKNUM=3DNF_INET_LOCAL_IN (1),=20
  NFXTA_PRIORITY=3D0, NFXTA_NFPROTO=3DNFPROTO_IPV6 (10).

5.8 Demotion from base chain

Removes the nf_hook.

Request:

=E2=80=A2 Type: NFXTM_CHAIN_DEMOTE

=E2=80=A2 Attributes: NFXTA_NAME

Response:

=E2=80=A2 Standard Netlink ACK, or NFXTA_ERROR:

  =E2=80=93 NFXTE_CHAIN_NOENT: The specified chain does not exist.

  =E2=80=93 NFXTE_PROMO_STATUS: Already demoted.

5.9 Implementation Identification (debug)

=46irst and foremost a debug command, and to get something=20
(table/chain-independent) that users can glare at (they love=20
doing that).

Request:

=E2=80=A2 nlmsg_type =3D NFXTM_IDENTIFY;

Multiple message response:

=E2=80=A2 An NFXTM_IDENTIFY message containing:

  =E2=80=93 An NFXTA_NAME attribute giving the name of the=20
    implementation/patchset.

=E2=80=A2 Zero or more NFXTM_IDMATCH_ENTRY messages, giving=20
  metainformation about the loaded match extensions. Each message=20
  contains three attributes:

  =E2=80=93 An NFXTA_NAME attribute for the name of the extension.

  =E2=80=93 An NFXTA_REVISION attribute to denote the version of the=20
    extension's parameter protocol.

  =E2=80=93 An NFXTA_SIZE attribute for the size of its per-instance da=
ta=20
    block.

  =E2=80=93 An NFXTA_HOOKMASK attribute for the bitmap of hooks the=20
    extensions may be used from.

=E2=80=A2 Zero or more NFXTM_IDTARGET_ENTRY messages, giving=20
  metainformation about the loaded target extensions:

  =E2=80=93 attributes like NFXTM_IDMATCH_ENTRY.

=E2=80=A2 NLMSG_DONE message.

5.10 Rule dump

Atomic dump of entire table/ruleset, or a single chain, with or=20
without rules.

Request:

=E2=80=A2 nlmsg_type =3D NFXTM_TABLE_DUMP;

=E2=80=A2 NFXTA_NAME attribute specifying the name of the chain to dump=
=2E=20
  Absence of attribute dumps entire table.

=E2=80=A2 NFXTA_RULE_IDX attribute specifying the particular rule=20
  (1-based index) to dump. Absence of attribute dumps entire=20
  chain. Use 0 to only get a chain list.

Multi Response:

=E2=80=A2 Zero or more chains, represented by the start marker message=20
  NFXTM_CHAIN_ENTRY and the end marker NFXTM_STOP. The=20
  NFXTM_CHAIN_ENTRY message may have NFXTA_HOOKNUM,=20
  NFXTA_PRIORITY and NFXTA_NFPROTO attributes if it is a base=20
  chain.

=E2=80=A2 Zero or more rules within NFXTM_CHAIN_ENTRY .. NFXTM_STOP,=20
  represented by the start marker message NFXTM_RULE_ENTRY and=20
  the end marker NFXTM_STOP.

=E2=80=A2 Zero or more actions within NFXTM_RULE_ENTRY .. NFXTM_STOP,=20
  represented by the start marker message NFXTM_MATCH_ENTRY,=20
  NFXTM_TARGET_ENTRY, NFXTM_VERDICT_ENTRY, NFXTM_JUMP_ENTRY or=20
  NFXTM_GOTO_ENTRY and the end marker NFXTM_STOP.

=E2=80=A2 Zero or more config data messages within NFXTM_MATCH_ENTRY or=
=20
  NFXTM_TARGET_ENTRY.

=E2=80=A2 Zero or more state data messages within NFXTM_MATCH_ENTRY or=20
  NFXTM_TARGET_ENTRY.

(See section [sub:Summary-of-transform] for example.)

Errors:

=E2=80=A2 If an error occurs during dump, an NFXTM_ERRNO message is=20
  emitted into the stream and the dump will then immediately=20
  terminate with a standard NLMSG_DONE message. No NFXTA_STOP=20
  attributes will be emitted if the dump stopped in the middle of=20
  a nesting level.

5.11 Table replace

Atomic replacement of an entire table/ruleset.

1. User sends NFXTM_TABLE_REPLACE request. The state is=20
  remembered per client socket.

2. Within this transaction, the following commands operate on a=20
  temporary table: NFXTM_CHAIN_NEW, NFXTM_CHAIN_DEL, NFXTM_CHAIN_
  MOVE, NFXTM_CHAIN_SPLICE.

3. End transaction with NFXTM_STOP, or abort with NFXTM_ABORT.

5.12 Chain splicing (add/delete rules)

Chain splicing does a bulk deletion of zero or more consecutive=20
rules, followed by a bulk insertion of zero or more consecutive=20
rules, all done in an atomic fashion. It operates similar to=20
Perl's splice function on arrays.

The user starts a transaction with a NFXTM_CHAIN_SPLICE request,=20
supplying the name of the chain that is to be modified in a=20
NFXTA_NAME attribute. xtnetlink will take the read lock on the=20
table to prevent a table replace operation from interfering, and=20
will take the write lock on the chain.

1. While in this context, higher-level transactions like=20
  NFXTM_TABLE_REPLACE, are rejected.

2. Send new rules (ordered list).

3. End transaction with NFXTM_STOP, or abort transaction entirely=20
  with NFXTM_ABORT.

New rules:

1. Send NFXTM_RULE_NEW. Must occur within the context of=20
  chain_splice.

2. NFXTM_STOP. This ends the current rule.

blubb

Request:

=E2=80=A2 NFXTA_NAME: Name of the chain to modify.

=E2=80=A2 NFXTA_OFFSET: Index of entry where operation should start.

=E2=80=A2 NFXTA_LENGTH: Number of entries starting from offset that=20
  should be removed. May be zero or more.

=E2=80=A2 Zero or more rules.

Response:

=E2=80=A2 Standard ACK.

=E2=80=A2 or detailed error code.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
