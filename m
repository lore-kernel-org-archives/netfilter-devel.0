Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EBA9C25B6B
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Oct 2023 08:55:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjJZIzO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Oct 2023 04:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344709AbjJZIzL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Oct 2023 04:55:11 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C9E1A1
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Oct 2023 01:55:08 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 65534)
        id DDC4058726697; Thu, 26 Oct 2023 10:55:06 +0200 (CEST)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id 54C7358726686;
        Thu, 26 Oct 2023 10:55:06 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH 01/10] man: display number ranges with an en dash
Date:   Thu, 26 Oct 2023 10:54:57 +0200
Message-ID: <20231026085506.94343-1-jengelh@inai.de>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

For ranges, en dashes should be used; cf. e.g.
https://en.wikipedia.org/wiki/Dash#En_dash .

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/libipt_ULOG.man |  2 +-
 extensions/libxt_NFLOG.man |  2 +-
 extensions/libxt_dscp.man  |  2 +-
 extensions/libxt_u32.man   | 16 ++++++++--------
 iptables/ebtables-nft.8    | 22 +++++++++++-----------
 5 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/extensions/libipt_ULOG.man b/extensions/libipt_ULOG.man
index c91f7764..c828b45e 100644
--- a/extensions/libipt_ULOG.man
+++ b/extensions/libipt_ULOG.man
@@ -9,7 +9,7 @@ Like LOG, this is a "non-terminating target", i.e. rule traversal
 continues at the next rule.
 .TP
 \fB\-\-ulog\-nlgroup\fP \fInlgroup\fP
