Return-Path: <SRS0=5Ubq=RV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA72C43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Mar 2019 09:47:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACC162075C
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Mar 2019 09:47:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V/+gXrTf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbfCRJrw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Mar 2019 05:47:52 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:46989 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727777AbfCRJrw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Mar 2019 05:47:52 -0400
Received: by mail-pf1-f182.google.com with SMTP id s23so10868075pfe.13
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Mar 2019 02:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-description
         :content-disposition:user-agent;
        bh=Eu+Ktlc6lSZemU8vuAm64gENu/t28Lr9soShJaEOI6Y=;
        b=V/+gXrTf7JhvDlvU5Im3CN71Tr8jk0Brr0Xv++M1y3f/2Y0nESH8XJjUgJ7uM+pfwT
         D6o5Rk0JjWkbD1TNFtdoaSNr4XKyOV1bc3MA8t+cs/BmN9YUZGwm48NkaCH8xYEOEFN4
         JrsBeXLcqkscOSkuS0AjPXSRFtL8pqpSOiFWdBal6aUIhfdC/0/OrmR8eLF8Mx9pF1k4
         HrCv6JFlXNXorYD/gv6w5HooLwGrEMv7vTO5SvN17vyzftJuQdtIDEEUNYOBKPBLJJHn
         N9tJt/ueedl12AFoRta2qtHMigZPo9UuD5wqGFJN0KSHbPaIpfHcVZDWXHz34su7YkFL
         QtOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-description:content-disposition:user-agent;
        bh=Eu+Ktlc6lSZemU8vuAm64gENu/t28Lr9soShJaEOI6Y=;
        b=WT2y4wMARSYI66tXoB67oKTeDu7VeQxm1C2070y88cCGKDMgU5sa+h1YtFzBtzmLdC
         gOMTsD38J9k6Q+o/0k1sAf+0eSWz5mN7HJ6SmklDZyyX0TzKSXsg34MetvSlcTzQV5Kz
         sadou7hYOlDn/doJDKSpNKqcA077131/fdhXf5fM6fdLvN7rIenELaLvEzEDXrS4RJRz
         2pSmTqO78kVAsHIJJhGcCxITdzC3Aq9XHOYSBFAVDFh5PybdDGftsYEKrsJdpMNCorbs
         e+QrqFpB/rSk2uR1Bg62Kx3OxyicLiz6AN6K5tC5VODyV/XeEnOpDjd6YLLed27U0J7R
         tDlg==
X-Gm-Message-State: APjAAAVXy1JCSWAHsiaMTCzNaP5IUZMknXJ0byPn8iOy9tWzuQVpBIiA
        CxJbdcNMeC7cITz5i37QYYK35n9f4mA=
X-Google-Smtp-Source: APXvYqyweTZ2qw8dJD8Vp5+2eUubtU24NLDtbntOSYnyDcxf+70fLgzBC4dD4mNT3Rk9kxp9St/XJw==
X-Received: by 2002:a62:a10c:: with SMTP id b12mr18038818pff.234.1552902471086;
        Mon, 18 Mar 2019 02:47:51 -0700 (PDT)
Received: from nebula ([103.210.49.131])
        by smtp.gmail.com with ESMTPSA id l28sm24876021pfi.186.2019.03.18.02.47.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 18 Mar 2019 02:47:50 -0700 (PDT)
Date:   Mon, 18 Mar 2019 15:17:45 +0530
From:   Karuna Grewal <karunagrewal98@gmail.com>
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [nftables] tests/py: Add Test for `meta time`
Message-ID: <20190318094745.GA4394@nebula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Description: test-meta-time
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Cyberoam-smtpxy-version: 1.0.6.3
X-Cyberoam-AV-Policy: default
X-CTCH-PVer:  0000001
X-CTCH-Spam:  Unknown
X-CTCH-VOD:  Unknown
X-CTCH-Flags:  0
X-CTCH-RefID:  str=0001.0A150207.5C8F6946.0007,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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
index d69b8b4e..3d23dc75 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -205,3 +205,6 @@ meta iif . meta oif vmap { "lo" . "lo" : drop };ok;iif . oif vmap { "lo" . "lo"
 
 meta random eq 1;ok;meta random 1
 meta random gt 1000000;ok;meta random > 1000000
+
+meta time 100;ok;meta timestamp 1m40s
+meta time ;fail
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
index b32770f5..71c68e42 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -1021,3 +1021,8 @@ ip test-ip4 input
   [ meta load priority => reg 1 ]
   [ cmp eq reg 1 0x87654321 ]
 
+# meta time 100
+ip test-ip4 input
+  [ meta load timestamp => reg 1 ]
+  [ cmp eq reg 1 0x00000064 ]
+
-- 
2.17.1

