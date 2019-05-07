Return-Path: <SRS0=SeaY=TH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C163FC004C9
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 May 2019 13:23:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F3FD2053B
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 May 2019 13:23:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfEGNXu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 May 2019 09:23:50 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:58380 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726321AbfEGNXu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 May 2019 09:23:50 -0400
Received: from localhost ([::1]:43238 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hO04R-0007rP-Ud; Tue, 07 May 2019 15:23:48 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] doc: Review man page synopses
Date:   Tue,  7 May 2019 15:23:50 +0200
Message-Id: <20190507132350.3487-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fix use of font typefaces:

- *bold* for terminals
- 'italic' for non-terminals
- plain for meta-characters

Apart from that:

* Variable definitions require an equals sign
* 'auto-merge' option in set spec does not take a parameter
* List header fields in payload expressions instead of unexplained
  placeholder
* Introduce non-terminals in some places to avoid repetitions or clarify
  syntax
* Fix syntax for ip6 header expresssion example
* Reorganize ct expression synopsis into four parts:
  1) direction not allowed
  2) direction optional
  3) direction mandatory
  4) direction and family mandatory
* Add missing 'version' keyword to osf expression
* Clarify verdict statements example topic
* Add synopses for payload and exthdr statements
* Fix typo: differv -> diffserv
* Reorganize reject statement synopsis to point out which code type
  is required for which type arg
* Counter statement requires either one of 'packets' or 'bytes' args or
  both, none is an invalid variant
* Limit statement accepts a unit in burst, too
* Improve language in limit statement description a bit

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/nft.txt                |  63 +++++++++----------
 doc/payload-expression.txt |  68 ++++++++++----------
 doc/primary-expression.txt |  18 +++---
 doc/stateful-objects.txt   |   8 +--
 doc/statements.txt         | 125 +++++++++++++++++++++++++------------
 5 files changed, 164 insertions(+), 118 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index a82a9c5f34447..4fca5c918b747 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -135,7 +135,7 @@ matched by include statements.
 SYMBOLIC VARIABLES
 ~~~~~~~~~~~~~~~~~~
 [verse]
-*define* variable 'expr'
+*define* 'variable' *=* 'expr'
 *$variable*
 
 Symbolic variables can be defined using the *define* statement. Variable
@@ -231,7 +231,7 @@ layer 3 protocol handlers and it can be used for early filtering and policing.
 RULESET
 -------
 [verse]
-{list | flush} *ruleset* ['family']
+{*list* | *flush*} *ruleset* ['family']
 
 The *ruleset* keyword is used to identify the whole set of tables, chains, etc.
 currently in place in kernel. The following *ruleset* commands exist:
@@ -254,10 +254,10 @@ Effectively, this is the nft-equivalent of *iptables-save* and
 TABLES
 ------
 [verse]
-{add | create} *table* ['family'] 'table' [ {flags 'flags'} ]
-{delete | list | flush} *table* ['family'] 'table'
-list *tables*
-delete *table* ['family'] handle 'handle'
+{*add* | *create*} *table* ['family'] 'table' [*{ flags* 'flags' *; }*]
+{*delete* | *list* | *flush*} *table* ['family'] 'table'
+*list tables*
+*delete table* ['family'] *handle* 'handle'
 
 Tables are containers for chains, sets and stateful objects. They are identified
 by their address family and their name. The address family must be one of *ip*,
@@ -307,11 +307,11 @@ add table inet mytable
 CHAINS
 ------
 [verse]
-{add | create} *chain* ['family'] 'table' 'chain' [ { type 'type' hook 'hook' [device 'device'] priority 'priority' ; [policy 'policy' ;] }]
-{delete | list | flush} *chain* ['family'] 'table' 'chain'
-list *chains*
-delete *chain* ['family'] 'table' handle 'handle'
-rename *chain* ['family'] 'table' 'chain' 'newname'
+{*add* | *create*} *chain* ['family'] 'table' 'chain' [*{ type* 'type' *hook* 'hook' [*device* 'device'] *priority* 'priority' *;* [*policy* 'policy' *;*] *}*]
+{*delete* | *list* | *flush*} *chain* ['family'] 'table' 'chain'
+*list chains*
+*delete chain* ['family'] 'table' *handle* 'handle'
+*rename chain* ['family'] 'table' 'chain' 'newname'
 
 Chains are containers for rules. They exist in two kinds, base chains and
 regular chains. A base chain is an entry point for packets from the networking
@@ -406,9 +406,9 @@ values are *accept* (which is the default) or *drop*.
 RULES
 -----
 [verse]
