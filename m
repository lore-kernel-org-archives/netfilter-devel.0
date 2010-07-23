From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/5] doc: consistent use of markup
Date: Fri, 23 Jul 2010 21:36:23 +0200
Message-ID: <1279913784-12272-6-git-send-email-jengelh@medozas.de>
References: <1279913784-12272-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:56115 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515Ab0GWTgf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Jul 2010 15:36:35 -0400
In-Reply-To: <1279913784-12272-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_CONNMARK.man  |   26 ++++++++++----------
 extensions/libxt_MARK.man      |   20 +++++++-------
 extensions/libxt_TOS.man       |   18 +++++++-------
 extensions/libxt_TPROXY.man    |    2 +-
 extensions/libxt_connlimit.man |    2 +-
 extensions/libxt_connmark.man  |    2 +-
 extensions/libxt_conntrack.man |   52 ++++++++++++++++++++--------------------
 extensions/libxt_hashlimit.man |   12 ++++----
 extensions/libxt_iprange.man   |    4 +-
 extensions/libxt_ipvs.man      |   12 ++++----
 extensions/libxt_recent.man    |   36 ++++++++++++++--------------
 extensions/libxt_set.man       |    2 +-
 extensions/libxt_time.man      |   16 ++++++------
 extensions/libxt_u32.man       |   36 ++++++++++++++--------------
 14 files changed, 120 insertions(+), 120 deletions(-)

diff --git a/extensions/libxt_CONNMARK.man b/extensions/libxt_CONNMARK.man
index 13c6b4b..9317923 100644
--- a/extensions/libxt_CONNMARK.man
+++ b/extensions/libxt_CONNMARK.man
@@ -2,7 +2,7 @@ This module sets the netfilter mark value associated with a connection. The
 mark is 32 bits wide.
 .TP
 \fB\-\-set\-xmark\fP \fIvalue\fP[\fB/\fP\fImask\fP]
-Zero out the bits given by \fImask\fR and XOR \fIvalue\fR into the ctmark.
+Zero out the bits given by \fImask\fP and XOR \fIvalue\fP into the ctmark.
 .TP
 \fB\-\-save\-mark\fP [\fB\-\-nfmask\fP \fInfmask\fP] [\fB\-\-ctmask\fP \fIctmask\fP]
 Copy the packet mark (nfmark) to the connection mark (ctmark) using the given
@@ -10,18 +10,18 @@ masks. The new nfmark value is determined as follows:
 .IP
 ctmark = (ctmark & ~ctmask) ^ (nfmark & nfmask)
 .IP
-i.e. \fIctmask\fR defines what bits to clear and \fInfmask\fR what bits of the
-nfmark to XOR into the ctmark. \fIctmask\fR and \fInfmask\fR default to
+i.e. \fIctmask\fP defines what bits to clear and \fInfmask\fP what bits of the
+nfmark to XOR into the ctmark. \fIctmask\fP and \fInfmask\fP default to
 0xFFFFFFFF.
 .TP
 \fB\-\-restore\-mark\fP [\fB\-\-nfmask\fP \fInfmask\fP] [\fB\-\-ctmask\fP \fIctmask\fP]
 Copy the connection mark (ctmark) to the packet mark (nfmark) using the given
 masks. The new ctmark value is determined as follows:
 .IP
-nfmark = (nfmark & ~\fInfmask\fR) ^ (ctmark & \fIctmask\fR);
+nfmark = (nfmark & ~\fInfmask\fP) ^ (ctmark & \fIctmask\fP);
 .IP
-i.e. \fInfmask\fR defines what bits to clear and \fIctmask\fR what bits of the
-ctmark to XOR into the nfmark. \fIctmask\fR and \fInfmask\fR default to
+i.e. \fInfmask\fP defines what bits to clear and \fIctmask\fP what bits of the
+ctmark to XOR into the nfmark. \fIctmask\fP and \fInfmask\fP default to
 0xFFFFFFFF.
 .IP
 \fB\-\-restore\-mark\fP is only valid in the \fBmangle\fP table.
@@ -29,16 +29,16 @@ ctmark to XOR into the nfmark. \fIctmask\fR and \fInfmask\fR default to
 The following mnemonics are available for \fB\-\-set\-xmark\fP:
 .TP
 \fB\-\-and\-mark\fP \fIbits\fP
-Binary AND the ctmark with \fIbits\fR. (Mnemonic for \fB\-\-set\-xmark
-0/\fR\fIinvbits\fR, where \fIinvbits\fR is the binary negation of \fIbits\fR.)
+Binary AND the ctmark with \fIbits\fP. (Mnemonic for \fB\-\-set\-xmark
+0/\fP\fIinvbits\fP, where \fIinvbits\fP is the binary negation of \fIbits\fP.)
 .TP
 \fB\-\-or\-mark\fP \fIbits\fP
