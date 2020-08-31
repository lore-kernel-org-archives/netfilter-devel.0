Return-Path: <SRS0=WPBU=CJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82932C433E2
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Aug 2020 13:00:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 531252068E
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Aug 2020 13:00:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="sEE1gJqL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgHaNAA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 31 Aug 2020 09:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbgHaM7y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Aug 2020 08:59:54 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E693C061575
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2020 05:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9WlPHdGyUxID0dpDKjtBJJ7YyCIXSG1dIBx46WMk6hg=; b=sEE1gJqLIR4Ai+edGhmIUsBgXa
        332l9qmYwXbONpDfa4fxtwXSFcO4pOezJyfbS4fnGdOxyZCgh2a8XiTFcesphz+zlBNyKTxflaAHC
        ZaxDIn6V3pHHEiscXj4MbMko3my0Sw6w+CG9jWmQTJjEBHfwWnPNR5XUZjqASwWY5+UG/WVcLEyje
        b/BZK7th4ojiFsA1fNjvNZB8r6JfL0vR4/SpFUbG2Vd6kczDWN3olbPgThKwmU5OJqnxMewwiPUIM
        QkRIYmwMq466TzHZ56IRZFNPrIJbMD5KBejuvT8rxHjHpKL2Z7i1jO1/DIRLSbA2bmd8XPw03iClU
        /k6kXFDw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kCjPb-0002zd-RM; Mon, 31 Aug 2020 13:59:51 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH 1/2] xt_ACCOUNT: update prototype of `struct nf_sockopt_ops` `.set` call-back.
Date:   Mon, 31 Aug 2020 13:59:47 +0100
Message-Id: <20200831125948.22891-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In 5.9, the `void __user` parameter has been replaced by a `sockptr`.
Update `ipt_acc_set_ctl` appropriately.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/ACCOUNT/xt_ACCOUNT.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/extensions/ACCOUNT/xt_ACCOUNT.c b/extensions/ACCOUNT/xt_ACCOUNT.c
index 019f5bda007e..18e0b8a0a1b7 100644
--- a/extensions/ACCOUNT/xt_ACCOUNT.c
+++ b/extensions/ACCOUNT/xt_ACCOUNT.c
@@ -28,6 +28,9 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/string.h>
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(5, 9, 0)
+#include <linux/sockptr.h>
+#endif
 #include <linux/spinlock.h>
 #include <asm/uaccess.h>
 #include <net/netns/generic.h>
@@ -879,7 +882,12 @@ static int ipt_acc_handle_get_data(struct ipt_acc_net *ian,
 }
 
 static int ipt_acc_set_ctl(struct sock *sk, int cmd,
-			void *user, unsigned int len)
+#if LINUX_VERSION_CODE < KERNEL_VERSION(5, 9, 0)
+			   void *user,
+#else
+			   sockptr_t arg,
+#endif
+			   unsigned int len)
 {
 	struct net *net = sock_net(sk);
 	struct ipt_acc_net *ian = net_generic(net, ipt_acc_net_id);
@@ -898,7 +906,12 @@ static int ipt_acc_set_ctl(struct sock *sk, int cmd,
 			break;
 		}
 
-		if (copy_from_user(&handle, user, len)) {
+#if LINUX_VERSION_CODE < KERNEL_VERSION(5, 9, 0)
+		if (copy_from_user(&handle, user, len))
+#else
+		if (copy_from_sockptr(&handle, arg, len))
+#endif
+		{
 			printk("ACCOUNT: ipt_acc_set_ctl: copy_from_user failed for "
 				"IPT_SO_SET_HANDLE_FREE\n");
 			break;
-- 
2.28.0

