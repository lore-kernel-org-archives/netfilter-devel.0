From: Harout Hedeshian <harouth@codeaurora.org>
Subject: [PATCH iptables] extensions: libxt_socket: update man pages and tests for --restore-skmark
Date: Mon, 13 Jul 2015 10:01:30 -0600
Message-ID: <1436803290-31561-1-git-send-email-harouth@codeaurora.org>
Cc: Harout Hedeshian <harouth@codeaurora.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44695 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbbGMQBm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Jul 2015 12:01:42 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Update the man pages for libxt_socket with a description and example
usage of the --restore-skmark option.

Also added tests for libxt_socket with various combinations of
--restore-skmark and the existing options.

Signed-off-by: Harout Hedeshian <harouth@codeaurora.org>
---
 extensions/libxt_socket.man | 14 ++++++++++++++
 extensions/libxt_socket.t   |  4 ++++
 2 files changed, 18 insertions(+)

diff --git a/extensions/libxt_socket.man b/extensions/libxt_socket.man
index 2ef32ce..f809df6 100644
--- a/extensions/libxt_socket.man
+++ b/extensions/libxt_socket.man
@@ -20,3 +20,17 @@ option instead.
 Example (assuming packets with mark 1 are delivered locally):
 .IP
 \-t mangle \-A PREROUTING \-m socket \-\-transparent \-j MARK \-\-set\-mark 1
+.TP
+\fB\-\-restore\-skmark\fP
+Set the packet mark to the matching socket's mark. Can be combined with the
+\fB\-\-transparent\fP and \fB\-\-nowildcard\fP options to restrict the sockets
+to be matched when restoring the packet mark.
+.PP
+Example: An application opens 2 transparent (\fBIP_TRANSPARENT\fP) sockets and
+sets a mark on them with \fBSO_MARK\fP socket option. We can filter matching packets:
+.IP
+\-t mangle \-I PREROUTING \-m socket \-\-transparent \-\-restore-skmark \-j action
+.IP
+\-t mangle \-A action \-m mark \-\-mark 10 \-j action2
+.IP
+\-t mangle \-A action \-m mark \-\-mark 11 \-j action3
diff --git a/extensions/libxt_socket.t b/extensions/libxt_socket.t
index 8c0036e..fe4eb3e 100644
--- a/extensions/libxt_socket.t
+++ b/extensions/libxt_socket.t
@@ -2,3 +2,7 @@
 *mangle
 -m socket;=;OK
 -m socket --transparent --nowildcard;=;OK
+-m socket --transparent --nowildcard --restore-skmark;=;OK
+-m socket --transparent --restore-skmark;=;OK
+-m socket --nowildcard --restore-skmark;=;OK
+-m socket --restore-skmark;=;OK
-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project

