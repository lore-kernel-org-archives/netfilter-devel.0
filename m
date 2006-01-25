From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH] updates ip6tables man page
Date: Wed, 25 Jan 2006 18:43:05 +0900 (JST)
Message-ID: <200601250943.k0P9h68V018323@toshiba.co.jp>
References: <200601200955.k0K9tSnM001413@toshiba.co.jp>
	<20060120112126.GB4603@sunbeam.de.gnumonks.org>
	<200601201150.k0KBoKuH016706@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Wed_Jan_25_18_43_05_2006_519)--"
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200601201150.k0KBoKuH016706@toshiba.co.jp>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

----Next_Part(Wed_Jan_25_18_43_05_2006_519)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi all,

From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 0/3] cleanups for matches
Date: Fri, 20 Jan 2006 20:50:19 +0900 (JST)

> From: Harald Welte <laforge@netfilter.org>
> Date: Fri, 20 Jan 2006 12:21:26 +0100
> 
> > I wish we had started a list of 'netfilter/iptables semantic changes' in
> > 2000 which we would always keep up to date.  Now there are a number of
> > subtle differences (like this) which almost nobody recalls :(
> 
> Ah, I forgot that. I can check IPv6 related words this weekend, but please
> don't expect good English. ;)

Done. Please correct me if there are wrong changes.

Summary is as follows.

ip6tables:
	- added 'esp' to '-p' and deleted 'ipv6-icmp'. The current ip6tables
	  doesn't handle 'ipv6-icmp' as special representation.
	- added 'raw' table.
	- added sentence about extension headers.

libip6t_multiport:
	- added "range is not supported now." I'll send a patch for
	  {libip6t,xt}_multiport with xt_esp patch and then change this
	  sentence.

libip6t_REJECT:
	- added description about tcp-reset

ilbip6t_ah:
	- added description about --ahlen and --ahres

libip6t_dst, libip6t_hbh, libip6t_eui, libip6t_ipv6header:
	- added more detail explanations

libip6t_icmpv6:
	- added type/code

libip6t_frag:
	- added description about obsoleted option --fraglen.

libip6t_physdev:
	- added '!'. physdev was drastically changed at linux 2.5.69
	  and it had already supported inversion.
	  But I didn't add history because it was the kernel under
	  development.

others:
	- replaced some terms with terms in RFCs.
	- format cleanup

and this patch also includes same changes to libipt_{ah, condition, esp,
fuzzy, length, mark, physdev}.

If there are no objections, I'll commit this.

Regards,

-- Yasuyuki Kozakai


----Next_Part(Wed_Jan_25_18_43_05_2006_519)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="ip6tables-man.patch"

diff --git a/extensions/libip6t_HL.man b/extensions/libip6t_HL.man
index 6b8291d..bf46881 100644
--- a/extensions/libip6t_HL.man
+++ b/extensions/libip6t_HL.man
@@ -1,17 +1,17 @@
-This is used to modify the IPv6 HOPLIMIT header field.  The HOPLIMIT field is 
-similar to what is known as TTL value in IPv4.  Setting or incrementing the
-HOPLIMIT field can potentially be very dangerous, so it should be avoided at
-any cost.  
-.TP
-.B Don't ever set or increment the value on packets that leave your local network!
+This is used to modify the Hop Limit field in IPv6 header. The Hop Limit field
+is similar to what is known as TTL value in IPv4.  Setting or incrementing the
+Hop Limit field can potentially be very dangerous, so it should be avoided at
+any cost. This target is only valid in
 .B mangle
 table.
 .TP
+.B Don't ever set or increment the value on packets that leave your local network!
+.TP
 .BI "--hl-set " "value"
-Set the HOPLIMIT value to `value'.
+Set the Hop Limit to `value'.
 .TP
 .BI "--hl-dec " "value"
-Decrement the HOPLIMIT value `value' times.
+Decrement the Hop Limit `value' times.
 .TP
 .BI "--hl-inc " "value"
-Increment the HOPLIMIT value `value' times.
+Increment the Hop Limit `value' times.
diff --git a/extensions/libip6t_REJECT.man b/extensions/libip6t_REJECT.man
index 75930f1..909d826 100644
--- a/extensions/libip6t_REJECT.man
+++ b/extensions/libip6t_REJECT.man
@@ -23,7 +23,7 @@ The type given can be
 .B " icmp6-port-unreachable"
 .B " port-unreach"
 .fi
-which return the appropriate IPv6-ICMP error message (\fBport-unreach\fP is
+which return the appropriate ICMPv6 error message (\fBport-unreach\fP is
 the default). Finally, the option
 .B tcp-reset
 can be used on rules which only match the TCP protocol: this causes a
@@ -31,4 +31,6 @@ TCP RST packet to be sent back.  This is
 .I ident
 (113/tcp) probes which frequently occur when sending mail to broken mail
 hosts (which won't accept your mail otherwise).
+.B tcp-reset
+can only be used with kernel versions 2.6.14 or latter.
 
diff --git a/extensions/libip6t_ah.man b/extensions/libip6t_ah.man
index 97de1e1..09d00fd 100644
--- a/extensions/libip6t_ah.man
+++ b/extensions/libip6t_ah.man
@@ -1,3 +1,10 @@
-This module matches the SPIs in AH header of IPSec packets.
+This module matches the parameters in Authentication header of IPsec packets.
 .TP
 .BR "--ahspi " "[!] \fIspi\fP[:\fIspi\fP]"
+Matches SPI.
+.TP
+.BR "--ahlen " "[!] \fIlength"
+Total length of this header in octets.
+.TP
+.BI "--ahres"
+Matches if the reserved field is filled with zero.
diff --git a/extensions/libip6t_condition.man b/extensions/libip6t_condition.man
index 30c478c..e0bba75 100644
--- a/extensions/libip6t_condition.man
+++ b/extensions/libip6t_condition.man
@@ -1,4 +1,4 @@
 This matches if a specific /proc filename is '0' or '1'.
 .TP
-.BI "--condition " "[!] filename"
+.BR "--condition " "[!] \fIfilename"
 Match on boolean value stored in /proc/net/ip6t_condition/filename file
diff --git a/extensions/libip6t_dst.man b/extensions/libip6t_dst.man
index 168a10f..f42d822 100644
--- a/extensions/libip6t_dst.man
+++ b/extensions/libip6t_dst.man
@@ -1,7 +1,7 @@
-This module matches the IPv6 destination header options
+This module matches the parameters in Destination Options header
 .TP
-.BI "--dst-len" "[!]" "length"
-Total length of this header
+.BR "--dst-len " "[!] \fIlength"
+Total length of this header in octets.
 .TP
-.BI "--dst-opts " "TYPE[:LEN],[,TYPE[:LEN]...]"
-Options and it's length (List).
+.BR "--dst-opts " "\fItype\fP[:\fIlength\fP][,\fItype\fP[:\fIlength\fP]...]"
+numeric type of option and the length of the option data in octets.
diff --git a/extensions/libip6t_esp.man b/extensions/libip6t_esp.man
index 7b84368..7898e02 100644
--- a/extensions/libip6t_esp.man
+++ b/extensions/libip6t_esp.man
@@ -1,3 +1,3 @@
-This module matches the SPIs in ESP header of IPSec packets.
+This module matches the SPIs in ESP header of IPsec packets.
 .TP
 .BR "--espspi " "[!] \fIspi\fP[:\fIspi\fP]"
diff --git a/extensions/libip6t_eui64.man b/extensions/libip6t_eui64.man
index 24fc56c..d01cb4f 100644
--- a/extensions/libip6t_eui64.man
+++ b/extensions/libip6t_eui64.man
@@ -1 +1,10 @@
-This module matches the EUI64 part of a stateless autoconfigured IPv6 address.  It compares the source MAC address with the lower 64 bits of the IPv6 address. 
+This module matches the EUI-64 part of a stateless autoconfigured IPv6 address.
+It compares the EUI-64 derived from the source MAC address in Ehternet frame
+with the lower 64 bits of the IPv6 source address. But "Universal/Local"
+bit is not compared. This module doesn't match other link layer frame, and
+is only valid in the
+.BR PREROUTING ,
+.BR INPUT
+and
+.BR FORWARD
+chains.
diff --git a/extensions/libip6t_frag.man b/extensions/libip6t_frag.man
index fff3db3..5ac13a4 100644
--- a/extensions/libip6t_frag.man
+++ b/extensions/libip6t_frag.man
@@ -1,19 +1,20 @@
-This module matches the time IPv6 fragmentathion header
+This module matches the parameters in Fragment header.
 .TP
-.BI "--fragid " "[!]" "id[:id]"
-Matches the given fragmentation ID (range).
+.BR "--fragid " "[!] \fIid\fP[:\fIid\fP]"
+Matches the given Identification or range of it.
 .TP
-.BI "--fraglen " "[!]" "length"
-Matches the total length of this header.
+.BR "--fraglen " "[!] \fIlength\fP"
+This option cannot be used with kernel version 2.6.10 or later. The length of
+Fragment header is static and this option doesn't make sense.
 .TP
-.BI "--fragres "
-Matches the reserved field, too.
+.BR "--fragres "
+Matches if the reserved fields are filled with zero.
 .TP
-.BI "--fragfirst "
+.BR "--fragfirst "
 Matches on the first fragment.
 .TP
-.BI "[--fragmore]"
+.BR "[--fragmore]"
 Matches if there are more fragments.
 .TP
-.BI "[--fraglast]"
+.BR "[--fraglast]"
 Matches if this is the last fragement.
diff --git a/extensions/libip6t_fuzzy.man b/extensions/libip6t_fuzzy.man
index 270c8d6..397727a 100644
--- a/extensions/libip6t_fuzzy.man
+++ b/extensions/libip6t_fuzzy.man
@@ -1,6 +1,6 @@
 This module matches a rate limit based on a fuzzy logic controller [FLC]
 .TP
-.BI "--lower-limit  "number"
+.BI "--lower-limit " "number"
 Specifies the lower limit (in packets per second).
 .TP
 .BI "--upper-limit " "number"
diff --git a/extensions/libip6t_hbh.man b/extensions/libip6t_hbh.man
index 8376f91..938e1f3 100644
--- a/extensions/libip6t_hbh.man
+++ b/extensions/libip6t_hbh.man
@@ -1,7 +1,7 @@
-This module matches the IPv6 hop-by-hop header options
+This module matches the parameters in Hop-by-Hop Options header
 .TP
-.BI "--hbh-len" "[!]" "length"
-Total length of this header
+.BR "--hbh-len " "[!] \fIlength\fP"
+Total length of this header in octets.
 .TP
-.BI "--hbh-opts " "TYPE[:LEN],[,TYPE[:LEN]...]"
-Options and it's length (List).
+.BR "--hbh-opts " "\fItype\fP[:\fIlength\fP][,\fItype\fP[:\fIlength\fP]...]"
+numeric type of option and the length of the option data in octets.
diff --git a/extensions/libip6t_hl.man b/extensions/libip6t_hl.man
index 9fcb730..d33e431 100644
--- a/extensions/libip6t_hl.man
+++ b/extensions/libip6t_hl.man
@@ -1,10 +1,10 @@
-This module matches the HOPLIMIT field in the IPv6 header.
+This module matches the Hop Limit field in the IPv6 header.
 .TP
-.BI "--hl-eq " "value"
-Matches if HOPLIMIT equals the given value.
+.BR "--hl-eq " "[!] \fIvalue\fP"
+Matches if Hop Limit equals \fIvalue\fP.
 .TP
-.BI "--hl-lt " "ttl"
-Matches if HOPLIMIT is less than the given value.
+.BI "--hl-lt " "value"
+Matches if Hop Limit is less than \fIvalue\fP.
 .TP
-.BI "--hl-gt " "ttl"
-Matches if HOPLIMIT is greater than the given value.
+.BI "--hl-gt " "value"
+Matches if Hop Limit is greater than \fIvalue\fP.
diff --git a/extensions/libip6t_icmpv6.man b/extensions/libip6t_icmpv6.man
index 2702954..2047180 100644
--- a/extensions/libip6t_icmpv6.man
+++ b/extensions/libip6t_icmpv6.man
@@ -1,9 +1,14 @@
 This extension is loaded if `--protocol ipv6-icmp' or `--protocol icmpv6' is
 specified. It provides the following option:
 .TP
-.BR "--icmpv6-type " "[!] \fItypename\fP"
-This allows specification of the ICMP type, which can be a numeric
-IPv6-ICMP type, or one of the IPv6-ICMP type names shown by the command
+.BR "--icmpv6-type " "[!] \fItype\fP[/\fIcode\fP]|\fItypename\fP"
+This allows specification of the ICMPv6 type, which can be a numeric
+ICMPv6
+.IR type ,
+.IR type
+and
+.IR code ,
+or one of the ICMPv6 type names shown by the command
 .nf
  ip6tables -p ipv6-icmp -h
 .fi
diff --git a/extensions/libip6t_ipv6header.man b/extensions/libip6t_ipv6header.man
index bec3e18..fe3fe98 100644
--- a/extensions/libip6t_ipv6header.man
+++ b/extensions/libip6t_ipv6header.man
@@ -1,10 +1,29 @@
-This module matches on IPv6 option headers
+This module matches IPv6 extension headers and/or upper layer header.
 .TP
-.BI "--header " "[!]" "headers"
-Matches the given type of headers.  
-Names: hop,dst,route,frag,auth,esp,none,proto
-Long Names: hop-by-hop,ipv6-opts,ipv6-route,ipv6-frag,ah,esp,ipv6-nonxt,protocol
-Numbers: 0,60,43,44,51,50,59
+.BR "--header " "[!] \fIheader\fP[,\fIheader\fP...]"
+Matches the packet which EXACTLY includes all specified headers. The headers
+encapsulated with ESP header are out of scope.
+.IR header
+can be
+.IR hop | hop-by-hop
+(Hop-by-Hop Options header),
+.IR dst
+(Destination Options header),
+.IR route
+(Routing header),
+.IR frag
+(Fragment header),
+.IR auth
+(Authentication header),
+.IR esp
+(Encapsulating Security Payload header),
+.IR none
+(No Next header) which matches 59 in the 'Next Header field' of IPv6 header or any IPv6 extension headers, or
+.IR proto
+which matches any upper layer protocol header. A protocol name from /etc/protocols and numeric value also allowed. The number 255 is equivalent to
+.IR proto .
 .TP
-.BI "--soft"
-The header CONTAINS the specified extensions.
+.BR "[--soft]"
+Matches if the packet includes all specified headers with
+.BR --header ,
+AT LEAST.
diff --git a/extensions/libip6t_length.man b/extensions/libip6t_length.man
index 72a6b5d..d781a04 100644
--- a/extensions/libip6t_length.man
+++ b/extensions/libip6t_length.man
@@ -1,4 +1,4 @@
-This module matches the length of a packet against a specific value
-or range of values.
+This module matches the length of the IPv6 payload in octets, or range of it.
+IPv6 header itself isn't counted.
 .TP
-.BR "--length " "\fIlength\fP[:\fIlength\fP]"
+.BR "--length " "[!] \fIlength\fP[:\fIlength\fP]"
diff --git a/extensions/libip6t_mark.man b/extensions/libip6t_mark.man
index 05f8e1e..a2a1395 100644
--- a/extensions/libip6t_mark.man
+++ b/extensions/libip6t_mark.man
@@ -4,6 +4,6 @@ This module matches the netfilter mark f
 target below).
 .TP
 .BR "--mark " "\fIvalue\fP[/\fImask\fP]"
-Matches packets with the given unsigned mark value (if a mask is
-specified, this is logically ANDed with the mask before the
+Matches packets with the given unsigned mark value (if a \fImask\fP is
+specified, this is logically ANDed with the \fImask\fP before the
 comparison).
diff --git a/extensions/libip6t_multiport.man b/extensions/libip6t_multiport.man
index 684f49f..159cc6d 100644
--- a/extensions/libip6t_multiport.man
+++ b/extensions/libip6t_multiport.man
@@ -1,6 +1,7 @@
 This module matches a set of source or destination ports.  Up to 15
 ports can be specified.  A port range (port:port) counts as two
-ports.  It can only be used in conjunction with
+ports, but range isn't supported now. It can only be used in conjunction
+with
 .B "-p tcp"
 or
 .BR "-p udp" .
diff --git a/extensions/libip6t_owner.man b/extensions/libip6t_owner.man
index 99680a6..edd72b1 100644
--- a/extensions/libip6t_owner.man
+++ b/extensions/libip6t_owner.man
@@ -1,7 +1,7 @@
 This module attempts to match various characteristics of the packet
 creator, for locally-generated packets.  It is only valid in the
 .B OUTPUT
-chain, and even this some packets (such as ICMP ping responses) may
+chain, and even this some packets (such as ICMPv6 ping responses) may
 have no owner, and hence never match.  This is regarded as experimental.
 .TP
 .BI "--uid-owner " "userid"
diff --git a/extensions/libip6t_physdev.man b/extensions/libip6t_physdev.man
index 846ec7c..1e635fc 100644
--- a/extensions/libip6t_physdev.man
+++ b/extensions/libip6t_physdev.man
@@ -3,7 +3,7 @@ to a bridge device. This module is a par
 a transparent bridging IP firewall and is only useful for kernel versions
 above version 2.5.44.
 .TP
-.B --physdev-in name
+.BR --physdev-in " [!] \fIname\fP"
 Name of a bridge port via which a packet is received (only for
 packets entering the
 .BR INPUT ,
@@ -14,7 +14,7 @@ chains). If the interface name ends in a
 interface which begins with this name will match. If the packet didn't arrive
 through a bridge device, this packet won't match this option, unless '!' is used.
 .TP
-.B --physdev-out name
+.BR --physdev-out " [!] \fIname\fP"
 Name of a bridge port via which a packet is going to be sent (for packets
 entering the
 .BR FORWARD ,
@@ -31,12 +31,12 @@ chain. If the packet won't leave by a br
 the output device will be, then the packet won't match this option, unless
 '!' is used.
 .TP
-.B --physdev-is-in
+.RB "[!] " --physdev-is-in
 Matches if the packet has entered through a bridge interface.
 .TP
-.B --physdev-is-out
+.RB "[!] " --physdev-is-out
 Matches if the packet will leave through a bridge interface.
 .TP
-.B --physdev-is-bridged
+.RB "[!] " --physdev-is-bridged
 Matches if the packet is being bridged and therefore is not being routed.
 This is only useful in the FORWARD and POSTROUTING chains.
diff --git a/extensions/libip6t_rt.man b/extensions/libip6t_rt.man
index 4347ecd..e56d5f4 100644
--- a/extensions/libip6t_rt.man
+++ b/extensions/libip6t_rt.man
@@ -1,19 +1,19 @@
 Match on IPv6 routing header
 .TP
-.BI "--rt-type " "[!]" "type"
+.BR "--rt-type" " [!] \fItype\fP"
 Match the type (numeric).
 .TP
-.BI "--rt-segsleft" "[!]" "num[:num]"
+.BR "--rt-segsleft" " [!] \fInum\fP[:\fInum\fP]"
 Match the `segments left' field (range).
 .TP
-.BI "--rt-len" "[!]" "length"
-Match the length of this header
+.BR "--rt-len" " [!] \fIlength\fP"
+Match the length of this header.
 .TP
-.BI "--rt-0-res"
+.BR "--rt-0-res"
 Match the reserved field, too (type=0)
 .TP
-.BI "--rt-0-addrs ADDR[,ADDR...]
+.BR "--rt-0-addrs" " \fIADDR\fP[,\fIADDR\fP...]"
 Match type=0 addresses (list).
 .TP
-.BI "--rt-0-not-strict"
+.BR "--rt-0-not-strict"
 List of type=0 addresses is not a strict list.
diff --git a/extensions/libipt_ah.man b/extensions/libipt_ah.man
index 97de1e1..7300c18 100644
--- a/extensions/libipt_ah.man
+++ b/extensions/libipt_ah.man
@@ -1,3 +1,3 @@
-This module matches the SPIs in AH header of IPSec packets.
+This module matches the SPIs in Authentication header of IPsec packets.
 .TP
 .BR "--ahspi " "[!] \fIspi\fP[:\fIspi\fP]"
diff --git a/extensions/libipt_condition.man b/extensions/libipt_condition.man
index 0fc51ff..ce2aa95 100644
--- a/extensions/libipt_condition.man
+++ b/extensions/libipt_condition.man
@@ -1,4 +1,4 @@
 This matches if a specific /proc filename is '0' or '1'.
 .TP
-.BI "--condition " "[!] filename"
+.BI "--condition " "[!] \fIfilename\fP"
 Match on boolean value stored in /proc/net/ipt_condition/filename file
diff --git a/extensions/libipt_esp.man b/extensions/libipt_esp.man
index 7b84368..7898e02 100644
--- a/extensions/libipt_esp.man
+++ b/extensions/libipt_esp.man
@@ -1,3 +1,3 @@
-This module matches the SPIs in ESP header of IPSec packets.
+This module matches the SPIs in ESP header of IPsec packets.
 .TP
 .BR "--espspi " "[!] \fIspi\fP[:\fIspi\fP]"
diff --git a/extensions/libipt_fuzzy.man b/extensions/libipt_fuzzy.man
index 270c8d6..397727a 100644
--- a/extensions/libipt_fuzzy.man
+++ b/extensions/libipt_fuzzy.man
@@ -1,6 +1,6 @@
 This module matches a rate limit based on a fuzzy logic controller [FLC]
 .TP
-.BI "--lower-limit  "number"
+.BI "--lower-limit " "number"
 Specifies the lower limit (in packets per second).
 .TP
 .BI "--upper-limit " "number"
diff --git a/extensions/libipt_length.man b/extensions/libipt_length.man
index 72a6b5d..43bbdcf 100644
--- a/extensions/libipt_length.man
+++ b/extensions/libipt_length.man
@@ -1,4 +1,4 @@
 This module matches the length of a packet against a specific value
 or range of values.
 .TP
-.BR "--length " "\fIlength\fP[:\fIlength\fP]"
+.BR "--length " "[!] \fIlength\fP[:\fIlength\fP]"
diff --git a/extensions/libipt_mark.man b/extensions/libipt_mark.man
index 05f8e1e..a2a1395 100644
--- a/extensions/libipt_mark.man
+++ b/extensions/libipt_mark.man
@@ -4,6 +4,6 @@ This module matches the netfilter mark f
 target below).
 .TP
 .BR "--mark " "\fIvalue\fP[/\fImask\fP]"
-Matches packets with the given unsigned mark value (if a mask is
-specified, this is logically ANDed with the mask before the
+Matches packets with the given unsigned mark value (if a \fImask\fP is
+specified, this is logically ANDed with the \fImask\fP before the
 comparison).
diff --git a/extensions/libipt_physdev.man b/extensions/libipt_physdev.man
index 846ec7c..1e635fc 100644
--- a/extensions/libipt_physdev.man
+++ b/extensions/libipt_physdev.man
@@ -3,7 +3,7 @@ to a bridge device. This module is a par
 a transparent bridging IP firewall and is only useful for kernel versions
 above version 2.5.44.
 .TP
-.B --physdev-in name
+.BR --physdev-in " [!] \fIname\fP"
 Name of a bridge port via which a packet is received (only for
 packets entering the
 .BR INPUT ,
@@ -14,7 +14,7 @@ chains). If the interface name ends in a
 interface which begins with this name will match. If the packet didn't arrive
 through a bridge device, this packet won't match this option, unless '!' is used.
 .TP
-.B --physdev-out name
+.BR --physdev-out " [!] \fIname\fP"
 Name of a bridge port via which a packet is going to be sent (for packets
 entering the
 .BR FORWARD ,
@@ -31,12 +31,12 @@ chain. If the packet won't leave by a br
 the output device will be, then the packet won't match this option, unless
 '!' is used.
 .TP
-.B --physdev-is-in
+.RB "[!] " --physdev-is-in
 Matches if the packet has entered through a bridge interface.
 .TP
-.B --physdev-is-out
+.RB "[!] " --physdev-is-out
 Matches if the packet will leave through a bridge interface.
 .TP
-.B --physdev-is-bridged
+.RB "[!] " --physdev-is-bridged
 Matches if the packet is being bridged and therefore is not being routed.
 This is only useful in the FORWARD and POSTROUTING chains.
diff --git a/ip6tables.8.in b/ip6tables.8.in
index 246c791..bf24d55 100644
--- a/ip6tables.8.in
+++ b/ip6tables.8.in
@@ -1,4 +1,4 @@
-.TH IP6TABLES 8 "Mar 09, 2002" "" ""
+.TH IP6TABLES 8 "Jan 22, 2006" "" ""
 .\"
 .\" Man page written by Andras Kis-Szabo <kisza@sch.bme.hu>
 .\" It is based on iptables man page.
@@ -131,6 +131,16 @@ Since kernel 2.4.18, three other built-i
 (for altering packets being routed through the box), and
 .B POSTROUTING
 (for altering packets as they are about to go out).
+.TP
+.BR "raw" :
+This table is used mainly for configuring exemptions from connection
+tracking in combination with the NOTRACK target.  It registers at the netfilter
+hooks with higher priority and is thus called before nf_conntrack, or any other
+IP6 tables.  It provides the following built-in chains:
+.B PREROUTING
+(for packets arriving via any network interface)
+.B OUTPUT
+(for packets generated by local processes)
 .RE
 .SH OPTIONS
 The options that are recognized by
@@ -231,11 +241,18 @@ The protocol of the rule or of the packe
 The specified protocol can be one of
 .IR tcp ,
 .IR udp ,
-.IR ipv6-icmp|icmpv6 ,
-or
+.IR icmpv6 ,
+.IR esp ,
 .IR all ,
 or it can be a numeric value, representing one of these protocols or a
-different one.  A protocol name from /etc/protocols is also allowed.
+different one. A protocol name from /etc/protocols is also allowed.
+But IPv6 extension headers except
+.IR esp
+are not allowed.
+.IR esp ,
+and
+.IR ipv6-nonext
+can be used with Kernel version 2.6.11 or later.
 A "!" argument before the protocol inverts the
 test.  The number zero is equivalent to
 .IR all .

----Next_Part(Wed_Jan_25_18_43_05_2006_519)----
