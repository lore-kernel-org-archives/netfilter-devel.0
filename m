Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21218C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Oct 2021 11:58:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F122860F3A
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Oct 2021 11:58:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234672AbhJKMAe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Oct 2021 08:00:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27610 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231240AbhJKMAb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Oct 2021 08:00:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633953510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=GAZ6OCoU8mXpWGYLobvhZu4RViQxLK7vPCbKw/NBVKY=;
        b=F2uuj93gEq3bmRk0a0aIN+vXY7NpA2nO3aVL8FYlEPXooiJgkxxaIurkR3S1oGy1lWJbbl
        nAmCboY1Oj5DlM2G6pcEkTDBrGlw4QvvLSKtMcObgzLGXk+hG3mqGTasHwpdHQ8ZonkmSn
        86R7SsvcvJ0tAqrBjQdmvhY8iR/su/0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402--0fAxcABPMayCLmvFMk-AQ-1; Mon, 11 Oct 2021 07:58:29 -0400
X-MC-Unique: -0fAxcABPMayCLmvFMk-AQ-1
Received: by mail-ed1-f70.google.com with SMTP id u17-20020a50d511000000b003daa3828c13so15661810edi.12
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Oct 2021 04:58:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GAZ6OCoU8mXpWGYLobvhZu4RViQxLK7vPCbKw/NBVKY=;
        b=FiBEYslKv0oejSrJIv+cebkxzLuUT4oI6PMTex8rY4LV10cWz+noVZ0B3IST/S4w/5
         x99SFM+vEHD8s5Pf+sn/RuHhOXll03oIAutgf8waf9ueTrZ0272WVKnYDZHKUDn+oQix
         BXNf8DwcJjdLY2iiIRc5XZq7Tpc0acVQPX6SrPNb7LmPEF9yXET1e4d8BwIWOMV91i6X
         IXubj2cO0Gr1AueYvhZQz05MzF4Na+623Z36ezPciz6ZUE8QhSWlRlp4wh0ko4IMS08l
         7gG8gTplHpEE0ZEtMezH6IxH2LaIp6KM9Ak6IGfCMHO8xV/CiJv/am8RVqdY1Ct8tAMZ
         ujTA==
X-Gm-Message-State: AOAM532AKYZhL8jU6Dr+Y+S0LwaO1tOMS35GWf4KBjsEIXVXL7oEcm9Q
        Yoxpl+jVK+vuLSM0FbyOoiIv9ZZtAv8rus/fmVntToDbXu9p7U7Ww29vYk3vjeXNbtKQBzM6Zmj
        Stp5vVErP/kVa2NdPDTrj5EbR8XdNpMpxVlvyJmptY/bbvOnrLs9or814A+i7CsY8ee1SQvj7F9
        stnQ==
X-Received: by 2002:a05:6402:190f:: with SMTP id e15mr28237028edz.310.1633953508146;
        Mon, 11 Oct 2021 04:58:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPwKdpvGAUqwLgADEKeZ+q8NbDbFYX3ZbgWS4dPt0KriGCQkrEA4GIG2AHJyM18hrGXvYoiw==
X-Received: by 2002:a05:6402:190f:: with SMTP id e15mr28237000edz.310.1633953507922;
        Mon, 11 Oct 2021 04:58:27 -0700 (PDT)
Received: from localhost ([185.112.167.59])
        by smtp.gmail.com with ESMTPSA id kd8sm3374051ejc.69.2021.10.11.04.58.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 04:58:27 -0700 (PDT)
From:   =?UTF-8?q?=C5=A0t=C4=9Bp=C3=A1n=20N=C4=9Bmec?= <snemec@redhat.com>
To:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft 1/2] doc: libnftables-json: make the example valid JSON
Date:   Mon, 11 Oct 2021 13:59:04 +0200
Message-Id: <20211011115905.1456177-1-snemec@redhat.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add missing comma between array elements.

Fixes: 2e56f533b36a ("doc: Improve example in libnftables-json(5)")
Signed-off-by: Štěpán Němec <snemec@redhat.com>
---
 doc/libnftables-json.adoc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doc/libnftables-json.adoc b/doc/libnftables-json.adoc
index c152dc055b50..f67de33482a9 100644
--- a/doc/libnftables-json.adoc
+++ b/doc/libnftables-json.adoc
@@ -92,7 +92,7 @@ translates into JSON as such:
 			"family": "inet",
 			"table": "mytable",
 			"chain": "mychain"
-	}}}
+	}}},
 	{ "add": { "rule": {
 			"family": "inet",
 			"table": "mytable",

base-commit: 6bcd0d576a60d8a681cc6dd78551633f09534260
-- 
2.33.0