-Binary OR the ctmark with \fIbits\fR. (Mnemonic for \fB\-\-set\-xmark\fP
-\fIbits\fR\fB/\fR\fIbits\fR.)
+Binary OR the ctmark with \fIbits\fP. (Mnemonic for \fB\-\-set\-xmark\fP
+\fIbits\fP\fB/\fP\fIbits\fP.)
 .TP
 \fB\-\-xor\-mark\fP \fIbits\fP
-Binary XOR the ctmark with \fIbits\fR. (Mnemonic for \fB\-\-set\-xmark\fP
-\fIbits\fR\fB/0\fR.)
+Binary XOR the ctmark with \fIbits\fP. (Mnemonic for \fB\-\-set\-xmark\fP
+\fIbits\fP\fB/0\fP.)
 .TP
 \fB\-\-set\-mark\fP \fIvalue\fP[\fB/\fP\fImask\fP]
 Set the connection mark. If a mask is specified then only those bits set in the
@@ -50,4 +50,4 @@ copied.
 .TP
 \fB\-\-restore\-mark\fP [\fB\-\-mask\fP \fImask\fP]
 Copy the ctmark to the nfmark. If a mask is specified, only those bits are
-copied. This is only valid in the \fBmangle\fR table.
+copied. This is only valid in the \fBmangle\fP table.
diff --git a/extensions/libxt_MARK.man b/extensions/libxt_MARK.man
index aaeceb4..712fb76 100644
--- a/extensions/libxt_MARK.man
+++ b/extensions/libxt_MARK.man
@@ -5,23 +5,23 @@ PREROUTING chain of the mangle table to affect routing.
 The mark field is 32 bits wide.
 .TP
 \fB\-\-set\-xmark\fP \fIvalue\fP[\fB/\fP\fImask\fP]
-Zeroes out the bits given by \fImask\fR and XORs \fIvalue\fR into the packet
-mark ("nfmark"). If \fImask\fR is omitted, 0xFFFFFFFF is assumed.
+Zeroes out the bits given by \fImask\fP and XORs \fIvalue\fP into the packet
+mark ("nfmark"). If \fImask\fP is omitted, 0xFFFFFFFF is assumed.
 .TP
 \fB\-\-set\-mark\fP \fIvalue\fP[\fB/\fP\fImask\fP]
-Zeroes out the bits given by \fImask\fR and ORs \fIvalue\fR into the packet
-mark. If \fImask\fR is omitted, 0xFFFFFFFF is assumed.
+Zeroes out the bits given by \fImask\fP and ORs \fIvalue\fP into the packet
+mark. If \fImask\fP is omitted, 0xFFFFFFFF is assumed.
 .PP
 The following mnemonics are available:
 .TP
 \fB\-\-and\-mark\fP \fIbits\fP
-Binary AND the nfmark with \fIbits\fR. (Mnemonic for \fB\-\-set\-xmark
-0/\fR\fIinvbits\fR, where \fIinvbits\fR is the binary negation of \fIbits\fR.)
+Binary AND the nfmark with \fIbits\fP. (Mnemonic for \fB\-\-set\-xmark
+0/\fP\fIinvbits\fP, where \fIinvbits\fP is the binary negation of \fIbits\fP.)
 .TP
 \fB\-\-or\-mark\fP \fIbits\fP
-Binary OR the nfmark with \fIbits\fR. (Mnemonic for \fB\-\-set\-xmark\fP
-\fIbits\fR\fB/\fR\fIbits\fR.)
+Binary OR the nfmark with \fIbits\fP. (Mnemonic for \fB\-\-set\-xmark\fP
+\fIbits\fP\fB/\fP\fIbits\fP.)
 .TP
 \fB\-\-xor\-mark\fP \fIbits\fP
-Binary XOR the nfmark with \fIbits\fR. (Mnemonic for \fB\-\-set\-xmark\fP
-\fIbits\fR\fB/0\fR.)
+Binary XOR the nfmark with \fIbits\fP. (Mnemonic for \fB\-\-set\-xmark\fP
+\fIbits\fP\fB/0\fP.)
diff --git a/extensions/libxt_TOS.man b/extensions/libxt_TOS.man
index d5cbfcb..46f6737 100644
--- a/extensions/libxt_TOS.man
+++ b/extensions/libxt_TOS.man
@@ -1,11 +1,11 @@
 This module sets the Type of Service field in the IPv4 header (including the
 "precedence" bits) or the Priority field in the IPv6 header. Note that TOS
 shares the same bits as DSCP and ECN. The TOS target is only valid in the
