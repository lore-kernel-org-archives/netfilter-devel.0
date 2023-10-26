Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D12FC25B48
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Oct 2023 08:55:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234957AbjJZIzT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Oct 2023 04:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344716AbjJZIzM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Oct 2023 04:55:12 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C761A5
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Oct 2023 01:55:08 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 65534)
        id 51F45587266A3; Thu, 26 Oct 2023 10:55:07 +0200 (CEST)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id 7166D58726688;
        Thu, 26 Oct 2023 10:55:06 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH 03/10] man: encode math minuses the way groff/man requires it
Date:   Thu, 26 Oct 2023 10:54:59 +0200
Message-ID: <20231026085506.94343-3-jengelh@inai.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231026085506.94343-1-jengelh@inai.de>
References: <20231026085506.94343-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The groff_char(7) manpage tells me that the magic incantation for
a mathematical minus is \[-].

On terminals, math minuses are oddly rendered with U+002D rather than
U+2212, but that's another topic for another day for another
software. In PostScript output (man -t), everything looks right.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/libxt_NFLOG.man     | 2 +-
 extensions/libxt_cpu.man       | 2 +-
 extensions/libxt_rateest.man   | 2 +-
 extensions/libxt_statistic.man | 2 +-
 iptables/ebtables-nft.8        | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/extensions/libxt_NFLOG.man b/extensions/libxt_NFLOG.man
index 093704a1..9d1b4271 100644
--- a/extensions/libxt_NFLOG.man
+++ b/extensions/libxt_NFLOG.man
@@ -9,7 +9,7 @@ may subscribe to the group to receive the packets. Like LOG, this is a
 non-terminating target, i.e. rule traversal continues at the next rule.
 .TP
 \fB\-\-nflog\-group\fP \fInlgroup\fP
-The netlink group (0\(en2^16\-1) to which packets are (only applicable for
+The netlink group (0\(en2^16\[-]1) to which packets are (only applicable for
 nfnetlink_log). The default value is 0.
 .TP
 \fB\-\-nflog\-prefix\fP \fIprefix\fP
diff --git a/extensions/libxt_cpu.man b/extensions/libxt_cpu.man
index c89ef08a..7fcc8189 100644
--- a/extensions/libxt_cpu.man
+++ b/extensions/libxt_cpu.man
@@ -1,6 +1,6 @@
 .TP
 [\fB!\fP] \fB\-\-cpu\fP \fInumber\fP
-Match cpu handling this packet. cpus are numbered from 0 to NR_CPUS-1
+Match cpu handling this packet. cpus are numbered from 0 to NR_CPUS\[-]1
 Can be used in combination with RPS (Remote Packet Steering) or
 multiqueue NICs to spread network traffic on different queues.
 .PP
diff --git a/extensions/libxt_rateest.man b/extensions/libxt_rateest.man
index 1989ff6c..d6ba3675 100644
--- a/extensions/libxt_rateest.man
+++ b/extensions/libxt_rateest.man
@@ -31,7 +31,7 @@ combinations:
 For each estimator (either absolute or relative mode), calculate the difference
 between the estimator-determined flow rate and the static value chosen with the
 BPS/PPS options. If the flow rate is higher than the specified BPS/PPS, 0 will
-be used instead of a negative value. In other words, "max(0, rateest#_rate -
+be used instead of a negative value. In other words, "max(0, rateest#_rate \[-]
 rateest#_bps)" is used.
 .TP
 [\fB!\fP] \fB\-\-rateest\-lt\fP
diff --git a/extensions/libxt_statistic.man b/extensions/libxt_statistic.man
index 47182bfb..e9ffa4b9 100644
--- a/extensions/libxt_statistic.man
+++ b/extensions/libxt_statistic.man
@@ -24,6 +24,6 @@ mode (see also the
 option).
 .TP
 \fB\-\-packet\fP \fIp\fP
-Set the initial counter value (0 <= p <= n\-1, default 0) for the
+Set the initial counter value (0 <= p <= n\[-]1, default 0) for the
 .B nth 
 mode.
diff --git a/iptables/ebtables-nft.8 b/iptables/ebtables-nft.8
index eaeb6d29..f8523f41 100644
--- a/iptables/ebtables-nft.8
+++ b/iptables/ebtables-nft.8
@@ -858,7 +858,7 @@ Log with the default logging options
 .TP
 .B --nflog-group "\fInlgroup\fP"
 .br
-The netlink group (1\(en2^32-1) to which packets are (only applicable for
+The netlink group (1\(en2^32\[-]1) to which packets are (only applicable for
 nfnetlink_log). The default value is 1.
 .TP
 .B --nflog-prefix "\fIprefix\fP"
-- 
2.42.0

