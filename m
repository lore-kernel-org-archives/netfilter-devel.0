From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/4] netfilter: xtables: schedule xt_state for removal
Date: Tue, 23 Mar 2010 21:45:00 +0100
Message-ID: <1269377101-13875-5-git-send-email-jengelh@medozas.de>
References: <1269377101-13875-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46046 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059Ab0CWUpN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Mar 2010 16:45:13 -0400
In-Reply-To: <1269377101-13875-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

xt_conntrack has been provided since v2.5.32.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Documentation/feature-removal-schedule.txt |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index ea227e3..0749a8f 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -587,3 +587,11 @@ Files:	net/netfilter/xt_NOTRACK.c
 When:	April 2011
 Why:	Superseded by xt_CT
 Who:	Netfilter developer team <netfilter-devel@vger.kernel.org>
+
+---------------------------
+
+What:	xt_state
+Files:	net/netfilter/xt_state.c
+When:	April 2011
+Why:	Superseded by xt_conntrack
+Who:	Jan Engelhardt <jengelh@medozas.de>
-- 
1.7.0.2

