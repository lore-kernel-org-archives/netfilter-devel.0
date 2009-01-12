From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: doc: escape minus sign in manpages
Date: Mon, 12 Jan 2009 03:39:16 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901120339080.20867@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0901090313110.16418@fbirervta.pbzchgretzou.qr> <496A9E8A.10405@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44541 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbZALCjU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Jan 2009 21:39:20 -0500
In-Reply-To: <496A9E8A.10405@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-01-12 02:36, Pablo Neira Ayuso wrote:
>
>> --- a/extensions/libip6t_LOG.man
>> +++ b/extensions/libip6t_LOG.man
>> @@ -1,31 +1,31 @@
>>  Turn on kernel logging of matching packets.  When this option is set
>>  for a rule, the Linux kernel will print some information on all
>> -matching packets (like most IPv6 IPv6-header fields) via the kernel log
>> +matching packets (like most IPv6 IPv6\-header fields) via the kernel log
>                                        ^^
>But hyphen is fine here.
>
>Could you rework you script to actually change only options to minus?
>This would result in a smaller patch.

parent fbb9d345e207d1441922d22e0be86f428c815ae7 (v1.4.3-rc1-14-gfbb9d34)
commit 44b2ac542f2f587b366506129c52a0f716b770d3
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Fri Jan 9 03:09:47 2009 +0100

doc: escape minus sign in manpages

groff formats '-' as a hyphen, and '\-' is needed for a minus.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_HL.man         |    6 ++--
 extensions/libip6t_LOG.man        |   12 ++++----
 extensions/libip6t_REJECT.man     |   26 ++++++++---------
 extensions/libip6t_ah.man         |    6 ++--
 extensions/libip6t_dst.man        |    4 +-
 extensions/libip6t_frag.man       |   12 ++++----
 extensions/libip6t_hbh.man        |    4 +-
 extensions/libip6t_hl.man         |    6 ++--
 extensions/libip6t_icmp6.man      |    6 ++--
 extensions/libip6t_ipv6header.man |    8 ++--
 extensions/libip6t_mh.man         |    6 ++--
 extensions/libip6t_rt.man         |   12 ++++----
 extensions/libipt_CLUSTERIP.man   |   16 +++++-----
 extensions/libipt_DNAT.man        |   14 ++++----
 extensions/libipt_ECN.man         |    4 +-
 extensions/libipt_LOG.man         |   12 ++++----
 extensions/libipt_MASQUERADE.man  |   10 +++---
 extensions/libipt_NETMAP.man      |    2 +-
 extensions/libipt_REDIRECT.man    |   10 +++---
 extensions/libipt_REJECT.man      |   24 +++++++--------
 extensions/libipt_SAME.man        |    8 ++--
 extensions/libipt_SET.man         |    4 +-
 extensions/libipt_SNAT.man        |   14 ++++----
 extensions/libipt_TTL.man         |    6 ++--
 extensions/libipt_ULOG.man        |    8 ++--
 extensions/libipt_addrtype.man    |   12 ++++----
 extensions/libipt_ah.man          |    2 +-
 extensions/libipt_ecn.man         |    6 ++--
 extensions/libipt_icmp.man        |    6 ++--
 extensions/libipt_realm.man       |    2 +-
 extensions/libipt_set.man         |    4 +-
 extensions/libipt_ttl.man         |    6 ++--
 extensions/libxt_CLASSIFY.man     |    4 +-
 extensions/libxt_CONNMARK.man     |   28 +++++++++---------
 extensions/libxt_CONNSECMARK.man  |    4 +-
 extensions/libxt_DSCP.man         |    4 +-
 extensions/libxt_MARK.man         |   16 +++++-----
 extensions/libxt_NFLOG.man        |   10 +++---
 extensions/libxt_NFQUEUE.man      |    2 +-
 extensions/libxt_RATEEST.man      |    6 ++--
 extensions/libxt_SECMARK.man      |    2 +-
 extensions/libxt_TCPMSS.man       |   12 ++++----
 extensions/libxt_TCPOPTSTRIP.man  |    6 ++--
 extensions/libxt_TOS.man          |   18 ++++++------
 extensions/libxt_TPROXY.man       |   10 +++---
 extensions/libxt_comment.man      |    4 +-
 extensions/libxt_connbytes.man    |    8 ++--
 extensions/libxt_connlimit.man    |   16 +++++-----
 extensions/libxt_connmark.man     |    2 +-
 extensions/libxt_conntrack.man    |   30 ++++++++++----------
 extensions/libxt_dccp.man         |    8 ++--
 extensions/libxt_dscp.man         |    4 +-
 extensions/libxt_esp.man          |    2 +-
 extensions/libxt_hashlimit.man    |   36 ++++++++++++------------
 extensions/libxt_helper.man       |    4 +-
 extensions/libxt_iprange.man      |    4 +-
 extensions/libxt_length.man       |    2 +-
 extensions/libxt_limit.man        |    4 +-
 extensions/libxt_mac.man          |    2 +-
 extensions/libxt_mark.man         |    2 +-
 extensions/libxt_multiport.man    |   14 ++++----
 extensions/libxt_owner.man        |   10 +++---
 extensions/libxt_physdev.man      |   10 +++---
 extensions/libxt_pkttype.man      |    2 +-
 extensions/libxt_policy.man       |   26 ++++++++--------
 extensions/libxt_quota.man        |    2 +-
 extensions/libxt_rateest.man      |   42 ++++++++++++++--------------
 extensions/libxt_recent.man       |   44 ++++++++++++++--------------
 extensions/libxt_sctp.man         |   12 ++++----
 extensions/libxt_state.man        |    2 +-
 extensions/libxt_statistic.man    |   14 ++++----
 extensions/libxt_string.man       |   10 +++---
 extensions/libxt_tcp.man          |   22 +++++++-------
 extensions/libxt_tcpmss.man       |    2 +-
 extensions/libxt_time.man         |   38 ++++++++++++------------
 extensions/libxt_tos.man          |    6 ++--
 extensions/libxt_u32.man          |   10 +++---
 extensions/libxt_udp.man          |   10 +++---
 ip6tables.8.in                    |   26 ++++++++++------
 79 files changed, 416 insertions(+), 414 deletions(-)

diff --git a/extensions/libip6t_HL.man b/extensions/libip6t_HL.man
index 050641f..0f3afb1 100644
--- a/extensions/libip6t_HL.man
+++ b/extensions/libip6t_HL.man
@@ -7,11 +7,11 @@ table.
 .PP
 .B Don't ever set or increment the value on packets that leave your local network!
 .TP
-.BI "--hl-set " "value"
+\fB\-\-hl\-set\fP \fIvalue\fP
 Set the Hop Limit to `value'.
 .TP
-.BI "--hl-dec " "value"
+\fB\-\-hl\-dec\fP \fIvalue\fP
 Decrement the Hop Limit `value' times.
 .TP
-.BI "--hl-inc " "value"
+\fB\-\-hl\-inc\fP \fIvalue\fP
 Increment the Hop Limit `value' times.
diff --git a/extensions/libip6t_LOG.man b/extensions/libip6t_LOG.man
index 9d51fd4..b7803fe 100644
--- a/extensions/libip6t_LOG.man
+++ b/extensions/libip6t_LOG.man
@@ -10,22 +10,22 @@ the next rule.  So if you want to LOG the packets you refuse, use two
 separate rules with the same matching criteria, first using target LOG
 then DROP (or REJECT).
 .TP
-.BI "--log-level " "level"
+\fB\-\-log\-level\fP \fIlevel\fP
 Level of logging (numeric or see \fIsyslog.conf\fP(5)).
 .TP
-.BI "--log-prefix " "prefix"
+\fB\-\-log\-prefix\fP \fIprefix\fP
 Prefix log messages with the specified prefix; up to 29 letters long,
 and useful for distinguishing messages in the logs.
 .TP
-.B --log-tcp-sequence
+\fB\-\-log\-tcp\-sequence\fP
 Log TCP sequence numbers. This is a security risk if the log is
 readable by users.
 .TP
-.B --log-tcp-options
+\fB\-\-log\-tcp\-options\fP
 Log options from the TCP packet header.
 .TP
-.B --log-ip-options
+\fB\-\-log\-ip\-options\fP
 Log options from the IPv6 packet header.
 .TP
-.B --log-uid
+\fB\-\-log\-uid\fP
 Log the userid of the process which generated the packet.
diff --git a/extensions/libip6t_REJECT.man b/extensions/libip6t_REJECT.man
index 877a769..2d09e05 100644
--- a/extensions/libip6t_REJECT.man
+++ b/extensions/libip6t_REJECT.man
@@ -11,25 +11,23 @@ chains, and user-defined chains which are only called from those
 chains.  The following option controls the nature of the error packet
 returned:
 .TP
-.BI "--reject-with " "type"
+\fB\-\-reject\-with\fP \fItype\fP
 The type given can be
-.nf
-.B " icmp6-no-route"
-.B " no-route"
-.B " icmp6-adm-prohibited"
-.B " adm-prohibited"
-.B " icmp6-addr-unreachable"
-.B " addr-unreach"
-.B " icmp6-port-unreachable"
-.B " port-unreach"
-.fi
-which return the appropriate ICMPv6 error message (\fBport-unreach\fP is
+\fBicmp6\-no\-route\fP,
+\fBno\-route\fP,
+\fBicmp6\-adm\-prohibited\fP,
+\fBadm\-prohibited\fP,
+\fBicmp6\-addr\-unreachable\fP,
+\fBaddr\-unreach\fP,
+\fBicmp6\-port\-unreachable\fP or
+\fBport\-unreach\fP
+which return the appropriate ICMPv6 error message (\fBport\-unreach\fP is
 the default). Finally, the option
-.B tcp-reset
+\fBtcp\-reset\fP
 can be used on rules which only match the TCP protocol: this causes a
 TCP RST packet to be sent back.  This is mainly useful for blocking 
 .I ident
 (113/tcp) probes which frequently occur when sending mail to broken mail
 hosts (which won't accept your mail otherwise).
-.B tcp-reset
+\fBtcp\-reset\fP
 can only be used with kernel versions 2.6.14 or later.
diff --git a/extensions/libip6t_ah.man b/extensions/libip6t_ah.man
index b4e74dc..9c24dcf 100644
--- a/extensions/libip6t_ah.man
+++ b/extensions/libip6t_ah.man
@@ -1,10 +1,10 @@
 This module matches the parameters in Authentication header of IPsec packets.
 .TP
-[\fB!\fP] \fB--ahspi\fP \fIspi\fP[\fB:\fP\fIspi\fP]
+[\fB!\fP] \fB\-\-ahspi\fP \fIspi\fP[\fB:\fP\fIspi\fP]
 Matches SPI.
 .TP
-[\fB!\fP] \fB--ahlen\fP \fIlength\fP
+[\fB!\fP] \fB\-\-ahlen\fP \fIlength\fP
 Total length of this header in octets.
 .TP
-.BI "--ahres"
+\fB\-\-ahres\fP
 Matches if the reserved field is filled with zero.
diff --git a/extensions/libip6t_dst.man b/extensions/libip6t_dst.man
index f4ca1c4..bfbb501 100644
--- a/extensions/libip6t_dst.man
+++ b/extensions/libip6t_dst.man
@@ -1,7 +1,7 @@
 This module matches the parameters in Destination Options header
 .TP
-[\fB!\fP] \fB--dst-len\fP \fIlength\fP
+[\fB!\fP] \fB\-\-dst\-len\fP \fIlength\fP
 Total length of this header in octets.
 .TP
-\fB--dst-opts\fP \fItype\fP[\fB:\fP\fIlength\fP][\fB,\fP\fItype\fP[\fB:\fP\fIlength\fP]...]
+\fB\-\-dst\-opts\fP \fItype\fP[\fB:\fP\fIlength\fP][\fB,\fP\fItype\fP[\fB:\fP\fIlength\fP]...]
 numeric type of option and the length of the option data in octets.
diff --git a/extensions/libip6t_frag.man b/extensions/libip6t_frag.man
index 7832cbf..7bfa227 100644
--- a/extensions/libip6t_frag.man
+++ b/extensions/libip6t_frag.man
@@ -1,20 +1,20 @@
 This module matches the parameters in Fragment header.
 .TP
-[\fB!\fP] \fB--fragid\fP \fIid\fP[\fB:\fP\fIid\fP]
+[\fB!\fP] \fB\-\-fragid\fP \fIid\fP[\fB:\fP\fIid\fP]
 Matches the given Identification or range of it.
 .TP
-[\fB!\fP] \fB--fraglen\fP \fIlength\fP
+[\fB!\fP] \fB\-\-fraglen\fP \fIlength\fP
 This option cannot be used with kernel version 2.6.10 or later. The length of
 Fragment header is static and this option doesn't make sense.
 .TP
-.BR "--fragres "
+\fB\-\-fragres\fP
 Matches if the reserved fields are filled with zero.
 .TP
-.BR "--fragfirst "
+\fB\-\-fragfirst\fP
 Matches on the first fragment.
 .TP
-\fB--fragmore\fP
+\fB\-\-fragmore\fP
 Matches if there are more fragments.
 .TP
-\fB--fraglast\fP
+\fB\-\-fraglast\fP
 Matches if this is the last fragment.
diff --git a/extensions/libip6t_hbh.man b/extensions/libip6t_hbh.man
index 38bae11..2d92e04 100644
--- a/extensions/libip6t_hbh.man
+++ b/extensions/libip6t_hbh.man
@@ -1,7 +1,7 @@
 This module matches the parameters in Hop-by-Hop Options header
 .TP
-[\fB!\fP] \fB--hbh-len\fP \fIlength\fP
+[\fB!\fP] \fB\-\-hbh\-len\fP \fIlength\fP
 Total length of this header in octets.
 .TP
-\fB--hbh-opts\fP \fItype\fP[\fB:\fP\fIlength\fP][\fB,\fP\fItype\fP[\fB:\fP\fIlength\fP]...]
+\fB\-\-hbh\-opts\fP \fItype\fP[\fB:\fP\fIlength\fP][\fB,\fP\fItype\fP[\fB:\fP\fIlength\fP]...]
 numeric type of option and the length of the option data in octets.
diff --git a/extensions/libip6t_hl.man b/extensions/libip6t_hl.man
index c8c7cd7..dfbfaf8 100644
--- a/extensions/libip6t_hl.man
+++ b/extensions/libip6t_hl.man
@@ -1,10 +1,10 @@
 This module matches the Hop Limit field in the IPv6 header.
 .TP
-[\fB!\fP] \fB--hl-eq\fP \fIvalue\fP
+[\fB!\fP] \fB\-\-hl\-eq\fP \fIvalue\fP
 Matches if Hop Limit equals \fIvalue\fP.
 .TP
-.BI "--hl-lt " "value"
+\fB\-\-hl\-lt\fP \fIvalue\fP
 Matches if Hop Limit is less than \fIvalue\fP.
 .TP
-.BI "--hl-gt " "value"
+\fB\-\-hl\-gt\fP \fIvalue\fP
 Matches if Hop Limit is greater than \fIvalue\fP.
diff --git a/extensions/libip6t_icmp6.man b/extensions/libip6t_icmp6.man
index 60dddf7..817e21c 100644
--- a/extensions/libip6t_icmp6.man
+++ b/extensions/libip6t_icmp6.man
@@ -1,7 +1,7 @@
-This extension can be used if `--protocol ipv6-icmp' or `--protocol icmpv6' is
+This extension can be used if `\-\-protocol ipv6\-icmp' or `\-\-protocol icmpv6' is
 specified. It provides the following option:
 .TP
-[\fB!\fP] \fB--icmpv6-type\fP \fItype\fP[\fB/\fP\fIcode\fP]|\fItypename\fP
+[\fB!\fP] \fB\-\-icmpv6\-type\fP \fItype\fP[\fB/\fP\fIcode\fP]|\fItypename\fP
 This allows specification of the ICMPv6 type, which can be a numeric
 ICMPv6
 .IR type ,
