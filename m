Return-Path: <SRS0=ZPzN=Z6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A706AC43603
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Dec 2019 09:27:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E8C520637
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Dec 2019 09:27:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jbH52F/q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbfLHJ1B (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 8 Dec 2019 04:27:01 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:35578 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfLHJ1A (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 8 Dec 2019 04:27:00 -0500
Received: by mail-lf1-f66.google.com with SMTP id 15so8441019lfr.2
        for <netfilter-devel@vger.kernel.org>; Sun, 08 Dec 2019 01:26:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q+6Qbrb69LfyvJ7usaj+313XMR1Ak9GsMBLkaSYfQGU=;
        b=jbH52F/qvM+dbY2CU7OrMyE8drs1xTonU1xojC/bzeSUEuYLeB2Hlwxb3zms9wy8f0
         LzJqHsRG3B/iPqVMfIvR9S9JOCEbh1z2vieQ8i6FtRtykVO/LwFrNa3tufXZCGrwI3hs
         SVuvwThmiMSinWeWmEPSEYq+A6HFw6TBUosmwhZfpe6kmSM4SlTvR37yFoDZj6Gx4iJR
         skHpDAqoG1gWIoGy4NkLA+ZkDlf87MnVSS8SDO9q1SSHugfkoCaucgM9pDYSSPwyRd8U
         GCy9j0Yx1Yla2LIJWSr4Wh5ElIogdAxDzsjPHrSwfvUDJgI/WtOTE4aM14hyw5ZA48dl
         hmvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q+6Qbrb69LfyvJ7usaj+313XMR1Ak9GsMBLkaSYfQGU=;
        b=HtEhMuB71xgVd1IsvnI5bc6YWZgdCPZM4Use0I0/Qw6KtVNFxjsI4WM5xUtRFJGqaD
         WhRIBCJqXCkYKp2FNmP+IZkkSDgyJK1kLtSYYYJ9+nyJeWN2a+MArZezMClHeePN4kO4
         3cF9LGuhiLdb83ThNzSE1NMR80t6WabodcNIxF3X/LeBXx8UrpkYE2AJGNCHTP9lcFKc
         1f6bgYOaTbgKcw6EtKatdGAuNLWbZFdZkPD6LZSq/bZk4heIrcgLFgpSdiuAX4M95JEU
         4v1ag5QO8LsVecB6Qc+RNz9f790A9w839aM9el9/fxpFE5I1oi0m+pCSr9qNmag3k0XL
         kTmw==
X-Gm-Message-State: APjAAAU5gTHp97DIXVbHBRpb8SbuD9ymwcChvl4osJkTKBOgA5AZPlUU
        LOcAFXOWbYWDo40GRKwBn/lNY41Z
X-Google-Smtp-Source: APXvYqzlYxIHOM3tfyfO2QEmPz02qoBmGe5BML8luTPpvur+xAFAJbaFeKZR3WBc7cStO97K+dM6Rw==
X-Received: by 2002:a19:c80a:: with SMTP id y10mr688531lff.177.1575797218897;
        Sun, 08 Dec 2019 01:26:58 -0800 (PST)
Received: from walnut.lan (balticom-231-46.balticom.lv. [83.99.231.46])
        by smtp.gmail.com with ESMTPSA id r23sm788037ljk.53.2019.12.08.01.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Dec 2019 01:26:58 -0800 (PST)
From:   nl6720 <nl6720@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     nl6720 <nl6720@gmail.com>
Subject: [PATCH nftables] doc: Remove repeated paragraph and fix typo
Date:   Sun,  8 Dec 2019 11:25:58 +0200
Message-Id: <20191208092557.14536-1-nl6720@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: nl6720 <nl6720@gmail.com>
---
 doc/primary-expression.txt | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/doc/primary-expression.txt b/doc/primary-expression.txt
index 5473d598..16324286 100644
--- a/doc/primary-expression.txt
+++ b/doc/primary-expression.txt
@@ -305,13 +305,7 @@ If no route was found for the source address/input interface combination, the ou
 In case the input interface is specified as part of the input key, the output interface index is always the same as the input interface index or zero.
 If only 'saddr oif' is given, then oif can be any interface index or zero.
 
-In this example, 'saddr . iif' lookups up routing information based on the source address and the input interface.
-oif picks the output interface index from the routing information.
-If no route was found for the source address/input interface combination, the output interface index is zero.
-In case the input interface is specified as part of the input key, the output interface index is always the same as the input interface index or zero.
-If only 'saddr oif' is given, then oif can be any interface index or zero.
-
-# drop packets to address not configured on ininterface
+# drop packets to address not configured on interface
 filter prerouting fib daddr . iif type != { local, broadcast, multicast } drop
 
 # perform lookup in a specific 'blackhole' table (0xdead, needs ip appropriate ip rule)
-- 
2.24.0