-This specifies the netlink group (1-32) to which the packet is sent.
+This specifies the netlink group (1\(en32) to which the packet is sent.
 Default value is 1.
 .TP
 \fB\-\-ulog\-prefix\fP \fIprefix\fP
diff --git a/extensions/libxt_NFLOG.man b/extensions/libxt_NFLOG.man
index 318e6305..093704a1 100644
--- a/extensions/libxt_NFLOG.man
+++ b/extensions/libxt_NFLOG.man
@@ -9,7 +9,7 @@ may subscribe to the group to receive the packets. Like LOG, this is a
 non-terminating target, i.e. rule traversal continues at the next rule.
 .TP
 \fB\-\-nflog\-group\fP \fInlgroup\fP
-The netlink group (0 - 2^16\-1) to which packets are (only applicable for
+The netlink group (0\(en2^16\-1) to which packets are (only applicable for
 nfnetlink_log). The default value is 0.
 .TP
 \fB\-\-nflog\-prefix\fP \fIprefix\fP
diff --git a/extensions/libxt_dscp.man b/extensions/libxt_dscp.man
index 63a17dac..ff4523fd 100644
--- a/extensions/libxt_dscp.man
+++ b/extensions/libxt_dscp.man
@@ -2,7 +2,7 @@ This module matches the 6 bit DSCP field within the TOS field in the
 IP header.  DSCP has superseded TOS within the IETF.
 .TP
 [\fB!\fP] \fB\-\-dscp\fP \fIvalue\fP
-Match against a numeric (decimal or hex) value [0-63].
+Match against a numeric (decimal or hex) value in the range 0\(en63.
 .TP
 [\fB!\fP] \fB\-\-dscp\-class\fP \fIclass\fP
 Match the DiffServ class. This value may be any of the
diff --git a/extensions/libxt_u32.man b/extensions/libxt_u32.man
index 40a69f8e..183a63f7 100644
--- a/extensions/libxt_u32.man
+++ b/extensions/libxt_u32.man
@@ -69,13 +69,13 @@ Example:
 .IP
 match IP packets with total length >= 256
 .IP
-The IP header contains a total length field in bytes 2-3.
+The IP header contains a total length field in bytes 2\(en3.
 .IP
 \-\-u32 "\fB0 & 0xFFFF = 0x100:0xFFFF\fP"
 .IP
-read bytes 0-3
+read bytes 0\(en3
 .IP
-AND that with 0xFFFF (giving bytes 2-3), and test whether that is in the range
+AND that with 0xFFFF (giving bytes 2\(en3), and test whether that is in the range
 [0x100:0xFFFF]
 .PP
 Example: (more realistic, hence more complicated)
@@ -86,7 +86,7 @@ First test that it is an ICMP packet, true iff byte 9 (protocol) = 1
 .IP
 \-\-u32 "\fB6 & 0xFF = 1 &&\fP ...
 .IP
-read bytes 6-9, use \fB&\fP to throw away bytes 6-8 and compare the result to
+read bytes 6\(en9, use \fB&\fP to throw away bytes 6\(en8 and compare the result to
 1. Next test that it is not a fragment. (If so, it might be part of such a
 packet but we cannot always tell.) N.B.: This test is generally needed if you
 want to match anything beyond the IP header. The last 6 bits of byte 6 and all
@@ -101,11 +101,11 @@ stored in the right half of byte 0 of the IP header itself.
 .IP
  ... \fB0 >> 22 & 0x3C @ 0 >> 24 = 0\fP"
 .IP
-The first 0 means read bytes 0-3, \fB>>22\fP means shift that 22 bits to the
+The first 0 means read bytes 0\(en3, \fB>>22\fP means shift that 22 bits to the
 right. Shifting 24 bits would give the first byte, so only 22 bits is four
 times that plus a few more bits. \fB&3C\fP then eliminates the two extra bits
 on the right and the first four bits of the first byte. For instance, if IHL=5,
-then the IP header is 20 (4 x 5) bytes long. In this case, bytes 0-1 are (in
+then the IP header is 20 (4 x 5) bytes long. In this case, bytes 0\(en1 are (in
 binary) xxxx0101 yyzzzzzz, \fB>>22\fP gives the 10 bit value xxxx0101yy and
 \fB&3C\fP gives 010100. \fB@\fP means to use this number as a new offset into
 the packet, and read four bytes starting from there. This is the first 4 bytes
@@ -115,7 +115,7 @@ the result with 0.
 .PP
 Example:
 .IP
-TCP payload bytes 8-12 is any of 1, 2, 5 or 8
+TCP payload bytes 8\(en12 is any of 1, 2, 5 or 8
 .IP
 First we test that the packet is a tcp packet (similar to ICMP).
 .IP
@@ -130,5 +130,5 @@ makes this the new offset into the packet, which is the start of the TCP
 header. The length of the TCP header (again in 32 bit words) is the left half
 of byte 12 of the TCP header. The \fB12>>26&3C\fP computes this length in bytes
 (similar to the IP header before). "@" makes this the new offset, which is the
-start of the TCP payload. Finally, 8 reads bytes 8-12 of the payload and
+start of the TCP payload. Finally, 8 reads bytes 8\(en12 of the payload and
 \fB=\fP checks whether the result is any of 1, 2, 5 or 8.
diff --git a/iptables/ebtables-nft.8 b/iptables/ebtables-nft.8
index 0304b508..eaeb6d29 100644
--- a/iptables/ebtables-nft.8
+++ b/iptables/ebtables-nft.8
@@ -722,46 +722,46 @@ for that option is used, while if the upper bound is omitted (but the colon agai
 highest possible upper bound for that option is used.
 .TP
 .BR "--stp-type " "[!] \fItype\fP"
-The BPDU type (0-255), recognized non-numerical types are
+The BPDU type (0\(en255), recognized non-numerical types are
 .IR config ", denoting a configuration BPDU (=0), and"
 .IR tcn ", denothing a topology change notification BPDU (=128)."
 .TP
 .BR "--stp-flags " "[!] \fIflag\fP"
-The BPDU flag (0-255), recognized non-numerical flags are
+The BPDU flag (0\(en255), recognized non-numerical flags are
 .IR topology-change ", denoting the topology change flag (=1), and"
 .IR topology-change-ack ", denoting the topology change acknowledgement flag (=128)."
 .TP
 .BR "--stp-root-prio " "[!] [\fIprio\fP][:\fIprio\fP]"
-The root priority (0-65535) range.
+The root priority (0\(en65535) range.
 .TP
 .BR "--stp-root-addr " "[!] [\fIaddress\fP][/\fImask\fP]"
 The root mac address, see the option
 .BR -s " for more details."
 .TP
 .BR "--stp-root-cost " "[!] [\fIcost\fP][:\fIcost\fP]"
-The root path cost (0-4294967295) range.
+The root path cost (0\(en4294967295) range.
 .TP
 .BR "--stp-sender-prio " "[!] [\fIprio\fP][:\fIprio\fP]"
-The BPDU's sender priority (0-65535) range.
+The BPDU's sender priority (0\(en65535) range.
 .TP
 .BR "--stp-sender-addr " "[!] [\fIaddress\fP][/\fImask\fP]"
 The BPDU's sender mac address, see the option
 .BR -s " for more details."
 .TP
 .BR "--stp-port " "[!] [\fIport\fP][:\fIport\fP]"
-The port identifier (0-65535) range.
+The port identifier (0\(en65535) range.
 .TP
 .BR "--stp-msg-age " "[!] [\fIage\fP][:\fIage\fP]"
-The message age timer (0-65535) range.
+The message age timer (0\(en65535) range.
 .TP
 .BR "--stp-max-age " "[!] [\fIage\fP][:\fIage\fP]"
-The max age timer (0-65535) range.
+The max age timer (0\(en65535) range.
 .TP
 .BR "--stp-hello-time " "[!] [\fItime\fP][:\fItime\fP]"
-The hello time timer (0-65535) range.
+The hello time timer (0\(en65535) range.
 .TP
 .BR "--stp-forward-delay " "[!] [\fIdelay\fP][:\fIdelay\fP]"
-The forward delay timer (0-65535) range.
+The forward delay timer (0\(en65535) range.
 .\" .SS string
 .\" This module matches on a given string using some pattern matching strategy.
 .\" .TP
@@ -858,7 +858,7 @@ Log with the default logging options
 .TP
 .B --nflog-group "\fInlgroup\fP"
 .br
-The netlink group (1 - 2^32-1) to which packets are (only applicable for
+The netlink group (1\(en2^32-1) to which packets are (only applicable for
 nfnetlink_log). The default value is 1.
 .TP
 .B --nflog-prefix "\fIprefix\fP"
-- 
2.42.0

