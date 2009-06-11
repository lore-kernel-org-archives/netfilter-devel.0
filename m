From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/5] libxt_tcp: manpage corrections and suggestions
Date: Thu, 11 Jun 2009 13:11:19 +0200
Message-ID: <1244718682-2497-3-git-send-email-jengelh@medozas.de>
References: <1244718682-2497-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38296 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762808AbZFKLLX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Jun 2009 07:11:23 -0400
In-Reply-To: <1244718682-2497-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Ian Bruce <ian_bruce@fastmail.net>

From: Ian Bruce <ian_bruce@fastmail.net>

The commit corrects some minor errors in the iptables(8) man page,
related to port ranges in the "tcp" module.

Reference: http://bugs.debian.org/531677
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_tcp.man |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_tcp.man b/extensions/libxt_tcp.man
index 0a99cdf..7a16118 100644
--- a/extensions/libxt_tcp.man
+++ b/extensions/libxt_tcp.man
@@ -4,10 +4,10 @@ provides the following options:
 [\fB!\fP] \fB\-\-source\-port\fP,\fB\-\-sport\fP \fIport\fP[\fB:\fP\fIport\fP]
 Source port or port range specification. This can either be a service
 name or a port number. An inclusive range can also be specified,
-using the format \fIport\fP\fB:\fP\fIport\fP.
+using the format \fIfirst\fP\fB:\fP\fIlast\fP.
 If the first port is omitted, "0" is assumed; if the last is omitted,
 "65535" is assumed.
-If the second port is greater than the first they will be swapped.
+If the first port is greater than the second one they will be swapped.
 The flag
 \fB\-\-sport\fP
 is a convenient alias for this option.
-- 
1.6.3.1

