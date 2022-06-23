Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F0B5C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jun 2022 18:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiFWS4T (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jun 2022 14:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237513AbiFWSq7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jun 2022 14:46:59 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A38F0145
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2022 10:50:35 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id eo8so118516edb.0
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2022 10:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LX7/5j7LBwpWUxwE1HGGKAM8ymVZla21S8l9MktRGw4=;
        b=c8mcW0nnk0WYBvffLlsY4I6xYAg80afC4juRzDTcx39Lc+M4MwgH95Ixb5+FOitXjP
         CHzHaStJO1wat/V3kGpoX+SZqDMaKOrxx84eDTavF/beix+3zgU6FytLaeJQ488XyWRV
         D+AAr+iu1SP0wn6p3Ukx16sLeRkMqMT5kBgHpf+gDqozcltkn/xlbxaXCA/fp3vCVNLg
         Tq7eLEGMWoGJVESjw39MFuGw229YErarKO2Jkwo3XImAFvn10GXzvGL46wiQPOHau0iY
         xxHXehNG0W3woTtiMXW4lZcDzuI49HFXu4nkpi1oui7piT4n7EWA2V2HutDogHETn3qm
         IJFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LX7/5j7LBwpWUxwE1HGGKAM8ymVZla21S8l9MktRGw4=;
        b=JtrCsJoeuLR7WHPZ/kK1M69AmwY193kUM+4YhrAJANrk7O/WaJUkc66wKka80bduru
         y+UO/EUBWKiyT7ZtydwT8r4+HbT0FmKHR3mm2qus9RAjMLLWwJDi9rJYPIunJhb4pUMX
         OZlh85dCJkgzEuvQTvdir4AGbFbRup+LLoE5AJw3GJ9sBZvUgHJTj6dpgWGoHM4Sl7do
         O/lpIIybvCdk/MMh+ZDlv0NL+sdxvUKGtZGvW8Oshb2IlDKZdZTy1xcKy+xdcanFo0Vu
         L/3eVYArqimWCFXN7LxbiEmZ9Ip2pIHwb/ZAgMq5tKkJ86tLzRMhPZ9nMLGGj4gY9eyh
         TY2Q==
X-Gm-Message-State: AJIora9WoWd6doUe4yILG5DXA7dCOLv4I+ifZ6nw4cPtPnDH445PZ++q
        CFxtlvR6pE0wfstcVng7U97dMEFV9CMX7A==
X-Google-Smtp-Source: AGRyM1vAgaL2g1ok6KfkeBmGg9kRkCe7rSoUXR/8EE5moLqhHrgzoMmM2hc45HbXcBpQTJkr7SGnpA==
X-Received: by 2002:aa7:c542:0:b0:435:75e:8a7b with SMTP id s2-20020aa7c542000000b00435075e8a7bmr12321771edr.108.1656006628309;
        Thu, 23 Jun 2022 10:50:28 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bf48a.dynamic.kabel-deutschland.de. [95.91.244.138])
        by smtp.gmail.com with ESMTPSA id o9-20020aa7c7c9000000b004356e90d13esm119891eds.83.2022.06.23.10.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 10:50:27 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH 4/6] conntrack: fix protocol number parsing
Date:   Thu, 23 Jun 2022 19:49:58 +0200
Message-Id: <20220623175000.49259-5-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220623175000.49259-1-mikhail.sennikovskii@ionos.com>
References: <20220623175000.49259-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Before this commit it was possible to successfully create a ct entry
passing -p 256 and -p some_nonsense.
In both cases an entry with the protocol=0 would be created.

Do not allow invalid protocol values to -p option.

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
---
 src/conntrack.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 500e736..dca7da6 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -882,6 +882,24 @@ static int ct_save_snprintf(char *buf, size_t len,
 
 extern struct ctproto_handler ct_proto_unknown;
 
+static int parse_proto_num(const char *str)
+{
+	char *endptr;
+	long val;
+
+	errno = 0;
+	val = strtol(str, &endptr, 0);
+	if ((errno == ERANGE && (val == LONG_MAX || val == LONG_MIN)) ||
+	    (errno != 0 && val == 0) ||
+	    endptr == str ||
+	    *endptr != '\0' ||
+	    val >= IPPROTO_MAX) {
+		return -1;
+	}
+
+	return val;
+}
+
 static struct ctproto_handler *findproto(char *name, int *pnum)
 {
 	struct ctproto_handler *cur;
@@ -901,8 +919,8 @@ static struct ctproto_handler *findproto(char *name, int *pnum)
 		return &ct_proto_unknown;
 	}
 	/* using a protocol number? */
-	protonum = atoi(name);
-	if (protonum >= 0 && protonum <= IPPROTO_MAX) {
+	protonum = parse_proto_num(name);
+	if (protonum >= 0) {
 		/* try lookup by number, perhaps this protocol is supported */
 		list_for_each_entry(cur, &proto_list, head) {
 			if (cur->protonum == protonum) {
-- 
2.25.1