@@ -10,5 +10,5 @@ and
 .IR code ,
 or one of the ICMPv6 type names shown by the command
 .nf
- ip6tables -p ipv6-icmp -h
+ ip6tables \-p ipv6\-icmp \-h
 .fi
diff --git a/extensions/libip6t_ipv6header.man b/extensions/libip6t_ipv6header.man
index 23478b4..a998861 100644
--- a/extensions/libip6t_ipv6header.man
+++ b/extensions/libip6t_ipv6header.man
@@ -1,15 +1,15 @@
 This module matches IPv6 extension headers and/or upper layer header.
 .TP
-\fB--soft\fP
+\fB\-\-soft\fP
 Matches if the packet includes \fBany\fP of the headers specified with
-\fB--header\fP.
+\fB\-\-header\fP.
 .TP
-[\fB!\fP] \fB--header\fP \fIheader\fP[\fB,\fP\fIheader\fP...]
+[\fB!\fP] \fB\-\-header\fP \fIheader\fP[\fB,\fP\fIheader\fP...]
 Matches the packet which EXACTLY includes all specified headers. The headers
 encapsulated with ESP header are out of scope.
 Possible \fIheader\fP types can be:
 .TP
-\fBhop\fP|\fBhop-by-hop\fP
+\fBhop\fP|\fBhop\-by\-hop\fP
 Hop-by-Hop Options header
 .TP
 \fBdst\fP
diff --git a/extensions/libip6t_mh.man b/extensions/libip6t_mh.man
index f5a1f96..4559e78 100644
--- a/extensions/libip6t_mh.man
+++ b/extensions/libip6t_mh.man
@@ -1,12 +1,12 @@
-This extension is loaded if `--protocol ipv6-mh' or `--protocol mh' is
+This extension is loaded if `\-\-protocol ipv6\-mh' or `\-\-protocol mh' is
 specified. It provides the following option:
 .TP
-[\fB!\fP] \fB--mh-type\fP \fItype\fP[\fB:\fP\fItype\fP]
+[\fB!\fP] \fB\-\-mh\-type\fP \fItype\fP[\fB:\fP\fItype\fP]
 This allows specification of the Mobility Header(MH) type, which can be
 a numeric MH
 .IR type ,
 .IR type
 or one of the MH type names shown by the command
 .nf
- ip6tables -p ipv6-mh -h
+ ip6tables \-p ipv6\-mh \-h
 .fi
diff --git a/extensions/libip6t_rt.man b/extensions/libip6t_rt.man
index 0ccaa5f..0443e0a 100644
--- a/extensions/libip6t_rt.man
+++ b/extensions/libip6t_rt.man
@@ -1,19 +1,19 @@
 Match on IPv6 routing header
 .TP
-[\fB!\fP] \fB--rt-type\fP \fItype\fP
+[\fB!\fP] \fB\-\-rt\-type\fP \fItype\fP
 Match the type (numeric).
 .TP
-[\fB!\fP] \fB--rt-segsleft\fP \fInum\fP[\fB:\fP\fInum\fP]
+[\fB!\fP] \fB\-\-rt\-segsleft\fP \fInum\fP[\fB:\fP\fInum\fP]
 Match the `segments left' field (range).
 .TP
-[\fB!\fP] \fB--rt-len\fP \fIlength\fP
+[\fB!\fP] \fB\-\-rt\-len\fP \fIlength\fP
 Match the length of this header.
 .TP
-.BR "--rt-0-res"
+\fB\-\-rt\-0\-res\fP
 Match the reserved field, too (type=0)
 .TP
-\fB--rt-0-addrs\fP \fIaddr\fP[\fB,\fP\fIaddr\fP...]
+\fB\-\-rt\-0\-addrs\fP \fIaddr\fP[\fB,\fP\fIaddr\fP...]
 Match type=0 addresses (list).
 .TP
-.BR "--rt-0-not-strict"
+\fB\-\-rt\-0\-not\-strict\fP
 List of type=0 addresses is not a strict list.
diff --git a/extensions/libipt_CLUSTERIP.man b/extensions/libipt_CLUSTERIP.man
index 8e766f3..8ec6d6b 100644
--- a/extensions/libipt_CLUSTERIP.man
+++ b/extensions/libipt_CLUSTERIP.man
@@ -3,22 +3,22 @@ a certain IP and MAC address without an explicit load balancer in front of
 them.  Connections are statically distributed between the nodes in this
 cluster.
 .TP
-.BI "--new "
+\fB\-\-new\fP
 Create a new ClusterIP.  You always have to set this on the first rule
 for a given ClusterIP.
 .TP
-.BI "--hashmode " "mode"
+\fB\-\-hashmode\fP \fImode\fP
 Specify the hashing mode.  Has to be one of
-.B sourceip, sourceip-sourceport, sourceip-sourceport-destport
+\fBsourceip\fP, \fBsourceip\-sourceport\fP, \fBsourceip\-sourceport\-destport\fP.
 .TP
-.BI "--clustermac " "mac"
-Specify the ClusterIP MAC address.  Has to be a link-layer multicast address
+\fB\-\-clustermac\fP \fImac\fP
+Specify the ClusterIP MAC address. Has to be a link\-layer multicast address
 .TP
-.BI "--total-nodes " "num"
+\fB\-\-total\-nodes\fP \fInum\fP
 Number of total nodes within this cluster.
 .TP
-.BI "--local-node " "num"
+\fB\-\-local\-node\fP \fInum\fP
 Local node number within this cluster.
 .TP
-.BI "--hash-init " "rnd"
+\fB\-\-hash\-init\fP \fIrnd\fP
 Specify the random seed used for hash initialization.
diff --git a/extensions/libipt_DNAT.man b/extensions/libipt_DNAT.man
index 65c152c..22e84c6 100644
--- a/extensions/libipt_DNAT.man
+++ b/extensions/libipt_DNAT.man
@@ -10,27 +10,27 @@ should be modified (and all future packets in this connection will
 also be mangled), and rules should cease being examined.  It takes one
 type of option:
 .TP
-\fB--to-destination\fP [\fIipaddr\fP][\fB-\fP\fIipaddr\fP][\fB:\fP\fIport\fP[\fB-\fP\fIport\fP]]
+\fB\-\-to\-destination\fP [\fIipaddr\fP][\fB\-\fP\fIipaddr\fP][\fB:\fP\fIport\fP[\fB\-\fP\fIport\fP]]
 which can specify a single new destination IP address, an inclusive
 range of IP addresses, and optionally, a port range (which is only
 valid if the rule also specifies
-.B "-p tcp"
+\fB\-p tcp\fP
 or
-.BR "-p udp" ).
+\fB\-p udp\fP).
 If no port range is specified, then the destination port will never be
 modified. If no IP address is specified then only the destination port
 will be modified.
 
-In Kernels up to 2.6.10 you can add several --to-destination options.  For
+In Kernels up to 2.6.10 you can add several \-\-to\-destination options. For
 those kernels, if you specify more than one destination address, either via an
-address range or multiple --to-destination options, a simple round-robin (one
+address range or multiple \-\-to\-destination options, a simple round-robin (one
 after another in cycle) load balancing takes place between these addresses.
 Later Kernels (>= 2.6.11-rc1) don't have the ability to NAT to multiple ranges
 anymore.
 .TP
-.BR "--random"
+\fB\-\-random\fP
 If option
-.B "--random"
+\fB\-\-random\fP
 is used then port mapping will be randomized (kernel >= 2.6.22).
 .RS
 .PP
diff --git a/extensions/libipt_ECN.man b/extensions/libipt_ECN.man
index 3668490..a9cbe10 100644
--- a/extensions/libipt_ECN.man
+++ b/extensions/libipt_ECN.man
@@ -1,7 +1,7 @@
 This target allows to selectively work around known ECN blackholes.
 It can only be used in the mangle table.
 .TP
-.BI "--ecn-tcp-remove"
+\fB\-\-ecn\-tcp\-remove\fP
 Remove all ECN bits from the TCP header.  Of course, it can only be used
 in conjunction with
-.BR "-p tcp" .
+\fB\-p tcp\fP.
diff --git a/extensions/libipt_LOG.man b/extensions/libipt_LOG.man
index 597ba3f..47c35e0 100644
--- a/extensions/libipt_LOG.man
+++ b/extensions/libipt_LOG.man
@@ -10,22 +10,22 @@ the next rule.  So if you want to LOG the packets you refuse, use two
 separate rules with the same matching criteria, first using target LOG
 then DROP (or REJECT).
 .TP
-.BI "--log-level " "level"
+\fB\-\-log\-level\fP \fIlevel\fP
 Level of logging (numeric or see \fIsyslog.conf\fP(5)).
 .TP
-.BI "--log-prefix " "prefix"
+\fB\-\-log\-prefix\fP \fIprefix\fP
 Prefix log messages with the specified prefix; up to 29 letters long,
 and useful for distinguishing messages in the logs.
 .TP
-.B --log-tcp-sequence
+\fB\-\-log\-tcp\-sequence\fP
 Log TCP sequence numbers. This is a security risk if the log is
 readable by users.
 .TP
-.B --log-tcp-options
+\fB\-\-log\-tcp\-options\fP
 Log options from the TCP packet header.
 .TP
-.B --log-ip-options
+\fB\-\-log\-ip\-options\fP
 Log options from the IP packet header.
 .TP
-.B --log-uid
+\fB\-\-log\-uid\fP
 Log the userid of the process which generated the packet.
diff --git a/extensions/libipt_MASQUERADE.man b/extensions/libipt_MASQUERADE.man
index f11ad86..8f42993 100644
--- a/extensions/libipt_MASQUERADE.man
+++ b/extensions/libipt_MASQUERADE.man
@@ -12,19 +12,19 @@ when the interface goes down.  This is the correct behavior when the
 next dialup is unlikely to have the same interface address (and hence
 any established connections are lost anyway).  It takes one option:
 .TP
-\fB--to-ports\fP \fIport\fP[\fB-\fP\fIport\fP]
+\fB\-\-to\-ports\fP \fIport\fP[\fB\-\fP\fIport\fP]
 This specifies a range of source ports to use, overriding the default
 .B SNAT
 source port-selection heuristics (see above).  This is only valid
 if the rule also specifies
-.B "-p tcp"
+\fB\-p tcp\fP
 or
-.BR "-p udp" .
+\fB\-p udp\fP.
 .TP
-.BR "--random"
+\fB\-\-random\fP
 Randomize source port mapping
 If option
-.B "--random"
+\fB\-\-random\fP
 is used then port mapping will be randomized (kernel >= 2.6.21).
 .RS
 .PP
diff --git a/extensions/libipt_NETMAP.man b/extensions/libipt_NETMAP.man
index f6a933c..a7e90b8 100644
--- a/extensions/libipt_NETMAP.man
+++ b/extensions/libipt_NETMAP.man
@@ -3,7 +3,7 @@ another network of addresses.  It can only be used from rules in the
 .B nat
 table.
 .TP
-\fB--to\fP \fIaddress\fP[\fB/\fP\fImask\fP]
+\fB\-\-to\fP \fIaddress\fP[\fB/\fP\fImask\fP]
 Network address to map to.  The resulting address will be constructed in the
 following way: All 'one' bits in the mask are filled in from the new `address'.
 All bits that are zero in the mask are filled in from the original address.
diff --git a/extensions/libipt_REDIRECT.man b/extensions/libipt_REDIRECT.man
index 0217045..90ab19d 100644
--- a/extensions/libipt_REDIRECT.man
+++ b/extensions/libipt_REDIRECT.man
@@ -9,17 +9,17 @@ chains.  It redirects the packet to the machine itself by changing the
 destination IP to the primary address of the incoming interface
 (locally-generated packets are mapped to the 127.0.0.1 address).
 .TP
-\fB--to-ports\fP \fIport\fP[\fB-\fP\fIport\fP]
+\fB\-\-to\-ports\fP \fIport\fP[\fB\-\fP\fIport\fP]
 This specifies a destination port or range of ports to use: without
 this, the destination port is never altered.  This is only valid
 if the rule also specifies
-.B "-p tcp"
+\fB\-p tcp\fP
 or
-.BR "-p udp" .
+\fB\-p udp\fP.
 .TP
-.BR "--random"
+\fB\-\-random\fP
 If option
-.B "--random"
+\fB\-\-random\fP
 is used then port mapping will be randomized (kernel >= 2.6.22).
 .RS
 .PP
diff --git a/extensions/libipt_REJECT.man b/extensions/libipt_REJECT.man
index d738a3d..c419a85 100644
--- a/extensions/libipt_REJECT.man
+++ b/extensions/libipt_REJECT.man
@@ -11,24 +11,22 @@ chains, and user-defined chains which are only called from those
 chains.  The following option controls the nature of the error packet
 returned:
 .TP
-.BI "--reject-with " "type"
+\fB\-\-reject\-with\fP \fItype\fP
 The type given can be