-\fBmangle\fR table.
+\fBmangle\fP table.
 .TP
 \fB\-\-set\-tos\fP \fIvalue\fP[\fB/\fP\fImask\fP]
-Zeroes out the bits given by \fImask\fR and XORs \fIvalue\fR into the
-TOS/Priority field. If \fImask\fR is omitted, 0xFF is assumed.
+Zeroes out the bits given by \fImask\fP and XORs \fIvalue\fP into the
+TOS/Priority field. If \fImask\fP is omitted, 0xFF is assumed.
 .TP
 \fB\-\-set\-tos\fP \fIsymbol\fP
 You can specify a symbolic name when using the TOS target for IPv4. It implies
@@ -15,13 +15,13 @@ iptables with \fB\-j TOS \-h\fP.
 The following mnemonics are available:
 .TP
 \fB\-\-and\-tos\fP \fIbits\fP
-Binary AND the TOS value with \fIbits\fR. (Mnemonic for \fB\-\-set\-tos
-0/\fR\fIinvbits\fR, where \fIinvbits\fR is the binary negation of \fIbits\fR.)
+Binary AND the TOS value with \fIbits\fP. (Mnemonic for \fB\-\-set\-tos
+0/\fP\fIinvbits\fP, where \fIinvbits\fP is the binary negation of \fIbits\fP.)
 .TP
 \fB\-\-or\-tos\fP \fIbits\fP
-Binary OR the TOS value with \fIbits\fR. (Mnemonic for \fB\-\-set\-tos\fP
-\fIbits\fR\fB/\fR\fIbits\fR.)
+Binary OR the TOS value with \fIbits\fP. (Mnemonic for \fB\-\-set\-tos\fP
+\fIbits\fP\fB/\fP\fIbits\fP.)
 .TP
 \fB\-\-xor\-tos\fP \fIbits\fP
-Binary XOR the TOS value with \fIbits\fR. (Mnemonic for \fB\-\-set\-tos\fP
-\fIbits\fR\fB/0\fR.)
+Binary XOR the TOS value with \fIbits\fP. (Mnemonic for \fB\-\-set\-tos\fP
+\fIbits\fP\fB/0\fP.)
diff --git a/extensions/libxt_TPROXY.man b/extensions/libxt_TPROXY.man
index 0129f84..2f7d82d 100644
--- a/extensions/libxt_TPROXY.man
+++ b/extensions/libxt_TPROXY.man
@@ -1,4 +1,4 @@
-This target is only valid in the \fBmangle\fR table, in the \fBPREROUTING\fR
+This target is only valid in the \fBmangle\fP table, in the \fBPREROUTING\fP
 chain and user-defined chains which are only called from this chain. It
 redirects the packet to a local socket without changing the packet header in
 any way. It can also change the mark value which can then be used in advanced
diff --git a/extensions/libxt_connlimit.man b/extensions/libxt_connlimit.man
index c85d768..c0246fd 100644
--- a/extensions/libxt_connlimit.man
+++ b/extensions/libxt_connlimit.man
@@ -2,7 +2,7 @@ Allows you to restrict the number of parallel connections to a server per
 client IP address (or client address block).
 .TP
 [\fB!\fP] \fB\-\-connlimit\-above\fP \fIn\fP
-Match if the number of existing connections is (not) above \fIn\fR.
+Match if the number of existing connections is (not) above \fIn\fP.
 .TP
 \fB\-\-connlimit\-mask\fP \fIprefix_length\fP
 Group hosts using the prefix length. For IPv4, this must be a number between
diff --git a/extensions/libxt_connmark.man b/extensions/libxt_connmark.man
index ee87d9e..4e83801 100644
--- a/extensions/libxt_connmark.man
+++ b/extensions/libxt_connmark.man
@@ -1,5 +1,5 @@
 This module matches the netfilter mark field associated with a connection
