Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 695B0C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Feb 2022 14:01:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234720AbiBXOBr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Feb 2022 09:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233253AbiBXOBr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Feb 2022 09:01:47 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFF728ADA1
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Feb 2022 06:01:17 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id p15so4544543ejc.7
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Feb 2022 06:01:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LkQOwcuda5tVFp2FrqlXme8jaqeMJ/8MYD4EyBoe+zc=;
        b=iUgU8jNNuEpAS/W3TBE2cCSQBCuwcmr83E/7u1eqYxAslAQ9QkqF8rAwAq4ptOJDI5
         0+K9cv1U7HrQEe7q0kZiDO9d2nNRrNYx1hpc7uaAR7PjgsmTQoOdsvBEWUpMXZjsQ2z5
         5mk9Y32U1UxiIFX54zgzLBmHBAAjD8xmT1gC9JLf8n/+05UlwxCYj7gvX+XkFy8RZXBa
         JkEmpNd+nMEYpACYDtO0CG+TCl3RRcWVs4ZtIEkV7/6II30wBJAgu33rKkRWBOJcNgUj
         1Hz2gX6y7zLTgJmd8TPPfwllDGGn9Ewl6TajHSsjVKhrP4mmcSflQQIFEudVICwWm5DU
         hYDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LkQOwcuda5tVFp2FrqlXme8jaqeMJ/8MYD4EyBoe+zc=;
        b=zv4MYY6rTzLqp/3lZqvOjWbiRw/I6z6w3V7ce78KOgk6OQTPBe7qaKvLqrIEpJBa1W
         gVDCdOry5nsoa8xhDIQ3Eb9A0IODbKHSN/uZSrQ60w3wVVhptbJo29tc3xr9VuuAEAjE
         Zn7qtjNgi5VGRMtwrmesr9WNmOLKWBlxpIuxjuDywujZBv1vUqdqRUH0+y4NbTaMigwJ
         xZlrnkct4ixMfdVzcwJRKRwKLWLsrVbdYhandRUvaq6/fcFS4u6p3c/ISNL3bSUXThyi
         azb/cXhHUPZNqBb1vPw9g/EcqO6SV+98AIWuSo7HvJd6zsibAj0k6GiG4e0lKm1FS+/t
         GmLw==
X-Gm-Message-State: AOAM530EE94+t4N7NtbUxyF/GeMfgHbRP971LQv1yMyQuXhCI/3NY9ez
        VIkBjVUk09T0ZRpd7lF12dZornpLr2PXMA==
X-Google-Smtp-Source: ABdhPJzu5ce4F2s6q3t8Y+lC1k+NlEzFzXQ3zayICj9wq8DxBYKoAz7a8ly2WHGO+f3B7RKfrDHnzg==
X-Received: by 2002:a17:906:1393:b0:6ba:dfb1:4435 with SMTP id f19-20020a170906139300b006badfb14435mr2514297ejc.736.1645711275454;
        Thu, 24 Feb 2022 06:01:15 -0800 (PST)
Received: from fedora.robimarko.hr (dh207-99-93.xnet.hr. [88.207.99.93])
        by smtp.googlemail.com with ESMTPSA id a7sm1382248ejc.46.2022.02.24.06.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 06:01:14 -0800 (PST)
From:   Robert Marko <robimarko@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Robert Marko <robimarko@gmail.com>
Subject: [PATCH v2] conntrack: fix build with kernel 5.15 and musl
Date:   Thu, 24 Feb 2022 15:01:11 +0100
Message-Id: <20220224140111.2011488-1-robimarko@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently, with kernel 5.15 headers and musl building is failing with
redefinition errors due to a conflict between the kernel and musl headers.

Musl is able to suppres the conflicting kernel header definitions if they
are included after the standard libc ones, however since ICMP definitions
were moved into a separate internal header to avoid duplication this has
stopped working and is breaking the builds.

It seems that the issue is that <netinet/in.h> which contains the UAPI
suppression defines is included in the internal.h header and not in the
proto.h which actually includes the kernel ICMP headers and thus UAPI
supression defines are not present.

Solve this by moving the <netinet/in.h> include before the ICMP kernel
includes in the proto.h

Fixes: bc1cb4b11403 ("conntrack: Move icmp request>reply type mapping to common file")
Signed-off-by: Robert Marko <robimarko@gmail.com>
---
Changes in v2:
* Add the forgoten fixes short hash
---
 include/internal/internal.h | 1 -
 include/internal/proto.h    | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/internal/internal.h b/include/internal/internal.h
index 2ef8a90..7cd7c44 100644
--- a/include/internal/internal.h
+++ b/include/internal/internal.h
@@ -14,7 +14,6 @@
 #include <arpa/inet.h>
 #include <time.h>
 #include <errno.h>
-#include <netinet/in.h>
 
 #include <libnfnetlink/libnfnetlink.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
diff --git a/include/internal/proto.h b/include/internal/proto.h
index 40e7bfe..60a5f4e 100644
--- a/include/internal/proto.h
+++ b/include/internal/proto.h
@@ -2,6 +2,7 @@
 #define _NFCT_PROTO_H_
 
 #include <stdint.h>
+#include <netinet/in.h>
 #include <linux/icmp.h>
 #include <linux/icmpv6.h>
 
-- 
2.35.1

