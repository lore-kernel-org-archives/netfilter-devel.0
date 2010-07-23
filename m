From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/5] doc: minimal spelling updates to xt_cpu
Date: Fri, 23 Jul 2010 21:36:21 +0200
Message-ID: <1279913784-12272-4-git-send-email-jengelh@medozas.de>
References: <1279913784-12272-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:56107 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694Ab0GWTgd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Jul 2010 15:36:33 -0400
In-Reply-To: <1279913784-12272-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_cpu.man |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_cpu.man b/extensions/libxt_cpu.man
index a9040c1..d9ea5c2 100644
--- a/extensions/libxt_cpu.man
+++ b/extensions/libxt_cpu.man
@@ -2,7 +2,7 @@
 [\fB!\fP] \fB\-\-cpu\fP \fInumber\fP
 Match cpu handling this packet. cpus are numbered from 0 to NR_CPUS-1
 Can be used in combination with RPS (Remote Packet Steering) or
-multiqueue NICS to spread network traffic on different queues.
+multiqueue NICs to spread network traffic on different queues.
 .PP
 Example:
 .PP
@@ -12,4 +12,4 @@ iptables \-t nat \-A PREROUTING \-p tcp \-\-dport 80 \-m cpu \-\-cpu 0
 iptables \-t nat \-A PREROUTING \-p tcp \-\-dport 80 \-m cpu \-\-cpu 1 
 \-j REDIRECT \-\-to\-port 8081
 .PP
-Available since linux 2.6.36
+Available since Linux 2.6.36.
-- 
1.7.1

