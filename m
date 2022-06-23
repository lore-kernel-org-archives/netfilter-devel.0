Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB016C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jun 2022 18:56:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbiFWS4U (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jun 2022 14:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237500AbiFWSq7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jun 2022 14:46:59 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484D6EFD71
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2022 10:50:31 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id pk21so19522504ejb.2
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2022 10:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M157kvxsyRWIFGV5imwA0YPTENMZr0VOo7Kmxd929+I=;
        b=KE4TQDe4azOe7amLvFfYgEBZZkxepAV01IxRPbjPnX9EDuaThRdmtgSEjBE7HFdD+t
         0x5saVkiWfz+O9ZuyLiZrMeK1tgAdYMAWWgu7EmZJwEv6ZiTp3gv2kxzkUHA9Ky0HaJH
         872Z0QDK+dKgA22sFhi/d29Ea3e5fdxmFzcTUPzrn6/sqhMv43R+vOH72qXryh72uvjp
         dlgW4UUJatblpaLw2BeNPJbPzxgNEC82DbYYDBLB0QlhYgJfiz9RBMZ/7FndEWyKlloB
         gEb8PT/mWc+VdaeSMIVY9Wr2rH//wTUyqTt4krH4tEsdA7n4XAY8v0jwbHJ0oATjPfWa
         PEVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M157kvxsyRWIFGV5imwA0YPTENMZr0VOo7Kmxd929+I=;
        b=4DIQXu6zJIM9p1H0l09qs2pltWq8NjEOXwSUKFyW9PBB8+zAbsp9oD13tsU1Y3QYZu
         dxF7JuKPC8ugP3cYP+wU4ZGwbFBPfLuYgkmVQLjjgaLMas1zbB+t3jJkyhw1hbSUpSov
         Y9pnjHKGGULTC5H3OJcrrq54tXj7U3D4y6qBiq95xOxxtFB7BmNY+uaJ7HGi4JAGO39P
         /sG2Vu1fA4QrJlRTJ3QZusX7GSLvTwqbpdLdbX2xJw1XWlsY4XBiLGAS0yASZoBwibRB
         4GnJGqlK63MCnsNSkRXiY+TfmsMZADyIlfCyZXXKh7i/iiYGhcDcZfCLPxGFaSI7lKKW
         1P3Q==
X-Gm-Message-State: AJIora/D+p5npyARB9cEGRkyoTYFYkdePOZ/AWn279SS2MjaQ52bU2jm
        DwhEXzkJPTDxLeQ/e48B80flyWY+1VtjQA==
X-Google-Smtp-Source: AGRyM1txFQIlAYKoH+UvMhmkVmukAZ/SbZW43nI5hlYtuwqKJfh3IXpwOMvO91V9Bx5Lsm9MjTEFDA==
X-Received: by 2002:a17:907:720e:b0:722:df77:f24e with SMTP id dr14-20020a170907720e00b00722df77f24emr9135113ejc.165.1656006625072;
        Thu, 23 Jun 2022 10:50:25 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bf48a.dynamic.kabel-deutschland.de. [95.91.244.138])
        by smtp.gmail.com with ESMTPSA id o9-20020aa7c7c9000000b004356e90d13esm119891eds.83.2022.06.23.10.50.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 10:50:24 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH 3/6] tests/conntrack: invalid protocol values
Date:   Thu, 23 Jun 2022 19:49:57 +0200
Message-Id: <20220623175000.49259-4-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220623175000.49259-1-mikhail.sennikovskii@ionos.com>
References: <20220623175000.49259-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Testcases covering passing invalid protocol values via -p parameter.
* -p 256 should fail
* -p foo should fail
which does not work properly at the moment.
Fix included in the next commit.

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
---
 tests/conntrack/testsuite/00create | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tests/conntrack/testsuite/00create b/tests/conntrack/testsuite/00create
index 9962e23..9fb3a0b 100644
--- a/tests/conntrack/testsuite/00create
+++ b/tests/conntrack/testsuite/00create
@@ -61,3 +61,8 @@
 -D -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 200 ; OK
 # delete again
 -D -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 200 ; BAD
+# Invalid protocol values
+# 256 should fail
+-I -t 10 -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p 256 ; BAD
+# take some invalid protocol name
+-I -t 10 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p foo ; BAD
-- 
2.25.1

