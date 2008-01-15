From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/38]: Hide a few more options under NETFILTER_ADVANCED
Date: Tue, 15 Jan 2008 07:19:13 +0100 (MET)
Message-ID: <20080115061908.3184.3417.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62159 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbYAOGTP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:19:15 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: Hide a few more options under NETFILTER_ADVANCED

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 46cc0c9011901f2697608a11c05d43765c7a3b38
tree 65a6a7d661d466e1f5fcc5a43836a24361327e50
parent ee28d55dcb195190fb8bbef5cc8f65b21fd78b52
author Patrick McHardy <kaber@trash.net> Mon, 14 Jan 2008 06:51:07 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:23:21 +0100

 net/netfilter/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 96dbe9f..a711b42 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -378,6 +378,7 @@ config NETFILTER_XT_TARGET_NOTRACK
 config NETFILTER_XT_TARGET_RATEEST
 	tristate '"RATEEST" target support'
 	depends on NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a `RATEEST' target, which allows to measure
 	  rates similar to TC estimators. The `rateest' match can be
@@ -676,6 +677,7 @@ config NETFILTER_XT_MATCH_QUOTA
 config NETFILTER_XT_MATCH_RATEEST
 	tristate '"rateest" match support'
 	depends on NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
 	select NETFILTER_XT_TARGET_RATEEST
 	help
 	  This option adds a `rateest' match, which allows to match on the
