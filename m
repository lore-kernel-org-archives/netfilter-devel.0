Return-Path: <SRS0=+PqO=WE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AB30C433FF
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Aug 2019 18:30:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D62F7217D7
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Aug 2019 18:30:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=metaloft-com.20150623.gappssmtp.com header.i=@metaloft-com.20150623.gappssmtp.com header.b="JdO5wl2m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732544AbfHHSas (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Aug 2019 14:30:48 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36672 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730768AbfHHSas (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Aug 2019 14:30:48 -0400
Received: by mail-pf1-f193.google.com with SMTP id r7so44570799pfl.3
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Aug 2019 11:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaloft-com.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=hVqUL+zHdMiUOrhH3nrSoWOULuR0zxylt5rnGcz/Gbs=;
        b=JdO5wl2mXHW/8vZRQFkgGccJIHin1m3A/igY7agvrny+UkV8XWBuKXF0cCN0Xmzanl
         QDDaiYb+OZm9jX+M199WfqOo9eW7opUYD/hoQsSB/Uxy1o8M7NVYXJ6NmCep454u7LYt
         T879L537v7hL+EVTVfXtIqeGzAQB48fUpMApd7u/54bDr1pfcLKyYOlIAuzdtFW5dtRE
         Oy6zj6QVhfs35EafZwCE+1JsM19vJyCdHeI0ogMP4+F/Lnh48Gmngc6aG3el5EfRmRsJ
         W/lAW/ZHlvOyJ7lrz1niGkpd9UsUcHmzJal9QFuSVwHKVBPhYupnFVm9la0hUhNz3Haq
         ckRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=hVqUL+zHdMiUOrhH3nrSoWOULuR0zxylt5rnGcz/Gbs=;
        b=nsON0qGKJmtV7K76AyjhqnIBVVulgyQx6wTe1KRlS8ZAOVG5+K/GHkGHKxJDMjsq/3
         zOtP6Vqplbsph8I6qLNwLyFic3Bu2AKnHq8lLelDy/uUQXn5qphKxlCt6Lv32L2XlK7i
         Y98cbyOGgIMZnB7GidQP5MxBUYAllNecW3T4OseQ7uymQQrd4jcVx6eCkP8rqCI93Dsb
         0OQJjyXdSFawp5spVSaSkva1WNZIDI1bGszy4+B29nRucAp4q1MsVClIJj+pqC5pJaCp
         3Y4afDE9tjvLfzHZj+8rvgVnwCcaOSacBql0o5OczEUAVwytDqK0lYOr5bkmm/0No0Er
         h2mw==
X-Gm-Message-State: APjAAAWOWYBKP7DJbzbQ3au4E8pgFfedNPF3PiFPyCQ7Qyopqss1BVkE
        KOBUWYBBnHTWbMXJsz7RHK3ZJu/ZRYU=
X-Google-Smtp-Source: APXvYqwaHnbqEnFgMsd9YUBvG3UlmQvlY+YUnVJS7NF423VbXi93kNaw3N+vVkOG//4//l7TfVHJFw==
X-Received: by 2002:a63:4a0d:: with SMTP id x13mr13645134pga.75.1565289047153;
        Thu, 08 Aug 2019 11:30:47 -0700 (PDT)
Received: from ?IPv6:2600:6c4e:2200:6881::3c8? (2600-6c4e-2200-6881-0000-0000-0000-03c8.dhcp6.chtrptr.net. [2600:6c4e:2200:6881::3c8])
        by smtp.gmail.com with ESMTPSA id v8sm80424367pgs.82.2019.08.08.11.30.46
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 11:30:46 -0700 (PDT)
To:     netfilter-devel@vger.kernel.org
From:   Dirk Morris <dmorris@metaloft.com>
Subject: [PATCH net v2] netfilter: Use consistent ct id hash calculation
Message-ID: <42f0ed4e-d070-b398-44de-15c65221f30c@metaloft.com>
Date:   Thu, 8 Aug 2019 11:30:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Change ct id hash calculation to only use invariants.

Currently the ct id hash calculation is based on some fields that can
change in the lifetime on a conntrack entry in some corner cases. This
results on the ct id change after the conntrack has been confirmed.
This changes the hash to be based on attributes which should never
change. Now the ct id hash is also consistent from initialization to
conntrack confirmation either even though it is unconfirmed.

Signed-off-by: Dirk Morris <dmorris@metaloft.com>
---
  nf_conntrack_core.c |    7 ++++---
  1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index ab73c5f..dad6868 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -318,9 +318,10 @@ u32 nf_ct_get_id(const struct nf_conn *ct)
  	net_get_random_once(&ct_id_seed, sizeof(ct_id_seed));
  
  	a = (unsigned long)ct;
-	b = (unsigned long)ct->master ^ net_hash_mix(nf_ct_net(ct));
-	c = (unsigned long)ct->ext;
-	d = (unsigned long)siphash(&ct->tuplehash, sizeof(ct->tuplehash),
+	b = (unsigned long)ct->master;
+	c = (unsigned long)nf_ct_net(ct);
+	d = (unsigned long)siphash(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
+				   sizeof(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple),
  				   &ct_id_seed);
  #ifdef CONFIG_64BIT
  	return siphash_4u64((u64)a, (u64)b, (u64)c, (u64)d, &ct_id_seed);
