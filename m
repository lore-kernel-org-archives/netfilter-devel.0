Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8024DC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Feb 2022 13:57:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbiBXN6A (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:58:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235275AbiBXN57 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Feb 2022 08:57:59 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0CA12F42F
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Feb 2022 05:57:29 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id lw4so4470838ejb.12
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Feb 2022 05:57:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=peEgInjc19eyOB70wnDgLUXOJ+3KkffNVYXhDGneFPA=;
        b=eutUhly5M6WrQndzfq+VsgAORzvcBY/px160Rw47P2wGLVrCYNdFio+2Rli+EuTfqZ
         Zt38HEyiBGwdCI01x4cm+cJJ9gSG7c+gc/9xqKYlVz3VZ/sxB42uJCzuWb4xWLo8w4a9
         c5W+D3xqxhhXlOrd1R/FOYfyn6s+fEGXjfjPjLtghHAVwOVRAei0DStNYbt9W+Dsra8L
         aNqer7KD/nckMWwjkE80QHP55ra1F2L4kKSPtuCyuYQa0FPCyslN/IJ/1SAH2Ig4QTGg
         Bvl8mZsSTbu360rDYPvhfDOkVjcJJRBqdzT2P8zi4nuyDyVDycMtEkgDNN30XdAQACls
         anjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=peEgInjc19eyOB70wnDgLUXOJ+3KkffNVYXhDGneFPA=;
        b=6ftktCHzBb5dyBQ19Q90NzLuwxIZPVnVgB9krpdcofWEWSxfpz3fy4WzTZWhM4pNOR
         r/09ylyzGLCQDVIe5BkRQdl//MZwlIawgv0rs39r4SvnHlF2Pxs+tsAH8F5raE8ChNRB
         /A39j4pHB9ewM4+rArj+hx8inUFHThOMTdkWfCdV3Sb4/iUWEH2l9jfHYnyQLHqH9Z1o
         wsGM5aZ4RZpbLhcKYhxrGfaqDEvyzGd9Hqi7XQPu+tRmQH2eZIf10wM1qZ0knD9UF68B
         E0x5TEudUV69na6IHc71aufMvpsgWcxpP2TM+QQCiNetKva0anJH3r97q2qrQQmA3s8W
         kVKQ==
X-Gm-Message-State: AOAM532GKURd+wFkboXkf1BqJboF1/RyYa+EbzhlyjAzRusMwTvO1FHI
        Pe6UjsUvDSYLW+5TO0WxkVSCrpvSp1lyGg==
X-Google-Smtp-Source: ABdhPJxAp+4WEg8oc3HdZkZu+XOG1PaLRbaeL5We01l2n7M4kMri6FqX6vHendXRf9CqLskWxO23Gg==
X-Received: by 2002:a17:906:27db:b0:6ce:6f8:d0e3 with SMTP id k27-20020a17090627db00b006ce06f8d0e3mr2369671ejc.455.1645711048013;
        Thu, 24 Feb 2022 05:57:28 -0800 (PST)
Received: from fedora.robimarko.hr (dh207-99-93.xnet.hr. [88.207.99.93])
        by smtp.googlemail.com with ESMTPSA id m18sm1420953eje.145.2022.02.24.05.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 05:57:27 -0800 (PST)
From:   Robert Marko <robimarko@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Robert Marko <robimarko@gmail.com>
Subject: [PATCH] conntrack: fix build with kernel 5.15 and musl
Date:   Thu, 24 Feb 2022 14:57:19 +0100
Message-Id: <20220224135719.2010499-1-robimarko@gmail.com>
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

Fixes:  ("conntrack: Move icmp request>reply type mapping to common file")
Signed-off-by: Robert Marko <robimarko@gmail.com>
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

