From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 2/5] extensions: eui64: set userspacesize=0
Date: Tue,  5 Mar 2013 02:08:12 +0100
Message-ID: <1362445695-15952-3-git-send-email-jengelh@inai.de>
References: <1362445695-15952-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:45715 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758941Ab3CEBIR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Mar 2013 20:08:17 -0500
In-Reply-To: <1362445695-15952-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The eui64 match does not use its parameter block at all, so
userspacesize should be 0. This resolves "eui64 is missing a save
function".

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/libip6t_eui64.c |    2 +-
 tests/options-most.rules   |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/extensions/libip6t_eui64.c b/extensions/libip6t_eui64.c
index 607bf86..3bd7a8f 100644
--- a/extensions/libip6t_eui64.c
+++ b/extensions/libip6t_eui64.c
@@ -6,7 +6,7 @@ static struct xtables_match eui64_mt6_reg = {
 	.version	= XTABLES_VERSION,
 	.family		= NFPROTO_IPV6,
 	.size		= XT_ALIGN(sizeof(int)),
-	.userspacesize	= XT_ALIGN(sizeof(int)),
+	.userspacesize	= 0,
 };
 
 void _init(void)
diff --git a/tests/options-most.rules b/tests/options-most.rules
index ef4e7f1..c26847e 100644
--- a/tests/options-most.rules
+++ b/tests/options-most.rules
@@ -91,6 +91,8 @@
 -A matches
 -A matches -p esp -m esp --espspi 5:4294967295
 -A matches
+-A matches -m eui64
+-A matches
 -A matches -m hashlimit --hashlimit-upto 1/sec --hashlimit-burst 1 --hashlimit-name mini1 --hashlimit-htable-expire 2000
 -A matches -m hashlimit --hashlimit-upto 1/sec --hashlimit-burst 1 --hashlimit-name mini1
 -A matches -m hashlimit --hashlimit-upto 1/min --hashlimit-burst 1 --hashlimit-name mini2
-- 
1.7.10.4

