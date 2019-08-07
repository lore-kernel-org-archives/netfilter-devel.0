Return-Path: <SRS0=iSAz=WD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18DA6C433FF
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Aug 2019 00:25:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D97D6214C6
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Aug 2019 00:25:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=metaloft-com.20150623.gappssmtp.com header.i=@metaloft-com.20150623.gappssmtp.com header.b="y/uGOiob"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbfHGAZf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Aug 2019 20:25:35 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35100 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726238AbfHGAZf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Aug 2019 20:25:35 -0400
Received: by mail-pg1-f193.google.com with SMTP id n4so733485pgv.2
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Aug 2019 17:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaloft-com.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=1+n2jV791B/qZPMBB+tZ2w+Rm1T/g2nQKQ80HO/r0r8=;
        b=y/uGOiobi5vSPNPicLCEmiDwKIXvg0sQZMaj4QQBSW6xXEVzDTBw2ZGyH49AtIGSla
         a/ybWifAPf5BIYQbRmP/9MnWeQmVLo842AklHn2fTW7VHVCRnqepQM2HQHxzLPtX60WU
         Ux7GCDbuhm1oxGSPf4pCeJUDFtHOjD1T5HhAuj02pJ77AyzQqLhcaxIt9eVGCjJGVqkG
         3u3/kFOtgs6c+BYN7wMwTEawX/PcrNonEdNNvMd3/8P1QhtZ7nOW0KzGH0y1X0FU/ROp
         hHpd+rYT14sfxrD7Jjc1dosaGlSmacYVH5HNS+TGtR5CLIVp6/yDesiGt/mdaWMH5slE
         xS6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=1+n2jV791B/qZPMBB+tZ2w+Rm1T/g2nQKQ80HO/r0r8=;
        b=t0FHPjTRFr4NNmrkHytRzGHngj02aFjx1xLPQ1vnMw2EB53HWKbO28kylUS5c2Y9rl
         rayMHMTcakvRcxS9qKXTYL30HqQgx+0vPmyrS5Wb/D3di4kE3MA05zaHYcM0oTX2Dwrs
         egaI5QvWfwAPJYPohxf9G6zXC1JU3hjOu4Ug2ZDE2AhhlinqrSvyvjxoK8MkRfDJlcGv
         TFK13wGZsAlx7L3xqum6wow+E2AI2hJMaJnAcI63OyYUH4J7CdzPdBoCkMnZLrIAJTL1
         TpeQ/qyGKMKNOgd7+hq3jdvB63jVxMW4/g1D8y32sHnd0CsddPiCmW2OvpCSkU0trUrZ
         0pIQ==
X-Gm-Message-State: APjAAAVe7TtM2fpQrEPykeVqyfNp06Af+eOEZdfCWHHj0kcq/PvcMov4
        eP52v+0BoGQ1hpuWwt9HMCQbcbPzNiM=
X-Google-Smtp-Source: APXvYqzXsJ9ucTBU4jcckuSkTcuiCwh/r4smYfjTbZ2DMf1PwYRkwTcN7pK7BJ0uMuGkVTjV1HpksA==
X-Received: by 2002:a63:1455:: with SMTP id 21mr5317235pgu.116.1565137534307;
        Tue, 06 Aug 2019 17:25:34 -0700 (PDT)
Received: from ?IPv6:2600:6c4e:2200:6881::3c8? (2600-6c4e-2200-6881-0000-0000-0000-03c8.dhcp6.chtrptr.net. [2600:6c4e:2200:6881::3c8])
        by smtp.gmail.com with ESMTPSA id d2sm20426564pjs.21.2019.08.06.17.25.33
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 17:25:33 -0700 (PDT)
To:     netfilter-devel@vger.kernel.org
From:   Dirk Morris <dmorris@metaloft.com>
Subject: [PATCH net] netfilter: Use consistent ct id hash calculation
Message-ID: <e5d48c19-508d-e1ed-1f16-8e0a3773c619@metaloft.com>
Date:   Tue, 6 Aug 2019 17:25:32 -0700
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

Currently the new ct id is a hash based on several attributes which do
not change throughout lifetime of the connection. However, the hash
includes the reply side tuple which does change during NAT on the
first packet. This means the ct id associated with the first packet of
a connection pre-NAT is different than it is post-NAT. This means if
you are using nfqueue or nflog in userspace the associated ct id
changes from pre-NAT on the first packet to post-NAT on the first
packet or all subsequent packets.

Below is a patch that (I think) provides the same level of uniqueness
of the hash, but is consistent through the lifetime of the first
packet and afterwards because it only uses the original direction
tuple.

Signed-off-by: Dirk Morris <dmorris@metaloft.com>
---
  nf_conntrack_core.c |    3 ++-
  1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index a542761..eae4898 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -471,7 +471,8 @@ u32 nf_ct_get_id(const struct nf_conn *ct)
         a = (unsigned long)ct;
         b = (unsigned long)ct->master ^ net_hash_mix(nf_ct_net(ct));
         c = (unsigned long)ct->ext;
-       d = (unsigned long)siphash(&ct->tuplehash, sizeof(ct->tuplehash),
+       d = (unsigned long)siphash(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
+                                  sizeof(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple),
                                    &ct_id_seed);
  #ifdef CONFIG_64BIT
         return siphash_4u64((u64)a, (u64)b, (u64)c, (u64)d, &ct_id_seed);
