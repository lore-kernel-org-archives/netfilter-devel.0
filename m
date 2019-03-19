Return-Path: <SRS0=OoGW=RW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 042FEC43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Mar 2019 11:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C941C20857
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Mar 2019 11:10:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nY6Br7tF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbfCSLKD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 07:10:03 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:41703 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbfCSLKD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 07:10:03 -0400
Received: by mail-pg1-f171.google.com with SMTP id k11so13597777pgb.8
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2019 04:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-description
         :content-disposition:user-agent;
        bh=wlMVfqV8KunmahLFkvw7ntgZKfN6GlPoWxCUjO7AFE8=;
        b=nY6Br7tFL0wJF2HdtYFkrZLWZC9zn8+y6unZBbJdITIDDO7LjtejkRdzuOBv3y0m0W
         395OL23fiqodENWY94rRXRqMgdCJMKYq2GyTluXw2BsrL0PQGveEt49w6j3rQId1Mqb5
         vEd72Mm9w4uKuB5qS4PnIBbst1ZLfZtujyLDkhgPLdhmF3zCoEJE1fQP1Hczznv6IC21
         CC/JLSxMSwb6jM6X5ZhgdoSHbysTEbo1JhSMq1pbAR1xvyEUribo0oBiGk+Z0yLOE7ki
         lolCtp0ILfgsgHHj1sjl/Ag6FgixL09OQkwzA75rEpmDZhISSMo7tb4nOOQ0PgKOtN7x
         0B6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-description:content-disposition:user-agent;
        bh=wlMVfqV8KunmahLFkvw7ntgZKfN6GlPoWxCUjO7AFE8=;
        b=WXcDgTkXqMRiq5M1nrq4RfZ1n2GgKVe1uVIr34DCMHQUiWbG62EPnB0e8Ze3GocdXI
         T6jUQWjCrayorfZF9kFQXJ8f54n73/CxA3y1+i+aHkK8YwVN1xjVkJOb7HRLz7f/sYto
         IBT7xk939CYb3MLRaOPGwa16LPt4cSG9s6YA55WJD+qvzyadVz1uMy2ZOoyzJMbvH9uI
         dztpC1H5jJXa+rTM/hR56YEBaLCRgdQrPHY2SDmZmUiDSBlF0MtILO7h5kTOnAUNAsRv
         rtVeC9QeEGlaEyfOZVE+qRwUjMETyvW8e4WY1V3WfkKzHfih4q9PT8t8Fse/pgwABiJq
         G6dA==
X-Gm-Message-State: APjAAAVO2ZwT/JI6VkaCnal20Tlm7BJvx+Nm3BrCVBpTBsCYRR8eRemp
        J6CJ1Bpv9j2IZV8PQiW/eLQ=
X-Google-Smtp-Source: APXvYqythHZ6L9SAApiZKdgY216AN0FGTbxnEIGnbJV8jIRBX4F99KseU01k87QIZ1E6vbH8us3RMw==
X-Received: by 2002:a63:d854:: with SMTP id k20mr1751626pgj.107.1552993801842;
        Tue, 19 Mar 2019 04:10:01 -0700 (PDT)
Received: from nebula ([118.185.27.155])
        by smtp.gmail.com with ESMTPSA id k83sm20978322pfj.178.2019.03.19.04.09.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 19 Mar 2019 04:10:01 -0700 (PDT)
Date:   Tue, 19 Mar 2019 16:39:51 +0530
From:   Karuna Grewal <karunagrewal98@gmail.com>
To:     fw@strlen.de, pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [nftables,v2] tests/py: Add Test for `meta time`
Message-ID: <20190319110951.GA3818@nebula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Description: test meta time
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Cyberoam-smtpxy-version: 1.0.6.3
X-Cyberoam-AV-Policy: default
X-CTCH-PVer:  0000001
X-CTCH-Spam:  Unknown
X-CTCH-VOD:  Unknown
X-CTCH-Flags:  0
X-CTCH-RefID:  str=0001.0A150208.5C90CE08.0096,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score:  0.000
X-CTCH-ScoreCust:  0.000
X-CTCH-Rules:  
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Karuna Grewal <karunagrewal98@gmail.com>
---
 tests/py/any/meta.t         |  3 +++
 tests/py/any/meta.t.json    | 12 ++++++++++++
 tests/py/any/meta.t.payload |  5 +++++
 3 files changed, 20 insertions(+)

diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index d69b8b4e..56368a57 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -205,3 +205,6 @@ meta iif . meta oif vmap { "lo" . "lo" : drop };ok;iif . oif vmap { "lo" . "lo"
 
 meta random eq 1;ok;meta random 1
 meta random gt 1000000;ok;meta random > 1000000
+
+meta time 100;ok;meta timestamp 1m40s
+meta time;fail
\ No newline at end of file
diff --git a/tests/py/any/meta.t.json b/tests/py/any/meta.t.json
index 2cf91cda..faef4e26 100644
--- a/tests/py/any/meta.t.json
+++ b/tests/py/any/meta.t.json
@@ -2499,3 +2499,15 @@
     }
 ]
 
+# meta time 100
+[
+    {
+        "match": {
+            "left": {
+                "meta": { "key": "time" }
+            },
+            "op": "==",
+            "right": 100
+        }
+    }
+]
\ No newline at end of file
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index b32770f5..9c696b14 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -1021,3 +1021,8 @@ ip test-ip4 input
   [ meta load priority => reg 1 ]
   [ cmp eq reg 1 0x87654321 ]
 
+# meta time 100
+ip test-ip4 input
+  [ meta load unknown => reg 1 ]
+  [ cmp eq reg 1 0x000186a0 0x00000000 ]
+
-- 
2.17.1

