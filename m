Return-Path: <SRS0=qEnH=WK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C16AC32753
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 14:54:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0A74206C1
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 14:54:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linode-com.20150623.gappssmtp.com header.i=@linode-com.20150623.gappssmtp.com header.b="aF0RKN8F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728232AbfHNOyU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 10:54:20 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44190 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfHNOyT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 10:54:19 -0400
Received: by mail-qt1-f195.google.com with SMTP id 44so79340517qtg.11
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2019 07:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linode-com.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=AIqmaYWytxUryYtM2D/vaPYMi74qLbL9gh9u9p+jfd0=;
        b=aF0RKN8FEeusOqoWoJZ3iWqp1ciUjcrSCQm9uzuvQrJszQEGhL5KJtHFKUrTKbb7Hb
         r9XkrfnbZgF6J4mNXyRh6Lmxf+x2FatHjNCjzGxz4lX51swFWuGQ1fld0ls8C3Gde6lb
         +jtlQiR5g8AWUtqU2/oTvZFKmXsOLHtalmV6skumRM0sPeoNU1HEDThDiF9NxPsBa1HC
         JyZhgjvtu5HkSWZ+zrP7uMvF38w6nrV7t8Z/UX71qM5OU9OBEh7dbJUvhqzwtRNdvYew
         8PnC2/cAC8N9vFUCsZNQaL93eg5kiapg1pIGMrhcLd0pPR5uK/0H5j9UpvqAYdd9KE35
         Y18w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=AIqmaYWytxUryYtM2D/vaPYMi74qLbL9gh9u9p+jfd0=;
        b=CoXli6jW53OB0QEeUk414p9cDRTs3K4KDONCusQ464IXCZ9BCu7lta5gDSfpEpYWCW
         La67c66nRX0qH9RxEiCCXaDKTISOvHtkEGi6cBx6Qu8lyQqgp7ydv2Ji7UwizBDZ9may
         9e4Z+mfFLZGdpx7HKK/g0nIgYL4El3PcprpJxnaI4aXRDhj2950IIbkFMAnyxHzsBCce
         y9mnR4NFigHsGlPqW2VBi4BgXuyqjxg3KHr7GrT8W6004A2PJSdmSfvdeODEF59c/qy7
         BJ4MnSwe1ie1b7wg+NkAYgG+E6/SyfpQz6MTkmhcg3zHwqq889g9ghJSsJnfFV2NS80Z
         hFKA==
X-Gm-Message-State: APjAAAWmzW4UGUJ1zxCsvTV33RsNJKEHvbVHUg0g/dCRqJIwQ3OjQzOo
        vmgZBM8Dop9jL22IXquL4rumzI55ca8=
X-Google-Smtp-Source: APXvYqzfldaCrApSgh/hsVh7gYfNu0OOpW5jLdJ87wdY36X2rFkyxzr7k4j0tKJG8PMrG+Grrziw4A==
X-Received: by 2002:ac8:24b4:: with SMTP id s49mr14790606qts.255.1565794458834;
        Wed, 14 Aug 2019 07:54:18 -0700 (PDT)
Received: from Todds-MacBook-Pro.local ([172.104.2.4])
        by smtp.gmail.com with ESMTPSA id h4sm5898957qtq.82.2019.08.14.07.54.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 07:54:18 -0700 (PDT)
From:   Todd Seidelmann <tseidelmann@linode.com>
Subject: [PATCH nf] netfilter: ebtables: Fix argument order to ADD_COUNTER
To:     netfilter-devel@vger.kernel.org, fw@strlen.de
Message-ID: <f4bc27ff-50b5-9522-379e-68208c029f2e@linode.com>
Date:   Wed, 14 Aug 2019 10:54:16 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The ordering of arguments to the x_tables ADD_COUNTER macro
appears to be wrong in ebtables (cf. ip_tables.c, ip6_tables.c,
and arp_tables.c).

This causes data corruption in the ebtables userspace tools
because they get incorrect packet & byte counts from the kernel.

Fixes: d72133e628803 ("netfilter: ebtables: use ADD_COUNTER macro")
Signed-off-by: Todd Seidelmann<tseidelmann@linode.com>
---
My last submission that included Florian Westphal's requests
seems to have been lost in the ether, so I'm resending.
Apologies for the spam.

  net/bridge/netfilter/ebtables.c | 8 ++++----
  1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index c8177a8..4096d8a 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -221,7 +221,7 @@ unsigned int ebt_do_table(struct sk_buff *skb,
              return NF_DROP;
          }

-        ADD_COUNTER(*(counter_base + i), 1, skb->len);
+        ADD_COUNTER(*(counter_base + i), skb->len, 1);

          /* these should only watch: not modify, nor tell us
           * what to do with the packet
@@ -959,8 +959,8 @@ static void get_counters(const struct ebt_counter *oldcounters,
              continue;
          counter_base = COUNTER_BASE(oldcounters, nentries, cpu);
          for (i = 0; i < nentries; i++)
-            ADD_COUNTER(counters[i], counter_base[i].pcnt,
-                    counter_base[i].bcnt);
+            ADD_COUNTER(counters[i], counter_base[i].bcnt,
+                    counter_base[i].pcnt);
      }
  }

@@ -1280,7 +1280,7 @@ static int do_update_counters(struct net *net, const char *name,

      /* we add to the counters of the first cpu */
      for (i = 0; i < num_counters; i++)
-        ADD_COUNTER(t->private->counters[i], tmp[i].pcnt, tmp[i].bcnt);
+        ADD_COUNTER(t->private->counters[i], tmp[i].bcnt, tmp[i].pcnt);

      write_unlock_bh(&t->lock);
      ret = 0;
--
1.8.3.1

