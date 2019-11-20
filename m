Return-Path: <SRS0=UIY/=ZM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC7FAC43141
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 17:44:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A730920715
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 17:44:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="FxYJzy/Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbfKTRoN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Nov 2019 12:44:13 -0500
Received: from mail-wr1-f48.google.com ([209.85.221.48]:33587 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbfKTRoM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Nov 2019 12:44:12 -0500
Received: by mail-wr1-f48.google.com with SMTP id w9so918578wrr.0
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 09:44:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3c6Ier7NrsUmDAwQr6FxsplGurRCfrDTFOmUr9Gk2PU=;
        b=FxYJzy/QgC9JOfeC2qZUuH1cUytIwDjTlgooH6ZgvAwsEIBHLbPWV9P/F5MJvv2XWr
         jlZdkXx2+mZbOwtS1J3jSdgG0gjdIGCiiFcCBCFQsg7392F9a7of4Ux8LDt00P/mkYuD
         W/j8Tc6UEuNG1uGz2RwVAwqUOEHb6k4tkL0Hzx4DReS04foCxmtDmPl2tEqcyfYvX8Jz
         jaB1ddl348hUc1a/7dmRA0t1ORugFdSkp7m2cvghXvUVQ3wIx33SxsTsgcckww+BHWbZ
         iMvit3wTrHCWatfAnmKCgZLe069GFb/z+vx+7kfNOzavYw/EQ6g3gTNxKqlW4B8HUzhF
         d31w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3c6Ier7NrsUmDAwQr6FxsplGurRCfrDTFOmUr9Gk2PU=;
        b=IXc1WzUsF6lX66c6PBz3hjcOtSFBLO1Fav0dEFAJiLc2kFpAFAudMJLg3tjWj/Aw5b
         RyB0IvEw+G8QIT97ZDXLJeX1Lp/QEa1l/vaN1hnmfba1OlVq4D9XKmlsktMqBzUO+wuG
         Yzup8A5BA08yU6keMmyMJcfZmVbQzcc+wcQyLHlEuMzN0C9Kl/6ZisSR1b5dmN4MVM8L
         B0341azu17KCvBoz/UaAd99KitZ0UtColYwNoxAafvcCqM1p9N77dV6PwXpe3EOXQCe7
         XHs2FAtlGvxrPd4xKJSY46OKWpKMkJiaCsfOfKHMJWreqVMkxGDStj5uKwSD/3jFzh4e
         9WkQ==
X-Gm-Message-State: APjAAAUUSRafTxLhDqKsPSRicjvI173M3OBbIj+WUhkLPwmHENwWf/eE
        qgzzNw+5XD+ktQ5bwM+x9RnviBF8
X-Google-Smtp-Source: APXvYqzi+YqP5ENZM9Wmp0cx7ZVbiIL/VkUcyvwU6ZQJ0LIJVDVnlgd8Kh4xFHER/04l8qwxudkxgw==
X-Received: by 2002:adf:f44a:: with SMTP id f10mr4994402wrp.63.1574271848041;
        Wed, 20 Nov 2019 09:44:08 -0800 (PST)
Received: from desktopdebian.localdomain (x4d06663e.dyn.telefonica.de. [77.6.102.62])
        by smtp.gmail.com with ESMTPSA id m3sm34558580wrb.67.2019.11.20.09.44.07
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 09:44:07 -0800 (PST)
From:   =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>
To:     netfilter-devel@vger.kernel.org
Subject: [RFC 1/4] statement: make secmark statements idempotent
Date:   Wed, 20 Nov 2019 18:43:54 +0100
Message-Id: <20191120174357.26112-1-cgzones@googlemail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently lines like

    ct state new meta secmark set tcp dport map @secmapping_in

become

    ct state new secmark name tcp dport map @secmapping_in

fixes: 3bc84e5c1fdd1ff011af9788fe174e0514c2c9ea

Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
---
 src/statement.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/statement.c b/src/statement.c
index af84e06c..be35bcef 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -233,6 +233,9 @@ static void objref_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 	case NFT_OBJECT_CT_EXPECT:
 		nft_print(octx, "ct expectation set ");
 		break;
+	case NFT_OBJECT_SECMARK:
+		nft_print(octx, "meta secmark set ");
+		break;
 	default:
 		nft_print(octx, "%s name ",
 			  objref_type_name(stmt->objref.type));
-- 
2.24.0

