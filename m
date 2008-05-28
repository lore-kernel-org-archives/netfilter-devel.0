From: Jan Engelhardt <jengelh@medozas.de>
Subject: manpages: consistent syntax
Date: Wed, 28 May 2008 18:45:19 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805281844480.16560@fbirervta.pbzchgretzou.qr>
References: <20080528150425.20290.58521.stgit@woodpecker.roonstrasse.net> <alpine.LNX.1.10.0805281841380.16560@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59845 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbYE1QpV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 May 2008 12:45:21 -0400
In-Reply-To: <alpine.LNX.1.10.0805281841380.16560@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


commit 314cc5f0dd48c047e660f45aaaf4e86675ab5d74
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue May 6 19:47:33 2008 +0200

    manpages: consistent syntax
    
    In the manpages, bold is used to denote characters the user has to
    enter verbatim, italic denotes placeholders and non-highlighted
    pieces are used as a structure: "[]" specifying an optional part,
    "{}" a mandatory part, with "|" used for alternations. The "!" for
    negation is better supported before the option than after it, too.
    The patch makes a few files consistent with this style already used
    in manpages.
---
 extensions/libip6t_ah.man         |    2 +-
 extensions/libip6t_dst.man        |    2 +-
 extensions/libip6t_frag.man       |    4 +-
 extensions/libip6t_hbh.man        |    4 +-
 extensions/libip6t_hl.man         |    2 +-
 extensions/libip6t_icmp6.man      |    2 +-
 extensions/libip6t_ipv6header.man |   58 ++++++++++++++++------------
 extensions/libip6t_mh.man         |    2 +-
 extensions/libip6t_rt.man         |    8 ++--
 extensions/libipt_MASQUERADE.man  |    2 +-
 extensions/libipt_NETMAP.man      |    2 +-
 extensions/libipt_REDIRECT.man    |    2 +-
 extensions/libipt_SET.man         |    4 +-
 extensions/libipt_ah.man          |    2 +-
 extensions/libipt_icmp.man        |    2 +-
 extensions/libipt_realm.man       |    2 +-
 extensions/libipt_set.man         |    2 +-
 extensions/libxt_CLASSIFY.man     |    2 +-
 extensions/libxt_TCPOPTSTRIP.man  |    2 +-
 extensions/libxt_dscp.man         |    2 +-
 extensions/libxt_esp.man          |    2 +-
 extensions/libxt_mac.man          |    2 +-
 extensions/libxt_multiport.man    |    6 +-
 extensions/libxt_physdev.man      |   10 ++--
 extensions/libxt_pkttype.man      |    2 +-
 extensions/libxt_policy.man       |   18 ++++----
 extensions/libxt_string.man       |    2 +-
 extensions/libxt_tcp.man          |   17 ++++----
 extensions/libxt_tcpmss.man       |    2 +-
 extensions/libxt_udp.man          |    4 +-
 30 files changed, 90 insertions(+), 83 deletions(-)

diff --git a/extensions/libip6t_ah.man b/extensions/libip6t_ah.man
index 807f9e3..b4e74dc 100644
--- a/extensions/libip6t_ah.man
+++ b/extensions/libip6t_ah.man
@@ -1,6 +1,6 @@
 This module matches the parameters in Authentication header of IPsec packets.
 .TP
-.BR "--ahspi " "[!] \fIspi\fP[:\fIspi\fP]"
+[\fB!\fP] \fB--ahspi\fP \fIspi\fP[\fB:\fP\fIspi\fP]
 Matches SPI.
 .TP
 [\fB!\fP] \fB--ahlen\fP \fIlength\fP
diff --git a/extensions/libip6t_dst.man b/extensions/libip6t_dst.man
index d895a0e..f4ca1c4 100644
--- a/extensions/libip6t_dst.man
+++ b/extensions/libip6t_dst.man
@@ -3,5 +3,5 @@ This module matches the parameters in Destination Options header
 [\fB!\fP] \fB--dst-len\fP \fIlength\fP
 Total length of this header in octets.
 .TP
