Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4714DC433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Oct 2022 16:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbiJRQpz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Oct 2022 12:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiJRQpx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Oct 2022 12:45:53 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01464BCB90
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Oct 2022 09:45:51 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-1370acb6588so17468724fac.9
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Oct 2022 09:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XCVrKEATsseHTOohYEMzUrJyOg1Xj/l9Iy8OWT30pNg=;
        b=gGIf0o87M/YmGGJdSV0RacXcJb0wgLL2ooeeD7VQDauKaIyBO30boqq65k/NKZ3r8k
         vAR0f3v/FI9c6bGwld/rzlJUqF+EijtP07bICDTguLXxeqNNkeN7ynehclPij6VFX6Da
         Fk3kFYLxdrV4VxbMaCD5Pm7OsSc5GqOlxRiCSEVqwCrpSPUwE8m+q0x40T2E7RdmFYe4
         TiQ6OWR8XV62pr6uEd3JlUnVvgI5nIPiI3Lh89eUVH9W+Jw+ZBle0y4dsSNg7189k4sN
         +/rEwMofyOfn+8XtPDprfhDsnOJZRNkjgIbgPSmwJ+/2HJlxv3bjHQA8fwY/qq45zXcQ
         /rBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XCVrKEATsseHTOohYEMzUrJyOg1Xj/l9Iy8OWT30pNg=;
        b=hZvdY/2DY4srv5abCvvd1U5aI2mewGjD/RifWw4WxWX8WUG0OiMLVp6SNKOrAUwdQ8
         no3lJrTjb/mPTzNJ6nD35l3nC62VmCEsncQzRp92HRZpqbGUqXo+Cfu8WplkcIDz2jrC
         TjeSmjk8IwIPYxgqCBhfjOzIHEPZD7cwkYTwyyFX7MbYrAxmFGnzt4uuZHMHfPAZO5hS
         ICGG/3DW1L6zCD3WP239TjXynjLAr/t08Vc4M+HQcEQLVQuthKhuzK3MDPFm14O0Hs0Y
         IoiJwoxqiPbpzLLX7WhMa9eRNOuloEFy/2ONff5LDDJyARn+o5PzyBa24j5FSzJWtDWl
         rNjQ==
X-Gm-Message-State: ACrzQf0L4A8dX0AqsSxCZbTBgzQeZ6JCC6SeLlTbfGb7FIwwOxTRUWDK
        ABA1m2EwVM4sKzKfh+M0voMDbLJc8O8=
X-Google-Smtp-Source: AMsMyM5j7Wdtg4qdbsed22SPtfAaG7ehqpeoLrL5DnnyPmQot6qV5jqYgVL+g3L7NvF8GBtxvw4pOA==
X-Received: by 2002:a05:6870:c147:b0:136:90c4:ee84 with SMTP id g7-20020a056870c14700b0013690c4ee84mr2178908oad.295.1666111550444;
        Tue, 18 Oct 2022 09:45:50 -0700 (PDT)
Received: from ian.penurio.us ([47.184.52.85])
        by smtp.gmail.com with ESMTPSA id be36-20020a05687058a400b0012763819bcasm6356072oab.50.2022.10.18.09.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 09:45:50 -0700 (PDT)
From:   Ian Pilcher <arequipeno@gmail.com>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [RFC PATCH 1/1] libnftnl: Fix res_id byte order
Date:   Tue, 18 Oct 2022 11:45:28 -0500
Message-Id: <20221018164528.250049-2-arequipeno@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221018164528.250049-1-arequipeno@gmail.com>
References: <20221018164528.250049-1-arequipeno@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The res_id member of struct nfgenmsg is supposed to be in network
byte order (big endian).  Call htons() in __nftnl_nlmsg_build_hdr()
to ensure that this is true on little endian systems.

Signed-off-by: Ian Pilcher <arequipeno@gmail.com>
---
 src/common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/common.c b/src/common.c
index 2d83c12..08572c3 100644
--- a/src/common.c
+++ b/src/common.c
@@ -10,6 +10,7 @@
 #include <stdlib.h>
 #include <sys/socket.h>
 #include <time.h>
+#include <arpa/inet.h>
 #include <linux/netlink.h>
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
@@ -37,7 +38,7 @@ static struct nlmsghdr *__nftnl_nlmsg_build_hdr(char *buf, uint16_t type,
 	nfh = mnl_nlmsg_put_extra_header(nlh, sizeof(struct nfgenmsg));
 	nfh->nfgen_family = family;
 	nfh->version = NFNETLINK_V0;
-	nfh->res_id = res_id;
+	nfh->res_id = htons(res_id);
 
 	return nlh;
 }
-- 
2.37.3

