Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92CB0C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Oct 2021 22:03:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7301060551
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Oct 2021 22:03:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhJ0WGO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Oct 2021 18:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbhJ0WGN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Oct 2021 18:06:13 -0400
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC658C061570
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Oct 2021 15:03:46 -0700 (PDT)
Received: by mail-oo1-xc30.google.com with SMTP id d144-20020a4a5296000000b002b6cf3f9aceso1420155oob.13
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Oct 2021 15:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=FZj61GWpM5pU/d2w4B5sJbmNh5cy3/ShsZZLOc2oT0M=;
        b=cnxq8LTb4m4lHltpRpcNOZ86z9xmsRvfOhagwKF/ZikdbfJNMKH4v59KmOawOxAubJ
         jDhhXoU1ED2IozJH/asPquGDIXQRE7r+/n2VcsV50o9tCM296h+xr+0otYBmOFEC5ivI
         isp5Ng7cfjEWeWuSlk/4e310xYKdbY73bhTF0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=FZj61GWpM5pU/d2w4B5sJbmNh5cy3/ShsZZLOc2oT0M=;
        b=PQdhge1jabyfgg1qPNU7SZBB0MQUyAUv9FySCLacyNMV4Jg3V1tIL5ws6EytOfhATx
         6O/j/aIHGQt9KiFY7IkOgUVRMfLLvu34CkRNYVSWwhDoM0QaCv/WZoxQd70LUiU1tjgm
         /Cx2SrHlaao1rwUfo3TBNReMZnxFM3eB5O6un7oPc/25ZrXNNTNRUBt/1RsJlZeUmM7P
         h4mm5P3ffzmPcaHIGsfkvQHVd2GRSx5JxhryH3OxU2AfsJbHHB7UjPAxS1+YHKB1QSUP
         OFVMvNY09f+peqF2IrzOFwZPuh/pckUxb5nfxyzxM0qS286O+kDIxWJuiAS3Tf/NvbQg
         2vUw==
X-Gm-Message-State: AOAM533RuJlkU/HKSxij5hpt9/aswENFwbYm2yEwSoR7BAQNo4ajEbFW
        f/TEiV+L5/Ic0e+esRNchJO2kKxHEv9NuQ==
X-Google-Smtp-Source: ABdhPJygftGJOYlkAtWTa8fjyNfF79I4ZEz3X3oWaacIUi04jNf6W3wQXnY0cGWpC3PAaECPfB+DQg==
X-Received: by 2002:a4a:d351:: with SMTP id d17mr239552oos.33.1635372225770;
        Wed, 27 Oct 2021 15:03:45 -0700 (PDT)
Received: from [172.16.0.2] ([8.20.123.21])
        by smtp.gmail.com with ESMTPSA id c17sm530997ots.35.2021.10.27.15.03.45
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 15:03:45 -0700 (PDT)
To:     netfilter-devel@vger.kernel.org
From:   Chris Arges <carges@cloudflare.com>
Subject: nft terse set listing issue: netlink: Error: Unknown set in lookup
 expression
Message-ID: <7bfa71f4-ec0c-d74d-cba6-a456a45ed2c1@cloudflare.com>
Date:   Wed, 27 Oct 2021 17:03:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi, I was wondering if it is possible to do terse listings of rulesets 
and ensure that set names are also visible.

For example if I have the following example:

#!/usr/sbin/nft -f
table inet filter {
     set example {
         type ipv4_addr
         flags interval
         auto-merge
         elements = { 10.10.10.10, 10.10.11.11 }
     }

     chain input {
         type filter hook prerouting priority filter; policy accept;
         ip saddr @example drop
     }
}

if I do the listing in v1.0.0, I will see the following:

$ sudo nft -t list ruleset
table inet filter {
     set example {
         type ipv4_addr
         flags interval
         auto-merge
     }

     chain input {
         type filter hook prerouting priority filter; policy accept;
         ip saddr @example drop
     }
}

In the latest master I see the following:

$ sudo nft -t list ruleset
table inet filter {
         chain input {
                 type filter hook prerouting priority filter; policy accept;
                 meta nfproto ipv4 drop
         }
}
netlink: Error: Unknown set 'example' in lookup expression

The old behavior is nice in that the set name is present without the 
contents of the set.

Thanks,

--chris