-.BR "--dst-opts " "\fItype\fP[:\fIlength\fP][,\fItype\fP[:\fIlength\fP]...]"
+\fB--dst-opts\fP \fItype\fP[\fB:\fP\fIlength\fP][\fB,\fP\fItype\fP[\fB:\fP\fIlength\fP]...]
 numeric type of option and the length of the option data in octets.
diff --git a/extensions/libip6t_frag.man b/extensions/libip6t_frag.man
index cc13e79..7832cbf 100644
--- a/extensions/libip6t_frag.man
+++ b/extensions/libip6t_frag.man
@@ -1,9 +1,9 @@
 This module matches the parameters in Fragment header.
 .TP
-.BR "--fragid " "[!] \fIid\fP[:\fIid\fP]"
+[\fB!\fP] \fB--fragid\fP \fIid\fP[\fB:\fP\fIid\fP]
 Matches the given Identification or range of it.
 .TP
-.BR "--fraglen " "[!] \fIlength\fP"
+[\fB!\fP] \fB--fraglen\fP \fIlength\fP
 This option cannot be used with kernel version 2.6.10 or later. The length of
 Fragment header is static and this option doesn't make sense.
 .TP
diff --git a/extensions/libip6t_hbh.man b/extensions/libip6t_hbh.man
index 938e1f3..38bae11 100644
--- a/extensions/libip6t_hbh.man
+++ b/extensions/libip6t_hbh.man
@@ -1,7 +1,7 @@
 This module matches the parameters in Hop-by-Hop Options header
 .TP
-.BR "--hbh-len " "[!] \fIlength\fP"
+[\fB!\fP] \fB--hbh-len\fP \fIlength\fP
 Total length of this header in octets.
 .TP
-.BR "--hbh-opts " "\fItype\fP[:\fIlength\fP][,\fItype\fP[:\fIlength\fP]...]"
+\fB--hbh-opts\fP \fItype\fP[\fB:\fP\fIlength\fP][\fB,\fP\fItype\fP[\fB:\fP\fIlength\fP]...]
 numeric type of option and the length of the option data in octets.
diff --git a/extensions/libip6t_hl.man b/extensions/libip6t_hl.man
index d33e431..c8c7cd7 100644
--- a/extensions/libip6t_hl.man
+++ b/extensions/libip6t_hl.man
@@ -1,6 +1,6 @@
 This module matches the Hop Limit field in the IPv6 header.
 .TP
-.BR "--hl-eq " "[!] \fIvalue\fP"
+[\fB!\fP] \fB--hl-eq\fP \fIvalue\fP
 Matches if Hop Limit equals \fIvalue\fP.
 .TP
 .BI "--hl-lt " "value"
diff --git a/extensions/libip6t_icmp6.man b/extensions/libip6t_icmp6.man
index c755fbf..60dddf7 100644
--- a/extensions/libip6t_icmp6.man
+++ b/extensions/libip6t_icmp6.man
@@ -1,7 +1,7 @@
 This extension can be used if `--protocol ipv6-icmp' or `--protocol icmpv6' is
 specified. It provides the following option:
 .TP
-.BR "--icmpv6-type " "[!] \fItype\fP[/\fIcode\fP]|\fItypename\fP"
+[\fB!\fP] \fB--icmpv6-type\fP \fItype\fP[\fB/\fP\fIcode\fP]|\fItypename\fP
 This allows specification of the ICMPv6 type, which can be a numeric
 ICMPv6
 .IR type ,
diff --git a/extensions/libip6t_ipv6header.man b/extensions/libip6t_ipv6header.man
index fe3fe98..23478b4 100644
--- a/extensions/libip6t_ipv6header.man
+++ b/extensions/libip6t_ipv6header.man
@@ -1,29 +1,37 @@
 This module matches IPv6 extension headers and/or upper layer header.
 .TP
