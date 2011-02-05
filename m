From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Xtables2 A7 spec draft
Date: Sat, 5 Feb 2011 20:33:16 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1102051930550.5522@blackhole.kfki.hu>
References: <alpine.LNX.2.01.1102011817480.7729@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:60029 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273Ab1BETdS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Feb 2011 14:33:18 -0500
In-Reply-To: <alpine.LNX.2.01.1102011817480.7729@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

On Wed, 2 Feb 2011, Jan Engelhardt wrote:

> I am posting the Xtables2 Netlink interface specification, draft 7
> for comments.
> 
> Additionally, further documentation and toolchain around
> it is available through the project page at
> 
> 	http://jengelh.medozas.de/projects/xtables/
> 
>  * User Documentation Chapter 1: Architectural Differences
>  * Developer Documentation Part 1: Netlink interface (WIP)
>    This is copied below to facilitate inline replies
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
>  \__ table (unordered chains)
>  |    \__ chain (ordered rules)
>  |    |    \__ rule (ordered actions)
>  |    |    |    \__ match (unordered data)
>  |    |    |    |    \__ config-data
>  |    |    |    |    |    \__ bin params
>  |    |    |    |    \__ state-data
>  |    |    |    |         \__ nlattrs
>  |    |    |    \__ match...
>  |    |    |    \__ target (unordered data)
>  |    |    |    |    \__ config-data
>  |    |    |    \__ target...
>  |    |    |    \__ verdict...
>  |    |    \__ rule...
>  |    \__ chain...
>  \__ table...

I believe the objects 'match', 'target', 'verdict' should be generalized 
and unified into a single entity named 'action' (or named whatever). It 
should have an attribute (better a flag attribute with a flag value) to 
denote that the given action is a terminating one (terminating 
target/verdict), so that the parser could check and warn/reject 
unreachable actions. That way the protocol were both simpler and more 
powerful at the same time. And we could express rules like

... -m whatever -j LOG -m more-specific -j DO-SOMETHING ...

I don't like the idea of passing binary parameters at any level: 
everything should be expressed in nlattrs.
 
> A more concrete example, here is a small ruleset, encoded into 
> XML (just one of many possible representations):
> 
> <table>
>   <chain name="INPUT">
>     <rule idx="1">
>       <match acidx="1" name="hashlimit" rev="1" csize="120">
>         <config-data>...</config-data>
>         <state-data>...</state-data>
>       </match>
>       <target acidx="2" name="TOS" rev="1">
>         ...
>       </target>
>       <verdict acidx="3" name="ACCEPT" />
>     </rule>
>   </chain>
> </table>
> 
> There are different ways to encode such a tree structure into a 
> serialized stream. In many Netlink protocols, children attributes 
> are encapsulated (a. k. a. ?nested?, though we will avoid this 
> term to avoid double-use) and treated as a whole as a parent's 
> opaque data. It cannot be told apart from normal data. (Like 
> writing ?<chain> &lt;rule&gt; ... &lt;/rule&gt; </chain>? in 
> XML.) We will call this format ?Encapsulated Encoding?.
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