-{add | insert} *rule* ['family'] 'table' 'chain' [ handle 'handle' | index 'index' ] 'statement' ... [ comment 'comment' ]
-replace *rule* ['family'] 'table' 'chain' handle 'handle' 'statement' ... [ comment 'comment' ]
-delete *rule* ['family'] 'table' 'chain' handle 'handle'
+{*add* | *insert*} *rule* ['family'] 'table' 'chain' [*handle* 'handle' | *index* 'index'] 'statement' ... [*comment* 'comment']
+*replace rule* ['family'] 'table' 'chain' *handle* 'handle' 'statement' ... [*comment* 'comment']
+*delete rule* ['family'] 'table' 'chain' *handle* 'handle'
 
 Rules are added to chains in the given table. If the family is not specified, the
 ip family is used. Rules are constructed from two kinds of components according
@@ -485,14 +485,13 @@ The sets allowed_hosts and allowed_ports need to be created first. The next
 section describes nft set syntax in more detail.
 
 [verse]
-add *set* ['family'] 'table' 'set' { type 'type' ; [flags 'flags' ;] [timeout 'timeout' ;] [gc-interval 'gc-interval' ;] [elements = { 'element'[,...]
-} ;] [size size ;] [policy policy ;] [auto-merge auto-merge ;] }
-{delete | list | flush} *set* ['family'] 'table' 'set'
-list *sets*
-delete *set* ['family'] 'table' handle 'handle'
-{add | delete} *element* ['family'] 'table' 'set' { 'element'[,...] }
-
-Sets are elements containers of a user-defined data type, they are uniquely
+*add set* ['family'] 'table' 'set' *{ type* 'type' *;* [*flags* 'flags' *;*] [*timeout* 'timeout' *;*] [*gc-interval* 'gc-interval' *;*] [*elements = {* 'element'[*,* ...] *} ;*] [*size* 'size' *;*] [*policy* 'policy' *;*] [*auto-merge ;*] *}*
+{*delete* | *list* | *flush*} *set* ['family'] 'table' 'set'
+*list sets*
+*delete set* ['family'] 'table' *handle* 'handle'
+{*add* | *delete*} *element* ['family'] 'table' 'set' *{* 'element'[*,* ...] *}*
+
+Sets are element containers of a user-defined data type, they are uniquely
 identified by a user-defined name and attached to tables. Their behaviour can
 be tuned with the flags that can be specified at set creation time.
 
@@ -538,10 +537,10 @@ automatic merge of adjacent/overlapping set elements (only for interval sets) |
 MAPS
 -----
 [verse]
-add *map* ['family'] 'table' 'map' { type 'type' [flags 'flags' ;] [elements = {'elements'[,...] } ;] [size 'size' ;] [policy 'policy' ;] }
-list *maps*
-{delete | list | flush} *map* ['family'] 'table' 'map'
-{add | delete} *element* ['family'] 'table' 'map' { elements = { 'elements'[,...] } ; }
+*add map* ['family'] 'table' 'map' *{ type* 'type' [*flags* 'flags' *;*] [*elements = {* 'element'[*,* ...] *} ;*] [*size* 'size' *;*] [*policy* 'policy' *;*] *}*
+{*delete* | *list* | *flush*} *map* ['family'] 'table' 'map'
+*list maps*
+{*add* | *delete*} *element* ['family'] 'table' 'map' *{ elements = {* 'element'[*,* ...] *} ; }*
 
 Maps store data based on some specific key used as input. They are uniquely identified by a user-defined name and attached to tables.
 
@@ -578,8 +577,8 @@ string: performance [default], memory
 FLOWTABLES
 -----------
 [verse]
-{add | create} *flowtable* ['family'] 'table' 'flowtable' { hook 'hook' priority 'priority' ; devices = { 'device'[,...] } ; }
-{delete | list} *flowtable* ['family'] 'table' 'flowtable'
+{*add* | *create*} *flowtable* ['family'] 'table' 'flowtable' *{ hook* 'hook' *priority* 'priority' *; devices = {* 'device'[*,* ...] *} ; }*
+{*delete* | *list*} *flowtable* ['family'] 'table' 'flowtable'
 
 Flowtables allow you to accelerate packet forwarding in software. Flowtables
 entries are represented through a tuple that is composed of the input interface,
@@ -608,10 +607,10 @@ and subtraction can be used to set relative priority, e.g. filter + 5 equals to
 STATEFUL OBJECTS
 ----------------
 [verse]
-{add | delete | list | reset} type ['family'] 'table' 'object'
-delete type ['family'] 'table' handle 'handle'
-list *counters*
-list *quotas*
+{*add* | *delete* | *list* | *reset*} 'type' ['family'] 'table' 'object'
+*delete* 'type' ['family'] 'table' *handle* 'handle'
+*list counters*
+*list quotas*
 
 Stateful objects are attached to tables and are identified by an unique name.
 They group stateful information from rules, to reference them in rules the
diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index 28061f362347b..7f3ca42d46056 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -1,7 +1,7 @@
 ETHERNET HEADER EXPRESSION
 ~~~~~~~~~~~~~~~~~~~~~~~~~~
 [verse]
-*ether* ['Ethernet' 'header' 'field']
+*ether* {*daddr* | *saddr* | *type*}
 
 .Ethernet header expression types
 [options="header"]
@@ -21,7 +21,7 @@ ether_type
 VLAN HEADER EXPRESSION
 ~~~~~~~~~~~~~~~~~~~~~~
 [verse]
-*vlan* ['VLAN' 'header' 'field']
+*vlan* {*id* | *cfi* | *pcp* | *type*}
 
 .VLAN header expression
 [options="header"]
@@ -44,7 +44,7 @@ ether_type
 ARP HEADER EXPRESSION
 ~~~~~~~~~~~~~~~~~~~~~
 [verse]
-*arp* ['ARP' 'header' 'field']
+*arp* {*htype* | *ptype* | *hlen* | *plen* | *operation*}
 
 .ARP header expression
 [options="header"]
@@ -70,7 +70,7 @@ arp_op
 IPV4 HEADER EXPRESSION
 ~~~~~~~~~~~~~~~~~~~~~~
 [verse]
-*ip* ['IPv4' 'header' 'field']
+*ip* {*version* | *hdrlength* | *dscp* | *ecn* | *length* | *id* | *frag-off* | *ttl* | *protocol* | *checksum* | *saddr* | *daddr* }
 
 .IPv4 header expression
 [options="header"]
@@ -117,7 +117,7 @@ ipv4_addr
 ICMP HEADER EXPRESSION
 ~~~~~~~~~~~~~~~~~~~~~~
 [verse]
-*icmp* ['ICMP' 'header' 'field']
+*icmp* {*type* | *code* | *checksum* | *id* | *sequence* | *gateway* | *mtu*}
 
 This expression refers to ICMP header fields. When using it in *inet*,
 *bridge* or *netdev* families, it will cause an implicit dependency on IPv4 to
@@ -154,7 +154,7 @@ integer (16 bit)
 IGMP HEADER EXPRESSION
 ~~~~~~~~~~~~~~~~~~~~~~
 [verse]
-*igmp* ['IGMP' 'header' 'field']
+*igmp* {*type* | *mrt* | *checksum* | *group*}
 
 This expression refers to IGMP header fields. When using it in *inet*,
 *bridge* or *netdev* families, it will cause an implicit dependency on IPv4 to
@@ -182,7 +182,7 @@ integer (32 bit)
 IPV6 HEADER EXPRESSION
 ~~~~~~~~~~~~~~~~~~~~~~
 [verse]
-*ip6* ['IPv6' 'header' 'field']
+*ip6* {*version* | *dscp* | *ecn* | *flowlabel* | *length* | *nexthdr* | *hoplimit* | *saddr* | *daddr*}
 
 This expression refers to the ipv6 header fields. Caution when using *ip6
 nexthdr*, the value only refers to the next header, i.e. *ip6 nexthdr tcp* will
@@ -223,14 +223,17 @@ ipv6_addr
 Destination address |
 ipv6_addr
 |=======================
-*matching if first extension header indicates a fragment* +
 
-*ip6* nexthdr ipv6-frag counter
+.Using ip6 header expressions
+-----------------------------
+# matching if first extension header indicates a fragment
+ip6 nexthdr ipv6-frag
+-----------------------------
 
 ICMPV6 HEADER EXPRESSION
 ~~~~~~~~~~~~~~~~~~~~~~~~
 [verse]
-*icmpv6* ['ICMPv6' 'header' 'field']
+*icmpv6* {*type* | *code* | *checksum* | *parameter-problem* | *packet-too-big* | *id* | *sequence* | *max-delay*}
 
 This expression refers to ICMPv6 header fields. When using it in *inet*,
 *bridge* or *netdev* families, it will cause an implicit dependency on IPv6 to
@@ -270,7 +273,7 @@ integer (16 bit)
 TCP HEADER EXPRESSION
 ~~~~~~~~~~~~~~~~~~~~~
 [verse]
-*tcp* ['TCP' 'header' 'field']
+*tcp* {*sport* | *dport* | *sequence* | *ackseq* | *doff* | *reserved* | *flags* | *window* | *checksum* | *urgptr*}
 
 .TCP header expression
 [options="header"]
@@ -311,7 +314,7 @@ integer (16 bit)
 UDP HEADER EXPRESSION
 ~~~~~~~~~~~~~~~~~~~~~
 [verse]
-*udp* ['UDP' 'header' 'field']
+*udp* {*sport* | *dport* | *length* | *checksum*}
 
 .UDP header expression
 [options="header"]