-.BR "--header " "[!] \fIheader\fP[,\fIheader\fP...]"
+\fB--soft\fP
+Matches if the packet includes \fBany\fP of the headers specified with
+\fB--header\fP.
+.TP
+[\fB!\fP] \fB--header\fP \fIheader\fP[\fB,\fP\fIheader\fP...]
 Matches the packet which EXACTLY includes all specified headers. The headers
 encapsulated with ESP header are out of scope.
-.IR header
-can be
-.IR hop | hop-by-hop
-(Hop-by-Hop Options header),
-.IR dst
-(Destination Options header),
-.IR route
-(Routing header),
-.IR frag
-(Fragment header),
-.IR auth
-(Authentication header),
-.IR esp
-(Encapsulating Security Payload header),
-.IR none
-(No Next header) which matches 59 in the 'Next Header field' of IPv6 header or any IPv6 extension headers, or
-.IR proto
-which matches any upper layer protocol header. A protocol name from /etc/protocols and numeric value also allowed. The number 255 is equivalent to
-.IR proto .
-.TP
-.BR "[--soft]"
-Matches if the packet includes all specified headers with
-.BR --header ,
-AT LEAST.
+Possible \fIheader\fP types can be:
+.TP
+\fBhop\fP|\fBhop-by-hop\fP
+Hop-by-Hop Options header
+.TP
+\fBdst\fP
+Destination Options header
+.TP
+\fBroute\fP
+Routing header
+.TP
+\fBfrag\fP
+Fragment header
+.TP
+\fBauth\fP
+Authentication header
+.TP
+\fBesp\fP
+Encapsulating Security Payload header
+.TP
+\fBnone\fP
+No Next header which matches 59 in the 'Next Header field' of IPv6 header or
+any IPv6 extension headers
+.TP
+\fBproto\fP
+which matches any upper layer protocol header. A protocol name from
+/etc/protocols and numeric value also allowed. The number 255 is equivalent to
+\fBproto\fP.
diff --git a/extensions/libip6t_mh.man b/extensions/libip6t_mh.man
index 14f1c64..f5a1f96 100644
--- a/extensions/libip6t_mh.man
+++ b/extensions/libip6t_mh.man
@@ -1,7 +1,7 @@
 This extension is loaded if `--protocol ipv6-mh' or `--protocol mh' is
 specified. It provides the following option:
 .TP
-.BR "--mh-type " "[!] \fItype\fP[:\fItype\fP]"
+[\fB!\fP] \fB--mh-type\fP \fItype\fP[\fB:\fP\fItype\fP]
 This allows specification of the Mobility Header(MH) type, which can be
 a numeric MH
 .IR type ,
diff --git a/extensions/libip6t_rt.man b/extensions/libip6t_rt.man
index e56d5f4..0ccaa5f 100644
--- a/extensions/libip6t_rt.man
+++ b/extensions/libip6t_rt.man
@@ -1,18 +1,18 @@
 Match on IPv6 routing header
 .TP
-.BR "--rt-type" " [!] \fItype\fP"
+[\fB!\fP] \fB--rt-type\fP \fItype\fP
 Match the type (numeric).
 .TP
