From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/5] doc: let man(1) autoalign the text in xt_cpu
Date: Fri, 23 Jul 2010 21:36:19 +0200
Message-ID: <1279913784-12272-2-git-send-email-jengelh@medozas.de>
References: <1279913784-12272-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:56102 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754314Ab0GWTgc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Jul 2010 15:36:32 -0400
In-Reply-To: <1279913784-12272-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_cpu.man |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_cpu.man b/extensions/libxt_cpu.man
index f42ac7a..6013890 100644
--- a/extensions/libxt_cpu.man
+++ b/extensions/libxt_cpu.man
@@ -8,9 +8,9 @@ multiqueue NICS to spread network traffic on different queues.
 Example:
 .PP
 iptables \-t nat \-A PREROUTING \-p tcp \-\-dport 80 \-m cpu \-\-cpu 0 
-        \-j REDIRECT \-\-to\-port 8080
+\-j REDIRECT \-\-to\-port 8080
 .PP
 iptables \-t nat \-A PREROUTING \-p tcp \-\-dport 80 \-m cpu \-\-cpu 1 
-        \-j REDIRECT \-\-to\-port 8081
+\-j REDIRECT \-\-to\-port 8081
 .PP
 Available since linux 2.6.36
-- 
1.7.1

