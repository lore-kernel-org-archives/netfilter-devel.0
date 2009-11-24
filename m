From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/3] doc: name resolution clarification
Date: Tue, 24 Nov 2009 16:07:34 +0100
Message-ID: <1259075255-25781-4-git-send-email-jengelh@medozas.de>
References: <1259075255-25781-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36326 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933215AbZKXPHe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:07:34 -0500
In-Reply-To: <1259075255-25781-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sometimes there are users who wonder about when name resolutions/DNS
queries are done, so let's add that for completeness.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.8.in |   10 ++++++----
 iptables.8.in  |    8 +++++---
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/ip6tables.8.in b/ip6tables.8.in
index 66d8543..5688133 100644
--- a/ip6tables.8.in
+++ b/ip6tables.8.in
@@ -240,10 +240,12 @@ option is omitted.
 .TP
 [\fB!\fP] \fB\-s\fP, \fB\-\-source\fP \fIaddress\fP[\fB/\fP\fImask\fP]
 Source specification.
-\fIAddress\fP can be either a hostname (please note that specifying
-any name to be resolved with a remote query such as DNS is a really bad idea),
-a network IPv6 address (with \fB/\fP\fImask\fP), or a plain IPv6 address.
-(the network name isn't supported now).
+\fIAddress\fP can be either be a hostname,
+a network IP address (with \fB/\fP\fImask\fP), or a plain IP address.
+Names will be resolved once only, before the rule is submitted to the kernel.
+Please note that specifying any name to be resolved with a remote query such as
+DNS is a really bad idea.
+(Resolving network names is not supported at this time.)
 The \fImask\fP is a plain number,
 specifying the number of 1's at the left side of the network mask.
 A "!" argument before the address specification inverts the sense of
diff --git a/iptables.8.in b/iptables.8.in
index 928f46a..d29deb2 100644
--- a/iptables.8.in
+++ b/iptables.8.in
@@ -239,9 +239,11 @@ option is omitted.
 .TP
 [\fB!\fP] \fB\-s\fP, \fB\-\-source\fP \fIaddress\fP[\fB/\fP\fImask\fP][\fB,\fP\fI...\fP]
 Source specification. \fIAddress\fP
-can be either a network name, a hostname (please note that specifying
-any name to be resolved with a remote query such as DNS is a really bad idea),
-a network IP address (with \fB/\fP\fImask\fP), or a plain IP address.
+can be either a network name, a hostname, a network IP address (with
+\fB/\fP\fImask\fP), or a plain IP address. Hostnames will
+be resolved once only, before the rule is submitted to the kernel.
+Please note that specifying any name to be resolved with a remote query such as
+DNS is a really bad idea.
 The \fImask\fP
 can be either a network mask or a plain number,
 specifying the number of 1's at the left side of the network mask.
-- 
1.6.5.2