-.BR "--rt-segsleft" " [!] \fInum\fP[:\fInum\fP]"
+[\fB!\fP] \fB--rt-segsleft\fP \fInum\fP[\fB:\fP\fInum\fP]
 Match the `segments left' field (range).
 .TP
-.BR "--rt-len" " [!] \fIlength\fP"
+[\fB!\fP] \fB--rt-len\fP \fIlength\fP
 Match the length of this header.
 .TP
 .BR "--rt-0-res"
 Match the reserved field, too (type=0)
 .TP
-.BR "--rt-0-addrs" " \fIADDR\fP[,\fIADDR\fP...]"
+\fB--rt-0-addrs\fP \fIaddr\fP[\fB,\fP\fIaddr\fP...]
 Match type=0 addresses (list).
 .TP
 .BR "--rt-0-not-strict"
diff --git a/extensions/libipt_MASQUERADE.man b/extensions/libipt_MASQUERADE.man
index ea3c8de..f11ad86 100644
--- a/extensions/libipt_MASQUERADE.man
+++ b/extensions/libipt_MASQUERADE.man
@@ -12,7 +12,7 @@ when the interface goes down.  This is the correct behavior when the
 next dialup is unlikely to have the same interface address (and hence
 any established connections are lost anyway).  It takes one option:
 .TP
-.BR "--to-ports " "\fIport\fP[-\fIport\fP]"
+\fB--to-ports\fP \fIport\fP[\fB-\fP\fIport\fP]
 This specifies a range of source ports to use, overriding the default
 .B SNAT
 source port-selection heuristics (see above).  This is only valid
diff --git a/extensions/libipt_NETMAP.man b/extensions/libipt_NETMAP.man
index d49a025..f6a933c 100644
--- a/extensions/libipt_NETMAP.man
+++ b/extensions/libipt_NETMAP.man
@@ -3,7 +3,7 @@ another network of addresses.  It can only be used from rules in the
 .B nat
 table.
 .TP
-.BI "--to "  "address[/mask]"
+\fB--to\fP \fIaddress\fP[\fB/\fP\fImask\fP]
 Network address to map to.  The resulting address will be constructed in the
 following way: All 'one' bits in the mask are filled in from the new `address'.
 All bits that are zero in the mask are filled in from the original address.
diff --git a/extensions/libipt_REDIRECT.man b/extensions/libipt_REDIRECT.man
index 72f1d4d..0217045 100644
--- a/extensions/libipt_REDIRECT.man
+++ b/extensions/libipt_REDIRECT.man
@@ -9,7 +9,7 @@ chains.  It redirects the packet to the machine itself by changing the
 destination IP to the primary address of the incoming interface
 (locally-generated packets are mapped to the 127.0.0.1 address).
 .TP
-.BR "--to-ports " "\fIport\fP[-\fIport\fP]"
+\fB--to-ports\fP \fIport\fP[\fB-\fP\fIport\fP]
 This specifies a destination port or range of ports to use: without
 this, the destination port is never altered.  This is only valid
 if the rule also specifies
diff --git a/extensions/libipt_SET.man b/extensions/libipt_SET.man
index 8f25bea..4da73ca 100644
--- a/extensions/libipt_SET.man
+++ b/extensions/libipt_SET.man
@@ -1,10 +1,10 @@
 This modules adds and/or deletes entries from IP sets which can be defined 
 by ipset(8).
 .TP
-.BR "--add-set " "setname flag[,flag...]"
+\fB--add-set\fP \fIsetname\fP \fIflag\fP[\fB,\fP\fIflag\fP...]
 add the address(es)/port(s) of the packet to the sets
 .TP
-.BR "--del-set " "setname flag[,flag...]"
+\fB--del-set\fP \fIsetname\fP \fIflag\fP[\fB,\fP\fIflag\fP...]
 delete the address(es)/port(s) of the packet from the sets,
 where flags are
 .BR "src"
diff --git a/extensions/libipt_ah.man b/extensions/libipt_ah.man
index 7300c18..3076554 100644
--- a/extensions/libipt_ah.man
+++ b/extensions/libipt_ah.man
@@ -1,3 +1,3 @@
 This module matches the SPIs in Authentication header of IPsec packets.
 .TP