@@ -334,7 +337,7 @@ integer (16 bit)
 UDP-LITE HEADER EXPRESSION
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~
 [verse]
-*udplite* ['UDP-Lite' 'header' 'field']
+*udplite* {*sport* | *dport* | *checksum*}
 
 .UDP-Lite header expression
 [options="header"]
@@ -354,7 +357,7 @@ integer (16 bit)
 SCTP HEADER EXPRESSION
 ~~~~~~~~~~~~~~~~~~~~~~~
 [verse]
-*sctp* ['SCTP' 'header' 'field']
+*sctp* {*sport* | *dport* | *vtag* | *checksum*}
 
 .SCTP header expression
 [options="header"]
@@ -377,7 +380,7 @@ integer (32 bit)
 DCCP HEADER EXPRESSION
 ~~~~~~~~~~~~~~~~~~~~~~
 [verse]
-*dccp* ['DCCP' 'header' 'field']
+*dccp* {*sport* | *dport*}
 
 .DCCP header expression
 [options="header"]
@@ -394,7 +397,7 @@ inet_service
 AUTHENTICATION HEADER EXPRESSION
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 [verse]
-*ah* ['AH' 'header' 'field']
+*ah* {*nexthdr* | *hdrlength* | *reserved* | *spi* | *sequence*}
 
 .AH header expression
 [options="header"]
@@ -420,7 +423,7 @@ integer (32 bit)
 ENCRYPTED SECURITY PAYLOAD HEADER EXPRESSION
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 [verse]
-*esp* ['ESP' 'header' 'field']
+*esp* {*spi* | *sequence*}
 
 .ESP header expression
 [options="header"]
@@ -436,7 +439,7 @@ integer (32 bit)
 
 IPCOMP HEADER EXPRESSION
 ~~~~~~~~~~~~~~~~~~~~~~~~~
-*comp* ['IPComp' 'header' 'field']
+*comp* {*nexthdr* | *flags* | *cpi*}
 
 .IPComp header expression
 [options="header"]
@@ -456,7 +459,7 @@ integer (16 bit)
 RAW PAYLOAD EXPRESSION
 ~~~~~~~~~~~~~~~~~~~~~~
 [verse]
-*@* [base,offset,length]
+*@*'base'*,*'offset'*,*'length'
 
 The raw payload expression instructs to load 'length' bits starting at 'offset' bits.
 Bit 0 refers to the very first bit -- in the C programming language, this
@@ -465,7 +468,7 @@ to match headers that do not have a human-readable template expression yet. Note
 that nft will not add dependencies for Raw payload expressions. If you e.g. want
 to match protocol fields of a transport header with protocol number 5, you need
 to manually exclude packets that have a different transport header, for instance
-my using meta l4proto 5 before the raw expression.
+by using *meta l4proto 5* before the raw expression.
 
 .Supported payload protocol bases
 [options="header"]
@@ -495,18 +498,18 @@ Extension header expressions refer to data from variable-sized protocol headers,
 
 nftables currently supports matching (finding) a given ipv6 extension header or TCP option.
 [verse]
-*hbh* {nexthdr | hdrlength}
-*frag* {nexthdr | frag-off | more-fragments | id}
-*rt* {nexthdr | hdrlength | type | seg-left}
-*dst* {nexthdr | hdrlength}
-*mh* {nexthdr | hdrlength | checksum | type}
-*srh* {flags | tag | sid | seg-left}
-*tcp option* {eol | noop | maxseg | window | sack-permitted | sack | sack0 | sack1 | sack2 | sack3 | timestamp} 'tcp_option_field'
+*hbh* {*nexthdr* | *hdrlength*}
+*frag* {*nexthdr* | *frag-off* | *more-fragments* | *id*}
+*rt* {*nexthdr* | *hdrlength* | *type* | *seg-left*}
+*dst* {*nexthdr* | *hdrlength*}
+*mh* {*nexthdr* | *hdrlength* | *checksum* | *type*}
+*srh* {*flags* | *tag* | *sid* | *seg-left*}
+*tcp option* {*eol* | *noop* | *maxseg* | *window* | *sack-permitted* | *sack* | *sack0* | *sack1* | *sack2* | *sack3* | *timestamp*} 'tcp_option_field'
 
 The following syntaxes are valid only in a relational expression with boolean type on right-hand side for checking header existence only:
 [verse]
-*exthdr* {hbh | frag | rt | dst | mh}
-*tcp option* {eol | noop | maxseg | window | sack-permitted | sack | sack0 | sack1 | sack2 | sack3 | timestamp}
+*exthdr* {*hbh* | *frag* | *rt* | *dst* | *mh*}
+*tcp option* {*eol* | *noop* | *maxseg* | *window* | *sack-permitted* | *sack* | *sack0* | *sack1* | *sack2* | *sack3* | *timestamp*}
 
 .IPv6 extension headers
 [options="header"]
