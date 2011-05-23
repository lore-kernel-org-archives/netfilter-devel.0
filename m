From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 07/13] doc: add some coded option examples to libxt_hashlimit
Date: Mon, 23 May 2011 16:39:17 +0200
Message-ID: <1306161564-4370-8-git-send-email-jengelh@medozas.de>
References: <1306161564-4370-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:44628 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755441Ab1EWOje (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 May 2011 10:39:34 -0400
In-Reply-To: <1306161564-4370-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_hashlimit.man |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/extensions/libxt_hashlimit.man b/extensions/libxt_hashlimit.man
index e91d0c6..f90577e 100644
--- a/extensions/libxt_hashlimit.man
+++ b/extensions/libxt_hashlimit.man
@@ -2,16 +2,7 @@
 \fBlimit\fP match) for a group of connections using a \fBsingle\fP iptables
 rule. Grouping can be done per-hostgroup (source and/or destination address)
 and/or per-port. It gives you the ability to express "\fIN\fP packets per time
-quantum per group":
-.TP
-matching on source host
-"1000 packets per second for every host in 192.168.0.0/16"
-.TP
-matching on source port
-"100 packets per second for every service of 192.168.1.1"
-.TP
-matching on subnet
-"10000 packets per minute for every /28 subnet in 10.0.0.0/8"
+quantum per group" (see below for some examples).
 .PP
 A hash limit option (\fB\-\-hashlimit\-upto\fP, \fB\-\-hashlimit\-above\fP) and
 \fB\-\-hashlimit\-name\fP are required.
@@ -57,3 +48,18 @@ After how many milliseconds do hash entries expire.
 .TP
 \fB\-\-hashlimit\-htable\-gcinterval\fP \fImsec\fP
 How many milliseconds between garbage collection intervals.
+.PP
+Examples:
+.TP
+matching on source host
+"1000 packets per second for every host in 192.168.0.0/16" =>
+\-s 192.168.0.0/16 \-\-hashlimit\-mode srcip \-\-hashlimit\-upto 1000/sec
+.TP
+matching on source port
+"100 packets per second for every service of 192.168.1.1" =>
+\-s 192.168.1.1 \-\-hashlimit\-mode srcport \-\-hashlimit\-upto 100/sec
+.TP
+matching on subnet
+"10000 packets per minute for every /28 subnet (groups of 8 addresses)
+in 10.0.0.0/8" =>
+\-s 10.0.0.8 \-\-hashlimit\-mask 28 \-\-hashlimit\-upto 10000/min
-- 
1.7.3.4