-.BR "--ahspi " "[!] \fIspi\fP[:\fIspi\fP]"
+[\fB!\fP] \fB--ahspi\fP \fIspi\fP[\fB:\fP\fIspi\fP]
diff --git a/extensions/libipt_icmp.man b/extensions/libipt_icmp.man
index 55d24b4..a912769 100644
--- a/extensions/libipt_icmp.man
+++ b/extensions/libipt_icmp.man
@@ -1,7 +1,7 @@
 This extension can be used if `--protocol icmp' is specified.  It
 provides the following option:
 .TP
-.BR "--icmp-type " "[!] \fItypename\fP"
+[\fB!\fP] \fB--icmp-type\fP \fItypename\fP
 This allows specification of the ICMP type, which can be a numeric
 ICMP type, or one of the ICMP type names shown by the command
 .nf
diff --git a/extensions/libipt_realm.man b/extensions/libipt_realm.man
index b33da0e..362ab60 100644
--- a/extensions/libipt_realm.man
+++ b/extensions/libipt_realm.man
@@ -1,7 +1,7 @@
 This matches the routing realm.  Routing realms are used in complex routing
 setups involving dynamic routing protocols like BGP.
 .TP
-.BI "--realm " "[!] " "value[/mask]"
+[\fB!\fP] \fB--realm\fP \fIvalue\fP[\fB/\fP\fImask\fP]
 Matches a given realm number (and optionally mask). If not a number, value
 can be a named realm from /etc/iproute2/rt_realms (mask can not be used in
 that case).
diff --git a/extensions/libipt_set.man b/extensions/libipt_set.man
index d280577..a92a950 100644
--- a/extensions/libipt_set.man
+++ b/extensions/libipt_set.man
@@ -1,6 +1,6 @@
 This modules macthes IP sets which can be defined by ipset(8).
 .TP
-.BR "--set " "setname flag[,flag...]"
+\fB--set\fP \fIsetname\fP \fIflag\fP[\fB,\fP\fIflag\fP...]
 where flags are
 .BR "src"
 and/or
diff --git a/extensions/libxt_CLASSIFY.man b/extensions/libxt_CLASSIFY.man
index 393c329..dbeff32 100644
--- a/extensions/libxt_CLASSIFY.man
+++ b/extensions/libxt_CLASSIFY.man
@@ -1,4 +1,4 @@
 This module allows you to set the skb->priority value (and thus classify the packet into a specific CBQ class).
 .TP
-.BI "--set-class " "MAJOR:MINOR"
+\fB--set-class\fP \fImajor\fP\fB:\fP\fIminor\fP
 Set the major and minor class value.
diff --git a/extensions/libxt_TCPOPTSTRIP.man b/extensions/libxt_TCPOPTSTRIP.man
index 0a8bd20..cd000f9 100644
--- a/extensions/libxt_TCPOPTSTRIP.man
+++ b/extensions/libxt_TCPOPTSTRIP.man
@@ -1,7 +1,7 @@
 This target will strip TCP options off a TCP packet. (It will actually replace
 them by NO-OPs.) As such, you will need to add the \fB-p tcp\fR parameters.
 .TP
-\fB--strip-options\fR \fIoption\fR[\fB,\fR\fI...\fR]
+\fB--strip-options\fP \fIoption\fP[\fB,\fP\fIoption\fP...]
 Strip the given option(s). The options may be specified by TCP option number or
 by symbolic name. The list of recognized options can be obtained by calling
 iptables with \fB-j TCPOPTSTRIP -h\fR.
diff --git a/extensions/libxt_dscp.man b/extensions/libxt_dscp.man
index 29ff3b2..4a42278 100644
--- a/extensions/libxt_dscp.man
+++ b/extensions/libxt_dscp.man
@@ -4,7 +4,7 @@ IP header.  DSCP has superseded TOS within the IETF.
 .BI "--dscp " "value"
 Match against a numeric (decimal or hex) value [0-63].
 .TP
-.BI "--dscp-class " "\fIDiffServ Class\fP"
+\fB--dscp-class\fP \fIclass\fP
 Match the DiffServ class. This value may be any of the
 BE, EF, AFxx or CSx classes.  It will then be converted
 into its according numeric value.
diff --git a/extensions/libxt_esp.man b/extensions/libxt_esp.man
index 7898e02..6a7cdea 100644
--- a/extensions/libxt_esp.man
+++ b/extensions/libxt_esp.man
@@ -1,3 +1,3 @@
 This module matches the SPIs in ESP header of IPsec packets.
 .TP
-.BR "--espspi " "[!] \fIspi\fP[:\fIspi\fP]"
+[\fB!\fP] \fB--espspi\fP \fIspi\fP[\fB:\fP\fIspi\fP]
diff --git a/extensions/libxt_mac.man b/extensions/libxt_mac.man
index 5321ca1..aca2c96 100644
--- a/extensions/libxt_mac.man
+++ b/extensions/libxt_mac.man
@@ -1,5 +1,5 @@
 .TP
-.BR "--mac-source " "[!] \fIaddress\fP"
+[\fB!\fP] \fB--mac-source\fP \fIaddress\fP
 Match source MAC address.  It must be of the form XX:XX:XX:XX:XX:XX.
 Note that this only makes sense for packets coming from an Ethernet device
 and entering the
diff --git a/extensions/libxt_multiport.man b/extensions/libxt_multiport.man
index ba760e9..cbd87e7 100644
--- a/extensions/libxt_multiport.man
+++ b/extensions/libxt_multiport.man
@@ -5,16 +5,16 @@ ports.  It can only be used in conjunction with
 or
 .BR "-p udp" .
 .TP
-.BR "--source-ports " "\fI[!] port\fP[,\fIport\fP[,\fIport:port\fP...]]"
+[\fB!\fP] \fB--source-ports\fP,\fB--sport\fP \fIport\fP[\fB,\fP\fIport\fP[\fB,\fP\fIport\fP\fB:\fP\fIport\fP...]]
 Match if the source port is one of the given ports.  The flag
 .B --sports
 is a convenient alias for this option.
 .TP
-.BR "--destination-ports " "\fI[!] port\fP[,\fIport\fP[,\fIport:port\fP...]]"
+[\fB!\fP] \fB--destination-ports\fP,\fB--dport\fP \fIport\fP[\fB,\fP\fIport\fP[\fB,\fP\fIport\fP\fB:\fP\fIport\fP...]]
 Match if the destination port is one of the given ports.  The flag
 .B --dports
 is a convenient alias for this option.
 .TP
-.BR "--ports " "\fI[!] port\fP[,\fIport\fP[,\fIport:port\fP...]]"
+[\fB!\fP] \fB--ports\fP \fIport\fP[\fB,\fP\fIport\fP[\fB,\fP\fIport\fP\fB:\fP\fIport\fP...]]
 Match if either the source or destination ports are equal to one of
 the given ports.
diff --git a/extensions/libxt_physdev.man b/extensions/libxt_physdev.man
index 1e635fc..a00622a 100644
--- a/extensions/libxt_physdev.man
+++ b/extensions/libxt_physdev.man
@@ -3,7 +3,7 @@ to a bridge device. This module is a part of the infrastructure that enables
 a transparent bridging IP firewall and is only useful for kernel versions
 above version 2.5.44.
 .TP
-.BR --physdev-in " [!] \fIname\fP"
+[\fB!\fP] \fB--physdev-in\fP \fIname\fP
 Name of a bridge port via which a packet is received (only for
 packets entering the
 .BR INPUT ,
@@ -14,7 +14,7 @@ chains). If the interface name ends in a "+", then any
 interface which begins with this name will match. If the packet didn't arrive
 through a bridge device, this packet won't match this option, unless '!' is used.
 .TP
-.BR --physdev-out " [!] \fIname\fP"
+[\fB!\fP] \fB--physdev-out\fP \fIname\fP
 Name of a bridge port via which a packet is going to be sent (for packets
 entering the
 .BR FORWARD ,
@@ -31,12 +31,12 @@ chain. If the packet won't leave by a bridge device or it is yet unknown what
 the output device will be, then the packet won't match this option, unless
 '!' is used.
 .TP
-.RB "[!] " --physdev-is-in
+[\fB!\fP] \fB--physdev-is-in\fP
 Matches if the packet has entered through a bridge interface.
 .TP
-.RB "[!] " --physdev-is-out
+[\fB!\fP] \fB--physdev-is-out\fP
 Matches if the packet will leave through a bridge interface.
 .TP
-.RB "[!] " --physdev-is-bridged
+[\fB!\fP] \fB--physdev-is-bridged\fP
 Matches if the packet is being bridged and therefore is not being routed.
 This is only useful in the FORWARD and POSTROUTING chains.
diff --git a/extensions/libxt_pkttype.man b/extensions/libxt_pkttype.man
index b52810b..127d80a 100644
--- a/extensions/libxt_pkttype.man
+++ b/extensions/libxt_pkttype.man
@@ -1,3 +1,3 @@
 This module matches the link-layer packet type.
 .TP
-.BI "--pkt-type " "[\fIunicast\fP|\fIbroadcast\fP|\fImulticast\fP]"
+\fB--pkt-type\fP {\fIunicast\fP|\fIbroadcast\fP|\fImulticast\fP}
diff --git a/extensions/libxt_policy.man b/extensions/libxt_policy.man
index eed163e..0c16273 100644
--- a/extensions/libxt_policy.man
+++ b/extensions/libxt_policy.man
@@ -1,6 +1,6 @@
 This modules matches the policy used by IPsec for handling a packet.
 .TP
-.BI "--dir " "in|out"
+\fB--dir\fP {\fBin\fP|\fBout\fP}
 Used to select whether to match the policy used for decapsulation or the
 policy that will be used for encapsulation.
 .B in
@@ -12,7 +12,7 @@ is valid in the
 .B POSTROUTING, OUTPUT and FORWARD
 chains.
 .TP
-.BI "--pol " "none|ipsec"
+\fB--pol\fP {\fBnone\fP|\fBipsec\fP}
 Matches if the packet is subject to IPsec processing.
 .TP
 .BI "--strict"
@@ -29,20 +29,20 @@ as level.
 .BI "--spi " "spi"
 Matches the SPI of the SA.
 .TP
-.BI "--proto " "ah|esp|ipcomp"
+\fB--proto\fP {\fBah\fP|\fBesp\fP|\fBipcomp\fP}
 Matches the encapsulation protocol.
 .TP
-.BI "--mode " "tunnel|transport"
+\fB--mode\fP {\fBtunnel\fP|\fBtransport\fP}
 Matches the encapsulation mode.
 .TP
-.BI "--tunnel-src " "addr[/mask]"
+\fB--tunnel-src\fP \fIaddr\fP[\fB/\fP\fImask\fP]
 Matches the source end-point address of a tunnel mode SA.
-Only valid with --mode tunnel.
+Only valid with \fB--mode tunnel\fP.
 .TP
-.BI "--tunnel-dst " "addr[/mask]"
+\fB--tunnel-dst\fP \fIaddr\fP[\fB/\fP\fImask\fP]
 Matches the destination end-point address of a tunnel mode SA.
-Only valid with --mode tunnel.
+Only valid with \fB--mode tunnel\fP.
 .TP
 .BI "--next"
 Start the next element in the policy specification. Can only be used with
---strict
+\fB--strict\fP.
diff --git a/extensions/libxt_string.man b/extensions/libxt_string.man
index 3f3e5b7..9e3b25c 100644
--- a/extensions/libxt_string.man
+++ b/extensions/libxt_string.man
@@ -1,6 +1,6 @@
 This modules matches a given string by using some pattern matching strategy. It requires a linux kernel >= 2.6.14.
 .TP
-.BI "--algo  " "bm|kmp"
+\fB--algo\fP {\fBbm\fP|\fBkmp\fP}
 Select the pattern matching strategy. (bm = Boyer-Moore, kmp = Knuth-Pratt-Morris)
 .TP
 .BI "--from " "offset"
diff --git a/extensions/libxt_tcp.man b/extensions/libxt_tcp.man
index cfafc9e..b087fc9 100644
--- a/extensions/libxt_tcp.man
+++ b/extensions/libxt_tcp.man
@@ -1,11 +1,10 @@
 These extensions can be used if `--protocol tcp' is specified. It
 provides the following options:
 .TP
