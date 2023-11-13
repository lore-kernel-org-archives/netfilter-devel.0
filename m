Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31685C05021
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Nov 2023 10:44:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbjKMKoJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Nov 2023 05:44:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjKMKoH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2023 05:44:07 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0739C10D7
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 02:44:04 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 65534)
        id 9E8F358725FD8; Mon, 13 Nov 2023 11:44:02 +0100 (CET)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id 5209158725FE7
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 11:44:02 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH 4/7] man: display number ranges with an en dash
Date:   Mon, 13 Nov 2023 11:43:09 +0100
Message-ID: <20231113104357.59087-5-jengelh@inai.de>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231113104357.59087-1-jengelh@inai.de>
References: <20231113104357.59087-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

For ranges, en dashes should be used; cf. e.g.
https://en.wikipedia.org/wiki/Dash#En_dash .

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 ebtables-legacy.8.in | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/ebtables-legacy.8.in b/ebtables-legacy.8.in
index 2a8e7ad..d1a06b3 100644
--- a/ebtables-legacy.8.in
+++ b/ebtables-legacy.8.in
@@ -789,46 +789,46 @@ for that option is used, while if the upper bound is omitted (but the colon agai
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
 .SS string
 This module matches on a given string using some pattern matching strategy.
 .TP
@@ -925,7 +925,7 @@ Log with the default logging options
 .TP
 .B --nflog-group "\fInlgroup\fP"
 .br
-The netlink group (1 - 2^32-1) to which packets are (only applicable for
+The netlink group (1\(en2^32-1) to which packets are (only applicable for
 nfnetlink_log). The default value is 1.
 .TP
 .B --nflog-prefix "\fIprefix\fP"
-- 
2.42.1

