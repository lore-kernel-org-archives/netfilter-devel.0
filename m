From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 09/24] doc: clarify that -p all is a special keyword only
Date: Wed, 25 May 2011 01:08:10 +0200
Message-ID: <1306278506-11463-10-git-send-email-jengelh@medozas.de>
References: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40946 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932993Ab1EXXIi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 19:08:38 -0400
In-Reply-To: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.8.in |    5 ++---
 iptables.8.in  |    5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/ip6tables.8.in b/ip6tables.8.in
index 61d6667..48ba18e 100644
--- a/ip6tables.8.in
+++ b/ip6tables.8.in
@@ -243,15 +243,14 @@ add, delete, insert, replace and append commands).
 [\fB!\fP] \fB\-p\fP, \fB\-\-protocol\fP \fIprotocol\fP
 The protocol of the rule or of the packet to check.
 The specified protocol can be one of \fBtcp\fP, \fBudp\fP, \fBudplite\fP,
-\fBicmpv6\fP, \fBesp\fP, \fBmh\fP or \fBall\fP,
+\fBicmpv6\fP, \fBesp\fP, \fBmh\fP or the special keyword "\fBall\fP",
 or it can be a numeric value, representing one of these protocols or a
 different one. A protocol name from /etc/protocols is also allowed.
 But IPv6 extension headers except \fBesp\fP are not allowed.
 \fBesp\fP and \fBipv6\-nonext\fP
 can be used with Kernel version 2.6.11 or later.
 A "!" argument before the protocol inverts the
-test.  The number zero is equivalent to \fBall\fP.
-Protocol \fBall\fP
+test.  The number zero is equivalent to \fBall\fP. "\fBall\fP"
 will match with all protocols and is taken as default when this
 option is omitted.
 .TP
diff --git a/iptables.8.in b/iptables.8.in
index 110c599..d09bf7a 100644
--- a/iptables.8.in
+++ b/iptables.8.in
@@ -246,12 +246,11 @@ add, delete, insert, replace and append commands).
 [\fB!\fP] \fB\-p\fP, \fB\-\-protocol\fP \fIprotocol\fP
 The protocol of the rule or of the packet to check.
 The specified protocol can be one of \fBtcp\fP, \fBudp\fP, \fBudplite\fP,
-\fBicmp\fP, \fBesp\fP, \fBah\fP, \fBsctp\fP or \fBall\fP,
+\fBicmp\fP, \fBesp\fP, \fBah\fP, \fBsctp\fP or the special keyword "\fBall\fP",
 or it can be a numeric value, representing one of these protocols or a
 different one.  A protocol name from /etc/protocols is also allowed.
 A "!" argument before the protocol inverts the
-test.  The number zero is equivalent to \fBall\fP.
-Protocol \fBall\fP
+test.  The number zero is equivalent to \fBall\fP. "\fBall\fP"
 will match with all protocols and is taken as default when this
 option is omitted.
 .TP
-- 
1.7.3.4

