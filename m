From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH iptables] extensions: libxt_NFLOG: add unit test to cover nflog-size with zero
Date: Wed, 20 Jul 2016 20:53:10 +0800
Message-ID: <1469019190-20263-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:35018 "EHLO m12-17.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882AbcGTMyF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jul 2016 08:54:05 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

"--nflog-size 0" is valid and we must display it appropriately.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 extensions/libxt_NFLOG.t | 1 +
 1 file changed, 1 insertion(+)

diff --git a/extensions/libxt_NFLOG.t b/extensions/libxt_NFLOG.t
index 78076b5..933fa22 100644
--- a/extensions/libxt_NFLOG.t
+++ b/extensions/libxt_NFLOG.t
@@ -7,6 +7,7 @@
 -j NFLOG --nflog-range 4294967295;=;OK
 -j NFLOG --nflog-range 4294967296;;FAIL
 -j NFLOG --nflog-range -1;;FAIL
+-j NFLOG --nflog-size 0;=;OK
 -j NFLOG --nflog-size 1;=;OK
 -j NFLOG --nflog-size 4294967295;=;OK
 -j NFLOG --nflog-size 4294967296;;FAIL
-- 
2.5.5