-.nf
-.B " icmp-net-unreachable"
-.B " icmp-host-unreachable"
-.B " icmp-port-unreachable"
-.B " icmp-proto-unreachable"
-.B " icmp-net-prohibited"
-.B " icmp-host-prohibited or"
-.B " icmp-admin-prohibited (*)"
-.fi
-which return the appropriate ICMP error message (\fBport-unreachable\fP is
+\fBicmp\-net\-unreachable\fP,
+\fBicmp\-host\-unreachable\fP,
+\fBicmp\-port\-unreachable\fP,
+\fBicmp\-proto\-unreachable\fP,
+\fBicmp\-net\-prohibited\fP,
+\fBicmp\-host\-prohibited\fP or
+\fBicmp\-admin\-prohibited\fP (*)
+which return the appropriate ICMP error message (\fBport\-unreachable\fP is
 the default).  The option
-.B tcp-reset
+\fBtcp\-reset\fP
 can be used on rules which only match the TCP protocol: this causes a
 TCP RST packet to be sent back.  This is mainly useful for blocking 
 .I ident
 (113/tcp) probes which frequently occur when sending mail to broken mail
 hosts (which won't accept your mail otherwise).
 .PP
-(*) Using icmp-admin-prohibited with kernels that do not support it will result in a plain DROP instead of REJECT
+(*) Using icmp\-admin\-prohibited with kernels that do not support it will result in a plain DROP instead of REJECT
diff --git a/extensions/libipt_SAME.man b/extensions/libipt_SAME.man
index 7e28ca5..b862aa4 100644
--- a/extensions/libipt_SAME.man
+++ b/extensions/libipt_SAME.man
@@ -1,15 +1,15 @@
 Similar to SNAT/DNAT depending on chain: it takes a range of addresses
-(`--to 1.2.3.4-1.2.3.7') and gives a client the same
+(`\-\-to 1.2.3.4\-1.2.3.7') and gives a client the same
 source-/destination-address for each connection.
 .TP
-\fB--to\fP \fIipaddr\fP[\fB-\fP\fIipaddr\fP]
+\fB\-\-to\fP \fIipaddr\fP[\fB\-\fP\fIipaddr\fP]
 Addresses to map source to. May be specified more than once for
 multiple ranges.
 .TP
-.B "--nodst"
+\fB\-\-nodst\fP
 Don't use the destination-ip in the calculations when selecting the
 new source-ip
 .TP
-.B "--random"
+\fB\-\-random\fP
 Port mapping will be forcibly randomized to avoid attacks based on 
 port prediction (kernel >= 2.6.21).
diff --git a/extensions/libipt_SET.man b/extensions/libipt_SET.man
index e2e2727..a3e17e2 100644
--- a/extensions/libipt_SET.man
+++ b/extensions/libipt_SET.man
@@ -1,10 +1,10 @@
 This modules adds and/or deletes entries from IP sets which can be defined 
 by ipset(8).
 .TP
-\fB--add-set\fP \fIsetname\fP \fIflag\fP[\fB,\fP\fIflag\fP...]
+\fB\-\-add\-set\fP \fIsetname\fP \fIflag\fP[\fB,\fP\fIflag\fP...]
 add the address(es)/port(s) of the packet to the sets
 .TP
-\fB--del-set\fP \fIsetname\fP \fIflag\fP[\fB,\fP\fIflag\fP...]
+\fB\-\-del\-set\fP \fIsetname\fP \fIflag\fP[\fB,\fP\fIflag\fP...]
 delete the address(es)/port(s) of the packet from the sets,
 where flags are
 .BR "src"
diff --git a/extensions/libipt_SNAT.man b/extensions/libipt_SNAT.man
index 34939af..040571b 100644
--- a/extensions/libipt_SNAT.man
+++ b/extensions/libipt_SNAT.man
@@ -7,28 +7,28 @@ modified (and all future packets in this connection will also be
 mangled), and rules should cease being examined.  It takes one type
 of option:
 .TP
-\fB--to-source\fP \fIipaddr\fP[\fB-\fP\fIipaddr\fP][\fB:\fP\fIport\fP[\fB-\fP\fIport\fP]]
+\fB\-\-to\-source\fP \fIipaddr\fP[\fB\-\fP\fIipaddr\fP][\fB:\fP\fIport\fP[\fB\-\fP\fIport\fP]]
 which can specify a single new source IP address, an inclusive range
 of IP addresses, and optionally, a port range (which is only valid if
 the rule also specifies
-.B "-p tcp"
+\fB\-p tcp\fP
 or
-.BR "-p udp" ).
+\fB\-p udp\fP).
 If no port range is specified, then source ports below 512 will be
 mapped to other ports below 512: those between 512 and 1023 inclusive
 will be mapped to ports below 1024, and other ports will be mapped to
 1024 or above. Where possible, no port alteration will
 
-In Kernels up to 2.6.10, you can add several --to-source options.  For those
+In Kernels up to 2.6.10, you can add several \-\-to\-source options. For those
 kernels, if you specify more than one source address, either via an address
-range or multiple --to-source options, a simple round-robin (one after another
+range or multiple \-\-to\-source options, a simple round-robin (one after another
 in cycle) takes place between these addresses.
 Later Kernels (>= 2.6.11-rc1) don't have the ability to NAT to multiple ranges
 anymore.
 .TP
-.BR "--random"
+\fB\-\-random\fP
 If option
-.B "--random"
+\fB\-\-random\fP
 is used then port mapping will be randomized (kernel >= 2.6.21).
 .RS
 .PP
diff --git a/extensions/libipt_TTL.man b/extensions/libipt_TTL.man
index 25a4438..89fc18f 100644
--- a/extensions/libipt_TTL.man
+++ b/extensions/libipt_TTL.man
@@ -9,11 +9,11 @@ so it should be avoided at any cost.
 .B mangle
 table.
 .TP
-.BI "--ttl-set " "value"
+\fB\-\-ttl\-set\fP \fIvalue\fP
 Set the TTL value to `value'.
 .TP
-.BI "--ttl-dec " "value"
+\fB\-\-ttl\-dec\fP \fIvalue\fP
 Decrement the TTL value `value' times.
 .TP
-.BI "--ttl-inc " "value"
+\fB\-\-ttl\-inc\fP \fIvalue\fP
 Increment the TTL value `value' times.
diff --git a/extensions/libipt_ULOG.man b/extensions/libipt_ULOG.man
index 51aa619..649b6e3 100644
--- a/extensions/libipt_ULOG.man
+++ b/extensions/libipt_ULOG.man
@@ -7,19 +7,19 @@ multicast groups and receive the packets.
 Like LOG, this is a "non-terminating target", i.e. rule traversal
 continues at the next rule.
 .TP
-.BI "--ulog-nlgroup " "nlgroup"
+\fB\-\-ulog\-nlgroup\fP \fInlgroup\fP
 This specifies the netlink group (1-32) to which the packet is sent.
 Default value is 1.
 .TP
-.BI "--ulog-prefix " "prefix"
+\fB\-\-ulog\-prefix\fP \fIprefix\fP
 Prefix log messages with the specified prefix; up to 32 characters
 long, and useful for distinguishing messages in the logs.
 .TP
-.BI "--ulog-cprange " "size"
+\fB\-\-ulog\-cprange\fP \fIsize\fP
 Number of bytes to be copied to userspace.  A value of 0 always copies
 the entire packet, regardless of its size.  Default is 0.
 .TP
-.BI "--ulog-qthreshold " "size"
+\fB\-\-ulog\-qthreshold\fP \fIsize\fP
 Number of packet to queue inside kernel.  Setting this value to, e.g. 10
 accumulates ten packets inside the kernel and transmits them as one
 netlink multipart message to userspace.  Default is 1 (for backwards
diff --git a/extensions/libipt_addrtype.man b/extensions/libipt_addrtype.man
index 88e7c66..731f9b1 100644
--- a/extensions/libipt_addrtype.man
+++ b/extensions/libipt_addrtype.man
@@ -40,13 +40,13 @@ FIXME
 .TP
 .BI "XRESOLVE"
 .TP
-[\fB!\fP] \fB--src-type\fP \fItype\fP
+[\fB!\fP] \fB\-\-src\-type\fP \fItype\fP
 Matches if the source address is of given type
 .TP
-[\fB!\fP] \fB--dst-type\fP \fItype\fP
+[\fB!\fP] \fB\-\-dst\-type\fP \fItype\fP
 Matches if the destination address is of given type
 .TP
-.BI "--limit-iface-in"
+.BI "\-\-limit\-iface\-in"
 The address type checking can be limited to the interface the packet is coming
 in. This option is only valid in the
 .BR PREROUTING ,
@@ -54,10 +54,10 @@ in. This option is only valid in the
 and
 .B FORWARD
 chains. It cannot be specified with the
-.B "--limit-iface-out"
+\fB\-\-limit\-iface\-out\fP
 option.
 .TP
-.BI "--limit-iface-out"
+\fB\-\-limit\-iface\-out\fP
 The address type checiking can be limited to the interface the packet is going
 out. This option is only valid in the
 .BR POSTROUTING ,
@@ -65,5 +65,5 @@ out. This option is only valid in the
 and
 .B FORWARD
 chains. It cannot be specified with the
-.B --limit-iface-in
+\fB\-\-limit\-iface\-in\fP
 option.
diff --git a/extensions/libipt_ah.man b/extensions/libipt_ah.man
index 3076554..d26455e 100644
--- a/extensions/libipt_ah.man
+++ b/extensions/libipt_ah.man
@@ -1,3 +1,3 @@
 This module matches the SPIs in Authentication header of IPsec packets.
 .TP
-[\fB!\fP] \fB--ahspi\fP \fIspi\fP[\fB:\fP\fIspi\fP]
+[\fB!\fP] \fB\-\-ahspi\fP \fIspi\fP[\fB:\fP\fIspi\fP]
diff --git a/extensions/libipt_ecn.man b/extensions/libipt_ecn.man
index d289d08..7f80647 100644
--- a/extensions/libipt_ecn.man
+++ b/extensions/libipt_ecn.man
@@ -1,11 +1,11 @@
 This allows you to match the ECN bits of the IPv4 and TCP header.  ECN is the Explicit Congestion Notification mechanism as specified in RFC3168
 .TP
-[\fB!\fP] \fB--ecn-tcp-cwr\fP
+[\fB!\fP] \fB\-\-ecn\-tcp\-cwr\fP
 This matches if the TCP ECN CWR (Congestion Window Received) bit is set.
 .TP
-[\fB!\fP] \fB--ecn-tcp-ece\fP
+[\fB!\fP] \fB\-\-ecn\-tcp\-ece\fP
 This matches if the TCP ECN ECE (ECN Echo) bit is set.
 .TP
-[\fB!\fP] \fB--ecn-ip-ect\fP \fInum\fP
+[\fB!\fP] \fB\-\-ecn\-ip\-ect\fP \fInum\fP
 This matches a particular IPv4 ECT (ECN-Capable Transport). You have to specify
 a number between `0' and `3'.
diff --git a/extensions/libipt_icmp.man b/extensions/libipt_icmp.man
index a912769..8c1bdbe 100644
--- a/extensions/libipt_icmp.man
+++ b/extensions/libipt_icmp.man
@@ -1,9 +1,9 @@
-This extension can be used if `--protocol icmp' is specified.  It
+This extension can be used if `\-\-protocol icmp' is specified. It
 provides the following option:
 .TP
-[\fB!\fP] \fB--icmp-type\fP \fItypename\fP
+[\fB!\fP] \fB\-\-icmp\-type\fP \fItypename\fP
 This allows specification of the ICMP type, which can be a numeric
 ICMP type, or one of the ICMP type names shown by the command
 .nf
- iptables -p icmp -h
+ iptables \-p icmp \-h
 .fi
diff --git a/extensions/libipt_realm.man b/extensions/libipt_realm.man
index 362ab60..a40b1ad 100644
--- a/extensions/libipt_realm.man
+++ b/extensions/libipt_realm.man
@@ -1,7 +1,7 @@
 This matches the routing realm.  Routing realms are used in complex routing
 setups involving dynamic routing protocols like BGP.
 .TP
-[\fB!\fP] \fB--realm\fP \fIvalue\fP[\fB/\fP\fImask\fP]
+[\fB!\fP] \fB\-\-realm\fP \fIvalue\fP[\fB/\fP\fImask\fP]
 Matches a given realm number (and optionally mask). If not a number, value
 can be a named realm from /etc/iproute2/rt_realms (mask can not be used in
 that case).
diff --git a/extensions/libipt_set.man b/extensions/libipt_set.man
index c8ff601..0df73c1 100644
--- a/extensions/libipt_set.man
+++ b/extensions/libipt_set.man
@@ -1,13 +1,13 @@
 This modules macthes IP sets which can be defined by ipset(8).
 .TP
-[\fB!\fP] \fB--set\fP \fIsetname\fP \fIflag\fP[\fB,\fP\fIflag\fP]...
+[\fB!\fP] \fB\-\-set\fP \fIsetname\fP \fIflag\fP[\fB,\fP\fIflag\fP]...
 where flags are
 .BR "src"
 and/or
 .BR "dst" 
 and there can be no more than six of them. Hence the command
 .nf
- iptables -A FORWARD -m set --set test src,dst
+ iptables \-A FORWARD \-m set \-\-set test src,dst
 .fi
 will match packets, for which (depending on the type of the set) the source
 address or port number of the packet can be found in the specified set. If 
diff --git a/extensions/libipt_ttl.man b/extensions/libipt_ttl.man
index f043c79..849f704 100644
--- a/extensions/libipt_ttl.man
+++ b/extensions/libipt_ttl.man
@@ -1,10 +1,10 @@
 This module matches the time to live field in the IP header.
 .TP
-.BI "--ttl-eq " "ttl"
+\fB\-\-ttl\-eq\fP \fIttl\fP
 Matches the given TTL value.
 .TP
-.BI "--ttl-gt " "ttl"
+\fB\-\-ttl\-gt\fP \fIttl\fP
 Matches if TTL is greater than the given TTL value.
 .TP
-.BI "--ttl-lt " "ttl"
+\fB\-\-ttl\-lt\fP \fIttl\fP
 Matches if TTL is less than the given TTL value.
diff --git a/extensions/libxt_CLASSIFY.man b/extensions/libxt_CLASSIFY.man
index dbeff32..578883e 100644
--- a/extensions/libxt_CLASSIFY.man
+++ b/extensions/libxt_CLASSIFY.man
@@ -1,4 +1,4 @@
-This module allows you to set the skb->priority value (and thus classify the packet into a specific CBQ class).
+This module allows you to set the skb\->priority value (and thus classify the packet into a specific CBQ class).
 .TP
-\fB--set-class\fP \fImajor\fP\fB:\fP\fIminor\fP
+\fB\-\-set\-class\fP \fImajor\fP\fB:\fP\fIminor\fP
 Set the major and minor class value.
diff --git a/extensions/libxt_CONNMARK.man b/extensions/libxt_CONNMARK.man
index e39a02a..571ce37 100644
--- a/extensions/libxt_CONNMARK.man
+++ b/extensions/libxt_CONNMARK.man
@@ -1,9 +1,9 @@
 This module sets the netfilter mark value associated with a connection.
 .TP
-\fB--set-xmark\fR \fIvalue\fR[\fB/\fR\fImask\fR]
+\fB\-\-set\-xmark\fP \fIvalue\fP[\fB/\fP\fImask\fP]
 Zero out the bits given by \fImask\fR and XOR \fIvalue\fR into the ctmark.
 .TP
-\fB--save-mark\fR [\fB--nfmask\fR \fInfmask\fR] [\fB--ctmask\fR \fIctmask\fR]
+\fB\-\-save\-mark\fP [\fB\-\-nfmask\fP \fInfmask\fP] [\fB\-\-ctmask\fP \fIctmask\fP]
 Copy the packet mark (nfmark) to the connection mark (ctmark) using the given
 masks. The new nfmark value is determined as follows:
 .IP
@@ -13,7 +13,7 @@ i.e. \fIctmask\fR defines what bits to clear and \fInfmask\fR what bits of the
 nfmark to XOR into the ctmark. \fIctmask\fR and \fInfmask\fR default to
 0xFFFFFFFF.
 .TP
-\fB--restore-mark\fR [\fB--nfmask\fR \fInfmask\fR] [\fB--ctmask\fR \fIctmask\fR]
+\fB\-\-restore\-mark\fP [\fB\-\-nfmask\fP \fInfmask\fP] [\fB\-\-ctmask\fP \fIctmask\fP]
 Copy the connection mark (ctmark) to the packet mark (nfmark) using the given
 masks. The new ctmark value is determined as follows:
 .IP
@@ -23,30 +23,30 @@ i.e. \fInfmask\fR defines what bits to clear and \fIctmask\fR what bits of the
 ctmark to XOR into the nfmark. \fIctmask\fR and \fInfmask\fR default to
 0xFFFFFFFF.
 .IP
-\fB--restore-mark\fR is only valid in the \fBmangle\fR table.
+\fB\-\-restore\-mark\fP is only valid in the \fBmangle\fP table.
 .PP
-The following mnemonics are available for \fB--set-xmark\fR:
+The following mnemonics are available for \fB\-\-set\-xmark\fP:
 .TP
-\fB--and-mark\fR \fIbits\fR
-Binary AND the ctmark with \fIbits\fR. (Mnemonic for \fB--set-xmark
+\fB\-\-and\-mark\fP \fIbits\fP
+Binary AND the ctmark with \fIbits\fR. (Mnemonic for \fB\-\-set\-xmark
 0/\fR\fIinvbits\fR, where \fIinvbits\fR is the binary negation of \fIbits\fR.)
 .TP
-\fB--or-mark\fR \fIbits\fR
-Binary OR the ctmark with \fIbits\fR. (Mnemonic for \fB--set-xmark\fR
+\fB\-\-or\-mark\fP \fIbits\fP
+Binary OR the ctmark with \fIbits\fR. (Mnemonic for \fB\-\-set\-xmark\fP
 \fIbits\fR\fB/\fR\fIbits\fR.)
 .TP
-\fB--xor-mark\fR \fIbits\fR
-Binary XOR the ctmark with \fIbits\fR. (Mnemonic for \fB--set-xmark\fR
+\fB\-\-xor\-mark\fP \fIbits\fP
+Binary XOR the ctmark with \fIbits\fR. (Mnemonic for \fB\-\-set\-xmark\fP
 \fIbits\fR\fB/0\fR.)
 .TP
-\fB--set-mark\fR \fIvalue\fR[\fB/\fR\fImask\fR]
+\fB\-\-set\-mark\fP \fIvalue\fP[\fB/\fP\fImask\fP]
 Set the connection mark. If a mask is specified then only those bits set in the
 mask are modified.
 .TP
-\fB--save-mark\fR [\fB--mask\fR \fImask\fR]
+\fB\-\-save\-mark\fP [\fB\-\-mask\fP \fImask\fP]
 Copy the nfmark to the ctmark. If a mask is specified, only those bits are
 copied.
 .TP
-\fB--restore-mark\fR [\fB--mask\fR \fImask\fR]
+\fB\-\-restore\-mark\fP [\fB\-\-mask\fP \fImask\fP]
 Copy the ctmark to the nfmark. If a mask is specified, only those bits are
 copied. This is only valid in the \fBmangle\fR table.
diff --git a/extensions/libxt_CONNSECMARK.man b/extensions/libxt_CONNSECMARK.man
index b94353a..a72e710 100644
--- a/extensions/libxt_CONNSECMARK.man
+++ b/extensions/libxt_CONNSECMARK.man
@@ -5,11 +5,11 @@ only valid in the
 .B mangle
 table.
 .TP
-.B --save
+\fB\-\-save\fP
 If the packet has a security marking, copy it to the connection
 if the connection is not marked.
 .TP
-.B --restore
+\fB\-\-restore\fP
 If the packet does not have a security marking, and the connection
 does, copy the security marking from the connection to the packet.
 
diff --git a/extensions/libxt_DSCP.man b/extensions/libxt_DSCP.man
index e8e5cf5..551ba2e 100644
--- a/extensions/libxt_DSCP.man
+++ b/extensions/libxt_DSCP.man
@@ -2,8 +2,8 @@ This target allows to alter the value of the DSCP bits within the TOS
 header of the IPv4 packet.  As this manipulates a packet, it can only
 be used in the mangle table.
 .TP
-.BI "--set-dscp " "value"
+\fB\-\-set\-dscp\fP \fIvalue\fP
 Set the DSCP field to a numerical value (can be decimal or hex)
 .TP
-.BI "--set-dscp-class " "class"
+\fB\-\-set\-dscp\-class\fP \fIclass\fP
 Set the DSCP field to a DiffServ class.
diff --git a/extensions/libxt_MARK.man b/extensions/libxt_MARK.man
index 9585f02..7bb05be 100644
--- a/extensions/libxt_MARK.man
+++ b/extensions/libxt_MARK.man
@@ -2,24 +2,24 @@ This target is used to set the Netfilter mark value associated with the packet.
 The target can only be used in the \fBmangle\fR table. It can, for example, be
 used in conjunction with routing based on fwmark (needs iproute2).
 .TP
-\fB--set-xmark\fR \fIvalue\fR[\fB/\fR\fImask\fR]
+\fB\-\-set\-xmark\fP \fIvalue\fP[\fB/\fP\fImask\fP]
 Zeroes out the bits given by \fImask\fR and XORs \fIvalue\fR into the packet
 mark ("nfmark"). If \fImask\fR is omitted, 0xFFFFFFFF is assumed.
 .TP
-\fB--set-mark\fR \fIvalue\fR[\fB/\fR\fImask\fR]
+\fB\-\-set\-mark\fP \fIvalue\fP[\fB/\fP\fImask\fP]
 Zeroes out the bits given by \fImask\fR and ORs \fIvalue\fR into the packet
 mark. If \fImask\fR is omitted, 0xFFFFFFFF is assumed.
 .PP
 The following mnemonics are available:
 .TP
-\fB--and-mark\fR \fIbits\fR
-Binary AND the nfmark with \fIbits\fR. (Mnemonic for \fB--set-xmark
+\fB\-\-and\-mark\fP \fIbits\fP
+Binary AND the nfmark with \fIbits\fR. (Mnemonic for \fB\-\-set\-xmark
 0/\fR\fIinvbits\fR, where \fIinvbits\fR is the binary negation of \fIbits\fR.)
 .TP
-\fB--or-mark\fR \fIbits\fR
-Binary OR the nfmark with \fIbits\fR. (Mnemonic for \fB--set-xmark\fR
+\fB\-\-or\-mark\fP \fIbits\fP
+Binary OR the nfmark with \fIbits\fR. (Mnemonic for \fB\-\-set\-xmark\fP
 \fIbits\fR\fB/\fR\fIbits\fR.)
 .TP
-\fB--xor-mark\fR \fIbits\fR
-Binary XOR the nfmark with \fIbits\fR. (Mnemonic for \fB--set-xmark\fR
+\fB\-\-xor\-mark\fP \fIbits\fP
+Binary XOR the nfmark with \fIbits\fR. (Mnemonic for \fB\-\-set\-xmark\fP
 \fIbits\fR\fB/0\fR.)
diff --git a/extensions/libxt_NFLOG.man b/extensions/libxt_NFLOG.man
index 08c42de..861501b 100644
--- a/extensions/libxt_NFLOG.man
+++ b/extensions/libxt_NFLOG.man
@@ -8,20 +8,20 @@ socket to the specified multicast group. One or more userspace processes
 may subscribe to the group to receive the packets. Like LOG, this is a
 non-terminating target, i.e. rule traversal continues at the next rule.
 .TP
-.BI "--nflog-group " "nlgroup"
-The netlink group (1 - 2^32-1) to which packets are (only applicable for
+\fB\-\-nflog\-group\fP \fInlgroup\fP
+The netlink group (1 - 2^32\-1) to which packets are (only applicable for
 nfnetlink_log). The default value is 0.
 .TP
-.BI "--nflog-prefix " "prefix"
+\fB\-\-nflog\-prefix\fP \fIprefix\fP
 A prefix string to include in the log message, up to 64 characters
 long, useful for distinguishing messages in the logs.
 .TP
-.BI "--nflog-range " "size"
+\fB\-\-nflog\-range\fP \fIsize\fP
 The number of bytes to be copied to userspace (only applicable for
 nfnetlink_log). nfnetlink_log instances may specify their own
 range, this option overrides it.
 .TP
-.BI "--nflog-threshold " "size"
+\fB\-\-nflog\-threshold\fP \fIsize\fP
 Number of packets to queue inside the kernel before sending them
 to userspace (only applicable for nfnetlink_log). Higher values
 result in less overhead per packet, but increase delay until the
diff --git a/extensions/libxt_NFQUEUE.man b/extensions/libxt_NFQUEUE.man
index d76721a..b2c90bb 100644
--- a/extensions/libxt_NFQUEUE.man
+++ b/extensions/libxt_NFQUEUE.man
@@ -2,7 +2,7 @@ This target is an extension of the QUEUE target. As opposed to QUEUE, it allows
 you to put a packet into any specific queue, identified by its 16-bit queue
 number.  
 .TP
-\fB--queue-num\fP \fIvalue\fP
+\fB\-\-queue\-num\fP \fIvalue\fP
 This specifies the QUEUE number to use. Valid queue numbers are 0 to 65535. The default value is 0.
 .PP
 It can only be used with Kernel versions 2.6.14 or later, since it requires
diff --git a/extensions/libxt_RATEEST.man b/extensions/libxt_RATEEST.man
index 58268cf..37de759 100644
--- a/extensions/libxt_RATEEST.man
+++ b/extensions/libxt_RATEEST.man
@@ -1,12 +1,12 @@
 The RATEEST target collects statistics, performs rate estimation calculation
 and saves the results for later evaluation using the \fBrateest\fP match.
 .TP
-\fB--rateest-name\fP \fIname\fP
+\fB\-\-rateest\-name\fP \fIname\fP
 Count matched packets into the pool referred to by \fIname\fP, which is freely
 choosable.
 .TP
-\fB--rateest-interval\fP \fIamount\fP{\fBs\fP|\fBms\fP|\fBus\fP}
+\fB\-\-rateest\-interval\fP \fIamount\fP{\fBs\fP|\fBms\fP|\fBus\fP}
 Rate measurement interval, in seconds, milliseconds or microseconds.
 .TP
-\fB--rateest-ewmalog\fP \fIvalue\fP
+\fB\-\-rateest\-ewmalog\fP \fIvalue\fP
 Rate measurement averaging time constant.
diff --git a/extensions/libxt_SECMARK.man b/extensions/libxt_SECMARK.man
index f892de9..f58bb43 100644
--- a/extensions/libxt_SECMARK.man
+++ b/extensions/libxt_SECMARK.man
@@ -4,4 +4,4 @@ valid in the
 .B mangle
 table.
 .TP
-.BI "--selctx " "security_context"
+\fB\-\-selctx\fP \fIsecurity_context\fP
diff --git a/extensions/libxt_TCPMSS.man b/extensions/libxt_TCPMSS.man
index 1cb1fcc..675fc5e 100644
--- a/extensions/libxt_TCPMSS.man
+++ b/extensions/libxt_TCPMSS.man
@@ -3,7 +3,7 @@ the maximum size for that connection (usually limiting it to your
 outgoing interface's MTU minus 40 for IPv4 or 60 for IPv6, respectively).
 Of course, it can only be used
 in conjunction with
-.BR "-p tcp" .
+\fB\-p tcp\fP.
 It is only valid in the
 .BR mangle
 table.
@@ -30,14 +30,14 @@ ssh works fine, but scp hangs after initial handshaking.
 Workaround: activate this option and add a rule to your firewall
 configuration like:
 .nf
- iptables -t mangle -A FORWARD -p tcp --tcp-flags SYN,RST SYN \\
-             -j TCPMSS --clamp-mss-to-pmtu
+ iptables \-t mangle \-A FORWARD \-p tcp \-\-tcp\-flags SYN,RST SYN \\
+             \-j TCPMSS \-\-clamp\-mss\-to\-pmtu
 .fi
 .TP
-.BI "--set-mss " "value"
+\fB\-\-set\-mss\fP \fIvalue\fP
 Explicitly set MSS option to specified value.
 .TP
-.B "--clamp-mss-to-pmtu"
-Automatically clamp MSS value to (path_MTU - 40 for IPv4; -60 for IPv6).
+\fB\-\-clamp\-mss\-to\-pmtu\fP
+Automatically clamp MSS value to (path_MTU \- 40 for IPv4; \-60 for IPv6).
 .PP
 These options are mutually exclusive.
diff --git a/extensions/libxt_TCPOPTSTRIP.man b/extensions/libxt_TCPOPTSTRIP.man
index cd000f9..2a07709 100644
--- a/extensions/libxt_TCPOPTSTRIP.man
+++ b/extensions/libxt_TCPOPTSTRIP.man
@@ -1,7 +1,7 @@
 This target will strip TCP options off a TCP packet. (It will actually replace
-them by NO-OPs.) As such, you will need to add the \fB-p tcp\fR parameters.
+them by NO-OPs.) As such, you will need to add the \fB\-p tcp\fP parameters.
 .TP
-\fB--strip-options\fP \fIoption\fP[\fB,\fP\fIoption\fP...]
+\fB\-\-strip\-options\fP \fIoption\fP[\fB,\fP\fIoption\fP...]
 Strip the given option(s). The options may be specified by TCP option number or
 by symbolic name. The list of recognized options can be obtained by calling
-iptables with \fB-j TCPOPTSTRIP -h\fR.
+iptables with \fB\-j TCPOPTSTRIP \-h\fP.
diff --git a/extensions/libxt_TOS.man b/extensions/libxt_TOS.man
index d9b774a..a42a73d 100644
--- a/extensions/libxt_TOS.man
+++ b/extensions/libxt_TOS.man
@@ -3,25 +3,25 @@ This module sets the Type of Service field in the IPv4 header (including the
 shares the same bits as DSCP and ECN. The TOS target is only valid in the
 \fBmangle\fR table.
 .TP
-\fB--set-tos\fR \fIvalue\fR[\fB/\fR\fImask\fR]
+\fB\-\-set\-tos\fP \fIvalue\fP[\fB/\fP\fImask\fP]
 Zeroes out the bits given by \fImask\fR and XORs \fIvalue\fR into the
 TOS/Priority field. If \fImask\fR is omitted, 0xFF is assumed.
 .TP
-\fB--set-tos\fR \fIsymbol\fR
+\fB\-\-set\-tos\fP \fIsymbol\fP
 You can specify a symbolic name when using the TOS target for IPv4. It implies
 a mask of 0xFF. The list of recognized TOS names can be obtained by calling
-iptables with \fB-j TOS -h\fR.
+iptables with \fB\-j TOS \-h\fP.
 .PP
 The following mnemonics are available:
 .TP
-\fB--and-tos\fR \fIbits\fR
-Binary AND the TOS value with \fIbits\fR. (Mnemonic for \fB--set-tos
+\fB\-\-and\-tos\fP \fIbits\fP
+Binary AND the TOS value with \fIbits\fR. (Mnemonic for \fB\-\-set\-tos
 0/\fR\fIinvbits\fR, where \fIinvbits\fR is the binary negation of \fIbits\fR.)
 .TP
-\fB--or-tos\fR \fIbits\fR
-Binary OR the TOS value with \fIbits\fR. (Mnemonic for \fB--set-tos\fR
+\fB\-\-or\-tos\fP \fIbits\fP
+Binary OR the TOS value with \fIbits\fR. (Mnemonic for \fB\-\-set\-tos\fP
 \fIbits\fR\fB/\fR\fIbits\fR.)
 .TP
-\fB--xor-tos\fR \fIbits\fR
-Binary XOR the TOS value with \fIbits\fR. (Mnemonic for \fB--set-tos\fR
+\fB\-\-xor\-tos\fP \fIbits\fP
+Binary XOR the TOS value with \fIbits\fR. (Mnemonic for \fB\-\-set\-tos\fP
 \fIbits\fR\fB/0\fR.)
diff --git a/extensions/libxt_TPROXY.man b/extensions/libxt_TPROXY.man
index f17848c..c087ebf 100644
--- a/extensions/libxt_TPROXY.man
+++ b/extensions/libxt_TPROXY.man
@@ -5,17 +5,17 @@ any way. It can also change the mark value which can then be used in advanced
 routing rules.
 It takes three options:
 .TP
-\fB--on-port\fR \fIport\fR
+\fB\-\-on\-port\fP \fIport\fP
 This specifies a destination port to use. It is a required option, 0 means the
 new destination port is the same as the original. This is only valid if the
-rule also specifies \fB-p tcp\fR or \fB-p udp\fR.
+rule also specifies \fB\-p tcp\fP or \fB\-p udp\fP.
 .TP
-\fB--on-ip\fR \fIaddress\fR
+\fB\-\-on\-ip\fP \fIaddress\fP
 This specifies a destination address to use. By default the address is the IP
 address of the incoming interface. This is only valid if the rule also
-specifies \fB-p tcp\fR or \fR-p udp\fR.
+specifies \fB\-p tcp\fP or \fP\-p udp\fP.
 .TP
-\fB--tproxy-mark\fR \fIvalue\fR[\fB/\fR\fImask\fR]
+\fB\-\-tproxy\-mark\fP \fIvalue\fP[\fB/\fP\fImask\fP]
 Marks packets with the given value/mask. The fwmark value set here can be used
 by advanced routing. (Required for transparent proxying to work: otherwise
 these packets will get forwarded, which is probably not what you want.)
diff --git a/extensions/libxt_comment.man b/extensions/libxt_comment.man
index 2f4ce55..94f871e 100644
--- a/extensions/libxt_comment.man
+++ b/extensions/libxt_comment.man
@@ -1,6 +1,6 @@
 Allows you to add comments (up to 256 characters) to any rule.
 .TP
-.BI "--comment " "comment"
+\fB\-\-comment\fP \fIcomment\fP
 .TP
 Example:
-iptables -A INPUT -s 192.168.0.0/16 -m comment --comment "A privatized IP block"
+iptables \-A INPUT \-s 192.168.0.0/16 \-m comment \-\-comment "A privatized IP block"
diff --git a/extensions/libxt_connbytes.man b/extensions/libxt_connbytes.man
index f547968..fc8c141 100644
--- a/extensions/libxt_connbytes.man
+++ b/extensions/libxt_connbytes.man
@@ -10,16 +10,16 @@ scheduled using a lower priority band in traffic control.
 The transferred bytes per connection can also be viewed through
 /proc/net/ip_conntrack and accessed via ctnetlink
 .TP
-[\fB!\fP] \fB--connbytes\fP \fIfrom\fP[\fB:\fR\fIto\fP]
+[\fB!\fP] \fB\-\-connbytes\fP \fIfrom\fP[\fB:\fP\fIto\fP]
 match packets from a connection whose packets/bytes/average packet
 size is more than FROM and less than TO bytes/packets. if TO is
 omitted only FROM check is done. "!" is used to match packets not
 falling in the range.
 .TP
-\fB--connbytes-dir\fR {\fBoriginal\fR|\fBreply\fR|\fBboth\fR}
+\fB\-\-connbytes\-dir\fP {\fBoriginal\fP|\fBreply\fP|\fBboth\fP}
 which packets to consider
 .TP
-\fB--connbytes-mode\fR {\fBpackets\fR|\fBbytes\fR|\fBavgpkt\fR}
+\fB\-\-connbytes\-mode\fP {\fBpackets\fP|\fBbytes\fP|\fBavgpkt\fP}
 whether to check the amount of packets, number of bytes transferred or
 the average size (in bytes) of all packets received so far. Note that
 when "both" is used together with "avgpkt", and data is going (mainly)
@@ -27,4 +27,4 @@ only in one direction (for example HTTP), the average packet size will
 be about half of the actual data packets.
 .TP
 Example:
-iptables .. -m connbytes --connbytes 10000:100000 --connbytes-dir both --connbytes-mode bytes ...
+iptables .. \-m connbytes \-\-connbytes 10000:100000 \-\-connbytes\-dir both \-\-connbytes\-mode bytes ...
diff --git a/extensions/libxt_connlimit.man b/extensions/libxt_connlimit.man
index dd6a155..eb0832a 100644
--- a/extensions/libxt_connlimit.man
+++ b/extensions/libxt_connlimit.man
@@ -1,27 +1,27 @@
 Allows you to restrict the number of parallel connections to a server per
 client IP address (or client address block).
 .TP
-[\fB!\fP] \fB--connlimit-above\fP \fIn\fP
+[\fB!\fP] \fB\-\-connlimit\-above\fP \fIn\fP
 Match if the number of existing connections is (not) above \fIn\fR.
 .TP
-\fB--connlimit-mask\fR \fIprefix_length\fR
+\fB\-\-connlimit\-mask\fP \fIprefix_length\fP
 Group hosts using the prefix length. For IPv4, this must be a number between
 (including) 0 and 32. For IPv6, between 0 and 128.
 .P
 Examples:
 .TP
 # allow 2 telnet connections per client host
-iptables -A INPUT -p tcp --syn --dport 23 -m connlimit --connlimit-above 2 -j REJECT
+iptables \-A INPUT \-p tcp \-\-syn \-\-dport 23 \-m connlimit \-\-connlimit\-above 2 \-j REJECT
 .TP
 # you can also match the other way around:
-iptables -A INPUT -p tcp --syn --dport 23 -m connlimit ! --connlimit-above 2 -j ACCEPT
+iptables \-A INPUT \-p tcp \-\-syn \-\-dport 23 \-m connlimit ! \-\-connlimit\-above 2 \-j ACCEPT
 .TP
 # limit the number of parallel HTTP requests to 16 per class C sized \
 network (24 bit netmask)
-iptables -p tcp --syn --dport 80 -m connlimit --connlimit-above 16
---connlimit-mask 24 -j REJECT
+iptables \-p tcp \-\-syn \-\-dport 80 \-m connlimit \-\-connlimit\-above 16
+\-\-connlimit\-mask 24 \-j REJECT
 .TP
 # limit the number of parallel HTTP requests to 16 for the link local network \
 (ipv6)
-ip6tables -p tcp --syn --dport 80 -s fe80::/64 -m connlimit --connlimit-above
-16 --connlimit-mask 64 -j REJECT
+ip6tables \-p tcp \-\-syn \-\-dport 80 \-s fe80::/64 \-m connlimit \-\-connlimit\-above
+16 \-\-connlimit\-mask 64 \-j REJECT
diff --git a/extensions/libxt_connmark.man b/extensions/libxt_connmark.man
index a50c537..ee87d9e 100644
--- a/extensions/libxt_connmark.man
+++ b/extensions/libxt_connmark.man
@@ -1,6 +1,6 @@
 This module matches the netfilter mark field associated with a connection
 (which can be set using the \fBCONNMARK\fR target below).
 .TP
-[\fB!\fP] \fB--mark\fR \fIvalue\fR[\fB/\fR\fImask\fR]
+[\fB!\fP] \fB\-\-mark\fP \fIvalue\fP[\fB/\fP\fImask\fP]
 Matches packets in connections with the given mark value (if a mask is
 specified, this is logically ANDed with the mark before the comparison).
diff --git a/extensions/libxt_conntrack.man b/extensions/libxt_conntrack.man
index 17c6dd2..b3d9e73 100644
--- a/extensions/libxt_conntrack.man
+++ b/extensions/libxt_conntrack.man
@@ -1,44 +1,44 @@
 This module, when combined with connection tracking, allows access to the
 connection tracking state for this packet/connection.
 .TP
-[\fB!\fR] \fB--ctstate\fR \fIstatelist\fR
+[\fB!\fR] \fB\-\-ctstate\fP \fIstatelist\fP
 \fIstatelist\fR is a comma separated list of the connection states to match.
 Possible states are listed below.
 .TP
-[\fB!\fR] \fB--ctproto\fR \fIl4proto\fR
+[\fB!\fR] \fB\-\-ctproto\fP \fIl4proto\fP
 Layer-4 protocol to match (by number or name)
 .TP
-[\fB!\fR] \fB--ctorigsrc\fR \fIaddress\fR[\fB/\fR\fImask\fR]
+[\fB!\fR] \fB\-\-ctorigsrc\fP \fIaddress\fP[\fB/\fP\fImask\fP]
 .TP
-[\fB!\fR] \fB--ctorigdst\fR \fIaddress\fR[\fB/\fR\fImask\fR]
+[\fB!\fR] \fB\-\-ctorigdst\fP \fIaddress\fP[\fB/\fP\fImask\fP]
 .TP
-[\fB!\fR] \fB--ctreplsrc\fR \fIaddress\fR[\fB/\fR\fImask\fR]
+[\fB!\fR] \fB\-\-ctreplsrc\fP \fIaddress\fP[\fB/\fP\fImask\fP]
 .TP
-[\fB!\fR] \fB--ctrepldst\fR \fIaddress\fR[\fB/\fR\fImask\fR]
+[\fB!\fR] \fB\-\-ctrepldst\fP \fIaddress\fP[\fB/\fP\fImask\fP]
 Match against original/reply source/destination address
 .TP
-[\fB!\fR] \fB--ctorigsrcport\fR \fIport\fR
+[\fB!\fR] \fB\-\-ctorigsrcport\fP \fIport\fP
 .TP
-[\fB!\fR] \fB--ctorigdstport\fR \fIport\fR
+[\fB!\fR] \fB\-\-ctorigdstport\fP \fIport\fP
 .TP
-[\fB!\fR] \fB--ctreplsrcport\fR \fIport\fR
+[\fB!\fR] \fB\-\-ctreplsrcport\fP \fIport\fP
 .TP
-[\fB!\fR] \fB--ctrepldstport\fR \fIport\fR
+[\fB!\fR] \fB\-\-ctrepldstport\fP \fIport\fP
 Match against original/reply source/destination port (TCP/UDP/etc.) or GRE key.
 .TP
-[\fB!\fR] \fB--ctstatus\fR \fIstatelist\fR
+[\fB!\fR] \fB\-\-ctstatus\fP \fIstatelist\fP
 \fIstatuslist\fR is a comma separated list of the connection statuses to match.
 Possible statuses are listed below.
 .TP
-[\fB!\fR] \fB--ctexpire\fR \fItime\fR[\fB:\fR\fItime\fR]
+[\fB!\fR] \fB\-\-ctexpire\fP \fItime\fP[\fB:\fP\fItime\fP]
 Match remaining lifetime in seconds against given value or range of values
 (inclusive)
 .TP
-\fB--ctdir\fR {\fBORIGINAL\fR|\fBREPLY\fR}
+\fB\-\-ctdir\fP {\fBORIGINAL\fP|\fBREPLY\fP}
 Match packets that are flowing in the specified direction. If this flag is not
 specified at all, matches packets in both directions.
 .PP
-States for \fB--ctstate\fR:
+States for \fB\-\-ctstate\fP:
 .TP
 \fBINVALID\fR
 meaning that the packet is associated with no known connection
@@ -63,7 +63,7 @@ destination.
 A virtual state, matching if the original destination differs from the reply
 source.
 .PP
-Statuses for \fB--ctstatus\fR:
+Statuses for \fB\-\-ctstatus\fP:
 .TP
 \fBNONE\fR
 None of the below.
diff --git a/extensions/libxt_dccp.man b/extensions/libxt_dccp.man
index 0320af4..82c3f70 100644
--- a/extensions/libxt_dccp.man
+++ b/extensions/libxt_dccp.man
@@ -1,12 +1,12 @@
 .TP
-[\fB!\fP] \fB--source-port\fP,\fB--sport\fP \fIport\fP[\fB:\fP\fIport\fP]
+[\fB!\fP] \fB\-\-source\-port\fP,\fB\-\-sport\fP \fIport\fP[\fB:\fP\fIport\fP]
 .TP
-[\fB!\fP] \fB--destination-port\fP,\fB--dport\fP \fIport\fP[\fB:\fP\fIport\fP]
+[\fB!\fP] \fB\-\-destination\-port\fP,\fB\-\-dport\fP \fIport\fP[\fB:\fP\fIport\fP]
 .TP
-[\fB!\fP] \fB--dccp-types\fR \fImask\fP
+[\fB!\fP] \fB\-\-dccp\-types\fP \fImask\fP
 Match when the DCCP packet type is one of 'mask'. 'mask' is a comma-separated
 list of packet types.  Packet types are: 
 .BR "REQUEST RESPONSE DATA ACK DATAACK CLOSEREQ CLOSE RESET SYNC SYNCACK INVALID" .
 .TP
-[\fB!\fP] \fB--dccp-option\fR \fInumber\fP
+[\fB!\fP] \fB\-\-dccp\-option\fP \fInumber\fP
 Match if DCP option set.
diff --git a/extensions/libxt_dscp.man b/extensions/libxt_dscp.man
index e2357db..63a17da 100644
--- a/extensions/libxt_dscp.man
+++ b/extensions/libxt_dscp.man
@@ -1,10 +1,10 @@
 This module matches the 6 bit DSCP field within the TOS field in the
 IP header.  DSCP has superseded TOS within the IETF.
 .TP
-[\fB!\fP] \fB--dscp\fP \fIvalue\fP
+[\fB!\fP] \fB\-\-dscp\fP \fIvalue\fP
 Match against a numeric (decimal or hex) value [0-63].
 .TP
-[\fB!\fP] \fB--dscp-class\fP \fIclass\fP
+[\fB!\fP] \fB\-\-dscp\-class\fP \fIclass\fP
 Match the DiffServ class. This value may be any of the
 BE, EF, AFxx or CSx classes.  It will then be converted
 into its according numeric value.
diff --git a/extensions/libxt_esp.man b/extensions/libxt_esp.man
index 6a7cdea..699a41c 100644
--- a/extensions/libxt_esp.man
+++ b/extensions/libxt_esp.man
@@ -1,3 +1,3 @@
 This module matches the SPIs in ESP header of IPsec packets.
 .TP
-[\fB!\fP] \fB--espspi\fP \fIspi\fP[\fB:\fP\fIspi\fP]
+[\fB!\fP] \fB\-\-espspi\fP \fIspi\fP[\fB:\fP\fIspi\fP]
diff --git a/extensions/libxt_hashlimit.man b/extensions/libxt_hashlimit.man
index 84642ca..9820a92 100644
--- a/extensions/libxt_hashlimit.man
+++ b/extensions/libxt_hashlimit.man
@@ -13,47 +13,47 @@ matching on source prot
 matching on subnet
 "10000 packets per minute for every /28 subnet in 10.0.0.0/8"
 .PP
-A hash limit option (\fB--hashlimit-upto\fR, \fB--hashlimit-above\fR) and
-\fB--hashlimit-name\fR are required.
+A hash limit option (\fB\-\-hashlimit\-upto\fP, \fB\-\-hashlimit\-above\fP) and
+\fB\-\-hashlimit\-name\fP are required.
 .TP
-\fB--hashlimit-upto\fR \fIamount\fR[\fB/second\fR|\fB/minute\fR|\fB/hour\fR|\fB/day\fR]
+\fB\-\-hashlimit\-upto\fP \fIamount\fP[\fB/second\fP|\fB/minute\fP|\fB/hour\fP|\fB/day\fP]
 Match if the rate is below or equal to \fIamount\fR/quantum. It is specified as
 a number, with an optional time quantum suffix; the default is 3/hour.
 .TP
-\fB--hashlimit-above\fR \fIamount\fR[\fB/second\fR|\fB/minute\fR|\fB/hour\fR|\fB/day\fR]
+\fB\-\-hashlimit\-above\fP \fIamount\fP[\fB/second\fP|\fB/minute\fP|\fB/hour\fP|\fB/day\fP]
 Match if the rate is above \fIamount\fR/quantum.
 .TP
-\fB--hashlimit-burst\fR \fIamount\fR
+\fB\-\-hashlimit\-burst\fP \fIamount\fP
 Maximum initial number of packets to match: this number gets recharged by one
 every time the limit specified above is not reached, up to this number; the
 default is 5.
 .TP
-\fB--hashlimit-mode\fR {\fBsrcip\fR|\fBsrcport\fR|\fBdstip\fR|\fBdstport\fR}\fB,\fP...
+\fB\-\-hashlimit\-mode\fP {\fBsrcip\fP|\fBsrcport\fP|\fBdstip\fP|\fBdstport\fP}\fB,\fP...
 A comma-separated list of objects to take into consideration. If no
---hashlimit-mode option is given, hashlimit acts like limit, but at the
+\-\-hashlimit\-mode option is given, hashlimit acts like limit, but at the
 expensive of doing the hash housekeeping.
 .TP
-\fB--hashlimit-srcmask\fR \fIprefix\fR
-When --hashlimit-mode srcip is used, all source addresses encountered will be
+\fB\-\-hashlimit\-srcmask\fP \fIprefix\fP
+When \-\-hashlimit\-mode srcip is used, all source addresses encountered will be
 grouped according to the given prefix length and the so-created subnet will be
 subject to hashlimit. \fIprefix\fR must be between (inclusive) 0 and 32. Note
-that --hashlimit-srcmask 0 is basically doing the same thing as not specifying
-srcip for --hashlimit-mode, but is technically more expensive.
+that \-\-hashlimit\-srcmask 0 is basically doing the same thing as not specifying
+srcip for \-\-hashlimit\-mode, but is technically more expensive.
 .TP
-\fB--hashlimit-dstmask\fR \fIprefix\fR
-Like --hashlimit-srcmask, but for destination addresses.
+\fB\-\-hashlimit\-dstmask\fP \fIprefix\fP
+Like \-\-hashlimit\-srcmask, but for destination addresses.
 .TP
-\fB--hashlimit-name\fR \fIfoo\fR
+\fB\-\-hashlimit\-name\fP \fIfoo\fP
 The name for the /proc/net/ipt_hashlimit/foo entry.
 .TP
-\fB--hashlimit-htable-size\fR \fIbuckets\fR
+\fB\-\-hashlimit\-htable\-size\fP \fIbuckets\fP
 The number of buckets of the hash table
 .TP
-\fB--hashlimit-htable-max\fR \fIentries\fR
+\fB\-\-hashlimit\-htable\-max\fP \fIentries\fP
 Maximum entries in the hash.
 .TP
-\fB--hashlimit-htable-expire\fR \fImsec\fR
+\fB\-\-hashlimit\-htable\-expire\fP \fImsec\fP
 After how many milliseconds do hash entries expire.
 .TP
-\fB--hashlimit-htable-gcinterval\fR \fImsec\fR
+\fB\-\-hashlimit\-htable\-gcinterval\fP \fImsec\fP
 How many milliseconds between garbage collection intervals.
diff --git a/extensions/libxt_helper.man b/extensions/libxt_helper.man
index 3df1d05..772b135 100644
--- a/extensions/libxt_helper.man
+++ b/extensions/libxt_helper.man
@@ -1,11 +1,11 @@
 This module matches packets related to a specific conntrack-helper.
 .TP
-[\fB!\fP] \fB--helper\fP \fIstring\fP
+[\fB!\fP] \fB\-\-helper\fP \fIstring\fP
 Matches packets related to the specified conntrack-helper.
 .RS
 .PP
 string can be "ftp" for packets related to a ftp-session on default port.
-For other ports append -portnr to the value, ie. "ftp-2121".
+For other ports append \-portnr to the value, ie. "ftp\-2121".
 .PP
 Same rules apply for other conntrack-helpers.
 .RE
diff --git a/extensions/libxt_iprange.man b/extensions/libxt_iprange.man
index 1941a3b..9f65de4 100644
--- a/extensions/libxt_iprange.man
+++ b/extensions/libxt_iprange.man
@@ -1,7 +1,7 @@
 This matches on a given arbitrary range of IP addresses.
 .TP
-[\fB!\fR] \fB--src-range\fR \fIfrom\fR[\fB-\fP\fIto\fR]
+[\fB!\fR] \fB\-\-src\-range\fP \fIfrom\fP[\fB\-\fP\fIto\fP]
 Match source IP in the specified range.
 .TP
-[\fB!\fR] \fB--dst-range\fR \fIfrom\fR[\fB-\fP\fIto\fR]
+[\fB!\fR] \fB\-\-dst\-range\fP \fIfrom\fP[\fB\-\fP\fIto\fP]
 Match destination IP in the specified range.
diff --git a/extensions/libxt_length.man b/extensions/libxt_length.man
index 27236ae..e324e03 100644
--- a/extensions/libxt_length.man
+++ b/extensions/libxt_length.man
@@ -2,4 +2,4 @@ This module matches the length of the layer-3 payload (e.g. layer-4 packet)
 f a packet against a specific value
 or range of values.
 .TP
-[\fB!\fP] \fB--length\fP \fIlength\fP[\fB:\fP\fIlength\fP]
+[\fB!\fP] \fB\-\-length\fP \fIlength\fP[\fB:\fP\fIlength\fP]
diff --git a/extensions/libxt_limit.man b/extensions/libxt_limit.man
index 0419c50..c00e1d9 100644
--- a/extensions/libxt_limit.man
+++ b/extensions/libxt_limit.man
@@ -4,12 +4,12 @@ A rule using this extension will match until this limit is reached
 .B LOG
 target to give limited logging, for example.
 .TP
-[\fB!\fP] \fB--limit\fP \fIrate\fP[\fB/second\fP|\fB/minute\fP|\fB/hour\fP|\fB/day\fP]
+[\fB!\fP] \fB\-\-limit\fP \fIrate\fP[\fB/second\fP|\fB/minute\fP|\fB/hour\fP|\fB/day\fP]
 Maximum average matching rate: specified as a number, with an optional
 `/second', `/minute', `/hour', or `/day' suffix; the default is
 3/hour.
 .TP
-.BI "--limit-burst " "number"
+\fB\-\-limit\-burst\fP \fInumber\fP
 Maximum initial number of packets to match: this number gets
 recharged by one every time the limit specified above is not reached,
 up to this number; the default is 5.
diff --git a/extensions/libxt_mac.man b/extensions/libxt_mac.man
index aca2c96..66072a2 100644
--- a/extensions/libxt_mac.man
+++ b/extensions/libxt_mac.man
@@ -1,5 +1,5 @@
 .TP
-[\fB!\fP] \fB--mac-source\fP \fIaddress\fP
+[\fB!\fP] \fB\-\-mac\-source\fP \fIaddress\fP
 Match source MAC address.  It must be of the form XX:XX:XX:XX:XX:XX.
 Note that this only makes sense for packets coming from an Ethernet device
 and entering the
diff --git a/extensions/libxt_mark.man b/extensions/libxt_mark.man
index 4b29cd0..264b17d 100644
--- a/extensions/libxt_mark.man
+++ b/extensions/libxt_mark.man
@@ -3,7 +3,7 @@ This module matches the netfilter mark field associated with a packet
 .B MARK
 target below).
 .TP
-[\fB!\fP] \fB--mark\fP \fIvalue\fP[\fB/\fP\fImask\fP]
+[\fB!\fP] \fB\-\-mark\fP \fIvalue\fP[\fB/\fP\fImask\fP]
 Matches packets with the given unsigned mark value (if a \fImask\fP is
 specified, this is logically ANDed with the \fImask\fP before the
 comparison).
diff --git a/extensions/libxt_multiport.man b/extensions/libxt_multiport.man
index b8e5e49..3918315 100644
--- a/extensions/libxt_multiport.man
+++ b/extensions/libxt_multiport.man
@@ -1,23 +1,23 @@
 This module matches a set of source or destination ports.  Up to 15
 ports can be specified.  A port range (port:port) counts as two
 ports.  It can only be used in conjunction with
-.B "-p tcp"
+\fB\-p tcp\fP
 or
-.BR "-p udp" .
+\fB\-p udp\fP.
 .TP
-[\fB!\fP] \fB--source-ports\fP,\fB--sport\fP \fIport\fP[\fB,\fP\fIport\fP|\fB,\fP\fIport\fP\fB:\fP\fIport\fP]...
+[\fB!\fP] \fB\-\-source\-ports\fP,\fB\-\-sport\fP \fIport\fP[\fB,\fP\fIport\fP|\fB,\fP\fIport\fP\fB:\fP\fIport\fP]...
 Match if the source port is one of the given ports.  The flag
-.B --sports
+\fB\-\-sports\fP
 is a convenient alias for this option. Multiple ports or port ranges are
 separated using a comma, and a port range is specified using a colon.
 \fB53,1024:65535\fP would therefore match ports 53 and all from 1024 through
 65535.
 .TP
-[\fB!\fP] \fB--destination-ports\fP,\fB--dport\fP \fIport\fP[\fB,\fP\fIport\fP|\fB,\fP\fIport\fP\fB:\fP\fIport\fP]...
+[\fB!\fP] \fB\-\-destination\-ports\fP,\fB\-\-dport\fP \fIport\fP[\fB,\fP\fIport\fP|\fB,\fP\fIport\fP\fB:\fP\fIport\fP]...
 Match if the destination port is one of the given ports.  The flag
-.B --dports
+\fB\-\-dports\fP
 is a convenient alias for this option.
 .TP
-[\fB!\fP] \fB--ports\fP \fIport\fP[\fB,\fP\fIport\fP|\fB,\fP\fIport\fP\fB:\fP\fIport\fP]...
+[\fB!\fP] \fB\-\-ports\fP \fIport\fP[\fB,\fP\fIport\fP|\fB,\fP\fIport\fP\fB:\fP\fIport\fP]...
 Match if either the source or destination ports are equal to one of
 the given ports.
diff --git a/extensions/libxt_owner.man b/extensions/libxt_owner.man
index 0bc0c65..49b58ce 100644
--- a/extensions/libxt_owner.man
+++ b/extensions/libxt_owner.man
@@ -3,17 +3,17 @@ for locally generated packets. This match is only valid in the OUTPUT and
 POSTROUTING chains. Forwarded packets do not have any socket associated with
 them. Packets from kernel threads do have a socket, but usually no owner.
 .TP
-[\fB!\fP] \fB--uid-owner\fP \fIusername\fP
+[\fB!\fP] \fB\-\-uid\-owner\fP \fIusername\fP
 .TP
-[\fB!\fP] \fB--uid-owner\fP \fIuserid\fP[\fB-\fP\fIuserid\fP]
+[\fB!\fP] \fB\-\-uid\-owner\fP \fIuserid\fP[\fB\-\fP\fIuserid\fP]
 Matches if the packet socket's file structure (if it has one) is owned by the
 given user. You may also specify a numerical UID, or an UID range.
 .TP
-[\fB!\fP] \fB--gid-owner\fP \fIgroupname\fP
+[\fB!\fP] \fB\-\-gid\-owner\fP \fIgroupname\fP
 .TP
-[\fB!\fP] \fB--gid-owner\fP \fIgroupid\fP[\fB-\fR\fIgroupid\fP]
+[\fB!\fP] \fB\-\-gid\-owner\fP \fIgroupid\fP[\fB\-\fP\fIgroupid\fP]
 Matches if the packet socket's file structure is owned by the given group.
 You may also specify a numerical GID, or a GID range.
 .TP
-[\fB!\fP] \fB--socket-exists\fP
+[\fB!\fP] \fB\-\-socket\-exists\fP
 Matches if the packet is associated with a socket.
diff --git a/extensions/libxt_physdev.man b/extensions/libxt_physdev.man
index a00622a..1e0f3d0 100644
--- a/extensions/libxt_physdev.man
+++ b/extensions/libxt_physdev.man
@@ -3,7 +3,7 @@ to a bridge device. This module is a part of the infrastructure that enables
 a transparent bridging IP firewall and is only useful for kernel versions
 above version 2.5.44.
 .TP
-[\fB!\fP] \fB--physdev-in\fP \fIname\fP
+[\fB!\fP] \fB\-\-physdev\-in\fP \fIname\fP
 Name of a bridge port via which a packet is received (only for
 packets entering the
 .BR INPUT ,
@@ -14,7 +14,7 @@ chains). If the interface name ends in a "+", then any
 interface which begins with this name will match. If the packet didn't arrive
 through a bridge device, this packet won't match this option, unless '!' is used.
 .TP
-[\fB!\fP] \fB--physdev-out\fP \fIname\fP
+[\fB!\fP] \fB\-\-physdev\-out\fP \fIname\fP
 Name of a bridge port via which a packet is going to be sent (for packets
 entering the
 .BR FORWARD ,
@@ -31,12 +31,12 @@ chain. If the packet won't leave by a bridge device or it is yet unknown what
 the output device will be, then the packet won't match this option, unless
 '!' is used.
 .TP
-[\fB!\fP] \fB--physdev-is-in\fP
+[\fB!\fP] \fB\-\-physdev\-is\-in\fP
 Matches if the packet has entered through a bridge interface.
 .TP
-[\fB!\fP] \fB--physdev-is-out\fP
+[\fB!\fP] \fB\-\-physdev\-is\-out\fP
 Matches if the packet will leave through a bridge interface.
 .TP
-[\fB!\fP] \fB--physdev-is-bridged\fP
+[\fB!\fP] \fB\-\-physdev\-is\-bridged\fP
 Matches if the packet is being bridged and therefore is not being routed.
 This is only useful in the FORWARD and POSTROUTING chains.
diff --git a/extensions/libxt_pkttype.man b/extensions/libxt_pkttype.man
index ecc6061..4560c76 100644
--- a/extensions/libxt_pkttype.man
+++ b/extensions/libxt_pkttype.man
@@ -1,3 +1,3 @@
 This module matches the link-layer packet type.
 .TP
-[\fB!\fP] \fB--pkt-type\fP {\fBunicast\fP|\fBbroadcast\fP|\fBmulticast\fP}
+[\fB!\fP] \fB\-\-pkt\-type\fP {\fBunicast\fP|\fBbroadcast\fP|\fBmulticast\fP}
diff --git a/extensions/libxt_policy.man b/extensions/libxt_policy.man
index 7b7cb2d..3500025 100644
--- a/extensions/libxt_policy.man
+++ b/extensions/libxt_policy.man
@@ -1,6 +1,6 @@
 This modules matches the policy used by IPsec for handling a packet.
 .TP
-\fB--dir\fP {\fBin\fP|\fBout\fP}
+\fB\-\-dir\fP {\fBin\fP|\fBout\fP}
 Used to select whether to match the policy used for decapsulation or the
 policy that will be used for encapsulation.
 .B in
@@ -12,37 +12,37 @@ is valid in the
 .B POSTROUTING, OUTPUT and FORWARD
 chains.
 .TP
-\fB--pol\fP {\fBnone\fP|\fBipsec\fP}
+\fB\-\-pol\fP {\fBnone\fP|\fBipsec\fP}
 Matches if the packet is subject to IPsec processing.
 .TP
-.BI "--strict"
+\fB\-\-strict\fP
 Selects whether to match the exact policy or match if any rule of
 the policy matches the given policy.
 .TP
-[\fB!\fP] \fB--reqid\fP \fIid\fP
+[\fB!\fP] \fB\-\-reqid\fP \fIid\fP
 Matches the reqid of the policy rule. The reqid can be specified with
 .B setkey(8)
 using
 .B unique:id
 as level.
 .TP
-[\fB!\fP] \fB--spi\fP \fIspi\fP
+[\fB!\fP] \fB\-\-spi\fP \fIspi\fP
 Matches the SPI of the SA.
 .TP
-[\fB!\fP] \fB--proto\fP {\fBah\fP|\fBesp\fP|\fBipcomp\fP}
+[\fB!\fP] \fB\-\-proto\fP {\fBah\fP|\fBesp\fP|\fBipcomp\fP}
 Matches the encapsulation protocol.
 .TP
-[\fB!\fP] \fB--mode\fP {\fBtunnel\fP|\fBtransport\fP}
+[\fB!\fP] \fB\-\-mode\fP {\fBtunnel\fP|\fBtransport\fP}
 Matches the encapsulation mode.
 .TP
-[\fB!\fP] \fB--tunnel-src\fP \fIaddr\fP[\fB/\fP\fImask\fP]
+[\fB!\fP] \fB\-\-tunnel\-src\fP \fIaddr\fP[\fB/\fP\fImask\fP]
 Matches the source end-point address of a tunnel mode SA.
-Only valid with \fB--mode tunnel\fP.
+Only valid with \fB\-\-mode tunnel\fP.
 .TP
-[\fB!\fP] \fB--tunnel-dst\fP \fIaddr\fP[\fB/\fP\fImask\fP]
+[\fB!\fP] \fB\-\-tunnel\-dst\fP \fIaddr\fP[\fB/\fP\fImask\fP]
 Matches the destination end-point address of a tunnel mode SA.
-Only valid with \fB--mode tunnel\fP.
+Only valid with \fB\-\-mode tunnel\fP.
 .TP
-.BI "--next"
+\fB\-\-next\fP
 Start the next element in the policy specification. Can only be used with
-\fB--strict\fP.
+\fB\-\-strict\fP.
diff --git a/extensions/libxt_quota.man b/extensions/libxt_quota.man
index 7945bee..f8bf77b 100644
--- a/extensions/libxt_quota.man
+++ b/extensions/libxt_quota.man
@@ -1,6 +1,6 @@
 Implements network quotas by decrementing a byte counter with each
 packet.
 .TP
-.BI "--quota " "bytes"
+\fB\-\-quota\fP \fIbytes\fP
 The quota in bytes.
 .P
diff --git a/extensions/libxt_rateest.man b/extensions/libxt_rateest.man
index 6d32d51..24c0673 100644
--- a/extensions/libxt_rateest.man
+++ b/extensions/libxt_rateest.man
@@ -2,32 +2,32 @@ The rate estimator can match on estimated rates as collected by the RATEEST
 target. It supports matching on absolute bps/pps values, comparing two rate
 estimators and matching on the difference between two rate estimators.
 .TP
-\fB--rateest1\fP \fIname\fP
+\fB\-\-rateest1\fP \fIname\fP
 Name of the first rate estimator.
 .TP
-\fB--rateest2\fP \fIname\fP
+\fB\-\-rateest2\fP \fIname\fP
 Name of the second rate estimator (if difference is to be calculated).
 .TP
-\fB--rateest-delta\fP
+\fB\-\-rateest\-delta\fP
 Compare difference(s) to given rate(s)
 .TP
-\fB--rateest1-bps\fP \fIvalue\fP
+\fB\-\-rateest1\-bps\fP \fIvalue\fP
 .TP
-\fB--rateest2-bps\fP \fIvalue\fP
+\fB\-\-rateest2\-bps\fP \fIvalue\fP
 Compare bytes per second.
 .TP
-\fB--rateest1-pps\fP \fIvalue\fP
+\fB\-\-rateest1\-pps\fP \fIvalue\fP
 .TP
-\fB--rateest2-pps\fP \fIvalue\fP
+\fB\-\-rateest2\-pps\fP \fIvalue\fP
 Compare packets per second.
 .TP
-[\fB!\fP] \fB--rateest-lt\fP
+[\fB!\fP] \fB\-\-rateest\-lt\fP
 Match if rate is less than given rate/estimator.
 .TP
-[\fB!\fP] \fB--rateest-gt\fP
+[\fB!\fP] \fB\-\-rateest\-gt\fP
 Match if rate is greater than given rate/estimator.
 .TP
-[\fB!\fP] \fB--rateest-eq\fP
+[\fB!\fP] \fB\-\-rateest\-eq\fP
 Match if rate is equal to given rate/estimator.
 .PP
 Example: This is what can be used to route outgoing data connections from an
@@ -36,20 +36,20 @@ connection was started:
 .PP
 # Estimate outgoing rates
 .PP
-iptables -t mangle -A POSTROUTING -o eth0 -j RATEEST --rateest-name eth0
---rateest-interval 250ms --rateest-ewma 0.5s
+iptables \-t mangle \-A POSTROUTING \-o eth0 \-j RATEEST \-\-rateest\-name eth0
+\-\-rateest\-interval 250ms \-\-rateest\-ewma 0.5s
 .PP
-iptables -t mangle -A POSTROUTING -o ppp0 -j RATEEST --rateest-name ppp0
---rateest-interval 250ms --rateest-ewma 0.5s
+iptables \-t mangle \-A POSTROUTING \-o ppp0 \-j RATEEST \-\-rateest\-name ppp0
+\-\-rateest\-interval 250ms \-\-rateest\-ewma 0.5s
 .PP
 # Mark based on available bandwidth
 .PP
-iptables -t mangle -A balance -m conntrack --ctstate NEW -m helper --helper ftp
--m rateest --rateest-delta --rateest1 eth0 --rateest-bps1 2.5mbit --rateest-gt
---rateest2 ppp0 --rateest-bps2 2mbit -j CONNMARK --set-mark 1
+iptables \-t mangle \-A balance \-m conntrack \-\-ctstate NEW \-m helper \-\-helper ftp
+\-m rateest \-\-rateest\-delta \-\-rateest1 eth0 \-\-rateest\-bps1 2.5mbit \-\-rateest\-gt
+\-\-rateest2 ppp0 \-\-rateest\-bps2 2mbit \-j CONNMARK \-\-set\-mark 1
 .PP
-iptables -t mangle -A balance -m conntrack --ctstate NEW -m helper --helper ftp
--m rateest --rateest-delta --rateest1 ppp0 --rateest-bps1 2mbit --rateest-gt
---rateest2 eth0 --rateest-bps2 2.5mbit -j CONNMARK --set-mark 2
+iptables \-t mangle \-A balance \-m conntrack \-\-ctstate NEW \-m helper \-\-helper ftp
+\-m rateest \-\-rateest\-delta \-\-rateest1 ppp0 \-\-rateest\-bps1 2mbit \-\-rateest\-gt
+\-\-rateest2 eth0 \-\-rateest\-bps2 2.5mbit \-j CONNMARK \-\-set\-mark 2
 .PP
-iptables -t mangle -A balance -j CONNMARK --restore-mark
+iptables \-t mangle \-A balance \-j CONNMARK \-\-restore\-mark
diff --git a/extensions/libxt_recent.man b/extensions/libxt_recent.man
index e30bb56..e03d8ec 100644
--- a/extensions/libxt_recent.man
+++ b/extensions/libxt_recent.man
@@ -5,60 +5,60 @@ For example, you can create a "badguy" list out of people attempting to connect
 to port 139 on your firewall and then DROP all future packets from them without
 considering them.
 .TP
-\fB--name\fR \fIname\fR
+\fB\-\-name\fP \fIname\fP
 Specify the list to use for the commands. If no name is given then
 \fBDEFAULT\fR will be used.
 .TP
-[\fB!\fR] \fB--set\fR
+[\fB!\fR] \fB\-\-set\fP
 This will add the source address of the packet to the list. If the source
 address is already in the list, this will update the existing entry. This will
 always return success (or failure if \fB!\fR is passed in).
 .TP
-\fB--rsource\fP
+\fB\-\-rsource\fP
 Match/save the source address of each packet in the recent list table. This
 is the default.
 .TP
-\fB--rdest\fP
+\fB\-\-rdest\fP
 Match/save the destination address of each packet in the recent list table.
 .TP
-[\fB!\fR] \fB--rcheck\fR
+[\fB!\fR] \fB\-\-rcheck\fP
 Check if the source address of the packet is currently in the list.
 .TP
-[\fB!\fR] \fB--update\fR
-Like \fB--rcheck\fR, except it will update the "last seen" timestamp if it
+[\fB!\fR] \fB\-\-update\fP
+Like \fB\-\-rcheck\fP, except it will update the "last seen" timestamp if it
 matches.
 .TP
-[\fB!\fR] \fB--remove\fR
+[\fB!\fR] \fB\-\-remove\fP
 Check if the source address of the packet is currently in the list and if so
 that address will be removed from the list and the rule will return true. If
 the address is not found, false is returned.
 .TP
-[\fB!\fR] \fB--seconds \fIseconds\fR
-This option must be used in conjunction with one of \fB--rcheck\fR or
-\fB--update\fR. When used, this will narrow the match to only happen when the
+[\fB!\fR] \fB\-\-seconds \fIseconds\fP
+This option must be used in conjunction with one of \fB\-\-rcheck\fP or
+\fB\-\-update\fP. When used, this will narrow the match to only happen when the
 address is in the list and was seen within the last given number of seconds.
 .TP
-[\fB!\fR] \fB--hitcount \fIhits\fR
-This option must be used in conjunction with one of \fB--rcheck\fR or
-\fB--update\fR. When used, this will narrow the match to only happen when the
+[\fB!\fR] \fB\-\-hitcount \fIhits\fP
+This option must be used in conjunction with one of \fB\-\-rcheck\fP or
+\fB\-\-update\fP. When used, this will narrow the match to only happen when the
 address is in the list and packets had been received greater than or equal to
-the given value. This option may be used along with \fB--seconds\fR to create
+the given value. This option may be used along with \fB\-\-seconds\fP to create
 an even narrower match requiring a certain number of hits within a specific
 time frame.
 .TP
-\fB--rttl\fR
-This option may only be used in conjunction with one of \fB--rcheck\fR or
-\fB--update\fR. When used, this will narrow the match to only happen when the
+\fB\-\-rttl\fP
+This option may only be used in conjunction with one of \fB\-\-rcheck\fP or
+\fB\-\-update\fP. When used, this will narrow the match to only happen when the
 address is in the list and the TTL of the current packet matches that of the
-packet which hit the \fB--set\fR rule. This may be useful if you have problems
+packet which hit the \fB\-\-set\fP rule. This may be useful if you have problems
 with people faking their source address in order to DoS you via this module by
 disallowing others access to your site by sending bogus packets to you.
 .PP
 Examples:
 .IP
-iptables -A FORWARD -m recent --name badguy --rcheck --seconds 60 -j DROP
+iptables \-A FORWARD \-m recent \-\-name badguy \-\-rcheck \-\-seconds 60 \-j DROP
 .IP
-iptables -A FORWARD -p tcp -i eth0 --dport 139 -m recent --name badguy --set -j DROP
+iptables \-A FORWARD \-p tcp \-i eth0 \-\-dport 139 \-m recent \-\-name badguy \-\-set \-j DROP
 .PP
 Steve's ipt_recent website (http://snowman.net/projects/ipt_recent/) also has
 some examples of usage.
@@ -72,7 +72,7 @@ list or written two using the following commands to modify the list:
 \fBecho +\fR\fIaddr\fR\fB >/proc/net/xt_recent/DEFAULT\fR
 to add \fIaddr\fR to the DEFAULT list
 .TP
-\fBecho -\fR\fIaddr\fR\fB >/proc/net/xt_recent/DEFAULT\fR
+\fBecho \-\fP\fIaddr\fP\fB >/proc/net/xt_recent/DEFAULT\fP
 to remove \fIaddr\fR from the DEFAULT list
 .TP
 \fBecho / >/proc/net/xt_recent/DEFAULT\fR
diff --git a/extensions/libxt_sctp.man b/extensions/libxt_sctp.man
index 5d7a477..1ecf05c 100644
--- a/extensions/libxt_sctp.man
+++ b/extensions/libxt_sctp.man
@@ -1,9 +1,9 @@
 .TP
-[\fB!\fP] \fB--source-port\fP,\fB--sport\fP \fIport\fP[\fB:\fP\fIport\fP]
+[\fB!\fP] \fB\-\-source\-port\fP,\fB\-\-sport\fP \fIport\fP[\fB:\fP\fIport\fP]
 .TP
-[\fB!\fP] \fB--destination-port\fP,\fB--dport\fP \fIport\fP[\fB:\fP\fIport\fP]
+[\fB!\fP] \fB\-\-destination\-port\fP,\fB\-\-dport\fP \fIport\fP[\fB:\fP\fIport\fP]
 .TP
-[\fB!\fP] \fB--chunk-types\fP {\fBall\fP|\fBany\fP|\fBonly\fP} \fIchunktype\fP[\fB:\fP\fIflags\fP] [...]
+[\fB!\fP] \fB\-\-chunk\-types\fP {\fBall\fP|\fBany\fP|\fBonly\fP} \fIchunktype\fP[\fB:\fP\fIflags\fP] [...]
 The flag letter in upper case indicates that the flag is to match if set,
 in the lower case indicates to match if unset.
 
@@ -21,8 +21,8 @@ SHUTDOWN_COMPLETE     T t
 .P
 Examples:
 
-iptables -A INPUT -p sctp --dport 80 -j DROP
+iptables \-A INPUT \-p sctp \-\-dport 80 \-j DROP
 
-iptables -A INPUT -p sctp --chunk-types any DATA,INIT -j DROP
+iptables \-A INPUT \-p sctp \-\-chunk\-types any DATA,INIT \-j DROP
 
-iptables -A INPUT -p sctp --chunk-types any DATA:Be -j ACCEPT
+iptables \-A INPUT \-p sctp \-\-chunk\-types any DATA:Be \-j ACCEPT
diff --git a/extensions/libxt_state.man b/extensions/libxt_state.man
index 8e943c3..b5e719a 100644
--- a/extensions/libxt_state.man
+++ b/extensions/libxt_state.man
@@ -1,7 +1,7 @@
 This module, when combined with connection tracking, allows access to
 the connection tracking state for this packet.
 .TP
-[\fB!\fP] \fB--state\fP \fIstate\fP
+[\fB!\fP] \fB\-\-state\fP \fIstate\fP
 Where state is a comma separated list of the connection states to
 match.  Possible states are
 .B INVALID
diff --git a/extensions/libxt_statistic.man b/extensions/libxt_statistic.man
index 7e17256..8fc3b29 100644
--- a/extensions/libxt_statistic.man
+++ b/extensions/libxt_statistic.man
@@ -1,30 +1,30 @@
 This module matches packets based on some statistic condition.
 It supports two distinct modes settable with the 
-.B --mode
+\fB\-\-mode\fP
 option.
 .PP
 Supported options:
 .TP
-.BI "--mode " "mode"
+\fB\-\-mode\fP \fImode\fP
 Set the matching mode of the matching rule, supported modes are
 .B random
 and
 .B nth. 
 .TP
-.BI "--probability " "p"
+\fB\-\-probability\fP \fIp\fP
 Set the probability from 0 to 1 for a packet to be randomly
 matched. It works only with the
 .B random
 mode.
 .TP
-.BI "--every " "n"
+\fB\-\-every\fP \fIn\fP
 Match one packet every nth packet. It works only with the
 .B nth
 mode (see also the 
-.B --packet
+\fB\-\-packet\fP
 option).
 .TP
-.BI "--packet " "p"
-Set the initial counter value (0 <= p <= n-1, default 0) for the
+\fB\-\-packet\fP \fIp\fP
+Set the initial counter value (0 <= p <= n\-1, default 0) for the
 .B nth 
 mode.
diff --git a/extensions/libxt_string.man b/extensions/libxt_string.man
index 01e15c2..725f3ff 100644
--- a/extensions/libxt_string.man
+++ b/extensions/libxt_string.man
@@ -1,16 +1,16 @@
 This modules matches a given string by using some pattern matching strategy. It requires a linux kernel >= 2.6.14.
 .TP
-\fB--algo\fP {\fBbm\fP|\fBkmp\fP}
+\fB\-\-algo\fP {\fBbm\fP|\fBkmp\fP}
 Select the pattern matching strategy. (bm = Boyer-Moore, kmp = Knuth-Pratt-Morris)
 .TP
-.BI "--from " "offset"
+\fB\-\-from\fP \fIoffset\fP
 Set the offset from which it starts looking for any matching. If not passed, default is 0.
 .TP
-.BI "--to " "offset"
+\fB\-\-to\fP \fIoffset\fP
 Set the offset from which it starts looking for any matching. If not passed, default is the packet size.
 .TP
-[\fB!\fP] \fB--string\fP \fIpattern\fP
+[\fB!\fP] \fB\-\-string\fP \fIpattern\fP
 Matches the given pattern.
 .TP
-[\fB!\fP] \fB--hex-string\fP \fIpattern\fP
+[\fB!\fP] \fB\-\-hex\-string\fP \fIpattern\fP
 Matches the given pattern in hex notation.
diff --git a/extensions/libxt_tcp.man b/extensions/libxt_tcp.man
index 9b4ed59..8f39cdb 100644
--- a/extensions/libxt_tcp.man
+++ b/extensions/libxt_tcp.man
@@ -1,7 +1,7 @@
-These extensions can be used if `--protocol tcp' is specified. It
+These extensions can be used if `\-\-protocol tcp' is specified. It
 provides the following options:
 .TP
-[\fB!\fP] \fB--source-port\fP,\fB--sport\fP \fIport\fP[\fB:\fP\fIport\fP]
+[\fB!\fP] \fB\-\-source\-port\fP,\fB\-\-sport\fP \fIport\fP[\fB:\fP\fIport\fP]
 Source port or port range specification. This can either be a service
 name or a port number. An inclusive range can also be specified,
 using the format \fIport\fP\fB:\fP\fIport\fP.
@@ -9,15 +9,15 @@ If the first port is omitted, "0" is assumed; if the last is omitted,
 "65535" is assumed.
 If the second port is greater than the first they will be swapped.
 The flag
-.B --sport
+\fB\-\-sport\fP
 is a convenient alias for this option.
 .TP
-[\fB!\fP] \fB--destination-port\fP,\fB--dport\fP \fIport\fP[\fB,\fP\fIport\fP]
+[\fB!\fP] \fB\-\-destination\-port\fP,\fB\-\-dport\fP \fIport\fP[\fB,\fP\fIport\fP]
 Destination port or port range specification.  The flag
-.B --dport
+\fB\-\-dport\fP
 is a convenient alias for this option.
 .TP
-[\fB!\fP] \fB--tcp-flags\fP \fImask\fP \fIcomp\fP
+[\fB!\fP] \fB\-\-tcp\-flags\fP \fImask\fP \fIcomp\fP
 Match when the TCP flags are as specified.  The first argument \fImask\fP is the
 flags which we should examine, written as a comma-separated list, and
 the second argument \fIcomp\fP is a comma-separated list of flags which must be
@@ -25,20 +25,20 @@ set.  Flags are:
 .BR "SYN ACK FIN RST URG PSH ALL NONE" .
 Hence the command
 .nf
- iptables -A FORWARD -p tcp --tcp-flags SYN,ACK,FIN,RST SYN
+ iptables \-A FORWARD \-p tcp \-\-tcp\-flags SYN,ACK,FIN,RST SYN
 .fi
 will only match packets with the SYN flag set, and the ACK, FIN and
 RST flags unset.
 .TP
-[\fB!\fP] \fB--syn\fP
+[\fB!\fP] \fB\-\-syn\fP
 Only match TCP packets with the SYN bit set and the ACK,RST and FIN bits
 cleared.  Such packets are used to request TCP connection initiation;
 for example, blocking such packets coming in an interface will prevent
 incoming TCP connections, but outgoing TCP connections will be
 unaffected.
-It is equivalent to \fB--tcp-flags SYN,RST,ACK,FIN SYN\fP.
-If the "!" flag precedes the "--syn", the sense of the
+It is equivalent to \fB\-\-tcp\-flags SYN,RST,ACK,FIN SYN\fP.
+If the "!" flag precedes the "\-\-syn", the sense of the
 option is inverted.
 .TP
-[\fB!\fP] \fB--tcp-option\fP \fInumber\fP
+[\fB!\fP] \fB\-\-tcp\-option\fP \fInumber\fP
 Match if TCP option set.
diff --git a/extensions/libxt_tcpmss.man b/extensions/libxt_tcpmss.man
index 01cdc3a..8ee715c 100644
--- a/extensions/libxt_tcpmss.man
+++ b/extensions/libxt_tcpmss.man
@@ -1,4 +1,4 @@
 This matches the TCP MSS (maximum segment size) field of the TCP header.  You can only use this on TCP SYN or SYN/ACK packets, since the MSS is only negotiated during the TCP handshake at connection startup time.
 .TP
-[\fB!\fP] \fB--mss\fP \fIvalue\fP[\fB:\fP\fIvalue\fP]
+[\fB!\fP] \fB\-\-mss\fP \fIvalue\fP[\fB:\fP\fIvalue\fP]
 Match a given TCP MSS value or range.
diff --git a/extensions/libxt_time.man b/extensions/libxt_time.man
index ab4a09c..83625a2 100644
--- a/extensions/libxt_time.man
+++ b/extensions/libxt_time.man
@@ -1,68 +1,68 @@
 This matches if the packet arrival time/date is within a given range. All
 options are optional, but are ANDed when specified.
 .TP
-\fB--datestart\fR \fIYYYY\fR[\fB-\fR\fIMM\fR[\fB-\fR\fIDD\fR[\fBT\fR\fIhh\fR[\fB:\fR\fImm\fR[\fB:\fR\fIss\fR]]]]]
+\fB\-\-datestart\fP \fIYYYY\fP[\fB\-\fP\fIMM\fP[\fB\-\fP\fIDD\fP[\fBT\fP\fIhh\fP[\fB:\fP\fImm\fP[\fB:\fP\fIss\fP]]]]]
 .TP
-\fB--datestop\fR \fIYYYY\fR[\fB-\fR\fIMM\fR[\fB-\fR\fIDD\fR[\fBT\fR\fIhh\fR[\fB:\fR\fImm\fR[\fB:\fR\fIss\fR]]]]]
+\fB\-\-datestop\fP \fIYYYY\fP[\fB\-\fP\fIMM\fP[\fB\-\fP\fIDD\fP[\fBT\fP\fIhh\fP[\fB:\fP\fImm\fP[\fB:\fP\fIss\fP]]]]]
 .IP
 Only match during the given time, which must be in ISO 8601 "T" notation.
 The possible time range is 1970-01-01T00:00:00 to 2038-01-19T04:17:07.
 .IP
-If --datestart or --datestop are not specified, it will default to 1970-01-01
+If \-\-datestart or \-\-datestop are not specified, it will default to 1970-01-01
 and 2038-01-19, respectively.
 .TP
-\fB--timestart\fR \fIhh\fR\fB:\fR\fImm\fR[\fB:\fR\fIss\fR]
+\fB\-\-timestart\fP \fIhh\fP\fB:\fP\fImm\fP[\fB:\fP\fIss\fP]
 .TP
-\fB--timestop\fR \fIhh\fR\fB:\fR\fImm\fR[\fB:\fR\fIss\fR]
+\fB\-\-timestop\fP \fIhh\fP\fB:\fP\fImm\fP[\fB:\fP\fIss\fP]
 .IP
 Only match during the given daytime. The possible time range is 00:00:00 to
 23:59:59. Leading zeroes are allowed (e.g. "06:03") and correctly interpreted
 as base-10.
 .TP
-[\fB!\fR] \fB--monthdays\fR \fIday\fR[\fB,\fR\fIday\fR...]
+[\fB!\fR] \fB\-\-monthdays\fP \fIday\fP[\fB,\fP\fIday\fP...]
 .IP
 Only match on the given days of the month. Possible values are \fB1\fR
 to \fB31\fR. Note that specifying \fB31\fR will of course not match
 on months which do not have a 31st day; the same goes for 28- or 29-day
 February.
 .TP
-[\fB!\fR] \fB--weekdays\fR \fIday\fR[\fB,\fR\fIday\fR...]
+[\fB!\fR] \fB\-\-weekdays\fP \fIday\fP[\fB,\fP\fIday\fP...]
 .IP
 Only match on the given weekdays. Possible values are \fBMon\fR, \fBTue\fR,
 \fBWed\fR, \fBThu\fR, \fBFri\fR, \fBSat\fR, \fBSun\fR, or values from \fB1\fR
-to \fB7\fR, respectively. You may also use two-character variants (\fBMo\fR,
+to \fB7\fR, respectively. You may also use two-character variants (\fBMo\fP,
 \fBTu\fR, etc.).
 .TP
-\fB--utc\fR
+\fB\-\-utc\fP
 .IP
-Interpret the times given for \fB--datestart\fR, \fB--datestop\fR,
-\fB--timestart\fR and \fB--timestop\fR to be UTC.
+Interpret the times given for \fB\-\-datestart\fP, \fB\-\-datestop\fP,
+\fB\-\-timestart\fP and \fB\-\-timestop\fP to be UTC.
 .TP
-\fB--localtz\fR
+\fB\-\-localtz\fP
 .IP
-Interpret the times given for \fB--datestart\fR, \fB--datestop\fR,
-\fB--timestart\fR and \fB--timestop\fR to be local kernel time. (Default)
+Interpret the times given for \fB\-\-datestart\fP, \fB\-\-datestop\fP,
+\fB\-\-timestart\fP and \fB\-\-timestop\fP to be local kernel time. (Default)
 .PP
 EXAMPLES. To match on weekends, use:
 .IP
--m time --weekdays Sa,Su
+\-m time \-\-weekdays Sa,Su
 .PP
 Or, to match (once) on a national holiday block:
 .IP
--m time --datestart 2007-12-24 --datestop 2007-12-27
+\-m time \-\-datestart 2007\-12\-24 \-\-datestop 2007\-12\-27
 .PP
 Since the stop time is actually inclusive, you would need the following stop
 time to not match the first second of the new day:
 .IP
--m time --datestart 2007-01-01T17:00 --datestop 2007-01-01T23:59:59
+\-m time \-\-datestart 2007\-01\-01T17:00 \-\-datestop 2007\-01\-01T23:59:59
 .PP
 During lunch hour:
 .IP
--m time --timestart 12:30 --timestop 13:30
+\-m time \-\-timestart 12:30 \-\-timestop 13:30
 .PP
 The fourth Friday in the month:
 .IP
--m time --weekdays Fr --monthdays 22,23,24,25,26,27,28
+\-m time \-\-weekdays Fr \-\-monthdays 22,23,24,25,26,27,28
 .PP
 (Note that this exploits a certain mathematical property. It is not possible to
 say "fourth Thursday OR fourth Friday" in one rule. It is possible with
diff --git a/extensions/libxt_tos.man b/extensions/libxt_tos.man
index cd72e95..ae73e63 100644
--- a/extensions/libxt_tos.man
+++ b/extensions/libxt_tos.man
@@ -2,11 +2,11 @@ This module matches the 8-bit Type of Service field in the IPv4 header (i.e.
 including the "Precedence" bits) or the (also 8-bit) Priority field in the IPv6
 header.
 .TP
-[\fB!\fP] \fB--tos\fR \fIvalue\fR[\fB/\fR\fImask\fR]
+[\fB!\fP] \fB\-\-tos\fP \fIvalue\fP[\fB/\fP\fImask\fP]
 Matches packets with the given TOS mark value. If a mask is specified, it is
 logically ANDed with the TOS mark before the comparison.
 .TP
-[\fB!\fP] \fB--tos\fR \fIsymbol\fR
+[\fB!\fP] \fB\-\-tos\fP \fIsymbol\fP
 You can specify a symbolic name when using the tos match for IPv4. The list of
-recognized TOS names can be obtained by calling iptables with \fB-m tos -h\fR.
+recognized TOS names can be obtained by calling iptables with \fB\-m tos \-h\fP.
 Note that this implies a mask of 0x3F, i.e. all but the ECN bits.
diff --git a/extensions/libxt_u32.man b/extensions/libxt_u32.man
index 8e00cc1..2ffab30 100644
--- a/extensions/libxt_u32.man
+++ b/extensions/libxt_u32.man
@@ -2,7 +2,7 @@ U32 tests whether quantities of up to 4 bytes extracted from a packet have
 specified values. The specification of what to extract is general enough to
 find data at given offsets from tcp headers or payloads.
 .TP
-[\fB!\fP] \fB--u32\fP \fItests\fP
+[\fB!\fP] \fB\-\-u32\fP \fItests\fP
 The argument amounts to a program in a small language described below.
 .IP
 tests := location "=" value | tests "&&" location "=" value
@@ -53,7 +53,7 @@ C = (*(A+B)<<24) + (*(A+B+1)<<16) + (*(A+B+2)<<8) + *(A+B+3)
 .IP
 @number A = A + C; then do the instruction number
 .PP
-Any access of memory outside [skb->data,skb->end] causes the match to fail.
+Any access of memory outside [skb\->data,skb\->end] causes the match to fail.
 Otherwise the result of the computation is the final value of C.
 .PP
 Whitespace is allowed but not required in the tests. However, the characters
@@ -66,7 +66,7 @@ match IP packets with total length >= 256
 .IP
 The IP header contains a total length field in bytes 2-3.
 .IP
---u32 "\fB0 & 0xFFFF = 0x100:0xFFFF\fR"
+\-\-u32 "\fB0 & 0xFFFF = 0x100:0xFFFF\fP"
 .IP
 read bytes 0-3
 .IP
@@ -79,7 +79,7 @@ match ICMP packets with icmp type 0
 .IP
 First test that it is an ICMP packet, true iff byte 9 (protocol) = 1
 .IP
---u32 "\fB6 & 0xFF = 1 &&\fR ...
+\-\-u32 "\fB6 & 0xFF = 1 &&\fP ...
 .IP
 read bytes 6-9, use \fB&\fR to throw away bytes 6-8 and compare the result to
 1. Next test that it is not a fragment. (If so, it might be part of such a
@@ -114,7 +114,7 @@ TCP payload bytes 8-12 is any of 1, 2, 5 or 8
 .IP
 First we test that the packet is a tcp packet (similar to ICMP).
 .IP
---u32 "\fB6 & 0xFF = 6 &&\fR ...
+\-\-u32 "\fB6 & 0xFF = 6 &&\fP ...
 .IP
 Next, test that it is not a fragment (same as above).
 .IP
diff --git a/extensions/libxt_udp.man b/extensions/libxt_udp.man
index af0682c..5339c8e 100644
--- a/extensions/libxt_udp.man
+++ b/extensions/libxt_udp.man
@@ -1,14 +1,14 @@
-These extensions can be used if `--protocol udp' is specified.  It
+These extensions can be used if `\-\-protocol udp' is specified. It
 provides the following options:
 .TP
-[\fB!\fP] \fB--source-port\fP,\fB--sport\fP \fIport\fP[\fB:\fP\fIport\fP]
+[\fB!\fP] \fB\-\-source\-port\fP,\fB\-\-sport\fP \fIport\fP[\fB:\fP\fIport\fP]
 Source port or port range specification.
 See the description of the
-.B --source-port
+\fB\-\-source\-port\fP
 option of the TCP extension for details.
 .TP
-[\fB!\fP] \fB--destination-port\fP,\fB--dport\fP \fIport\fP[\fB:\fP\fIport\fP]
+[\fB!\fP] \fB\-\-destination\-port\fP,\fB\-\-dport\fP \fIport\fP[\fB:\fP\fIport\fP]
 Destination port or port range specification.
 See the description of the
-.B --destination-port
+\fB\-\-destination\-port\fP
 option of the TCP extension for details.
diff --git a/ip6tables.8.in b/ip6tables.8.in
index 6308e02..3ca63d8 100644
--- a/ip6tables.8.in
+++ b/ip6tables.8.in
@@ -25,25 +25,31 @@
 .\"
 .\"
 .SH NAME
-ip6tables \- IPv6 packet filter administration
+ip6tables - IPv6 packet filter administration
 .SH SYNOPSIS
-\fBip6tables\fP [\fB-t\fP \fItable\fP] {\fB-A\fP|\fB-D\fP} \fIchain rule-specification\fP [\fIoptions...\fP]
+\fBip6tables\fP [\fB\-t\fP \fItable\fP] {\fB\-A\fP|\fB\-D\fP} \fIchain
+rule\-specification\fP [\fIoptions...\fP]
 .PP
-\fBip6tables\fP [\fB-t\fP \fItable\fP] \fB-I\fP [\fIrulenum\fP] \fIrule-specification\fP [\fIoptions...\fP]
+\fBip6tables\fP [\fB\-t\fP \fItable\fP] \fB\-I\fP [\fIrulenum\fP]
+\fIrule\-specification\fP [\fIoptions...\fP]
 .PP
-\fBip6tables\fP [\fB-t\fP \fItable\fP] \fB-R\fP \fIrulenum rule-specification\fP [\fIoptions...\fP]
+\fBip6tables\fP [\fB\-t\fP \fItable\fP] \fB\-R\fP \fIrulenum
+rule\-specification\fP [\fIoptions...\fP]
 .PP
-\fBip6tables\fP [\fB-t\fP \fItable\fP] \fB-D\fP \fIchain rulenum\fP [\fIoptions...\fP]
+\fBip6tables\fP [\fB\-t\fP \fItable\fP] \fB\-D\fP \fIchain rulenum\fP
+[\fIoptions...\fP]
 .PP
-\fBip6tables\fP [\fB-t\fP \fItable\fP] \fB-S\fP [\fIchain\fP]
+\fBip6tables\fP [\fB\-t\fP \fItable\fP] \fB\-S\fP [\fIchain\fP]
 .PP
-\fBip6tables\fP [\fB-t\fP \fItable\fP] {\fB-F\fP|\fB-L\fP|\fB-Z\fP} [\fIchain\fP] [\fIoptions...\fP]
+\fBip6tables\fP [\fB\-t\fP \fItable\fP] {\fB\-F\fP|\fB\-L\fP|\fB\-Z\fP}
+[\fIchain\fP] [\fIoptions...\fP]
 .PP
-\fBip6tables\fP [\fB-t\fP \fItable\fP] \fB-N\fP \fIchain\fP
+\fBip6tables\fP [\fB\-t\fP \fItable\fP] \fB\-N\fP \fIchain\fP
 .PP
-\fBip6tables\fP [\fB-t\fP \fItable\fP] \fB-X\fP [\fIchain\fP]
+\fBip6tables\fP [\fB\-t\fP \fItable\fP] \fB\-X\fP [\fIchain\fP]
 .PP
-\fBip6tables\fP [\fB-t\fP \fItable\fP] \fB-P\fP \fIchain target\fP [\fIoptions...\fP]
+\fBip6tables\fP [\fB\-t\fP \fItable\fP] \fB\-P\fP \fIchain target\fP
+[\fIoptions...\fP]
 .PP
 \fBip6tables\fP [\fB-t\fP \fItable\fP] \fB-E\fP \fIold-chain-name new-chain-name\fP
 .SH DESCRIPTION
-- 
# Created with git-export-patch
