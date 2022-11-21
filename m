Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9905DC4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Nov 2022 22:27:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbiKUW1j (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 17:27:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiKUW1h (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 17:27:37 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B20EDF3D
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2022 14:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NOLlBsW8k7BgHGysVbxBhN4ePfhDjNMnNraKErPIVlg=; b=qP+iDh3LIs+qYOytMRcz3kTYnQ
        AmQv/15692EFx6T0qj/5E2dUEEZBLkSxKTc1SO6LFQaqxGUK0ZO1K0pc/ex7NLc3SzX0VX86JZn7c
        N1I3mp9sgco50FB1m34c5/Xwj5cNxJv+d8NhnMp9t1ATJquwoMHiFvkb3HqTj9NzBG3N0uQgXUR71
        TKZyIO0qikTXYFfrRafvJY22vJC/SfIokuAZoFDt1SYcllBSpnW7H8xXNSTVahRvBZHVYSqYgFLd0
        Eq3DB5/PwWibTndUb/TYQbYx20v/+zNMTmyjDWqxP4B71ExTBaUPviA2wxqWpdQoJwI5TRhiQHtos
        RB3IuliQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oxFGC-005LgP-4v
        for netfilter-devel@vger.kernel.org; Mon, 21 Nov 2022 22:27:28 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 03/34] output: JSON: remove incorrect config value check
Date:   Mon, 21 Nov 2022 22:25:40 +0000
Message-Id: <20221121222611.3914559-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221121222611.3914559-1-jeremy@azazel.net>
References: <20221121222611.3914559-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The `u.string` member of a config entry is an array, and so never NULL.
Output the device string unconditionally.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/ulogd_output_JSON.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/output/ulogd_output_JSON.c b/output/ulogd_output_JSON.c
index bbc3dba5d41a..700abc25e5ea 100644
--- a/output/ulogd_output_JSON.c
+++ b/output/ulogd_output_JSON.c
@@ -277,7 +277,7 @@ static int json_interp(struct ulogd_pluginstance *upi)
 {
 	struct json_priv *opi = (struct json_priv *) &upi->private;
 	unsigned int i;
-	char *buf, *tmp;
+	char *dvc, *buf, *tmp;
 	size_t buflen;
 	json_t *msg;
 
@@ -335,10 +335,8 @@ static int json_interp(struct ulogd_pluginstance *upi)
 			json_object_set_new(msg, "timestamp", json_string(timestr));
 	}
 
-	if (upi->config_kset->ces[JSON_CONF_DEVICE].u.string) {
-		char *dvc = upi->config_kset->ces[JSON_CONF_DEVICE].u.string;
-		json_object_set_new(msg, "dvc", json_string(dvc));
-	}
+	dvc = upi->config_kset->ces[JSON_CONF_DEVICE].u.string;
+	json_object_set_new(msg, "dvc", json_string(dvc));
 
 	for (i = 0; i < upi->input.num_keys; i++) {
 		struct ulogd_key *key = upi->input.keys[i].u.source;
-- 
2.35.1