-.BR "--source-port " "[!] \fIport\fP[:\fIport\fP]"
+[\fB!\fP] \fB--source-port\fP,\fB--sport\fP \fIport\fP[\fB:\fP\fIport\fP]
 Source port or port range specification. This can either be a service
 name or a port number. An inclusive range can also be specified,
-using the format
-.IR port : port .
+using the format \fIport\fP\fB:\fP\fIport\fP.
 If the first port is omitted, "0" is assumed; if the last is omitted,
 "65535" is assumed.
 If the second port greater then the first they will be swapped.
@@ -13,15 +12,15 @@ The flag
 .B --sport
 is a convenient alias for this option.
 .TP
-.BR "--destination-port " "[!] \fIport\fP[:\fIport\fP]"
+[\fB!\fP] \fB--destination-port\fP,\fB--dport\fP \fIport\fP[\fB,\fP\fIport\fP]
 Destination port or port range specification.  The flag
 .B --dport
 is a convenient alias for this option.
 .TP
-.BR "--tcp-flags " "[!] \fImask\fP \fIcomp\fP"
-Match when the TCP flags are as specified.  The first argument is the
+[\fB!\fP] \fB--tcp-flags\fP \fImask\fP \fIcomp\fP
+Match when the TCP flags are as specified.  The first argument \fImask\fP is the
 flags which we should examine, written as a comma-separated list, and
