Return-Path: <SRS0=lxoE=WR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2191C3A59E
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 15:47:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7177222DA7
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 15:47:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linode-com.20150623.gappssmtp.com header.i=@linode-com.20150623.gappssmtp.com header.b="LDivPezK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728357AbfHUPr5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Aug 2019 11:47:57 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44409 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727975AbfHUPr4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Aug 2019 11:47:56 -0400
Received: by mail-qt1-f194.google.com with SMTP id 44so3556341qtg.11
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2019 08:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linode-com.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=ADb0+6xAYca78suARSDYqlC4v8alHPueUcIf/cGSFiM=;
        b=LDivPezKEhb0GghAnbE9Ifsch3mANXanG7aDmZVn9QpLFd/IzC1gMASY2xrbelxuNX
         prYkM0helR7Evem7tQ2m/sgscA+2Hn92/4e5wpr3Y7Q+AzFMIdRdEJqq+eZAPAHeviDX
         /9ZU268ftWdzDNezdQMJaPMYppB/l/r0SUFgoyd7pcDOIUMrwbTuONZ8tH6XbMv0bYAq
         jg95sc5iJ80AE5YIKzcObWBmUebVa7RStfaLYLotR+ICXh1l7y1ZwjcliYgo1JlyVQAQ
         irUp/uTUZegwYZZaHSXOG/k/AldfBMHMuCBsgEs+hXfeLBVTB6RJdyuIWDgKFo5a9SXF
         +9Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=ADb0+6xAYca78suARSDYqlC4v8alHPueUcIf/cGSFiM=;
        b=iytNtSzPh769mF7HvDztHfWco19bQEMTxTBnK7Ic8sQzEQ2MQTE444X65nfowSQKW7
         u9K/qjb5re3G2tN82Q61IDNcwhWb11YiNrfbC7/7NG66Km5AMrrrZAU7kcWS5UNCoPCw
         U1aw7znLy1W3ocyM0YKx3FCEq3hMtkYAglkDDlWC90QzZCHVa2eMr9OdvvbBRsKfwyoL
         tmTFJLNXJEPYbmcjDH0r7zjvvL0gs69XsfEuvuUqKAqlVMtQJxDbYcT4ayCpRNeuCAJF
         tDdS4BLzgyPSRJVcy5RYCQxWDdnDd135v1Lk6Moz/wOnTouz2ebjgniBLxL+wiWhkAax
         wyrg==
X-Gm-Message-State: APjAAAWgTmPbKPfqswlMF3YdZs6nuTapkd54WltsWsq6rc6hXGIwhFts
        8NSI4QCxVWRUclRZO/qaVcyi2XKDK4HVirOdDEWVkLDCbTKPO+XoQdL07TWD7HRSYQexN/NtzmE
        GYo5QrthaoGVwmXl+UMsz/grkP/EXJ0daD9J6imkiwrxqwe86hlf+Ce0zhT6ZPb2HX+KSgKPQ/Z
        dOLk/cbUU=
X-Google-Smtp-Source: APXvYqyyBPbPQsd+6xFcj3MuDh6HRBjBqYmTjr2zOuX/9y8aZZZYpAV1IaFaGMelnYkV4m7/sp7jXg==
X-Received: by 2002:ac8:649:: with SMTP id e9mr30927317qth.135.1566402475599;
        Wed, 21 Aug 2019 08:47:55 -0700 (PDT)
Received: from Todds-MacBook-Pro.local ([172.104.2.4])
        by smtp.gmail.com with ESMTPSA id o200sm10445283qke.66.2019.08.21.08.47.54
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Aug 2019 08:47:54 -0700 (PDT)
To:     netfilter-devel@vger.kernel.org
From:   Todd Seidelmann <tseidelmann@linode.com>
Subject: [PATCH] netfilter: xt_physdev: Fix spurious error message in
 physdev_mt_check
Message-ID: <88b305fb-ebb9-5e81-f8ef-55a18609c5fc@linode.com>
Date:   Wed, 21 Aug 2019 11:47:53 -0400
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

Simplify the check in physdev_mt_check() to emit an error message
only when passed an invalid chain (ie, NF_INET_LOCAL_OUT).
This avoids cluttering up the log with errors against valid rules.

For large/heavily modified rulesets, current behavior can quickly
overwhelm the ring buffer, because this function gets called on
every change, regardless of the rule that was changed.

Signed-off-by: Todd Seidelmann <tseidelmann@linode.com>
---

  net/netfilter/xt_physdev.c | 6 ++----
  1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index ead7c6022208..b92b22ce8abd 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -101,11 +101,9 @@ static int physdev_mt_check(const struct 
xt_mtchk_param *par)
         if (info->bitmask & (XT_PHYSDEV_OP_OUT | XT_PHYSDEV_OP_ISOUT) &&
             (!(info->bitmask & XT_PHYSDEV_OP_BRIDGED) ||
              info->invert & XT_PHYSDEV_OP_BRIDGED) &&
-           par->hook_mask & ((1 << NF_INET_LOCAL_OUT) |
-           (1 << NF_INET_FORWARD) | (1 << NF_INET_POST_ROUTING))) {
+           par->hook_mask & (1 << NF_INET_LOCAL_OUT)) {
                 pr_info_ratelimited("--physdev-out and --physdev-is-out 
only supported in the FORWARD and POSTROUTING chains with bridged 
traffic\n");
-               if (par->hook_mask & (1 << NF_INET_LOCAL_OUT))
-                       return -EINVAL;
+               return -EINVAL;
         }

         if (!brnf_probed) {
--
2.17.1
