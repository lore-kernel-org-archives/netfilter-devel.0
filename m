From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/6] Update .gitignore
Date: Tue, 16 Nov 2010 12:43:30 +0100
Message-ID: <1289907814-32706-4-git-send-email-jengelh@medozas.de>
References: <1289907814-32706-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47725 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933601Ab0KPLnj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Nov 2010 06:43:39 -0500
In-Reply-To: <1289907814-32706-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 examples/netfilter/.gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/examples/netfilter/.gitignore b/examples/netfilter/.gitignore
index 0d1727d..f2f863f 100644
--- a/examples/netfilter/.gitignore
+++ b/examples/netfilter/.gitignore
@@ -1,2 +1,3 @@
+/nf-log
 /nf-queue
 /nfct-event
-- 
1.7.1

