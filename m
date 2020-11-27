Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D233FC3E8C5
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Nov 2020 01:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86D7321D7A
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Nov 2020 01:34:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UoTHEUkl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729604AbgK1BbX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Nov 2020 20:31:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42356 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731101AbgK0T72 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Nov 2020 14:59:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606507152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=3cBR/GAHSZu/mG/kVh3pbERrLW8qnpOV0nfvW9Q+mXU=;
        b=UoTHEUklWlpqlQbQUiYQFUAeivaC/NIiouxNwSjnun3K6Nm7GcyhOKdkk8aZ71VSiWHmf4
        hZL733RRuxvgiz7i9cjA2O0BvQEkzwMojK2J08gdIvmOupR/FMmwwA+/PlUkrYw46W1vUC
        NWtgSf6OS162AJ8cMQiu+ywaKJBUV08=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-ctz6WqwJNTuiUdOcKB98-g-1; Fri, 27 Nov 2020 14:20:40 -0500
X-MC-Unique: ctz6WqwJNTuiUdOcKB98-g-1
Received: by mail-qt1-f198.google.com with SMTP id d9so3767186qtr.5
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Nov 2020 11:20:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3cBR/GAHSZu/mG/kVh3pbERrLW8qnpOV0nfvW9Q+mXU=;
        b=ZWWcgfIX+PCHxnVWAvR2/MVZ4g6NAXcR8KsYDt+qQ++FusUOxYCgxH6cbvMWSZNrHT
         +FeftMSeZZdDd9bg8aXBEQIW/YBGaYAcnjP17u0+2sMad5WBKbuWRdhQzkoW6CNy3rN3
         31Pd3RWfCiTqwJt9wkYecUrSqwScpYcxdg8zY5E/WHol07bX7vbJtlkWJIgoQqbTZ2/c
         1TuHJbafdD8eb7qKWXcm27y/NB7b3sp8bjcrU2cgqD6VtiHaCZR8dVZ6+s3f++PfiRWv
         GurpUoOuiP+CYC9HPOu77NaxlqsuOrX20oqcaBmI8LUSVDxOMdMqoiAeRTemzCdJ/Xqm
         +07g==
X-Gm-Message-State: AOAM530LlBCVe3Z5csY2y1oEE5rEkenmIB1rdHS1gmWwlo5O6No8Ijyo
        Zcpu/nV9+dyVhjPnamI3ksifFCPORjB9X92v4+jl2l3xtQZfH7WmUztdIKRHy1Oxo8FqRHshIGN
        cQIRRx+sO9H+xfu+E+/Kw736CX7fO
X-Received: by 2002:aed:2f81:: with SMTP id m1mr9264792qtd.209.1606504840012;
        Fri, 27 Nov 2020 11:20:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwow2CpnnXkAmPv5elf6jRYc2fUaRyRZggyU2yVjFNSThGuDv/h+bB3I0vDIjnpmjS8h7gaFA==
X-Received: by 2002:aed:2f81:: with SMTP id m1mr9264774qtd.209.1606504839841;
        Fri, 27 Nov 2020 11:20:39 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id h4sm7327013qkh.93.2020.11.27.11.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 11:20:39 -0800 (PST)
From:   trix@redhat.com
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] netfilter: remove trailing semicolon in macro definition
Date:   Fri, 27 Nov 2020 11:20:34 -0800
Message-Id: <20201127192034.2858213-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Tom Rix <trix@redhat.com>

The macro use will already have a semicolon.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 include/net/netfilter/nf_tables_offload.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index 1d34fe154fe0..ae8160b62b10 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -81,7 +81,7 @@ int nft_flow_rule_offload_commit(struct net *net);
 
 #define NFT_OFFLOAD_MATCH_EXACT(__key, __base, __field, __len, __reg)	\
 	NFT_OFFLOAD_MATCH(__key, __base, __field, __len, __reg)		\
-	memset(&(__reg)->mask, 0xff, (__reg)->len);
+	memset(&(__reg)->mask, 0xff, (__reg)->len)
 
 int nft_chain_offload_priority(struct nft_base_chain *basechain);
 
-- 
2.18.4

