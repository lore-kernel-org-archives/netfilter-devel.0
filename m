Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21EFBC43334
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jun 2022 18:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbiFWS4h (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jun 2022 14:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236871AbiFWSqq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jun 2022 14:46:46 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F474EF4E5
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2022 10:50:24 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id ej4so32684edb.7
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2022 10:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RsMjAHkfOPJoLOQZ18XT5Gb1zQhOmdcdXQ9wXZ9JUjg=;
        b=MRwHvWfS6eIVzRHK+DjEEB9FD/98kMuWf6pqrt86otY1XfNrNprFi6BljWyqtRqh3z
         JDLSW43Iht/Wr4A5Al/+lN7AKxv1ze7pUi2cvLN6Hu/ReOEzmkuem5M9c5Lu4SaizWFS
         R62gLjVOccq3SVB8TIPWLwdaWQSdPi5XUYT6R7OEANloG68Jtu6P6ilE/VeVjJ+XisOi
         E7VrjIbbXgxi/0TtJy6QFw5K0asxyjTaYtEpVr+d2xv+uxpj5unCPorWC+hlGsClXNYy
         bIqwZm6iBrIqcXxseO5MY8wbycsvC8RYeEdo0NjPXcBnqyNsEaUsUlOCWr+Yk9JB6dKU
         odCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RsMjAHkfOPJoLOQZ18XT5Gb1zQhOmdcdXQ9wXZ9JUjg=;
        b=McrBALuot9JVu7xNvXOiZwsuSzjSu+2jvu8PAstVU2XdWnFQEY3gWys9Vul1rT04cz
         h48NSpgjkFvbxaJI6t2hrWFqBhqSSQ9XpsQMKuNiWmQny4AzPechd7P+y2PIt5rX/CJn
         Ev3VCrVyfMBqjWfggB2wgBf7+Pf0+KgfHTERtqYuzddERzeuYwne0Br63OyPdX3UDe2H
         wMIJLkVwyRR2I5HOjhSUV9t/tesBNVCa7tY1BuiZp9echFQYoiK2/ECSsd1WhHEkUpoo
         HiVbjKDTObpVZQxU0ZCYfJhbzgw5ZjhgRT9n15RnPRwWMoYBjr9EfCmXT7rGPRt1IJ5Z
         +RkQ==
X-Gm-Message-State: AJIora+MAE/sNOErZfD8AgliHSpv0Fsc4xGMct+mTP9slk9Ar+dA4BSL
        qaa+HafKeLtzLZdH45NGYDHws7z52pGljg==
X-Google-Smtp-Source: AGRyM1uryYCLOf0Hz6+BTLMArimLU9YL+gE2987rtxzLHEwH1+8v5LIis87ArjaJpptzqpnBbZVH/Q==
X-Received: by 2002:aa7:c7c4:0:b0:431:75d6:6b3 with SMTP id o4-20020aa7c7c4000000b0043175d606b3mr12123549eds.280.1656006621641;
        Thu, 23 Jun 2022 10:50:21 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bf48a.dynamic.kabel-deutschland.de. [95.91.244.138])
        by smtp.gmail.com with ESMTPSA id o9-20020aa7c7c9000000b004356e90d13esm119891eds.83.2022.06.23.10.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 10:50:20 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH 1/6] tests/conntrack: ct create for unknown protocols
Date:   Thu, 23 Jun 2022 19:49:55 +0200
Message-Id: <20220623175000.49259-2-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220623175000.49259-1-mikhail.sennikovskii@ionos.com>
References: <20220623175000.49259-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Testcases covering creation of ct entries of unknown L4 protocols,
which does not work properly at the moment.
Fix included in the next commit.

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
---
 tests/conntrack/testsuite/00create | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/tests/conntrack/testsuite/00create b/tests/conntrack/testsuite/00create
index 911e711..9962e23 100644
--- a/tests/conntrack/testsuite/00create
+++ b/tests/conntrack/testsuite/00create
@@ -34,3 +34,30 @@
 -I -t 29 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
 # delete icmp ping request entry
 -D -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
+# Test protocols unknown by the conntrack tool
+# IGMP
+-I -t 10 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 2 ; OK
+# Create again - should fail
+-I -t 10 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 2 ; BAD
+# repeat using protocol name instead of the value, should fail as well
+-I -t 10 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p igmp ; BAD
+# delete
+-D -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 2 ; OK
+# delete again should fail
+-D -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 2 ; BAD
+# create using protocol name instead of the value
+-I -t 10 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p igmp ; OK
+# update
+-U -t 11 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 2 ; OK
+# delete
+-D -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 2 ; OK
+# delete again should fail
+-D -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p igmp ; BAD
+# take some protocol that is not normally not in /etc/protocols
+-I -t 10 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 200 ; OK
+# update
+-U -t 11 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 200 ; OK
+# delete
+-D -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 200 ; OK
+# delete again
+-D -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 200 ; BAD
-- 
2.25.1

