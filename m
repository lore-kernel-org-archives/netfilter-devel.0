From: aft <aftnix@gmail.com>
Subject: [PATCH] Added OBSF_print()
Date: Fri, 21 Sep 2012 17:23:10 +0600
Message-ID: <1348226590.2075.1.camel@kernel-host-rh6>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38134 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284Ab2IULX1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Sep 2012 07:23:27 -0400
Received: by pbbrr4 with SMTP id rr4so2424780pbb.19
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Sep 2012 04:23:26 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Also added the __init()

Signed-off-by: Arif Hossain <aftnix@gmail.com>
---
 extensions/libxt_OBSF.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/extensions/libxt_OBSF.c b/extensions/libxt_OBSF.c
index e94c91d..3eadfe8 100644
--- a/extensions/libxt_OBSF.c
+++ b/extensions/libxt_OBSF.c
@@ -129,11 +129,19 @@ static void OBSF_parse(struct xt_option_call *cb)
 static void OBSF_print(const void *ip,
 		       const struct xt_entry_target *target, int numeric)
 {
+	const struct xt_OBSF_tginfo *info = (void *)target->data;
+
+	printf("Cipher Algorithm : %s\n", (info->flags & XT_OBSF_ENC_ARC4) ? "ARC4": "AES");
+	printf("Cipher Mode : %s\n", (info->flags & XT_OBSF_ENC_ENC) ? "ENC" : "DEC");
+	printf("Pading %s\n",(info->flags & XT_OBSF_PAD_ENABLED) ? "Enabled": "Disabled");
+	printf("Padding Mode: %s\n", (info->flags & XT_OBSF_PAD_STATIC) ? "Static" : "Random");
 }
 

 static void OBSF_save(const void *ip, const struct xt_entry_target *target)
 {
+	const struct xt_OBSF_tginfo *info = (void *)target->data;
+
 }
 

@@ -148,3 +156,8 @@ static struct xtables_target obsf_target = {
 				.save = OBSF_save,
 				.x6_options = OBSF_opts,
 };
+
+static void __init(void)
+{
+	xtables_register_target(&obsf_target);
+}
-- 
1.7.1


