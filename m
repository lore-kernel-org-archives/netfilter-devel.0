From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/4] iptables: restore negation for -f
Date: Tue,  5 Jul 2011 15:14:41 +0200
Message-ID: <1309871682-27307-5-git-send-email-jengelh@medozas.de>
References: <1309871682-27307-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:42327 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932350Ab1GENOx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jul 2011 09:14:53 -0400
In-Reply-To: <1309871682-27307-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This move was missed in commit v1.4.11~77^2~6.

References: http://bugs.debian.org/632695
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 iptables/iptables.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/iptables/iptables.c b/iptables/iptables.c
index 477e8f1..6ceaf6b 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -178,9 +178,9 @@ static const int inverse_for_options[NUMBER_OF_OPT] =
 /* -x */ 0,
 /* -i */ IPT_INV_VIA_IN,
 /* -o */ IPT_INV_VIA_OUT,
-/* -f */ IPT_INV_FRAG,
 /*--line*/ 0,
 /* -c */ 0,
+/* -f */ IPT_INV_FRAG,
 };
 
 #define opts iptables_globals.opts
-- 
1.7.3.4