-the second argument is a comma-separated list of flags which must be
+the second argument \fIcomp\fP is a comma-separated list of flags which must be
 set.  Flags are:
 .BR "SYN ACK FIN RST URG PSH ALL NONE" .
 Hence the command
@@ -31,7 +30,7 @@ Hence the command
 will only match packets with the SYN flag set, and the ACK, FIN and
 RST flags unset.
 .TP
-.B "[!] --syn"
+[\fB!\fP] \fB--syn\fP
 Only match TCP packets with the SYN bit set and the ACK,RST and FIN bits
 cleared.  Such packets are used to request TCP connection initiation;
 for example, blocking such packets coming in an interface will prevent
@@ -41,5 +40,5 @@ It is equivalent to \fB--tcp-flags SYN,RST,ACK,FIN SYN\fP.
 If the "!" flag precedes the "--syn", the sense of the
 option is inverted.
 .TP
-.BR "--tcp-option " "[!] \fInumber\fP"
+[\fB!\fP] \fB--tcp-option\fP \fInumber\fP
 Match if TCP option set.
diff --git a/extensions/libxt_tcpmss.man b/extensions/libxt_tcpmss.man
index 91fe322..01cdc3a 100644
--- a/extensions/libxt_tcpmss.man
+++ b/extensions/libxt_tcpmss.man
@@ -1,4 +1,4 @@
 This matches the TCP MSS (maximum segment size) field of the TCP header.  You can only use this on TCP SYN or SYN/ACK packets, since the MSS is only negotiated during the TCP handshake at connection startup time.
 .TP
-.BI "[!] "--mss " value[:value]"
+[\fB!\fP] \fB--mss\fP \fIvalue\fP[\fB:\fP\fIvalue\fP]
 Match a given TCP MSS value or range.
diff --git a/extensions/libxt_udp.man b/extensions/libxt_udp.man
index 1d5e590..af0682c 100644
--- a/extensions/libxt_udp.man
+++ b/extensions/libxt_udp.man
@@ -1,13 +1,13 @@
 These extensions can be used if `--protocol udp' is specified.  It
 provides the following options:
 .TP
-.BR "--source-port " "[!] \fIport\fP[:\fIport\fP]"
+[\fB!\fP] \fB--source-port\fP,\fB--sport\fP \fIport\fP[\fB:\fP\fIport\fP]
 Source port or port range specification.
 See the description of the
 .B --source-port
 option of the TCP extension for details.
 .TP
-.BR "--destination-port " "[!] \fIport\fP[:\fIport\fP]"
+[\fB!\fP] \fB--destination-port\fP,\fB--dport\fP \fIport\fP[\fB:\fP\fIport\fP]
 Destination port or port range specification.
 See the description of the
 .B --destination-port
