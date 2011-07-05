From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/4] doc: fix version string in ip6tables.8
Date: Tue,  5 Jul 2011 15:14:39 +0200
Message-ID: <1309871682-27307-3-git-send-email-jengelh@medozas.de>
References: <1309871682-27307-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:42318 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739Ab1GENOu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jul 2011 09:14:50 -0400
In-Reply-To: <1309871682-27307-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 iptables/ip6tables.8.in |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/iptables/ip6tables.8.in b/iptables/ip6tables.8.in
index 20e271d..0f7e3cc 100644
--- a/iptables/ip6tables.8.in
+++ b/iptables/ip6tables.8.in
@@ -1,4 +1,4 @@
-.TH IP6TABLES 8 "" "iptables 1.4.4" "iptables 1.4.4"
+.TH IP6TABLES 8 "" "@PACKAGE_AND_VERSION@" "@PACKAGE_AND_VERSION@"
 .\"
 .\" Man page written by Andras Kis-Szabo <kisza@sch.bme.hu>
 .\" It is based on iptables man page.
-- 
1.7.3.4

