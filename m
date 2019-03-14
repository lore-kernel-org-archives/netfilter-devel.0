Return-Path: <SRS0=rsEJ=RR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 145CFC43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Mar 2019 07:58:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5CE321019
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Mar 2019 07:58:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="Yp8lYPOn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfCNH61 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Mar 2019 03:58:27 -0400
Received: from mta-p6.oit.umn.edu ([134.84.196.206]:60596 "EHLO
        mta-p6.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbfCNH61 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Mar 2019 03:58:27 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p6.oit.umn.edu (Postfix) with ESMTP id DD7A2C6E
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Mar 2019 07:58:25 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p6.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p6.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id sryFrWKtWy03 for <netfilter-devel@vger.kernel.org>;
        Thu, 14 Mar 2019 02:58:25 -0500 (CDT)
Received: from mail-it1-f200.google.com (mail-it1-f200.google.com [209.85.166.200])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p6.oit.umn.edu (Postfix) with ESMTPS id A9E42A0C
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Mar 2019 02:58:25 -0500 (CDT)
Received: by mail-it1-f200.google.com with SMTP id 9so3866567ita.8
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Mar 2019 00:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=BbqmGjLcyKyOuWw9asJAe7bSmTd5l7ynZnmbov0Wmhg=;
        b=Yp8lYPOnNd28KD6jqchkkdgKvUfWU1AsHXHZWrmuomjTC+9E/0sYw4d5ddtQ7HNd9c
         NpqkwjYyYwgoJ/EEBMwuK7rm6CapaeP0xAzgfhrVXLa1LvhDNhTsfn8CeRYYqXB0aeTI
         OxWIJJlPaPuTg/mOo3qgART5mTnFtD3vNeksk205Rh0yAn9RLKGactmulY63p5YnDmfo
         502Dsqz54cn3l3ntKDASv25YL9NeOad+GSWYd89iqGTbXWuFEn5fuc4XuUrMZsq5LWH0
         Nj0K9yclks3jM8dMoD0v5tTLyjYJ/V8nkH8up6CsA4plN6amimKgiKlJEnPZfPjL1lGb
         uXWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BbqmGjLcyKyOuWw9asJAe7bSmTd5l7ynZnmbov0Wmhg=;
        b=S4YKrQ85ROu93wzu90vPJZcyPtMgSBxp41/8SH8K9Zd2ySWOrtcgnINUoh5QywskuB
         2he8HxgnCNpu9HeVnPXJYgWmjBttoCbM0xRE4zNnEiyJT5f/6i4aJ6WHWRgZHpZ/Aao/
         iO/J8WxEJoQnFwl509KF8b9H9oT2U7OZXvcuz6MdZ8k81EwsPSjQm057AkswfFkTtt7j
         KCB+5qP12NCA03tt7GsU5VSWtDIr92uetGJn6zytMIx7Mz0Ya6/FDelv3/eD3u0rxs5e
         6saH7kFmPHtRgJFAkpZjzC2Rec3sqC26sDjSiqOL2wOydoCDQPzcn038odavqjCY8szD
         ucCg==
X-Gm-Message-State: APjAAAVkXuJn+kIe7rikT9FAkRYMu461fSDPZgVWAh88Cb8CloocezSd
        9O5UyUBuz2jczNtaGZcq6tF9BP9t09R7EwHQY03ro0qEySw2YwbPqlhANVWOYmS4RJnWbtmqjaY
        IyRfm/XppDCVksVphJVBMMIjVZXoQ2N55
X-Received: by 2002:a02:5cdd:: with SMTP id w90mr27367130jad.90.1552550305275;
        Thu, 14 Mar 2019 00:58:25 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxtfMDaKG4fvcj2S91FxJFVr0D4tev6/8EWOXYaVlu4u3dHgBC2i3k7uiHsHfXicWqAjDYorw==
X-Received: by 2002:a02:5cdd:: with SMTP id w90mr27367117jad.90.1552550305022;
        Thu, 14 Mar 2019 00:58:25 -0700 (PDT)
Received: from bee.dtc.umn.edu (cs-bee-u.cs.umn.edu. [128.101.106.63])
        by smtp.gmail.com with ESMTPSA id i14sm892269itc.34.2019.03.14.00.58.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Mar 2019 00:58:24 -0700 (PDT)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ipv6: ip6t_srh: fix NULL pointer dereferences
Date:   Thu, 14 Mar 2019 02:58:18 -0500
Message-Id: <20190314075818.29951-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

skb_header_pointer may return NULL. The current code dereference
its return values without a NULL check.

The fix inserts the checks to avoid NULL pointer dereferences.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 net/ipv6/netfilter/ip6t_srh.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/ipv6/netfilter/ip6t_srh.c b/net/ipv6/netfilter/ip6t_srh.c
index 1059894a6f4c..4cb83fb69844 100644
--- a/net/ipv6/netfilter/ip6t_srh.c
+++ b/net/ipv6/netfilter/ip6t_srh.c
@@ -210,6 +210,8 @@ static bool srh1_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		psidoff = srhoff + sizeof(struct ipv6_sr_hdr) +
 			  ((srh->segments_left + 1) * sizeof(struct in6_addr));
 		psid = skb_header_pointer(skb, psidoff, sizeof(_psid), &_psid);
+		if (!psid)
+			return false;
 		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_PSID,
 				ipv6_masked_addr_cmp(psid, &srhinfo->psid_msk,
 						     &srhinfo->psid_addr)))
@@ -223,6 +225,8 @@ static bool srh1_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		nsidoff = srhoff + sizeof(struct ipv6_sr_hdr) +
 			  ((srh->segments_left - 1) * sizeof(struct in6_addr));
 		nsid = skb_header_pointer(skb, nsidoff, sizeof(_nsid), &_nsid);
+		if (!nsid)
+			return false;
 		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_NSID,
 				ipv6_masked_addr_cmp(nsid, &srhinfo->nsid_msk,
 						     &srhinfo->nsid_addr)))
@@ -233,6 +237,8 @@ static bool srh1_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	if (srhinfo->mt_flags & IP6T_SRH_LSID) {
 		lsidoff = srhoff + sizeof(struct ipv6_sr_hdr);
 		lsid = skb_header_pointer(skb, lsidoff, sizeof(_lsid), &_lsid);
+		if (!lsid)
+			return false;
 		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_LSID,
 				ipv6_masked_addr_cmp(lsid, &srhinfo->lsid_msk,
 						     &srhinfo->lsid_addr)))
-- 
2.17.1

