Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5CAEC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jun 2022 18:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiFWS4R (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jun 2022 14:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237553AbiFWSrF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jun 2022 14:47:05 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A70F0179
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2022 10:50:38 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id lw20so20302005ejb.4
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2022 10:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v9s2qeuAZ1uw2lNqLXUaPb67nfl1t1dQNUBrFsgBcSI=;
        b=TUstiTg3arw41YKCji21RVXnfDB7R12hP0uIHLAARxiMtG6ByxH5lktxJs6zf8Whqq
         4zwuChNcXOYqo74use/sju5fWz1/JOjdVoprXbi4JZXfScXDF4mbk2a8PCLCFlSAcTyt
         abPaxO4sI4Nd1UtDmYfT+5UZ0lfkH2RwdWWS0znE6+kbv7+YeTLn1JKT6y3ZaEHaheiO
         2KBpqOBbkLL24p0milqZ28yzhXI3W1csC+mgJQ6McrqjVqVNQHZpcgG0Ob+NLSYNJxZQ
         +I+vavUavy83YWZrngMXzvf8sFJl6B7wn8W7mDpG2XZEffHkiUhIYVSoD3ry/sSN9kZw
         62BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v9s2qeuAZ1uw2lNqLXUaPb67nfl1t1dQNUBrFsgBcSI=;
        b=G844DsIZ/wqQ7xYGuCt0SACmot2wPKkFl32UZpNtbP4IaM3YyF/apT95J3TbBnbAHT
         8WMyCubCgXj4HBm3CYI3Yeu7pQCyaijb76OtGGjh01kTvi1On8hSLvSXzVli0MOtSzdh
         V2ds36TojltslCXd6g5uqar1M1ThduGUR1mVUBdvrCFYkSDKHcsDtiEYw3PtSO/MTtX9
         skf5fZNn+r+fovpWyHcov5xF5Q3mVdoZemHiu9Aeg0i+mY3GvZllM3JckuBmgnbClm6G
         IMjJuPZa84Ng3sVLb6Lphz1hD0rAEJ9HuOuJWpD0EovTexkbEGp68jlKGOuK4a7X5sHp
         xWcg==
X-Gm-Message-State: AJIora+QfjHHW6d1tCfXc77KuTyvtekN5PxF4e/1ui6z+u+IGJvBOyGt
        IGH7TNYwLppzLn2Qt+UJBQ53r72KRYvMiQ==
X-Google-Smtp-Source: AGRyM1uAj3vZL6dGaud+j7Pd758v9WgTKNZhaqh1yajVyGE7KIIt/7rSQEU7DdjisjHz7sJylfYvjg==
X-Received: by 2002:a17:907:80ca:b0:70f:77fd:cfbd with SMTP id io10-20020a17090780ca00b0070f77fdcfbdmr9280322ejc.82.1656006630319;
        Thu, 23 Jun 2022 10:50:30 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bf48a.dynamic.kabel-deutschland.de. [95.91.244.138])
        by smtp.gmail.com with ESMTPSA id o9-20020aa7c7c9000000b004356e90d13esm119891eds.83.2022.06.23.10.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 10:50:29 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH 5/6] tests/conntrack: ct -o save for unknown protocols
Date:   Thu, 23 Jun 2022 19:49:59 +0200
Message-Id: <20220623175000.49259-6-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220623175000.49259-1-mikhail.sennikovskii@ionos.com>
References: <20220623175000.49259-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Testcases covering dumping in -o save formate of ct entries of
L4 protocols unknown to the conntrack tool,
which does not work properly at the moment.
Fix included in the next commit.

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
---
 tests/conntrack/testsuite/09dumpopt | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/tests/conntrack/testsuite/09dumpopt b/tests/conntrack/testsuite/09dumpopt
index 447590b..c1e0e6e 100644
--- a/tests/conntrack/testsuite/09dumpopt
+++ b/tests/conntrack/testsuite/09dumpopt
@@ -145,3 +145,29 @@
 -D -w 11 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
 # clean up after yourself
 -D -w 10 ; OK
+# Cover protocols unknown to the conntrack tool
+# Create a conntrack entries
+# IGMP
+-I -w 10 -t 59 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 2 ;
+# Some fency protocol
+-I -w 10 -t 59 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 200 ;
+# Some fency protocol with IPv6
+-I -w 10 -t 59 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p 200 ;
+-R - ; OK
+# copy to zone 11
+-L -w 10 -o save ; |s/-w 10/-w 11/g
+-R - ; OK
+# Delete stuff in zone 10, should succeed
+# IGMP
+-D -w 10 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 2 ; OK
+# Some fency protocol
+-D -w 10  -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 200 ; OK
+# Some fency protocol with IPv6
+-D -w 10 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p 200 ; OK
+# Delete stuff in zone 11, should succeed
+# IGMP
+-D -w 11 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 2 ; OK
+# Some fency protocol
+-D -w 11  -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 200 ; OK
+# Some fency protocol with IPv6
+-D -w 11 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p 200 ; OK
-- 
2.25.1

