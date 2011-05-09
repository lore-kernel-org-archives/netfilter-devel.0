From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/2] doc: S/DNAT allows to omit IP addresses
Date: Mon,  9 May 2011 21:53:42 +0200
Message-ID: <1304970823-11244-3-git-send-email-jengelh@medozas.de>
References: <1304970823-11244-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54469 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102Ab1EITxr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 15:53:47 -0400
In-Reply-To: <1304970823-11244-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_DNAT.c   |    2 +-
 extensions/libipt_DNAT.man |    2 +-
 extensions/libipt_SNAT.c   |    2 +-
 extensions/libipt_SNAT.man |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index 49c74e1..6eedca1 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -26,7 +26,7 @@ static void DNAT_help(void)
 {
 	printf(
 "DNAT target options:\n"
-" --to-destination <ipaddr>[-<ipaddr>][:port-port]\n"
+" --to-destination [<ipaddr>[-<ipaddr>]][:port[-port]]\n"
 "				Address to map destination to.\n"
 "[--random] [--persistent]\n");
 }
diff --git a/extensions/libipt_DNAT.man b/extensions/libipt_DNAT.man
index d1e0a3a..d5ded35 100644
--- a/extensions/libipt_DNAT.man
+++ b/extensions/libipt_DNAT.man
@@ -10,7 +10,7 @@ should be modified (and all future packets in this connection will
 also be mangled), and rules should cease being examined.  It takes one
 type of option:
 .TP
-\fB\-\-to\-destination\fP [\fIipaddr\fP][\fB\-\fP\fIipaddr\fP][\fB:\fP\fIport\fP[\fB\-\fP\fIport\fP]]
+\fB\-\-to\-destination\fP [\fIipaddr\fP[\fB\-\fP\fIipaddr\fP]][\fB:\fP\fIport\fP[\fB\-\fP\fIport\fP]]
 which can specify a single new destination IP address, an inclusive
 range of IP addresses, and optionally, a port range (which is only
 valid if the rule also specifies
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index 532770d..1a00954 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -26,7 +26,7 @@ static void SNAT_help(void)
 {
 	printf(
 "SNAT target options:\n"
-" --to-source <ipaddr>[-<ipaddr>][:port-port]\n"
+" --to-source [<ipaddr>[-<ipaddr>]][:port[-port]]\n"
 "				Address to map source to.\n"
 "[--random] [--persistent]\n");
 }
diff --git a/extensions/libipt_SNAT.man b/extensions/libipt_SNAT.man
index 6b828fd..80e2cb9 100644
--- a/extensions/libipt_SNAT.man
+++ b/extensions/libipt_SNAT.man
@@ -7,7 +7,7 @@ modified (and all future packets in this connection will also be
 mangled), and rules should cease being examined.  It takes one type
 of option:
 .TP
-\fB\-\-to\-source\fP \fIipaddr\fP[\fB\-\fP\fIipaddr\fP][\fB:\fP\fIport\fP[\fB\-\fP\fIport\fP]]
+\fB\-\-to\-source\fP [\fIipaddr\fP[\fB\-\fP\fIipaddr\fP]][\fB:\fP\fIport\fP[\fB\-\fP\fIport\fP]]
 which can specify a single new source IP address, an inclusive range
 of IP addresses, and optionally, a port range (which is only valid if
 the rule also specifies
-- 
1.7.1

