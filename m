Return-Path: <SRS0=/ozj=TY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA739C282E1
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 18:50:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 825E821848
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 18:50:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uvuYJL/L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbfEXSuH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 May 2019 14:50:07 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35882 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728920AbfEXSuH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 May 2019 14:50:07 -0400
Received: by mail-pf1-f193.google.com with SMTP id v80so5833970pfa.3
        for <netfilter-devel@vger.kernel.org>; Fri, 24 May 2019 11:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NOVfu/VlcXbB+ctNFJruU6wG9jt1ij+UNgu5ZM/ZIA4=;
        b=uvuYJL/LUWnTkLSPXOqW01eDM55/wDVpU3idrwfst8eqgUHNBI+6gAvsJe+V+jlzKH
         Yfcw5yFFFUEjXDpelUGSnmaKtEaKjG0GU17TwC5ViuxI4X8MdSa4s+vsgZvRjxUiXQhj
         8llL/jU1eiT0QKzR1cgd6vSbh4sfUBrWMU2X1nN4ViPxhxINKjV6tFXWIcrstTritBDI
         ZFCnT/sA3hjm9C/ofcHh3BktWk1ht4TtYBF7xlkMxU6Z/DzePlLsZEea7xVjK6JhnSF1
         9BwCQev4Y+EYYz/z2L2JJdsNnHxtsabOfAfqImZi/bdIBWzE5eS01EDfPk1X2FK3C7Xj
         I/rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NOVfu/VlcXbB+ctNFJruU6wG9jt1ij+UNgu5ZM/ZIA4=;
        b=cUAm0ERUjJ/haT41T+Gzzd6e+NuTBlQLpmUedvXq9CX4RPvpFvdeWcWbF+o4OrqzsA
         o9M807ZXgq1ozQBpxouTYdo8cwZrh8Y1l53p1ctrQUxTZwA8n5URkQRCXGco4ArhM8Mp
         mHTVX+RB4gCFmrB2xnfQYiIraBaOF6piR6hmlWcnHZ9H9bbta5uKYCJbYI/iYmvKDFhn
         0NnYixap7puegZaMlLElpi4YOMj6fGvwk8jd1o5i7c3IpefEEMoP+cgY9V0NhFqjFkz9
         Z1VWdzJ5CuMyg168PxSCx5NSqua14gXykg2qM4NAucR+az0pk7gM1HwEvwFe2Kq70spd
         5iAg==
X-Gm-Message-State: APjAAAX4MAZmgXbreTrDRSg1NXrJBqVTNBQPipF2Iboeyj1yoIWnsJag
        sM7iONwxF5VmK5PJsLSB7tBKPVGH/A4=
X-Google-Smtp-Source: APXvYqw1ZlS/vrbDzu5gqdXhUs9mJThHdzLiozUDoB1WwQdJmhpNaBkjxc4/DndVtvEuxu5mQu6gwA==
X-Received: by 2002:a63:eb50:: with SMTP id b16mr32618701pgk.150.1558723806001;
        Fri, 24 May 2019 11:50:06 -0700 (PDT)
Received: from localhost.localdomain ([2405:204:e08c:113f:983f:2b22:f507:ea96])
        by smtp.gmail.com with ESMTPSA id a11sm3418395pff.128.2019.05.24.11.50.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 11:50:05 -0700 (PDT)
From:   Shekhar Sharma <shekhar250198@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Shekhar Sharma <shekhar250198@gmail.com>
Subject: [PATCH nft v1 ] py: nftables.py: fix python3
Date:   Sat, 25 May 2019 00:19:50 +0530
Message-Id: <20190524184950.468164-1-shekhar250198@gmail.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch converts the 'nftables.py' file (nftables/py/nftables.py) to run on both python2 and python3.


Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
---
 py/nftables.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/py/nftables.py b/py/nftables.py
index 33cd2dfd..badcfa5c 100644
--- a/py/nftables.py
+++ b/py/nftables.py
@@ -297,7 +297,7 @@ class Nftables:
         val = self.nft_ctx_output_get_debug(self.__ctx)
 
         names = []
-        for n,v in self.debug_flags.items():
+        for n,v in list(self.debug_flags.items()):
             if val & v:
                 names.append(n)
                 val &= ~v
-- 
2.21.0.windows.1