@@ -588,9 +591,10 @@ is true for the *zone*, if a direction is given, the zone is only matched if the
 zone id is tied to the given direction. +
 
 [verse]
-*ct* {state | direction | status | mark | expiration | helper | label | l3proto | protocol | bytes | packets | avgpkt | zone}
-*ct* {original | reply} {l3proto | protocol | proto-src | proto-dst | bytes | packets | avgpkt | zone}
-*ct* {original | reply} {ip | ip6} {saddr | daddr}
+*ct* {*state* | *direction* | *status* | *mark* | *expiration* | *helper* | *label*}
+*ct* [*original* | *reply*] {*l3proto* | *protocol* | *bytes* | *packets* | *avgpkt* | *zone*}
+*ct* {*original* | *reply*} {*proto-src* | *proto-dst*}
+*ct* {*original* | *reply*} {*ip* | *ip6*} {*saddr* | *daddr*}
 
 .Conntrack expressions
 [options="header"]
diff --git a/doc/primary-expression.txt b/doc/primary-expression.txt
index a62ed00eb3140..6eb9583ac9e94 100644
--- a/doc/primary-expression.txt
+++ b/doc/primary-expression.txt
@@ -1,10 +1,8 @@
 META EXPRESSIONS
 ~~~~~~~~~~~~~~~~
 [verse]
-*meta* {length | nfproto | l4proto | protocol | priority}
-[meta] {mark | iif | iifname | iiftype | oif | oifname | oiftype |
-skuid | skgid | nftrace | rtclassid | ibrname | obrname | pkttype | cpu
-| iifgroup | oifgroup | cgroup | random | ipsec | iifkind | oifkind}
+*meta* {*length* | *nfproto* | *l4proto* | *protocol* | *priority*}
+[*meta*] {*mark* | *iif* | *iifname* | *iiftype* | *oif* | *oifname* | *oiftype* | *skuid* | *skgid* | *nftrace* | *rtclassid* | *ibrname* | *obrname* | *pkttype* | *cpu* | *iifgroup* | *oifgroup* | *cgroup* | *random* | *ipsec* | *iifkind* | *oifkind*}
 
 A meta expression refers to meta data associated with a packet.
 
@@ -160,7 +158,7 @@ raw prerouting meta ipsec exists accept
 SOCKET EXPRESSION
 ~~~~~~~~~~~~~~~~~
 [verse]
-*socket* \{transparent\}
+*socket* {*transparent* | *mark*}
 
 Socket expression can be used to search for an existing open TCP/UDP socket and
 its attributes that can be associated with a packet. It looks for an established
