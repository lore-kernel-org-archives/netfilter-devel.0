Return-Path: <SRS0=dQkn=A4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DAE9C433E3
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jul 2020 16:25:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 297452065F
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jul 2020 16:25:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dq1U1O1K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbgGQQZI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Jul 2020 12:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgGQQZI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Jul 2020 12:25:08 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF89C0619D2;
        Fri, 17 Jul 2020 09:25:08 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id e11so9280509qkm.3;
        Fri, 17 Jul 2020 09:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Bgxlqmi2+F2aXisPWdaUIbUjIKEMc7nJuMVPpqp6z0c=;
        b=Dq1U1O1K0vuSFxJkkHmHOInamh0NUsS/68BH4CFYc+ccBa0v72VmFVXY38wU9ne0kz
         84CBUPHd09Cs85F0RJjYUWlFwFsQ216g8lLkK6L4RM2MDt+k23DyEG9gJKgsfn5mASez
         Cvhdt7aeLZ52QAq5FJId/uj+8zFNtPmIA3i1LW7MYjoZu00u6aybD3w/rilJOZeVFiPl
         bAqyGRf5CNQPG4CnHq9bVzVOIL4inW7F/taOfwg2h0bqxa1cayk2o18+MTXwBUPewyHP
         gabcBuuYIuslbAaSt8+M07RNbCi4ORAbZ8GIKwrNcIiQbm1oDZqlkNbkHI9mk+FcCUgB
         dBCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Bgxlqmi2+F2aXisPWdaUIbUjIKEMc7nJuMVPpqp6z0c=;
        b=fv15/TBL5yUYjbCKqVCK7ik/7pKUe9b6XhxZurAXhtWmeAtUwnyYnHpTNVk2oVPGCI
         PGv2VU9GdWuLj0IgM8Gf/1MMbkTnYmkXqRmkYaQZKcQMS6whAqqZWCv9rOUMRtH04rQG
         djqdlFVcfpqu4/+kWmFeMm5X0qbXntm5H8M5GTJkMBkG1cU+LehNlAxHO+jshG+Fw6MC
         6t/Isjt5HqsLvs/jTC2FcReyBxCd9ohBYiyHlwyXISJD+pcjkbyUjuWMKiTwzQc0jP08
         nzHGRC2/lAeLNxCYlTrvVEz0Tc2FX18IZckT2tg2NCT0J64t3QoJNGm+tk8RYCDQgyzX
         1YDg==
X-Gm-Message-State: AOAM530Dtlmy/+QF0k9XOhJU0wh3NxXh4UtsdtkYIO8s7T+GZ+SrSZPa
        ZOC8AKF3xfQm9MmTtXDYEHY=
X-Google-Smtp-Source: ABdhPJxpuQte05hxE6BYCg0vddjtc7fOKQ/xjZLrRhcjSorY8vbs8i1jkB6RK7hJ1tBdW4atb8YlRA==
X-Received: by 2002:a05:620a:120e:: with SMTP id u14mr9724694qkj.147.1595003107617;
        Fri, 17 Jul 2020 09:25:07 -0700 (PDT)
Received: from T480s.vmware.com (toroon0411w-lp130-02-64-231-189-42.dsl.bell.ca. [64.231.189.42])
        by smtp.googlemail.com with ESMTPSA id g4sm10817526qtp.89.2020.07.17.09.25.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 09:25:06 -0700 (PDT)
From:   Andrew Sy Kim <kim.andrewsy@gmail.com>
Cc:     Julian Anastasov <ja@ssi.bg>, Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Andrew Sy Kim <kim.andrewsy@gmail.com>
Subject: [PATCH] ipvs: add missing struct name in ip_vs_enqueue_expire_nodest_conns when CONFIG_SYSCTL is disabled
Date:   Fri, 17 Jul 2020 12:24:50 -0400
Message-Id: <20200717162450.1049-1-kim.andrewsy@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Adds missing "*ipvs" to ip_vs_enqueue_expire_nodest_conns when
CONFIG_SYSCTL is disabled

Signed-off-by: Andrew Sy Kim <kim.andrewsy@gmail.com>
---
 include/net/ip_vs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 91a9e1d590a6..9a59a33787cb 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -1533,7 +1533,7 @@ static inline void ip_vs_enqueue_expire_nodest_conns(struct netns_ipvs *ipvs)
 
 void ip_vs_expire_nodest_conn_flush(struct netns_ipvs *ipvs);
 #else
-static inline void ip_vs_enqueue_expire_nodest_conns(struct netns_ipvs) {}
+static inline void ip_vs_enqueue_expire_nodest_conns(struct netns_ipvs *ipvs) {}
 #endif
 
 #define IP_VS_DFWD_METHOD(dest) (atomic_read(&(dest)->conn_flags) & \
-- 
2.20.1

