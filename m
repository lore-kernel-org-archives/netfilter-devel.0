From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 11/24] doc: remove redundant .IP calls in libxt_time
Date: Wed, 25 May 2011 01:08:12 +0200
Message-ID: <1306278506-11463-12-git-send-email-jengelh@medozas.de>
References: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40955 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933582Ab1EXXIk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 19:08:40 -0400
In-Reply-To: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_time.man |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/extensions/libxt_time.man b/extensions/libxt_time.man
index 2bceaf6..4aff7ff 100644
--- a/extensions/libxt_time.man
+++ b/extensions/libxt_time.man
@@ -4,7 +4,6 @@ options are optional, but are ANDed when specified.
 \fB\-\-datestart\fP \fIYYYY\fP[\fB\-\fP\fIMM\fP[\fB\-\fP\fIDD\fP[\fBT\fP\fIhh\fP[\fB:\fP\fImm\fP[\fB:\fP\fIss\fP]]]]]
 .TP
 \fB\-\-datestop\fP \fIYYYY\fP[\fB\-\fP\fIMM\fP[\fB\-\fP\fIDD\fP[\fBT\fP\fIhh\fP[\fB:\fP\fImm\fP[\fB:\fP\fIss\fP]]]]]
-.IP
 Only match during the given time, which must be in ISO 8601 "T" notation.
 The possible time range is 1970-01-01T00:00:00 to 2038-01-19T04:17:07.
 .IP
@@ -14,32 +13,27 @@ and 2038-01-19, respectively.
 \fB\-\-timestart\fP \fIhh\fP\fB:\fP\fImm\fP[\fB:\fP\fIss\fP]
 .TP
 \fB\-\-timestop\fP \fIhh\fP\fB:\fP\fImm\fP[\fB:\fP\fIss\fP]
-.IP
 Only match during the given daytime. The possible time range is 00:00:00 to
 23:59:59. Leading zeroes are allowed (e.g. "06:03") and correctly interpreted
 as base-10.
 .TP
 [\fB!\fP] \fB\-\-monthdays\fP \fIday\fP[\fB,\fP\fIday\fP...]
-.IP
 Only match on the given days of the month. Possible values are \fB1\fP
 to \fB31\fP. Note that specifying \fB31\fP will of course not match
 on months which do not have a 31st day; the same goes for 28- or 29-day
 February.
 .TP
 [\fB!\fP] \fB\-\-weekdays\fP \fIday\fP[\fB,\fP\fIday\fP...]
-.IP
 Only match on the given weekdays. Possible values are \fBMon\fP, \fBTue\fP,
 \fBWed\fP, \fBThu\fP, \fBFri\fP, \fBSat\fP, \fBSun\fP, or values from \fB1\fP
 to \fB7\fP, respectively. You may also use two-character variants (\fBMo\fP,
 \fBTu\fP, etc.).
 .TP
 \fB\-\-utc\fP
-.IP
 Interpret the times given for \fB\-\-datestart\fP, \fB\-\-datestop\fP,
 \fB\-\-timestart\fP and \fB\-\-timestop\fP to be UTC.
 .TP
 \fB\-\-localtz\fP
-.IP
 Interpret the times given for \fB\-\-datestart\fP, \fB\-\-datestop\fP,
 \fB\-\-timestart\fP and \fB\-\-timestop\fP to be local kernel time. (Default)
 .PP
-- 
1.7.3.4