@@ -206,7 +204,7 @@ table inet x {
 OSF EXPRESSION
 ~~~~~~~~~~~~~~
 [verse]
-osf {name}
+*osf* [*ttl* {*loose* | *skip*}] {*name* | *version*}
 
 The osf expression does passive operating system fingerprinting. This
 expression compares some data (Window Size, MSS, options and their order, DF,
@@ -249,7 +247,7 @@ table inet x {
 FIB EXPRESSIONS
 ~~~~~~~~~~~~~~~
 [verse]
-*fib* {saddr | daddr | {mark | iif | oif}} {oif | oifname | type}
+*fib* {*saddr* | *daddr* | *mark* | *iif* | *oif*} [*.* ...] {*oif* | *oifname* | *type*}
 
 A fib expression queries the fib (forwarding information base) to obtain
 information such as the output interface index a particular address would use.
@@ -286,7 +284,7 @@ filter prerouting meta mark set 0xdead fib daddr . mark type vmap { blackhole :
 ROUTING EXPRESSIONS
 ~~~~~~~~~~~~~~~~~~~
 [verse]
-*rt* {classid | nexthop}
+*rt* [*ip* | *ip6*] {*classid* | *nexthop* | *mtu* | *ipsec*}
 
 A routing expression refers to routing data associated with a packet.
 
@@ -333,8 +331,8 @@ IPSEC EXPRESSIONS
 ~~~~~~~~~~~~~~~~~
 
 [verse]
-*ipsec* {in | out} [ spnum 'NUM' ]  {reqid | spi }
-*ipsec* {in | out} [ spnum 'NUM' ]  {ip | ip6 } { saddr | daddr }
+*ipsec* {*in* | *out*} [ *spnum* 'NUM' ]  {*reqid* | *spi*}
+*ipsec* {*in* | *out*} [ *spnum* 'NUM' ]  {*ip* | *ip6*} {*saddr* | *daddr*}
 
 An ipsec expression refers to ipsec data associated with a packet.
 
diff --git a/doc/stateful-objects.txt b/doc/stateful-objects.txt
index 6de4e8bd023fb..cc1b698d7831a 100644
--- a/doc/stateful-objects.txt
+++ b/doc/stateful-objects.txt
@@ -1,7 +1,7 @@
 CT HELPER
 ~~~~~~~~~
 [verse]
-*ct* helper 'helper' {type 'type' protocol 'protocol' ; [l3proto 'family' ;] }
+*ct helper* 'helper' *{ type* 'type' *protocol* 'protocol' *;* [*l3proto* 'family' *;*] *}*
 
 Ct helper is used to define connection tracking helpers that can then be used in
 combination with the *ct helper set* statement. 'type' and 'protocol' are
@@ -43,7 +43,7 @@ table inet myhelpers {
 CT TIMEOUT
 ~~~~~~~~~~
 [verse]
-*ct* timeout 'name' {protocol 'protocol' ; policy = {'state': 'value'} ;[l3proto 'family' ;] }
+*ct timeout* 'name' *{ protocol* 'protocol' *; policy = {* 'state'*:* 'value' [*,* ...] *} ;* [*l3proto* 'family' *;*] *}*
 
 Ct timeout is used to update connection tracking timeout values.Timeout policies are assigned
 with the *ct timeout set* statement. 'protocol' and 'policy' are
@@ -98,7 +98,7 @@ sport=41360 dport=22
 COUNTER
 ~~~~~~~
 [verse]
-*counter* [packets bytes]
+*counter* ['packets bytes']
 
 .Counter specifications
 [options="header"]
@@ -115,7 +115,7 @@ unsigned integer (64 bit)
 QUOTA
 ~~~~~
 [verse]
-*quota* [over | until] [used]
+*quota* [*over* | *until*] ['used']
 
 .Quota specifications
 [options="header"]
diff --git a/doc/statements.txt b/doc/statements.txt
index d51e44c077087..bc2f944960100 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -3,8 +3,8 @@ VERDICT STATEMENT
 The verdict statement alters control flow in the ruleset and issues policy decisions for packets.
 
 [verse]
-{accept | drop | queue | continue | return}
-{jump | goto} 'chain'
+{*accept* | *drop* | *queue* | *continue* | *return*}
+{*jump* | *goto*} 'chain'
 
 *accept* and *drop* are absolute verdicts -- they terminate ruleset evaluation immediately.
 
@@ -35,7 +35,7 @@ resumes with the next base chain hook, not the rule following the queue verdict.
  call stack, meaning that after the new chain evaluation will continue at the last
  chain instead of the one containing the goto statement.
 
-.Verdict statements
+.Using verdict statements
 -------------------
 # process packets from eth0 and the internal network in from_lan
 # chain, drop all packets from eth0 with different source addresses.
@@ -46,8 +46,11 @@ filter input iif eth0 drop
 
 PAYLOAD STATEMENT
 ~~~~~~~~~~~~~~~~~
+[verse]
+'payload_expression' *set* 'value'
+
 The payload statement alters packet content. It can be used for example to
-set ip DSCP (differv) header field or ipv6 flow labels.
+set ip DSCP (diffserv) header field or ipv6 flow labels.
 
 .route some packets instead of bridging
 ---------------------------------------
@@ -63,6 +66,9 @@ ip forward ip dscp set 42
 
 EXTENSION HEADER STATEMENT
 ~~~~~~~~~~~~~~~~~~~~~~~~~~
+[verse]
+'extension_header_expression' *set* 'value'
+
 The extension header statement alters packet content in variable-sized headers.
 This can currently be used to alter the TCP Maximum segment size of packets,
 similar to TCPMSS.
@@ -77,9 +83,9 @@ tcp flags syn tcp option maxseg size set rt mtu
 LOG STATEMENT
 ~~~~~~~~~~~~~
 [verse]
-*log* [prefix 'quoted_string'] [level 'syslog-level'] [flags 'log-flags']
-*log* group 'nflog_group' [prefix 'quoted_string'] [queue-threshold 'value'] [snaplen 'size']
-*log* level audit
+*log* [*prefix* 'quoted_string'] [*level* 'syslog-level'] [*flags* 'log-flags']
+*log* *group* 'nflog_group' [*prefix* 'quoted_string'] [*queue-threshold* 'value'] [*snaplen* 'size']
+*log level audit*
 
 The log statement enables logging of matching packets. When this statement is
 used from a rule, the Linux kernel will print some information on all matching
@@ -154,8 +160,14 @@ ip6 filter output log flags all
 REJECT STATEMENT
 ~~~~~~~~~~~~~~~~
 [verse]
-*reject* [ with {icmp | icmpv6 | icmpx} type {icmp_code | icmpv6_code | icmpx_code} ]
-*reject* [ with tcp reset ]
+____
+*reject* [ *with* 'REJECT_WITH' ]
+
+'REJECT_WITH' := *icmp type* 'icmp_code' |
+                 *icmpv6 type* 'icmpv6_code' |
+                 *icmpx type* 'icmpx_code' |
+                 *tcp reset*
+____
 
 A reject statement is used to send back an error packet in response to the
 matched packet otherwise it is equivalent to drop so it is a terminating
@@ -190,14 +202,15 @@ COUNTER STATEMENT
 A counter statement sets the hit count of packets along with the number of bytes.
 
 [verse]
-*counter* [ packets 'number' bytes 'number' ]
+*counter* *packets* 'number' *bytes* 'number'
+*counter* { *packets* 'number' | *bytes* 'number' }
 
 CONNTRACK STATEMENT
 ~~~~~~~~~~~~~~~~~~~
 The conntrack statement can be used to set the conntrack mark and conntrack labels.
 
 [verse]
-*ct* {mark | event | label | zone} set 'value'
+*ct* {*mark* | *event* | *label* | *zone*} *set* 'value'
 
 The ct statement sets meta data associated with a connection. The zone id
 has to be assigned before a conntrack lookup takes place, i.e. this has to be
@@ -254,7 +267,8 @@ META STATEMENT
 A meta statement sets the value of a meta expression. The existing meta fields
 are: priority, mark, pkttype, nftrace. +
 
-meta {mark | priority | pkttype | nftrace} set 'value' +
+[verse]
+*meta* {*mark* | *priority* | *pkttype* | *nftrace*} *set* 'value'
 
 A meta statement sets meta data associated with a packet. +
 
@@ -279,13 +293,18 @@ ruleset packet tracing on/off. Use *monitor trace* command to watch traces|
 LIMIT STATEMENT
 ~~~~~~~~~~~~~~~
 [verse]
-*limit* rate [over] 'packet_number' / {second | minute | hour | day} [burst 'packet_number' packets]
-*limit* rate [over] 'byte_number' {bytes | kbytes | mbytes} / {second | minute | hour | day | week} [burst 'byte_number' bytes]
+____
+*limit rate* [*over*] 'packet_number' */* 'TIME_UNIT' [*burst* 'packet_number' *packets*]
+*limit rate* [*over*] 'byte_number' 'BYTE_UNIT' */* 'TIME_UNIT' [*burst* 'byte_number' 'BYTE_UNIT']
+
+'TIME_UNIT' := *second* | *minute* | *hour* | *day*
+'BYTE_UNIT' := *bytes* | *kbytes* | *mbytes*
+____
 
 A limit statement matches at a limited rate using a token bucket filter. A rule
 using this statement will match until this limit is reached. It can be used in
-combination with the log statement to give limited logging. The over keyword,
-that is optional, makes it match over the specified rate.
+combination with the log statement to give limited logging. The optional
+*over* keyword makes it match over the specified rate.
 
 .limit statement values
 [options="header"]
@@ -302,16 +321,23 @@ unsigned integer (32 bit)
 NAT STATEMENTS
 ~~~~~~~~~~~~~~
 [verse]
-*snat* to address [:port] [persistent, random, fully-random]
-*snat* to address - address [:port - port] [persistent, random, fully-random]
-*snat* to { ip | ip6 } address - address [:port - port] [persistent, random ]
-*dnat* to address [:port] [persistent, random, fully-random]
-*dnat* to address [:port - port] [persistent, random ]
-*dnat* to { ip | ip6 } address [:port - port] [persistent, random ]
-*masquerade* to [:port] [persistent, random, fully-random]
-*masquerade* to [:port - port] [persistent, random, fully-random]
-*redirect* to [:port] [persistent, random, fully-random]
-*redirect* to [:port - port] [persistent, random, fully-random]
+____
+*snat to* 'address' [*:*'port'] ['PRF_FLAGS']
+*snat to* 'address' *-* 'address' [*:*'port' *-* 'port'] ['PRF_FLAGS']
+*snat to* { *ip* | *ip6* } 'address' *-* 'address' [*:*'port' *-* 'port'] ['PR_FLAGS']
+*dnat to* 'address' [*:*'port'] ['PRF_FLAGS']
+*dnat to* 'address' [*:*'port' *-* 'port'] ['PR_FLAGS']
+*dnat to* { *ip* | *ip6* } 'address' [*:*'port' *-* 'port'] ['PR_FLAGS']
+*masquerade to* [*:*'port'] ['PRF_FLAGS']
+*masquerade to* [*:*'port' *-* 'port'] ['PRF_FLAGS']
+*redirect to* [*:*'port'] ['PRF_FLAGS']
+*redirect to* [*:*'port' *-* 'port'] ['PRF_FLAGS']
+
+'PRF_FLAGS' := 'PRF_FLAG' [*,* 'PRF_FLAGS']
+'PR_FLAGS'  := 'PR_FLAG' [*,* 'PR_FLAGS']
+'PRF_FLAG'  := 'PR_FLAG' | *fully-random*
+'PR_FLAG'   := *persistent* | *random*
+____
 
 The nat statements are only valid from nat chain types. +
 
@@ -407,16 +433,16 @@ is used as parameter. Tproxy matching requires another rule that ensures the
 presence of transport protocol header is specified.
 
 [verse]
-tproxy to 'address' : 'port'
-tproxy to {'address' | : 'port'}
+*tproxy to* 'address'*:*'port'
+*tproxy to* {'address' | *:*'port'}
 
 This syntax can be used in *ip/ip6* tables where network layer protocol is
-obvious. Either ip address or port can be specified, but at least one of them is
+obvious. Either IP address or port can be specified, but at least one of them is
 necessary.
 
 [verse]
-tproxy {ip | ip6} to 'address' [: 'port']
-tproxy to : 'port'
+*tproxy* {*ip* | *ip6*} *to* 'address'[*:*'port']
+*tproxy to :*'port'
 
 This syntax can be used in *inet* tables. The *ip/ip6* parameter defines the
 family the rule will match. The *address* parameter must be of this family.
@@ -463,7 +489,7 @@ A flow statement allows us to select what flows you want to accelerate
 forwarding through layer 3 network stack bypass. You have to specify the
 flowtable name where you want to offload this flow.
 
-*flow add* @flowtable
+*flow add @*'flowtable'
 
 QUEUE STATEMENT
 ~~~~~~~~~~~~~~~
@@ -474,8 +500,14 @@ or re-inject the packet into the kernel. See libnetfilter_queue documentation
 for details.
 
 [verse]
-*queue* [num 'queue_number'] [bypass]
-*queue* [num 'queue_number_from' - 'queue_number_to'] [bypass,fanout]
+____
+*queue* [*num* 'queue_number'] [*bypass*]
+*queue* [*num* 'queue_number_from' - 'queue_number_to'] ['QUEUE_FLAGS']
+
+'QUEUE_FLAGS' := 'QUEUE_FLAG' [*,* 'QUEUE_FLAGS']
+'QUEUE_FLAG'  := *bypass* | *fanout*
+____
+
 
 .queue statement values
 [options="header"]
@@ -509,8 +541,8 @@ The dup statement is used to duplicate a packet and send the copy to a different
 destination.
 
 [verse]
-*dup* to 'device'
-*dup* to 'address' device '*device*'
+*dup to* 'device'
+*dup to* 'address' *device* 'device'
 
 .Dup statement values
 [options="header"]
@@ -544,7 +576,7 @@ The fwd statement is used to redirect a raw packet to another interface. It is
 only available in the netdev family ingress hook. It is similar to the dup
 statement except that no copy is made.
 
-*fwd* to 'device'
+*fwd to* 'device'
 
 SET STATEMENT
 ~~~~~~~~~~~~~
@@ -556,7 +588,7 @@ number of entries in set will not grow indefinitely). The set statement can be
 used to e.g. create dynamic blacklists.
 
 [verse]
-{add | update} '@setname' { 'expression' [timeout 'timeout'] [comment 'string'] }
+{*add* | *update*} *@*'setname' *{* 'expression' [*timeout* 'timeout'] [*comment* 'string'] *}*
 
 .Example for simple blacklist
 -----------------------------
@@ -588,7 +620,15 @@ MAP STATEMENT
 The map statement is used to lookup data based on some specific input key.
 
 [verse]
-'expression' *map* *{* 'key' *:* 'value' [*,* 'key' *:* 'value' ...] *}*
+____
+'expression' *map* *{* 'MAP_ELEMENTS' *}*
+
+'MAP_ELEMENTS' := 'MAP_ELEMENT' [*,* 'MAP_ELEMENTS']
+'MAP_ELEMENT'  := 'key' *:* 'value'
+____
+
+The 'key' is a value returned by 'expression'.
+// XXX: Write about where map statement can be used (list of statements?)
 
 .Using the map statement
 ------------------------
@@ -609,7 +649,12 @@ The verdict map (vmap) statement works analogous to the map statement, but
 contains verdicts as values.
 
 [verse]
-'expression' *vmap* *{* 'key' *:* 'verdict' [*,* 'key' *:* 'verdict' ...] *}*
+____
+'expression' *vmap* *{* 'VMAP_ELEMENTS' *}*
+
+'VMAP_ELEMENTS' := 'VMAP_ELEMENT' [*,* 'VMAP_ELEMENTS']
+'VMAP_ELEMENT'  := 'key' *:* 'verdict'
+____
 
 .Using the vmap statement
 -------------------------
-- 
2.21.0

