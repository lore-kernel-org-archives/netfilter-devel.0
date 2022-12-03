Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D867CC47088
	for <netfilter-devel@archiver.kernel.org>; Sat,  3 Dec 2022 19:02:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiLCTCY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 3 Dec 2022 14:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiLCTCW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 3 Dec 2022 14:02:22 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4371C903
        for <netfilter-devel@vger.kernel.org>; Sat,  3 Dec 2022 11:02:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=f7lk6Dkl4tXSVHAhBnTTcIPUvcZJaHbebLJO055opDg=; b=NzJfL+gsCUd0VvGXpKwpDrz4bD
        FGquN7eiUe/lDuTtWoXFslD63AjgzIR+E/8X7wnV+h1IwYryb/8GEQeNrIOfoE6OhOL0X+LdNWepd
        kmXE5Tri3MF81ItLv4KglFKAtIC0o+w+WPsDZSN15wbMa69B8bpQjSNrC7KbYX5j+oaht7/JOzrWv
        Sb0Urjvz3YKPJwZ4oS4PQ+smDqPlkDK/VsEZ4iFxT4DVlWtG7tPHfg03AYGx+NYeQz0Ef6LE4qJrs
        JRGmmqHIsOUGFQzIlROCFBTzEkkUw/iLxjH5aKE3Z03+elPYFbPAjaexaQTkaGbD1p8bRsvOsGlIW
        KtRVUYGw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p1XmE-000B5v-I4
        for netfilter-devel@vger.kernel.org; Sat, 03 Dec 2022 19:02:18 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 3/4] JSON: remove incorrect config value check
Date:   Sat,  3 Dec 2022 19:02:11 +0000
Message-Id: <20221203190212.346490-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221203190212.346490-1-jeremy@azazel.net>
References: <20221203190212.346490-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The `u.string` member of a config entry is an array, and so never `NULL`.
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

