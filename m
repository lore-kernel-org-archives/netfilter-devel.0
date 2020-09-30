Return-Path: <SRS0=6DLs=DH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D65AAC4727F
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Sep 2020 09:58:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F8B42075F
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Sep 2020 09:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729067AbgI3J67 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Sep 2020 05:58:59 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:42601 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727657AbgI3J65 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Sep 2020 05:58:57 -0400
Received: by mail-wr1-f49.google.com with SMTP id c18so1063875wrm.9
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Sep 2020 02:58:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:autocrypt:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=vrI3+3SwH+QXvsae7mKBfWi/a6tSDXZik/5AUEFXq/U=;
        b=AiyfqU3ccLvzBlMnV92XnwvA5DAtPcQzVcP84B5GfVixKWO+/WcmWQPla/UYPrIrxX
         gkrTm+5A+T85QWmXISeBhn7rb2UDTisoEaHGtu1agSTY/bCzu0rbUYAMHU8pFDbDzZYo
         ThZDxOr21L+oiuG66gX31D2FLe+VO7Cvq/uYMzyODkgm4EHNASoHnr0eYez5FnSSHxlh
         LrQ8eiCKztYknU9oQRMxyvTRS1h3ZWpsdzSfH1yo3NsfGpcKaEm2VhLQKJlDejcnbq/S
         cqlOM571Y42wJcz5GO9SG+jKI1pQ/m0hFXUbXgrQeqT/o6NVC4O1CO1ejHbPScKLDVZ5
         4S2g==
X-Gm-Message-State: AOAM532L5en24Drzk9fe1ihQB3gdVwXl7wwSyVqXzC+PLvLcMwai82k0
        05ZzwD0ymFywFBwgDxYFB/QGtvZkIf7TwQ==
X-Google-Smtp-Source: ABdhPJymLktRCoOCesppB4+zCWNMkcMKC2BicWjfFt9SrSr4XU0zUAIzcJDh6mTxvdAbKA22HvkaSQ==
X-Received: by 2002:adf:9b8b:: with SMTP id d11mr2340755wrc.71.1601459934086;
        Wed, 30 Sep 2020 02:58:54 -0700 (PDT)
Received: from [10.239.43.214] (79.red-80-24-233.staticip.rima-tde.net. [80.24.233.79])
        by smtp.gmail.com with ESMTPSA id t10sm1824634wmi.1.2020.09.30.02.58.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 02:58:53 -0700 (PDT)
To:     Phil Sutter <phil@nwl.cc>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: iptables-nft-restore issue
Autocrypt: addr=arturo@netfilter.org; keydata=
 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
 EXgmBmyUKrJkh/zvupp9t9Y2ioPbcMObRIEXio4=
Message-ID: <198c69b7-d7b2-f910-c469-199bfe2fda28@netfilter.org>
Date:   Wed, 30 Sep 2020 11:58:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

(CC'ing netfilter-devel)

I discovered my openstack neutron linuxbridge-agent malfunctioning when using
iptables-nft and it seems this ruleset is causing the issue:

=== 8< ===
*raw
:OUTPUT - [0:0]
:PREROUTING - [0:0]
:neutron-linuxbri-OUTPUT - [0:0]
:neutron-linuxbri-PREROUTING - [0:0]
-I OUTPUT 1 -j neutron-linuxbri-OUTPUT
-I PREROUTING 1 -j neutron-linuxbri-PREROUTING
-I neutron-linuxbri-PREROUTING 1 -m physdev --physdev-in brq7425e328-56 -m
comment --comment "Set zone for f101a28-1d" -j CT --zone 4097
-I neutron-linuxbri-PREROUTING 2 -i brq7425e328-56 -m comment --comment "Set
zone for f101a28-1d" -j CT --zone 4097
-I neutron-linuxbri-PREROUTING 3 -m physdev --physdev-in tap7f101a28-1d -m
comment --comment "Set zone for f101a28-1d" -j CT --zone 4097

COMMIT
# Completed by iptables_manager
=== 8< ===

I'm testing current iptables git HEAD (f75750ff) and this is the diff between
iptables-nft and iptables-legacy:

=== 8< ===
arturo@endurance:~/git/netfilter/iptables master ± sudo
iptables/xtables-legacy-multi iptables-restore --verbose ~/t

Flushing chain `PREROUTING'
Flushing chain `OUTPUT'
Flushing chain `neutron-linuxbri-OUTPUT'
Flushing chain `neutron-linuxbri-PREROUTING'
Deleting chain `neutron-linuxbri-OUTPUT'
Deleting chain `neutron-linuxbri-PREROUTING'
# Completed by iptables_manager

arturo@endurance:~/git/netfilter/iptables master ± sudo
iptables/xtables-nft-multi iptables-restore --verbose ~/t

Flushing chain `PREROUTING'
Flushing chain `OUTPUT'
iptables-restore: line 12 failed
=== 8< ===

In case it helps, this is linux kernel 5.8.10 here, but I can reproduce the
issue in older kernels (4.19.132 in the case of my neutron server).

Let me know if I should open a ticket in netfilter's bugzilla, or this is
something you are already working on.

regards.
