Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80A91C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Oct 2021 11:58:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5724C60F35
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Oct 2021 11:58:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236026AbhJKMAe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Oct 2021 08:00:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26867 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234672AbhJKMAc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Oct 2021 08:00:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633953512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7M7iV0P2ZxZQVYdgpWbQMm5uaj3Gw/OXws9bEgy5/fo=;
        b=ZwYWMA0EanWZ9Q9l43EZlvTsgA9YUZU+T4WDbNuY8cahKdBZL400FLBS7aDsVKPjs9bLWa
        EQgiLh/GsJgTCr4SzJLMe5ig9oVtfVT8SHaMnq0WcE++VMiC1UT5zPDv3+bGxlc0DYRzdG
        qIzqEJitZQ3IdOv1HIl5SbB3L+FyNf0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-5IIlU4fKNaG_ob39Bz1zWw-1; Mon, 11 Oct 2021 07:58:31 -0400
X-MC-Unique: 5IIlU4fKNaG_ob39Bz1zWw-1
Received: by mail-ed1-f71.google.com with SMTP id g28-20020a50d0dc000000b003dae69dfe3aso15643709edf.7
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Oct 2021 04:58:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7M7iV0P2ZxZQVYdgpWbQMm5uaj3Gw/OXws9bEgy5/fo=;
        b=zutptFehU8iTFFa3L+1bvyiNqpF87CrtxHNI/8uSl+xWM+IsdkoAEP5Ik2UXayeGS3
         inP3bsA9i3DxdFN/aVkKaa9rNdolCh7Gl2eCcZrATPdOUKDXhjf9gwCQCC7jTRkh3aam
         8jxz4E5nZH+Bxj93j5GuDMU/9m6GooaIW9L54fn3DEqZu3ElyleGfBR773WU6aUXhvhq
         P6n35G4bV8LmcPqT18WadT+Z91Bh4whanfyMLx9hmOimPter/PDvweJSPQbLEXOjs2K1
         TZSxHACRMFrvFY+OQ4tz/rugmEIZLgS4gIVTJXPqyf6U9m3ndetjfbstJII3LnKXqok1
         t5jA==
X-Gm-Message-State: AOAM533dFQnZDQ5THK5vPIdM5ydvs4ozxiYa8KUkvVSUjO7oweyWYP3A
        vR2ixCcZ6PBDmxdw6A3o5S+LMcgZb7TXvJ8qhy8oNIz0cjeMSA7YiHPvNuwnOIcE47N6p04bgd9
        kJ8p2Vo3IPX9DWs4Sx6kOFzewiiWSKo4CNOSdcAsdvQN3Axk+mlJMojobuNKhwfV75/HJKv0r4j
        ASvQ==
X-Received: by 2002:a17:906:7a50:: with SMTP id i16mr25883550ejo.507.1633953509612;
        Mon, 11 Oct 2021 04:58:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw8JfZI/BK0nkSy71+EnBw7pEI5BxohwcdjLBqZK5XjKJP7FsF/QJtTpo0zWXxzpFLV+hqoEQ==
X-Received: by 2002:a17:906:7a50:: with SMTP id i16mr25883534ejo.507.1633953509445;
        Mon, 11 Oct 2021 04:58:29 -0700 (PDT)
Received: from localhost ([185.112.167.59])
        by smtp.gmail.com with ESMTPSA id nd22sm3558631ejc.98.2021.10.11.04.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 04:58:28 -0700 (PDT)
From:   =?UTF-8?q?=C5=A0t=C4=9Bp=C3=A1n=20N=C4=9Bmec?= <snemec@redhat.com>
To:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft 2/2] doc: libnftables-json: make the example valid libnftables JSON input
Date:   Mon, 11 Oct 2021 13:59:05 +0200
Message-Id: <20211011115905.1456177-2-snemec@redhat.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011115905.1456177-1-snemec@redhat.com>
References: <20211011115905.1456177-1-snemec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fixes: 2e56f533b36a ("doc: Improve example in libnftables-json(5)")
Fixes: 90d4ee087171 ("JSON: Make match op mandatory, introduce 'in' operator")
Signed-off-by: Štěpán Němec <snemec@redhat.com>
---
 doc/libnftables-json.adoc | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/doc/libnftables-json.adoc b/doc/libnftables-json.adoc
index f67de33482a9..9cc17ff26306 100644
--- a/doc/libnftables-json.adoc
+++ b/doc/libnftables-json.adoc
@@ -91,7 +91,7 @@ translates into JSON as such:
 	{ "add": { "chain": {
 			"family": "inet",
 			"table": "mytable",
-			"chain": "mychain"
+			"name": "mychain"
 	}}},
 	{ "add": { "rule": {
 			"family": "inet",
@@ -99,6 +99,7 @@ translates into JSON as such:
 			"chain": "mychain",
 			"expr": [
 				{ "match": {
+					"op": "==",
 					"left": { "payload": {
 							"protocol": "tcp",
 							"field": "dport"
-- 
2.33.0

