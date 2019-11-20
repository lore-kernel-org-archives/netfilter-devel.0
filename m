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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 321B8C432C3
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 17:44:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C3A420715
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 17:44:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="C1K1Yu22"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbfKTRoM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Nov 2019 12:44:12 -0500
Received: from mail-wm1-f50.google.com ([209.85.128.50]:39492 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727784AbfKTRoM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Nov 2019 12:44:12 -0500
Received: by mail-wm1-f50.google.com with SMTP id t26so563356wmi.4
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 09:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=MR26rSDphCs0ksxzxIf3nVhGyiRYuqnEVHwpuHDMCdA=;
        b=C1K1Yu22wpK3Ri0I9qeapo0PJF39KY6uOrL+dxd4eAADRjeKZH4pEF7vBQOeDk+4EG
         8GZ/SJyLbRyoT/rJhKXD7uMnsprbQweq6HuizPK7Zd9sshEmbjqwxklLalrMCpdWJ+vA
         2S4TfePa+8jJBhMHf5VtoLMluwEkd0kQv1Lp0yy9uPjUdFcmQjCNokgoEqL+0cRj6XaU
         0B+hvOWLRgK7CD17VHgtG8eECry2c1aBqLWNqujPIemiB3c2bQiEey6H7Mn+UA9YHgXc
         b6g5uX8w03T0ict14THP0iQ+682OoQwrtDOzemYqFkMe2RupR8H0jIyanIhpGLoZ9Cek
         sL6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MR26rSDphCs0ksxzxIf3nVhGyiRYuqnEVHwpuHDMCdA=;
        b=l90Xf7QQtb5EX3JPwOaZrHZQ5lgKb/PHOhWyJLm7XZKJ2kNKhKNotqfV1a3k3I5PvT
         MmgMxn8uiXufhy3mxb94L/veMQnR3+Q+VdtHwPmX9Vb04CEP3TEdNEsNQKkTk93MkqKO
         1zShtKJGNhe3pHbKKifmN+Yh0/RBrA5USRou0L/el1mBRsgr49wzsfPIbCT0fQgkhjp5
         BQYo67YkAHH19L1r3sRpmfJe8WbvC+i6PhUVP8dwRUI53uiDuXACmX04gcmFeVNGAq9R
         GHSimjDVRYDNGNrTPm39COw9fwjmT8H0kaoLwBp4mLODqpaH9ff+7Wn3j1a7T+55VkGm
         uljQ==
X-Gm-Message-State: APjAAAVr69ORMP3rCGvla4dMHPEP0Nr0IpZ+EzivdtkfL1esxjbmAwzL
        yO83PdCZ/IT4nPpBvIy7ezr7IDZJ
X-Google-Smtp-Source: APXvYqyBrLe3i+B0uGmx+SXY1iFH9jLPFoh/wQAHwQN9G6uguUHcvfVLUY9oxJWo/ifdoN5CJtK/Iw==
X-Received: by 2002:a1c:e915:: with SMTP id q21mr4886830wmc.164.1574271849884;
        Wed, 20 Nov 2019 09:44:09 -0800 (PST)
Received: from desktopdebian.localdomain (x4d06663e.dyn.telefonica.de. [77.6.102.62])
        by smtp.gmail.com with ESMTPSA id m3sm34558580wrb.67.2019.11.20.09.44.09
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 09:44:09 -0800 (PST)
From:   =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>
To:     netfilter-devel@vger.kernel.org
Subject: [RFC 4/4] src: add ability to reset secmarks
Date:   Wed, 20 Nov 2019 18:43:57 +0100
Message-Id: <20191120174357.26112-4-cgzones@googlemail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191120174357.26112-1-cgzones@googlemail.com>
References: <20191120174357.26112-1-cgzones@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add the ability to reset secmark associations between the user-end string representation and the kernel intern secid.
This allows a lightweight reset, without reloading the whole configuration and resetting all counters etc. .

*TODO*:
Pablo suggested to drop this change.
Are the actual objects in the kernel not destroyed and recreated?
Or is this functionality useless?

Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
---
 src/evaluate.c     |  2 ++
 src/parser_bison.y | 12 ++++++++++++
 src/rule.c         |  6 ++++++
 3 files changed, 20 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 740d3c30..cebc33d3 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3982,8 +3982,10 @@ static int cmd_evaluate_reset(struct eval_ctx *ctx, struct cmd *cmd)
 	switch (cmd->obj) {
 	case CMD_OBJ_COUNTER:
 	case CMD_OBJ_QUOTA:
+	case CMD_OBJ_SECMARK:
 	case CMD_OBJ_COUNTERS:
 	case CMD_OBJ_QUOTAS:
+	case CMD_OBJ_SECMARKS:
 		if (cmd->handle.table.name == NULL)
 			return 0;
 		if (table_lookup(&cmd->handle, &ctx->nft->cache) == NULL)
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 707f4671..eb767547 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1375,6 +1375,18 @@ reset_cmd		:	COUNTERS	ruleset_spec
 			{
 				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_QUOTA, &$2, &@$, NULL);
 			}
+			|	SECMARKS	ruleset_spec
+			{
+				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_SECMARKS, &$2, &@$, NULL);
+			}
+			|	SECMARKS	TABLE	table_spec
+			{
+				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_SECMARKS, &$3, &@$, NULL);
+			}
+			|	SECMARK		obj_spec
+			{
+				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_SECMARK, &$2, &@$, NULL);
+			}
 			;
 
 flush_cmd		:	TABLE		table_spec
diff --git a/src/rule.c b/src/rule.c
index 4abc13c9..08b04827 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2539,6 +2539,12 @@ static int do_command_reset(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_QUOTA:
 		type = NFT_OBJECT_QUOTA;
 		break;
+	case CMD_OBJ_SECMARKS:
+		dump = true;
+		/* fall through */
+	case CMD_OBJ_SECMARK:
+		type = NFT_OBJECT_SECMARK;
+		break;
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
-- 
2.24.0

