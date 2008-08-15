From: Jan Engelhardt <jengelh@medozas.de>
Subject: manpages: add missing rateest documentation
Date: Thu, 14 Aug 2008 20:30:39 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808142030200.32487@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36904 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbYHOAal (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Aug 2008 20:30:41 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit c918302a6d769055da8627bcf189f9e64d3073f9
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Aug 14 20:24:58 2008 -0400

manpages: add missing rateest documentation

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_RATEEST.man |    1 +
 extensions/libxt_rateest.man |   55 ++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 0 deletions(-)
 create mode 100644 extensions/libxt_rateest.man

diff --git a/extensions/libxt_RATEEST.man b/extensions/libxt_RATEEST.man
index 6ad802c..58268cf 100644
--- a/extensions/libxt_RATEEST.man
+++ b/extensions/libxt_RATEEST.man
@@ -9,3 +9,4 @@ choosable.
 Rate measurement interval, in seconds, milliseconds or microseconds.
 .TP
 \fB--rateest-ewmalog\fP \fIvalue\fP
+Rate measurement averaging time constant.
diff --git a/extensions/libxt_rateest.man b/extensions/libxt_rateest.man
new file mode 100644
index 0000000..6d32d51
--- /dev/null
+++ b/extensions/libxt_rateest.man
@@ -0,0 +1,55 @@
+The rate estimator can match on estimated rates as collected by the RATEEST
+target. It supports matching on absolute bps/pps values, comparing two rate
+estimators and matching on the difference between two rate estimators.
+.TP
+\fB--rateest1\fP \fIname\fP
+Name of the first rate estimator.
+.TP
+\fB--rateest2\fP \fIname\fP
+Name of the second rate estimator (if difference is to be calculated).
+.TP
+\fB--rateest-delta\fP
+Compare difference(s) to given rate(s)
+.TP
+\fB--rateest1-bps\fP \fIvalue\fP
+.TP
+\fB--rateest2-bps\fP \fIvalue\fP
+Compare bytes per second.
+.TP
+\fB--rateest1-pps\fP \fIvalue\fP
+.TP
+\fB--rateest2-pps\fP \fIvalue\fP
+Compare packets per second.
+.TP
+[\fB!\fP] \fB--rateest-lt\fP
+Match if rate is less than given rate/estimator.
+.TP
+[\fB!\fP] \fB--rateest-gt\fP
+Match if rate is greater than given rate/estimator.
+.TP
+[\fB!\fP] \fB--rateest-eq\fP
+Match if rate is equal to given rate/estimator.
+.PP
+Example: This is what can be used to route outgoing data connections from an
+FTP server over two lines based on the available bandwidth at the time the data
+connection was started:
+.PP
+# Estimate outgoing rates
+.PP
+iptables -t mangle -A POSTROUTING -o eth0 -j RATEEST --rateest-name eth0
+--rateest-interval 250ms --rateest-ewma 0.5s
+.PP
+iptables -t mangle -A POSTROUTING -o ppp0 -j RATEEST --rateest-name ppp0
+--rateest-interval 250ms --rateest-ewma 0.5s
+.PP
+# Mark based on available bandwidth
+.PP
+iptables -t mangle -A balance -m conntrack --ctstate NEW -m helper --helper ftp
+-m rateest --rateest-delta --rateest1 eth0 --rateest-bps1 2.5mbit --rateest-gt
+--rateest2 ppp0 --rateest-bps2 2mbit -j CONNMARK --set-mark 1
+.PP
+iptables -t mangle -A balance -m conntrack --ctstate NEW -m helper --helper ftp
+-m rateest --rateest-delta --rateest1 ppp0 --rateest-bps1 2mbit --rateest-gt
+--rateest2 eth0 --rateest-bps2 2.5mbit -j CONNMARK --set-mark 2
+.PP
+iptables -t mangle -A balance -j CONNMARK --restore-mark

