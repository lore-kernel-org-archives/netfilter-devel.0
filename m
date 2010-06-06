From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/4] doc: xt_LED: nroff formatting requirements
Date: Sun,  6 Jun 2010 13:23:56 +0200
Message-ID: <1275823437-12089-5-git-send-email-jengelh@medozas.de>
References: <1275823437-12089-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:45397 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757322Ab0FFLYE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Jun 2010 07:24:04 -0400
In-Reply-To: <1275823437-12089-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Verbatim dashes need to be backslash-prefixed.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_LED.man |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/extensions/libxt_LED.man b/extensions/libxt_LED.man
index 0226f10..81c2f29 100644
--- a/extensions/libxt_LED.man
+++ b/extensions/libxt_LED.man
@@ -4,11 +4,11 @@ system. One example might be to light up an LED for a few minutes every time
 an SSH connection is made to the local machine. The following options control
 the trigger behavior:
 .TP
-\fB--led-trigger-id\fP \fIname\fP
+\fB\-\-led\-trigger\-id\fP \fIname\fP
 This is the name given to the LED trigger. The actual name of the trigger
 will be prefixed with "netfilter-".
 .TP
-\fB--led-delay\fP \fIms\fP
+\fB\-\-led-delay\fP \fIms\fP
 This indicates how long (in milliseconds) the LED should be left illuminated
 when a packet arrives before being switched off again. The default is 0
 (blink as fast as possible.) The special value \fIinf\fP can be given to
@@ -16,7 +16,7 @@ leave the LED on permanently once activated. (In this case the trigger will
 need to be manually detached and reattached to the LED device to switch it
 off again.)
 .TP
-\fB--led-always-blink\fP
+\fB\-\-led\-always\-blink\fP
 Always make the LED blink on packet arrival, even if the LED is already on.
 This allows notification of new packets even with long delay values (which
 otherwise would result in a silent prolonging of the delay time.)
@@ -24,7 +24,7 @@ otherwise would result in a silent prolonging of the delay time.)
 Example:
 .TP
 Create an LED trigger for incoming SSH traffic:
-iptables -A INPUT -p tcp --dport 22 -j LED --led-trigger-id ssh
+iptables \-A INPUT \-p tcp \-\-dport 22 \-j LED \-\-led\-trigger\-id ssh
 .TP
 Then attach the new trigger to an LED:
-echo netfilter-ssh >/sys/class/leds/\fIledname\fP/trigger
+echo netfilter\-ssh >/sys/class/leds/\fIledname\fP/trigger
-- 
1.7.1