-(which can be set using the \fBCONNMARK\fR target below).
+(which can be set using the \fBCONNMARK\fP target below).
 .TP
 [\fB!\fP] \fB\-\-mark\fP \fIvalue\fP[\fB/\fP\fImask\fP]
 Matches packets in connections with the given mark value (if a mask is
diff --git a/extensions/libxt_conntrack.man b/extensions/libxt_conntrack.man
index ec51ef5..d37ed17 100644
--- a/extensions/libxt_conntrack.man
+++ b/extensions/libxt_conntrack.man
@@ -1,36 +1,36 @@
 This module, when combined with connection tracking, allows access to the
 connection tracking state for this packet/connection.
 .TP
-[\fB!\fR] \fB\-\-ctstate\fP \fIstatelist\fP
-\fIstatelist\fR is a comma separated list of the connection states to match.
+[\fB!\fP] \fB\-\-ctstate\fP \fIstatelist\fP
+\fIstatelist\fP is a comma separated list of the connection states to match.
 Possible states are listed below.
 .TP
-[\fB!\fR] \fB\-\-ctproto\fP \fIl4proto\fP
+[\fB!\fP] \fB\-\-ctproto\fP \fIl4proto\fP
 Layer-4 protocol to match (by number or name)
 .TP
-[\fB!\fR] \fB\-\-ctorigsrc\fP \fIaddress\fP[\fB/\fP\fImask\fP]
+[\fB!\fP] \fB\-\-ctorigsrc\fP \fIaddress\fP[\fB/\fP\fImask\fP]
 .TP
-[\fB!\fR] \fB\-\-ctorigdst\fP \fIaddress\fP[\fB/\fP\fImask\fP]
+[\fB!\fP] \fB\-\-ctorigdst\fP \fIaddress\fP[\fB/\fP\fImask\fP]
 .TP
-[\fB!\fR] \fB\-\-ctreplsrc\fP \fIaddress\fP[\fB/\fP\fImask\fP]
+[\fB!\fP] \fB\-\-ctreplsrc\fP \fIaddress\fP[\fB/\fP\fImask\fP]
 .TP
-[\fB!\fR] \fB\-\-ctrepldst\fP \fIaddress\fP[\fB/\fP\fImask\fP]
+[\fB!\fP] \fB\-\-ctrepldst\fP \fIaddress\fP[\fB/\fP\fImask\fP]
 Match against original/reply source/destination address
 .TP
-[\fB!\fR] \fB\-\-ctorigsrcport\fP \fIport\fP
+[\fB!\fP] \fB\-\-ctorigsrcport\fP \fIport\fP
 .TP
-[\fB!\fR] \fB\-\-ctorigdstport\fP \fIport\fP
+[\fB!\fP] \fB\-\-ctorigdstport\fP \fIport\fP
 .TP
-[\fB!\fR] \fB\-\-ctreplsrcport\fP \fIport\fP
+[\fB!\fP] \fB\-\-ctreplsrcport\fP \fIport\fP
 .TP
-[\fB!\fR] \fB\-\-ctrepldstport\fP \fIport\fP
+[\fB!\fP] \fB\-\-ctrepldstport\fP \fIport\fP
 Match against original/reply source/destination port (TCP/UDP/etc.) or GRE key.
 .TP
-[\fB!\fR] \fB\-\-ctstatus\fP \fIstatelist\fP
-\fIstatuslist\fR is a comma separated list of the connection statuses to match.
+[\fB!\fP] \fB\-\-ctstatus\fP \fIstatelist\fP
+\fIstatuslist\fP is a comma separated list of the connection statuses to match.
 Possible statuses are listed below.
 .TP
-[\fB!\fR] \fB\-\-ctexpire\fP \fItime\fP[\fB:\fP\fItime\fP]
+[\fB!\fP] \fB\-\-ctexpire\fP \fItime\fP[\fB:\fP\fItime\fP]
 Match remaining lifetime in seconds against given value or range of values
 (inclusive)
 .TP
@@ -40,46 +40,46 @@ specified at all, matches packets in both directions.
 .PP
 States for \fB\-\-ctstate\fP:
 .TP
-\fBINVALID\fR
+\fBINVALID\fP
 meaning that the packet is associated with no known connection
 .TP
-\fBNEW\fR
+\fBNEW\fP
 meaning that the packet has started a new connection, or otherwise associated
 with a connection which has not seen packets in both directions, and
 .TP
-\fBESTABLISHED\fR
+\fBESTABLISHED\fP
 meaning that the packet is associated with a connection which has seen packets
 in both directions,
 .TP
-\fBRELATED\fR
+\fBRELATED\fP
 meaning that the packet is starting a new connection, but is associated with an
 existing connection, such as an FTP data transfer, or an ICMP error.
 .TP
-\fBUNTRACKED\fR
+\fBUNTRACKED\fP
 meaning that the packet is not tracked at all, which happens if you use
 the NOTRACK target in raw table.
 .TP
-\fBSNAT\fR
+\fBSNAT\fP
 A virtual state, matching if the original source address differs from the reply
 destination.
 .TP
-\fBDNAT\fR
+\fBDNAT\fP
 A virtual state, matching if the original destination differs from the reply
 source.
 .PP
 Statuses for \fB\-\-ctstatus\fP:
 .TP
-\fBNONE\fR
+\fBNONE\fP
 None of the below.
 .TP
-\fBEXPECTED\fR
+\fBEXPECTED\fP
 This is an expected connection (i.e. a conntrack helper set it up)
 .TP
-\fBSEEN_REPLY\fR
+\fBSEEN_REPLY\fP
 Conntrack has seen packets in both directions.
 .TP
-\fBASSURED\fR
+\fBASSURED\fP
 Conntrack entry should never be early-expired.
 .TP
-\fBCONFIRMED\fR
+\fBCONFIRMED\fP
 Connection is confirmed: originating packet has left box.
diff --git a/extensions/libxt_hashlimit.man b/extensions/libxt_hashlimit.man
index b870f55..e91d0c6 100644
--- a/extensions/libxt_hashlimit.man
+++ b/extensions/libxt_hashlimit.man
@@ -1,7 +1,7 @@
-\fBhashlimit\fR uses hash buckets to express a rate limiting match (like the
-\fBlimit\fR match) for a group of connections using a \fBsingle\fR iptables
+\fBhashlimit\fP uses hash buckets to express a rate limiting match (like the
+\fBlimit\fP match) for a group of connections using a \fBsingle\fP iptables
 rule. Grouping can be done per-hostgroup (source and/or destination address)
-and/or per-port. It gives you the ability to express "\fIN\fR packets per time
+and/or per-port. It gives you the ability to express "\fIN\fP packets per time
 quantum per group":
 .TP
 matching on source host
@@ -17,11 +17,11 @@ A hash limit option (\fB\-\-hashlimit\-upto\fP, \fB\-\-hashlimit\-above\fP) and
 \fB\-\-hashlimit\-name\fP are required.
 .TP
 \fB\-\-hashlimit\-upto\fP \fIamount\fP[\fB/second\fP|\fB/minute\fP|\fB/hour\fP|\fB/day\fP]
-Match if the rate is below or equal to \fIamount\fR/quantum. It is specified as
+Match if the rate is below or equal to \fIamount\fP/quantum. It is specified as
 a number, with an optional time quantum suffix; the default is 3/hour.
 .TP
 \fB\-\-hashlimit\-above\fP \fIamount\fP[\fB/second\fP|\fB/minute\fP|\fB/hour\fP|\fB/day\fP]
-Match if the rate is above \fIamount\fR/quantum.
+Match if the rate is above \fIamount\fP/quantum.
 .TP
 \fB\-\-hashlimit\-burst\fP \fIamount\fP
 Maximum initial number of packets to match: this number gets recharged by one
@@ -36,7 +36,7 @@ expensive of doing the hash housekeeping.
 \fB\-\-hashlimit\-srcmask\fP \fIprefix\fP
 When \-\-hashlimit\-mode srcip is used, all source addresses encountered will be
 grouped according to the given prefix length and the so-created subnet will be
-subject to hashlimit. \fIprefix\fR must be between (inclusive) 0 and 32. Note
+subject to hashlimit. \fIprefix\fP must be between (inclusive) 0 and 32. Note
 that \-\-hashlimit\-srcmask 0 is basically doing the same thing as not specifying
 srcip for \-\-hashlimit\-mode, but is technically more expensive.
 .TP
diff --git a/extensions/libxt_iprange.man b/extensions/libxt_iprange.man
index 9f65de4..9bbaac3 100644
--- a/extensions/libxt_iprange.man
+++ b/extensions/libxt_iprange.man
@@ -1,7 +1,7 @@
 This matches on a given arbitrary range of IP addresses.
 .TP
-[\fB!\fR] \fB\-\-src\-range\fP \fIfrom\fP[\fB\-\fP\fIto\fP]
+[\fB!\fP] \fB\-\-src\-range\fP \fIfrom\fP[\fB\-\fP\fIto\fP]
 Match source IP in the specified range.
 .TP
-[\fB!\fR] \fB\-\-dst\-range\fP \fIfrom\fP[\fB\-\fP\fIto\fP]
+[\fB!\fP] \fB\-\-dst\-range\fP \fIfrom\fP[\fB\-\fP\fIto\fP]
 Match destination IP in the specified range.
diff --git a/extensions/libxt_ipvs.man b/extensions/libxt_ipvs.man
index 8968e1a..db9bc66 100644
--- a/extensions/libxt_ipvs.man
+++ b/extensions/libxt_ipvs.man
@@ -1,24 +1,24 @@
 Match IPVS connection properties.
 .TP
-[\fB!\fR] \fB\-\-ipvs\fP
+[\fB!\fP] \fB\-\-ipvs\fP
 packet belongs to an IPVS connection
 .TP
 Any of the following options implies \-\-ipvs (even negated)
 .TP
-[\fB!\fR] \fB\-\-vproto\fP \fIprotocol\fP
+[\fB!\fP] \fB\-\-vproto\fP \fIprotocol\fP
 VIP protocol to match; by number or name, e.g. "tcp"
 .TP
-[\fB!\fR] \fB\-\-vaddr\fP \fIaddress\fP[\fB/\fP\fImask\fP]
+[\fB!\fP] \fB\-\-vaddr\fP \fIaddress\fP[\fB/\fP\fImask\fP]
 VIP address to match
 .TP
-[\fB!\fR] \fB\-\-vport\fP \fIport\fP
+[\fB!\fP] \fB\-\-vport\fP \fIport\fP
 VIP port to match; by number or name, e.g. "http"
 .TP
 \fB\-\-vdir\fP {\fBORIGINAL\fP|\fBREPLY\fP}
 flow direction of packet
 .TP
-[\fB!\fR] \fB\-\-vmethod\fP {\fBGATE\fP|\fBIPIP\fP|\fBMASQ\fP}
+[\fB!\fP] \fB\-\-vmethod\fP {\fBGATE\fP|\fBIPIP\fP|\fBMASQ\fP}
 IPVS forwarding method used
 .TP
-[\fB!\fR] \fB\-\-vportctl\fP \fIport\fP
+[\fB!\fP] \fB\-\-vportctl\fP \fIport\fP
 VIP port of the controlling connection to match, e.g. 21 for FTP
diff --git a/extensions/libxt_recent.man b/extensions/libxt_recent.man
index 532c328..0392c2c 100644
--- a/extensions/libxt_recent.man
+++ b/extensions/libxt_recent.man
@@ -10,12 +10,12 @@ mutually exclusive.
 .TP
 \fB\-\-name\fP \fIname\fP
 Specify the list to use for the commands. If no name is given then
-\fBDEFAULT\fR will be used.
+\fBDEFAULT\fP will be used.
 .TP
-[\fB!\fR] \fB\-\-set\fP
+[\fB!\fP] \fB\-\-set\fP
 This will add the source address of the packet to the list. If the source
 address is already in the list, this will update the existing entry. This will
-always return success (or failure if \fB!\fR is passed in).
+always return success (or failure if \fB!\fP is passed in).
 .TP
 \fB\-\-rsource\fP
 Match/save the source address of each packet in the recent list table. This
@@ -24,14 +24,14 @@ is the default.
 \fB\-\-rdest\fP
 Match/save the destination address of each packet in the recent list table.
 .TP
-[\fB!\fR] \fB\-\-rcheck\fP
+[\fB!\fP] \fB\-\-rcheck\fP
 Check if the source address of the packet is currently in the list.
 .TP
-[\fB!\fR] \fB\-\-update\fP
+[\fB!\fP] \fB\-\-update\fP
 Like \fB\-\-rcheck\fP, except it will update the "last seen" timestamp if it
 matches.
 .TP
-[\fB!\fR] \fB\-\-remove\fP
+[\fB!\fP] \fB\-\-remove\fP
 Check if the source address of the packet is currently in the list and if so
 that address will be removed from the list and the rule will return true. If
 the address is not found, false is returned.
@@ -68,37 +68,37 @@ iptables \-A FORWARD \-p tcp \-i eth0 \-\-dport 139 \-m recent \-\-name badguy \
 Steve's ipt_recent website (http://snowman.net/projects/ipt_recent/) also has
 some examples of usage.
 .PP
-\fB/proc/net/xt_recent/*\fR are the current lists of addresses and information
+\fB/proc/net/xt_recent/*\fP are the current lists of addresses and information
 about each entry of each list.
 .PP
-Each file in \fB/proc/net/xt_recent/\fR can be read from to see the current
+Each file in \fB/proc/net/xt_recent/\fP can be read from to see the current
 list or written two using the following commands to modify the list:
 .TP
-\fBecho +\fR\fIaddr\fR\fB >/proc/net/xt_recent/DEFAULT\fR
-to add \fIaddr\fR to the DEFAULT list
+\fBecho +\fP\fIaddr\fP\fB >/proc/net/xt_recent/DEFAULT\fP
+to add \fIaddr\fP to the DEFAULT list
 .TP
 \fBecho \-\fP\fIaddr\fP\fB >/proc/net/xt_recent/DEFAULT\fP
-to remove \fIaddr\fR from the DEFAULT list
+to remove \fIaddr\fP from the DEFAULT list
 .TP
-\fBecho / >/proc/net/xt_recent/DEFAULT\fR
+\fBecho / >/proc/net/xt_recent/DEFAULT\fP
 to flush the DEFAULT list (remove all entries).
 .PP
 The module itself accepts parameters, defaults shown:
 .TP
-\fBip_list_tot\fR=\fI100\fR
+\fBip_list_tot\fP=\fI100\fP
 Number of addresses remembered per table.
 .TP
-\fBip_pkt_list_tot\fR=\fI20\fR
+\fBip_pkt_list_tot\fP=\fI20\fP
 Number of packets per address remembered.
 .TP
-\fBip_list_hash_size\fR=\fI0\fR
+\fBip_list_hash_size\fP=\fI0\fP
 Hash table size. 0 means to calculate it based on ip_list_tot, default: 512.
 .TP
-\fBip_list_perms\fR=\fI0644\fR
+\fBip_list_perms\fP=\fI0644\fP
 Permissions for /proc/net/xt_recent/* files.
 .TP
-\fBip_list_uid\fR=\fI0\fR
+\fBip_list_uid\fP=\fI0\fP
 Numerical UID for ownership of /proc/net/xt_recent/* files.
 .TP
-\fBip_list_gid\fR=\fI0\fR
+\fBip_list_gid\fP=\fI0\fP
 Numerical GID for ownership of /proc/net/xt_recent/* files.
diff --git a/extensions/libxt_set.man b/extensions/libxt_set.man
index aca1bfc..01b115f 100644
--- a/extensions/libxt_set.man
+++ b/extensions/libxt_set.man
@@ -15,7 +15,7 @@ the set type of the specified set is single dimension (for example ipmap),
 then the command will match packets for which the source address can be
 found in the specified set. 
 .PP
-The option \fB\-\-match\-set\fR can be replaced by \fB\-\-set\fR if that does 
+The option \fB\-\-match\-set\fP can be replaced by \fB\-\-set\fP if that does 
 not clash with an option of other extensions.
 .PP
 Use of -m set requires that ipset kernel support is provided. As standard
diff --git a/extensions/libxt_time.man b/extensions/libxt_time.man
index 83625a2..2bceaf6 100644
--- a/extensions/libxt_time.man
+++ b/extensions/libxt_time.man
@@ -19,19 +19,19 @@ Only match during the given daytime. The possible time range is 00:00:00 to
 23:59:59. Leading zeroes are allowed (e.g. "06:03") and correctly interpreted
 as base-10.
 .TP
-[\fB!\fR] \fB\-\-monthdays\fP \fIday\fP[\fB,\fP\fIday\fP...]
+[\fB!\fP] \fB\-\-monthdays\fP \fIday\fP[\fB,\fP\fIday\fP...]
 .IP
-Only match on the given days of the month. Possible values are \fB1\fR
-to \fB31\fR. Note that specifying \fB31\fR will of course not match
+Only match on the given days of the month. Possible values are \fB1\fP
+to \fB31\fP. Note that specifying \fB31\fP will of course not match
 on months which do not have a 31st day; the same goes for 28- or 29-day
 February.
 .TP
-[\fB!\fR] \fB\-\-weekdays\fP \fIday\fP[\fB,\fP\fIday\fP...]
+[\fB!\fP] \fB\-\-weekdays\fP \fIday\fP[\fB,\fP\fIday\fP...]
 .IP
-Only match on the given weekdays. Possible values are \fBMon\fR, \fBTue\fR,
-\fBWed\fR, \fBThu\fR, \fBFri\fR, \fBSat\fR, \fBSun\fR, or values from \fB1\fR
-to \fB7\fR, respectively. You may also use two-character variants (\fBMo\fP,
-\fBTu\fR, etc.).
+Only match on the given weekdays. Possible values are \fBMon\fP, \fBTue\fP,
+\fBWed\fP, \fBThu\fP, \fBFri\fP, \fBSat\fP, \fBSun\fP, or values from \fB1\fP
+to \fB7\fP, respectively. You may also use two-character variants (\fBMo\fP,
+\fBTu\fP, etc.).
 .TP
 \fB\-\-utc\fP
 .IP
diff --git a/extensions/libxt_u32.man b/extensions/libxt_u32.man
index 2ffab30..7c8615d 100644
--- a/extensions/libxt_u32.man
+++ b/extensions/libxt_u32.man
@@ -11,22 +11,22 @@ value := range | value "," range
 .IP
 range := number | number ":" number
 .PP
-a single number, \fIn\fR, is interpreted the same as \fIn:n\fR. \fIn:m\fR is
-interpreted as the range of numbers \fB>=n\fR and \fB<=m\fR.
+a single number, \fIn\fP, is interpreted the same as \fIn:n\fP. \fIn:m\fP is
+interpreted as the range of numbers \fB>=n\fP and \fB<=m\fP.
 .IP "" 4
 location := number | location operator number
 .IP "" 4
 operator := "&" | "<<" | ">>" | "@"
 .PP
-The operators \fB&\fR, \fB<<\fR, \fB>>\fR and \fB&&\fR mean the same as in C.
-The \fB=\fR is really a set membership operator and the value syntax describes
-a set. The \fB@\fR operator is what allows moving to the next header and is
+The operators \fB&\fP, \fB<<\fP, \fB>>\fP and \fB&&\fP mean the same as in C.
+The \fB=\fP is really a set membership operator and the value syntax describes
+a set. The \fB@\fP operator is what allows moving to the next header and is
 described further below.
 .PP
 There are currently some artificial implementation limits on the size of the
 tests:
 .IP "    *"
-no more than 10 of "\fB=\fR" (and 9 "\fB&&\fR"s) in the u32 argument
+no more than 10 of "\fB=\fP" (and 9 "\fB&&\fP"s) in the u32 argument
 .IP "    *"
 no more than 10 ranges (and 9 commas) per value
 .IP "    *"
@@ -35,7 +35,7 @@ no more than 10 numbers (and 9 operators) per location
 To describe the meaning of location, imagine the following machine that
 interprets it. There are three registers:
 .IP
-A is of type \fBchar *\fR, initially the address of the IP header
+A is of type \fBchar *\fP, initially the address of the IP header
 .IP
 B and C are unsigned 32 bit integers, initially zero
 .PP
@@ -81,28 +81,28 @@ First test that it is an ICMP packet, true iff byte 9 (protocol) = 1
 .IP
 \-\-u32 "\fB6 & 0xFF = 1 &&\fP ...
 .IP
-read bytes 6-9, use \fB&\fR to throw away bytes 6-8 and compare the result to
+read bytes 6-9, use \fB&\fP to throw away bytes 6-8 and compare the result to
 1. Next test that it is not a fragment. (If so, it might be part of such a
 packet but we cannot always tell.) N.B.: This test is generally needed if you
 want to match anything beyond the IP header. The last 6 bits of byte 6 and all
 of byte 7 are 0 iff this is a complete packet (not a fragment). Alternatively,
 you can allow first fragments by only testing the last 5 bits of byte 6.
 .IP
- ... \fB4 & 0x3FFF = 0 &&\fR ...
+ ... \fB4 & 0x3FFF = 0 &&\fP ...
 .IP
 Last test: the first byte past the IP header (the type) is 0. This is where we
 have to use the @syntax. The length of the IP header (IHL) in 32 bit words is
 stored in the right half of byte 0 of the IP header itself.
 .IP
- ... \fB0 >> 22 & 0x3C @ 0 >> 24 = 0\fR"
+ ... \fB0 >> 22 & 0x3C @ 0 >> 24 = 0\fP"
 .IP
-The first 0 means read bytes 0-3, \fB>>22\fR means shift that 22 bits to the
+The first 0 means read bytes 0-3, \fB>>22\fP means shift that 22 bits to the
 right. Shifting 24 bits would give the first byte, so only 22 bits is four
-times that plus a few more bits. \fB&3C\fR then eliminates the two extra bits
+times that plus a few more bits. \fB&3C\fP then eliminates the two extra bits
 on the right and the first four bits of the first byte. For instance, if IHL=5,
 then the IP header is 20 (4 x 5) bytes long. In this case, bytes 0-1 are (in
-binary) xxxx0101 yyzzzzzz, \fB>>22\fR gives the 10 bit value xxxx0101yy and
-\fB&3C\fR gives 010100. \fB@\fR means to use this number as a new offset into
+binary) xxxx0101 yyzzzzzz, \fB>>22\fP gives the 10 bit value xxxx0101yy and
+\fB&3C\fP gives 010100. \fB@\fP means to use this number as a new offset into
 the packet, and read four bytes starting from there. This is the first 4 bytes
 of the ICMP payload, of which byte 0 is the ICMP type. Therefore, we simply
 shift the value 24 to the right to throw out all but the first byte and compare
@@ -118,12 +118,12 @@ First we test that the packet is a tcp packet (similar to ICMP).
 .IP
 Next, test that it is not a fragment (same as above).
 .IP
- ... \fB0 >> 22 & 0x3C @ 12 >> 26 & 0x3C @ 8 = 1,2,5,8\fR"
+ ... \fB0 >> 22 & 0x3C @ 12 >> 26 & 0x3C @ 8 = 1,2,5,8\fP"
 .IP
-\fB0>>22&3C\fR as above computes the number of bytes in the IP header. \fB@\fR
+\fB0>>22&3C\fP as above computes the number of bytes in the IP header. \fB@\fP
 makes this the new offset into the packet, which is the start of the TCP
 header. The length of the TCP header (again in 32 bit words) is the left half
-of byte 12 of the TCP header. The \fB12>>26&3C\fR computes this length in bytes
+of byte 12 of the TCP header. The \fB12>>26&3C\fP computes this length in bytes
 (similar to the IP header before). "@" makes this the new offset, which is the
 start of the TCP payload. Finally, 8 reads bytes 8-12 of the payload and
-\fB=\fR checks whether the result is any of 1, 2, 5 or 8.
+\fB=\fP checks whether the result is any of 1, 2, 5 or 8.
-- 
1.7.1

