Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFA39C433DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Feb 2021 13:22:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 549BF64EAD
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Feb 2021 13:22:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbhBRNVP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Feb 2021 08:21:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53381 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232112AbhBRLIM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Feb 2021 06:08:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613646403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9a0VmrjU5oR2MSmbMFYe83p91wVANTAiazu1hZChGMA=;
        b=OR8xqBsweWr3BaHCNzNlBo9xwCcB5fOLz+rz2vqzoAZGPEPNYkpeRPpQPf+gsokWbFm9Ie
        Ivpm9EGHvZzrV7gSh3dajT2nSM0Nh1nYtwCHwJtCNH+ziBJrMZ9C+zMctM4Mh5A1Rc0mDM
        p2RxRxqXPdIB3FKHbCUbrCTy0oWj8ko=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-z_FVz97sPOK6wkg27z6CfA-1; Thu, 18 Feb 2021 06:06:41 -0500
X-MC-Unique: z_FVz97sPOK6wkg27z6CfA-1
Received: by mail-ej1-f72.google.com with SMTP id jg11so529652ejc.23
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Feb 2021 03:06:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9a0VmrjU5oR2MSmbMFYe83p91wVANTAiazu1hZChGMA=;
        b=lNmsDoUorKLBgklHHOp9r5rSDCD9aY35DOliTBp37m2Ds2M5wZEbeifMloy7mC/LMW
         Aei0aD8f7H+0XK87Q1YXC4GOwIpecc59eMt98yof4kXWPa7hCS4xIGzdxmS/a/jvvZ4H
         +PV3uDF9sU44eee2K1FKsKUxd0cHD7bPErT8CRa9Z1KIGaF87qjvgWzm074sJteVzclv
         xxGur3oYHaFqEaUPhQv+Vt7lAMjjVt2R8GLPh/SYk7tvjDYra9mAU4iSBQnOLiLPmZkD
         QWM7zbzVJUXjpG6/leQcysvwGdzvIF90fj0nhfZ6hJeTP18hK+cENH03VlDn5xrVf9yk
         NUOA==
X-Gm-Message-State: AOAM532Wi3/iXrsDnJI7n/lzmO0tdQYPqklixKS4kHdMyBTmAe/v0W/d
        xjEu0y4+zIIE5UN46grmoLIUnW3qQGn8f1ejKB+il5Ghh4/UccZyuxbueZalIhPOtlrOWChT2FT
        p5GNsUSiIOTdV63FuJADwTqZBT6S2hWGKoQii/k3B2iwrBnrJVyOF+lpI/KNIuKbDNS/TEic5DB
        oFpDI6
X-Received: by 2002:a17:907:7811:: with SMTP id la17mr3308407ejc.436.1613646400578;
        Thu, 18 Feb 2021 03:06:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyoENcyiGXnyuK6CUqTLTMI0acUbgciIiUsxgjDnDbFkWRmbgLLef1AqMmG5Xq/t953LPFQkQ==
X-Received: by 2002:a17:907:7811:: with SMTP id la17mr3308391ejc.436.1613646400362;
        Thu, 18 Feb 2021 03:06:40 -0800 (PST)
Received: from localhost.localdomain ([2a02:ed3:472:7000::1000])
        by smtp.gmail.com with ESMTPSA id s18sm2297753ejc.79.2021.02.18.03.06.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Feb 2021 03:06:40 -0800 (PST)
Subject: [libnftnl PATCH 2/2 v2] Avoid out of bounds read from data
To:     Pablo Neira Ayuso <pablo@netfilter.org>
References: <152a0191-c777-2b57-0775-ba94a59c74a0@redhat.com>
 <20210217230100.GB32290@salvia>
Cc:     netfilter-devel@vger.kernel.org
From:   Maya Rashish <mrashish@redhat.com>
Message-ID: <1ec62c2c-869d-9acf-138d-99baeaca07b0@redhat.com>
Date:   Thu, 18 Feb 2021 13:06:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210217230100.GB32290@salvia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When data is smaller than the destination, &ctr->pkts.

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
index 8af5a8e..6b22e46 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -67,6 +67,8 @@ void __nftnl_assert_attr_exists(uint16_t attr, uint16_t attr_max,

  #define array_size(arr)		(sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))

+#define	MIN(a,b)		((a) > (b) ? (b) : (a))
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

