Return-Path: <SRS0=+PqO=WE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8959C433FF
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Aug 2019 20:57:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92F732173C
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Aug 2019 20:57:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=metaloft-com.20150623.gappssmtp.com header.i=@metaloft-com.20150623.gappssmtp.com header.b="eZgilQqN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733140AbfHHU5y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Aug 2019 16:57:54 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46022 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfHHU5y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Aug 2019 16:57:54 -0400
Received: by mail-pg1-f194.google.com with SMTP id o13so44658916pgp.12
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Aug 2019 13:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaloft-com.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=aUfO1bzZydpivOgSWyt7HiNnEH/RqxXr12ar/QHzGC0=;
        b=eZgilQqN3gEBQbb7L9ShIKOYRihBUpiQp+QTtXjY1UUOt4Q6IwoLoTDTu9ZYRxfAV/
         pR4vUq6TrQYctA8nVHQ2DTUCuT79BcmahD8F0cWiNeR830f6WlDPqBZhCpXViBOZMEdp
         1uzOlmcS8Z+hxRvMi7WYVb29oHRtxiZwKcgofIznj6FpVcOwBv/4hA2QPrju30Zy85+c
         1jz/4YDyc4hgv+QPISGY4jTuH9Px+2BIB6PuVY7psm5tSzdorcASN5fSQBNygng8+WAp
         qUd6EhvKGyTPRi35TmemX+ZkQiS083fAtX0a1oXT2mN92awD+pNI9I6fmywvWbxPl7Kr
         8dTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=aUfO1bzZydpivOgSWyt7HiNnEH/RqxXr12ar/QHzGC0=;
        b=gBnl3j5JAITZOGxpN2OAqkHa0hV3/RNrSk9RcZKfvZ5a9HES4nq+MzwrWrRHv+Vmnn
         IF+KTYPCN2xNrKeIiMdNtdufH8dSzNy3MzMG0itMMTv21VeXkCtUMadpPTmIqcA+GFKo
         x7oYP8DsfTmmFK0vPzJHyyzU77zIsohFse1ounMR8Dk78xQVe1pKHNgMFd813HDw19gO
         qjimJmjM+KpIW2Zcsxs7stiGhRlvvMHuhja+D+SFYqKiWuUu+9vVIy8ghzJJAE2F3mGf
         Ja/+xfoLk09yG5J2Y5T5fXaunwHgkDKXgJKaDOnw42xeV4Ttuxr/JP2YNbYCLeFYFe7Q
         WGqQ==
X-Gm-Message-State: APjAAAWDBSvlQ0AbVqRQwA2iU4vnvv5m9V6N7AmYzUNmVaSwQh3Yy9MR
        k09ztwkfzshH55JMTxTGZKn18vJR8ek=
X-Google-Smtp-Source: APXvYqzHqAqXEWCI4Es4rEp8rqNvKhZUt+GwtRsKx9C+yVI/8swNJnN7igXY5/xSsXAnPHfn+rvrnQ==
X-Received: by 2002:a65:4341:: with SMTP id k1mr14418186pgq.153.1565297872887;
        Thu, 08 Aug 2019 13:57:52 -0700 (PDT)
Received: from ?IPv6:2600:6c4e:2200:6881::3c8? (2600-6c4e-2200-6881-0000-0000-0000-03c8.dhcp6.chtrptr.net. [2600:6c4e:2200:6881::3c8])
        by smtp.gmail.com with ESMTPSA id e24sm6398614pgk.21.2019.08.08.13.57.52
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 13:57:52 -0700 (PDT)
To:     netfilter-devel@vger.kernel.org
From:   Dirk Morris <dmorris@metaloft.com>
Subject: [PATCH net v3] Use consistent ct id hash calculation
Message-ID: <51ae3971-1374-c8d0-e848-6574a5cdf4c1@metaloft.com>
Date:   Thu, 8 Aug 2019 13:57:51 -0700
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
change in the lifetime on a conntrack entry in some corner cases. The
current hash uses the whole tuple which contains an hlist pointer
which will change when the conntrack is placed on the dying list
resulting in a ct id change.

This patch also removes the reply-side tuple and extension pointer
from the hash calculation so that the ct id will will not change from
initialization until confirmation.

Fixes: 3c79107631db1f7 ("netfilter: ctnetlink: don't use conntrack/expect object addresses as id")
Signed-off-by: Dirk Morris <dmorris@metaloft.com>
---
  nf_conntrack_core.c |   16 ++++++++--------
  1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index ab73c5f..f86625f 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -302,13 +302,12 @@ EXPORT_SYMBOL_GPL(nf_ct_invert_tuple);
   * table location, we assume id gets exposed to userspace.
   *
   * Following nf_conn items do not change throughout lifetime
- * of the nf_conn after it has been committed to main hash table:
+ * of the nf_conn:
   *
   * 1. nf_conn address
- * 2. nf_conn->ext address
- * 3. nf_conn->master address (normally NULL)
- * 4. tuple
- * 5. the associated net namespace
+ * 2. nf_conn->master address (normally NULL)
+ * 3. the associated net namespace
+ * 4. the original direction tuple
   */
  u32 nf_ct_get_id(const struct nf_conn *ct)
  {
@@ -318,9 +317,10 @@ u32 nf_ct_get_id(const struct nf_conn *ct)
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
