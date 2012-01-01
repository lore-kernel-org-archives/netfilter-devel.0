From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/3] doc: Linux 2.6.39 already has the defs
Date: Sun,  1 Jan 2012 01:25:33 +0100
Message-ID: <1325377535-11289-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:51158 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721Ab2AAAZi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 31 Dec 2011 19:25:38 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 README |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/README b/README
index e5c0ddf..dd6e66b 100644
--- a/README
+++ b/README
@@ -4,7 +4,7 @@ instructions too.
 
 0. You need the source tree of your kernel (version >= 2.6.34)
    and it have to be configured with ip6tables support enabled,
-   modules compiled. For kernel versions <= 2.6.39 please apply
+   modules compiled. For kernel versions < 2.6.39 please apply
    the netlink.patch against your kernel tree, which adds the
    new subsystem identifier for ipset.
 
-- 
1.7.7

