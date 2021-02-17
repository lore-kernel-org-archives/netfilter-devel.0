Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1762AC433E9
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Feb 2021 20:48:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB93964E6C
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Feb 2021 20:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234662AbhBQUs0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Feb 2021 15:48:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51524 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230315AbhBQUsV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Feb 2021 15:48:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613594815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=xHNs+krQDWBUYEOMl+kZuFAm15Utl+C1pG0+ACWQ4SU=;
        b=XliVF1fbTqEXe6Q9cL3wK5+s57gdbpu7ZI/QtFV++EuYdhGwVkQfE5PMc6z5/fevWFipxC
        0uv8nkvH9jAhmKWU5sv9H+feKyBmgHnPtP/xMhuIBnCHegLiM2QigMpRKxi3fmBnqpzzCd
        N3/0OdLhdPGYjaISS/QfgyIKnTyTd3Q=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-DDOzr_EjMaOclLpl9BkoNA-1; Wed, 17 Feb 2021 15:46:53 -0500
X-MC-Unique: DDOzr_EjMaOclLpl9BkoNA-1
Received: by mail-ed1-f72.google.com with SMTP id y90so5056374ede.8
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Feb 2021 12:46:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=xHNs+krQDWBUYEOMl+kZuFAm15Utl+C1pG0+ACWQ4SU=;
        b=Wml53zzL8mi/QoBcqkO5DHkzt4bNHNcaLTlpqoinTPWPUNKQPUOLCFHtFdGw+krww0
         zbx7HBt8dVdMvw/f8lZVpA69d5RVagQJnr55YRTi0ZcLqgkZQ8gM9XV/ZQYGgsth6Zg4
         SGbDs0JS5I4bKdKmAyKqTNsfJQqM6YUSulZzer/1j2Fi9eApkknomWApOmjEhDxyTiHv
         UqNYKQen7YsjFppbsfY4I+9eRX84Eai9SgrvdOvkCZHKuDSaBD+2sH3XTzbh0/wpLLv4
         x4DyN9kfKWUE1Ww4P642N4N5e+up3cLZ0IXh/o5L0jaxvDO2Hnh0+z4GI69ONeIeHDoD
         5h3w==
X-Gm-Message-State: AOAM530G4nCptLb8OFdGE6dTl8zpd/kBFZv08MSo8QeLj64hY7PyZzjU
        fBrcyDddPIoOFwPQ/qLCZvRshuQl5XhXaWckNcPZ1V2dAwq4ejkDnHOHfZZZRALamvzJOmo2tPY
        m2oV44Mpz8ZkU7aEVrw7e9+IAwcT4PoXxujb505VPl39XdJ84DoRRxU7IOOUaMnp9JcKV4y2qhe
        XHWSfr
X-Received: by 2002:aa7:da19:: with SMTP id r25mr614151eds.367.1613594812021;
        Wed, 17 Feb 2021 12:46:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJybX67jqWI1ev57RGJcAYGnZ34TttAO/GT01BRqzGw5r+MPkYbzSebL/BVp71QLkq4BHDOrzg==
X-Received: by 2002:aa7:da19:: with SMTP id r25mr614138eds.367.1613594811869;
        Wed, 17 Feb 2021 12:46:51 -0800 (PST)
Received: from localhost.localdomain ([2a02:ed3:472:7000::1000])
        by smtp.gmail.com with ESMTPSA id k9sm1606636edo.30.2021.02.17.12.46.51
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Feb 2021 12:46:51 -0800 (PST)
To:     netfilter-devel@vger.kernel.org
From:   Maya Rashish <mrashish@redhat.com>
Subject: [libnftnl PATCH 2/2] Avoid out of bounds read from data
Message-ID: <152a0191-c777-2b57-0775-ba94a59c74a0@redhat.com>
Date:   Wed, 17 Feb 2021 22:46:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This might introduce some issues since we're now not
filling the rest of the memory, but filling out with
uninitialized garbage is probably as bad as leaving it
as garbage.

Signed-off-by: Maya Rashish <mrashish@redhat.com>
---
  include/utils.h    | 2 ++
  src/expr/counter.c | 4 ++--
  2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index 8af5a8e..7413534 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -67,6 +67,8 @@ void __nftnl_assert_attr_exists(uint16_t attr, uint16_t attr_max,

  #define array_size(arr)		(sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))

+#define	MIN(a,b)		(a>b ? (b) : (a))
+
  const char *nftnl_family2str(uint32_t family);
  int nftnl_str2family(const char *family);

diff --git a/src/expr/counter.c b/src/expr/counter.c
index 89a602e..fb036dd 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -35,10 +35,10 @@ nftnl_expr_counter_set(struct nftnl_expr *e, uint16_t type,

  	switch(type) {
  	case NFTNL_EXPR_CTR_BYTES:
-		memcpy(&ctr->bytes, data, sizeof(ctr->bytes));
+		memcpy(&ctr->bytes, data, MIN(data_len, sizeof(ctr->bytes)));
  		break;
  	case NFTNL_EXPR_CTR_PACKETS:
-		memcpy(&ctr->pkts, data, sizeof(ctr->pkts));
+		memcpy(&ctr->pkts, data, MIN(data_len, sizeof(ctr->pkts)));
  		break;
  	default:
  		return -1;
-- 
2.29.2