The pagesize limit is a real problem. :-(( I don't see how could we avoid 
the possibility to split a single rule into multiple messages, because it 
did not simply fit into a single one.

> Certain voices in the community call for the obsoletion of such 
> data blobs and replace them by Netlink attributes; there are no 
> objections to doing so. However, the problem of size-limited 
> sk_buffs applies to opaque data of any kind, and Netlink 
> attributes fall within that.

I'm among the ones who object data blobs.
 
> The Xtables2 Netlink protocol encodes each node of information as 
> a standalone attribute, to be called Flat Encoding, that is 
> appended (a. k. a. ?chained?) to the data stream. By avoiding 
> encapsulated attributes, it is possible to split messages at much 
> finer levels, and provides for attributes that happen to use 
> opaque data with a maximally-sized buffer.

Even with encapsulation, the messages can be split at any level.
 
> 1.2 Nest markers<sub:Nest-markers>
> 
> Since Netlink messages do have a 32-bit quantity to store the 
> message length, rulesets of roughly up to 4 GB are possibile, 
> which is currently regarded as sufficient. The largest (while 
> still being meaningful) rulesets seen to date in the industry 
> weighed in at approximately 150 MB.
> 
> Whereas encapsulated attribute encoding automatically provided 
> for boundaries, this is realized using dummy attributes in the 
> chained approach. The start of a nesting level can be implicitly 
> represented by the presence of the attribute that would have 
> otherwise been used for encapsulated nesting. For declaring an 
> end of a nest level, an extra attribute is needed:
> 
> ? ?chain { rule; rule; ... }? \Leftrightarrow CHAIN RULE RULE ... 
>   STOP

With encapsulation, there were no need such an extra STOP attribute - 
except that we may have to split the encapsulated attributes into multiple 
messages and thus the STOP attribute/marker is needed.
 
> 1.3 Attribute limitations in nfnetlink
> 
> Netlink, being just a base protocol, does not specify what comes 
> after the nlmsghdr, or how it is ordered. This is left up to the 
> subprotocols based on Netlink. nfnetlink has two effective 
> shortcomings (due to its parser) that shall be held in mind:
> 
> ? Attribute ordering is ignored and lost

Even if netlink does not state that attribute ordering is kept, it does 
not state either that attributes may be reordered. Netling as transport 
protocol does not care about the attributes. So we can say that for 
xtables2, the attribute order in the netlink messages is fixed, period.
 
> ? No support for more than one attribute with the same type 
>   within a message

Oh no, you can put as many attributes with the same type as you like (and 
fit) into a single nested attribute!

> struct nlattr **tb;
> nla_for_each_attr(attr, head, ...)
>         tb[nla_type(attr)] = attr;
> 
> This kills the idea of being able to do, for example, a table 
> replace, in a single Netlink request message. This is like having 
> to split an XML file at every tag simply because two tags can 
> carry the same attribute. So Netlink requests have to be broken 
> down into many many tiny parts and extra state has to be kept 
> around in the kernel.
> 
> put_header(msg, NFXTM_TABLE_REPLACE);
> foreach (rule)
>         put(msg, rule);
> send(sock, msg);

And so the simple processing above can be applied.
 
> will become
> 
> put_header(msg, NFXTM_TABLE_REPLACE);
> send(sock, msg);
> foreach (rule) {
>         clean(msg);
>         put_header(msg, NFXTM_RULE_DATA);
>         put(msg, rule);
>         send(sock, msg);
> }
> clean(msg);
> put_header(msg, NFXTM_COMMIT);
> send(sock, msg);
> 
> or worse. In other words, the fact that the kernel side will use 
> a temporary table (an implementation detail) will be exposed to 
> userspace, which is bad too.
 
> 1.4 Summary of transform<sub:Summary-of-transform>
> 
> Essentially there is a 1:1 transform on the XML-like tree shown 
> above, to:
> 
> NFXTM_CHAIN_ENTRY<name=INPUT,usertid=1>
>   NFXTM_RULE_ENTRY<idx=1,usertid=1>
>     NFXTM_MATCH_ENTRY<acidx=1,name=hashlimit,rev=1,usertid=2>
>       NFXTM_CONFIG_DATA
>         NFXTM_ARB_DATA<whatever>
>         NFXTM_ARB_DATA<more arbitrary data>
>       NFXTM_STOP
>       NFXTM_STATE_DATA
>         NFXTM_ATTR_DATA<nlattrs>
>         NFXTM_ATTR_DATA<more nlattrs>
>       NFXTM_STOP
>     NFXTM_STOP
>     NFXTM_TARGET_ENTRY<acidx=2,name=TOS,rev=0,usertid=3>
>       ...
>     NFXTM_STOP
>     NFXTM_VERDICT_ENTRY<acidx=3,name=ACCEPT,usertid=3>
>     NFXTM_STOP
>   NFXTM_STOP
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

Nothing specifies what nlmsg_seq should be in, so it's up to the 
application, i.e. xtables2, how it's used...
 
> Even if that were decidedly so, that brings along a problem. In 
> NLM_F_MULTI-style dumps, all messages would have the same 
> nlmsg_seq. To counter this, multi messages will have an 
> NFXT-specific sequence counter (NFXTA_SEQNO) in addition, 
> especially since ordering is so much more crucial in Xtables than 
> it is in other parts of networking.

...but yes, for dumping an additional attribute is required to make sure 
the ordering is kept. Actually, two attributes: one at the rule level, and 
one at the "action" level in the given rule.
 
> 1.6 Improved granularity error reporting
> 
> Xtables extensions as of Linux 2.6.37 can only return system 
> error codes back to userspace in case there is a problem. The 
> most common occurrences are, for example, ENOMEM (?Memory 
> allocation failure? / ?Out of memory?), and the dreaded EINVAL (?
> Invalid argument?). Best practices at the moment are to printk a 
> string to the kernel log for further information detailing the 
> circumstances about the cause of EINVAL. In the light of this 
> overload of EINVAL, an improved error reporting scheme is sought. 
> (Other networking subsystems also suffer from this problem.)
> 
> By suggestion of Jozsef Kadlecsik, the Xtables2 protocol reports 
> three kinds of errors:
> 
> ? General/standard (integer) error codes, where there is no point 
>   (or cannot be) to specify the nature of the error exactly. Like 
>   in the example, ENOMEM: it is needles to report which new data 
>   field could not be allocated.
> 
> ? General Xtables2 error codes (largely replaces EINVAL sites) in 
>   integer form, similar to errno. Use cases include:
> 
>   ? chain for a requested operation does not exist
> 
>   ? an extension is used from a hook it is not supposed to be
> 
> ? Free-form string. Standalone, or in addition to the above.
> It is impossible to provision error numbers for extensions, 
>   especially those that are out-of-tree. The problems that 
>   forcing a component to reuse another component's error code 
>   space can be seen in the overuse of EINVAL. We are aware that 
>   raw strings in kernel modules can hinder internationalization, 
>   but it is seen as the better choice over awkward error codes 
>   that convey nothing. It is also expected that strings do not 
>   change that often.
> 
> The three error types will be conveyed by three distinct 
> attributes: NFXTA_ERRNO (generic error codes), NFXTA_XTERRNO (xt2 
> error codes), and NFXTA_ERRSTR (free-form string).

I hammer the issue further :-). With properly separated error number 
domains, the three type can be expressed in a single error attribute. Just 
a second attribute is required to carry the identifier of the action in 
the rule to which the third type error code belongs to.

I'm still not convinced about the usefulness of the error string. The 
kernel part is always paired with the userspace part. The developer 
exactly knows which kind of errors can be send back to the userspace and 
can thus provide the textual decoding. As netlink sends back the original 
message in the error message, the userspace can fully decode every 
attribute (since it itself encoded it) too.

If a decoding for an error code is not provided, that's a bug an thus must 
be fixed.

>   Error pointer
> 
> Once a table/chain splice request has been finalized, 
> xt_check_{match,target} is run, which can return:
> 
> ? chain name, rule index, match/target index, NFXTE_*/custom 
>   string
> 
>   Line number
> 
> I noticed Jozsef has added a line number attribute in ipset 
> version 5 to facilitate locating errors for users. For its 
> apparent value, such attribute is also specified for xtnetlink:
> 
> A request message can contain a ?ping attribute?, NFXTA_USERTID, 
> which xtnetlink may keep track of and which may be reported back 
> verbatim in case an error occured. It may be used to represent 
> the source line, or any other number.

The line number is a very good identifier for a rule.

> ? For the tree example in section 1, the ruleset file would be ?
>   -A INPUT \
> -m hashlimit ... \
> -j TOS ... -j ACCEPT?.
> 
> 1.7 Multi-type responses
> 
> Using multi-type responses provides for a seemingly shorter reply 
> (in at least one case) than not doing so:
> 
> ? \RightarrowNFXTM_CHAIN_DUMP<NFXTA_NAME>
> \LeftarrowNFXTM_RULE_START<>
> \LeftarrowNFXTM_EMATCH<NFXTA_NAME, NFXTA_REVISION, NFXTA_DATA>
> \LeftarrowNFXTM_EMATCH<NFXTA_NAME, NFXTA_REVISION, NFXTA_DATA>
> \LeftarrowNFXTM_ETARGET<NFXTA_NAME, NFXTA_REVISION, NFXTA_DATA>
> \LeftarrowNFXTM_ETARGET<NFXTA_NAME, NFXTA_REVISION, NFXTA_DATA>
> \LeftarrowNFXTM_RULE_END<>
> \LeftarrowNFXTM_RULE_START<>
> \LeftarrowNFXTM_ETARGET<NFXTA_VERDICT>
> \LeftarrowNFXTM_RULE_END<>
> \LeftarrowNLMSG_DONE
> 
> ? \RightarrowCHAIN_DUMP<NFXTA_NAME>
> \LeftarrowCHAIN_DUMP<NFXTA_RULE_START>
> \LeftarrowCHAIN_DUMP<NFXTA_MATCH_START>
> \LeftarrowCHAIN_DUMP<NFXTA_NAME, NFXTA_REVISION, NFXTA_DATA>
> \LeftarrowCHAIN_DUMP<NFXTA_MATCH_END>
> \LeftarrowCHAIN_DUMP<NFXTA_MATCH_START>
> \LeftarrowCHAIN_DUMP<NFXTA_NAME, NFXTA_REVISION, NFXTA_DATA>
> \LeftarrowCHAIN_DUMP<NFXTA_MATCH_END>
> \LeftarrowCHAIN_DUMP<NFXTA_TARGET_START>
> \LeftarrowCHAIN_DUMP<NFXTA_NAME, NFXTA_REVISION, NFXTA_DATA>
> \LeftarrowCHAIN_DUMP<NFXTA_TARGET_END>
> \LeftarrowCHAIN_DUMP<NFXTA_TARGET_START>
> \LeftarrowCHAIN_DUMP<NFXTA_NAME, NFXTA_REVISION, NFXTA_DATA>
> \LeftarrowCHAIN_DUMP<NFXTA_TARGET_END>
> \LeftarrowCHAIN_DUMP<NFXTA_RULE_END>
> \LeftarrowCHAIN_DUMP<NFXTA_RULE_START>
> \LeftarrowCHAIN_DUMP<NFXTA_TARGET_START>
> \LeftarrowCHAIN_DUMP<NFXTA_VERDICT>
> \LeftarrowCHAIN_DUMP<NFXTA_TARGET_END>
> \LeftarrowCHAIN_DUMP<NFXTA_RULE_END>
> \LeftarrowNLMSG_DONE
> 
> 2 General use
> 
> 2.1 Socket
> 
> Xtables2 is made available through an nfnetlink socket. 
> Specifically, this is a Netlink socket of type NETLINK_NETFILTER, 
> with which messages are exchanged that are tagged having Xtables 
> as the subsystem.
> 
> #include <sys/socket.h>
> #include <linux/netlink.h>
> 
> struct nlmsghdr nlmsg;
> int nf_socket = socket(AF_NETLINK, SOCK_RAW, 
> NETFILTER_NETFILTER);
> nlmsg.nlmsg_type = (NFNL_SUBSYS_XTABLES << 8) | xt_msg_type;
> 
> 2.2 Message format
> 
> All messages transmitted over the Netlink socket are to have the 
> base struct nlmsghdr header, followed by a struct nfgenmsg header 
> as mandated by nfnetlink. The .nfgen_family member is always set 
> to NFPROTO_UNSPEC. The .version member denotes the format of the 
> byte stream following nfgenmsg; this is currently version 0. The 
> .res_id member is unused.
> 
> 3 Attributes
> 
> The meaning of attributes depends upon the message and logical 
> nesting level in which they appear. Their type however remains 
> the same, such that a single Netlink attribute validation policy 
> object (struct nla_policy) can be used for all message types.
> 
> A table of all known attributes:
[...]

Maybe it was just not worded expicitly in the specification, but all 
attribute types which are affected should be sent in network order.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
