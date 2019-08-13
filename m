Return-Path: <SRS0=20ch=WJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A992C32750
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 13:22:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3BC020578
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 13:22:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linode-com.20150623.gappssmtp.com header.i=@linode-com.20150623.gappssmtp.com header.b="PJmZjZui"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbfHMNWV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Aug 2019 09:22:21 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42712 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728536AbfHMNWU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Aug 2019 09:22:20 -0400
Received: by mail-qt1-f196.google.com with SMTP id t12so17686110qtp.9
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 06:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linode-com.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=DQ4mMXTZgl1WVV5uHkxStemoDQNoVfeoGM36kj7uXFo=;
        b=PJmZjZuirwJoAwy7AzajA/eiPGZr5aHxxHRLzBzRVKUVh6iuo2QZYP8eAThbwokWum
         0k28WefdfbJ75/japuo2eW9cbwOi/ihEFr/A9+wbJs23HoNa5hRyKK0swEGla25REva8
         90dh/NIlz/YSU07lhjaP0GBPn8i4bp23/bJM7rgIk2djp8kMBxgO8a8WUNlSHLNxHUuQ
         Ddf/uj7xLa9gcpPuH0pA2D5vnZaZMvMV39n/oJf7bU7iqKW3rHXw2UVOPRLV4w397a1v
         3cIP04GiF/b6IoV2zbv2PvXiZIonu6xisUMFODW4BS3Zsnr9j+263SEduO6nN8xyw5p4
         sfxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=DQ4mMXTZgl1WVV5uHkxStemoDQNoVfeoGM36kj7uXFo=;
        b=mFGR+eUyKtT2gZ9i29/rRERtGwiIt+SZAg+tjpSAtA5yiUi8eKeQBARZuZHi3W4NTj
         Z1TmEL6Pz9AOiH27he9mmBoyFKWtwSyfFDoSiAstfhOXNB3BRGiFl1RevccSwKWwQUZ8
         EAz/OMiFnkqe8oUqAKImmiLjaaGFK47TzUr/Yb1U03mTikqOtb/hM/4KI5mPeclHqToB
         hrimrwcopxUByju+qlSRBfGR2Z0oKPOQJ5N411yAiR7cu6zJZmwoN4xaTBsYfkSNEmMl
         CBPW40v/mKEhGT31n0qGbVxl6QR6j30fxmqmYoUe0cM1Picjm4IatZ/95bdDAmvmdZPi
         EteA==
X-Gm-Message-State: APjAAAWIDAXiy7exVDP7cjwD4GPgnaWNHlfeWkKaxKiI7Z4QRPzBr4Jd
        r19bXlP4CzfI4LfWfGOGKCIOi9APN3wMC3BzCRTx9dmgCSjrn9PNWrNUXuPXO7T28cv66xAP08w
        ofIdFAJsAbhk1QWHCfnAhJCx9GTAXQtnXmORMCMmdoz4rNI8rz9q/PyrAzw8oxx9dAyV0kihViP
        bYDi3xdxg=
X-Google-Smtp-Source: APXvYqyrA1F/nHkROAA8iFBRGUtIoz4CHXkk/evx+Bzp31yEXE9JIO2/TWyp+7baTJVt0YCD9RmZuA==
X-Received: by 2002:ac8:7354:: with SMTP id q20mr5349624qtp.60.1565702539157;
        Tue, 13 Aug 2019 06:22:19 -0700 (PDT)
Received: from Todds-MacBook-Pro.local ([172.104.2.4])
        by smtp.gmail.com with ESMTPSA id k21sm8904168qki.50.2019.08.13.06.22.18
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 06:22:18 -0700 (PDT)
To:     netfilter-devel@vger.kernel.org
From:   Todd Seidelmann <tseidelmann@linode.com>
Subject: [PATCH nf] netfilter: ebtables: Fix argument order to ADD_COUNTER
Message-ID: <0330b679-4649-df92-f0d7-a0b5c7dcc87d@linode.com>
Date:   Tue, 13 Aug 2019 09:22:17 -0400
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
---
  net/bridge/netfilter/ebtables.c | 8 ++++----
  1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c 
b/net/bridge/netfilter/ebtables.c
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
@@ -959,8 +959,8 @@ static void get_counters(const struct ebt_counter 
*oldcounters,
              continue;
          counter_base = COUNTER_BASE(oldcounters, nentries, cpu);
          for (i = 0; i < nentries; i++)
-            ADD_COUNTER(counters[i], counter_base[i].pcnt,
-                    counter_base[i].bcnt);
+            ADD_COUNTER(counters[i], counter_base[i].bcnt,
+                    counter_base[i].pcnt);
      }
  }

@@ -1280,7 +1280,7 @@ static int do_update_counters(struct net *net, 
const char *name,

      /* we add to the counters of the first cpu */
      for (i = 0; i < num_counters; i++)
-        ADD_COUNTER(t->private->counters[i], tmp[i].pcnt, tmp[i].bcnt);
+        ADD_COUNTER(t->private->counters[i], tmp[i].bcnt, tmp[i].pcnt);

      write_unlock_bh(&t->lock);
      ret = 0;
--
1.8.3.1

