Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2344C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Mar 2022 10:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbiCZKLI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 26 Mar 2022 06:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbiCZKLI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 26 Mar 2022 06:11:08 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0721EC71
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Mar 2022 03:09:32 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id d5so17126012lfj.9
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Mar 2022 03:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=Ejr7KK2dxrBOHlmLiNOb8ne6WScstQky9HgutUHWOUQ=;
        b=FmNDXDuWteODlWclsl1imluf5pz7soJ6LS3b2Hgm1kHVvTB+5QWaRhwcN/jLiHt2xK
         qJ928iXPBLl4pMjKzVeNaMJobQEnqhBFGgSY9EYDDMa2ccL9qDnBWgn2iIUNsSkL1BFa
         f6ukdvHw075VtFNcITkUWVQ+3SBiUtpelvjcw3VTLTbAqSAXRMXkr6DP9Hbx9CKPJIqL
         ghujZIWiTCfgz9aDSIU+fTz8mfodow7UrJMxDzsKA8+QSOATU5WSuSXDrIr7W8gKZPPl
         o71WYSCdg+gxw1haarAl2yXqaMkbfZHURgH6cGwcQV3g79wYa2J7QHE08m3TC0+rllDQ
         c9zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=Ejr7KK2dxrBOHlmLiNOb8ne6WScstQky9HgutUHWOUQ=;
        b=CD1ApoWSaBbx9RI/QdIW5RUimzJ4/i/VwKt69hEKLCkoLuVF9OWpFibAnlFtydBmPZ
         fzMXMml+elzZDN9pQXdBZWEZbPLURzmEv+agCFJLMIiAIfLAIcEyIz7HNEO3LZypkUJH
         y0afDH2W8ntpaaDpOMRqD/qZ2healFRPdGgMFpWgfZcUCh2bFq/KtMhISrsm428UkYj7
         s9pOg/xLgVlDc3aasPhPMHYnIEud9HWgjbiBYAzOEVgnxi+39hET9S4EFYct0pWPu4Cj
         XQz3b7QR6Ufx3sk/kr4Rwid/kW0wdI+vtaloWJ7643TB12YWhbGW7mjUTgq2VxmaJtJ3
         9Uww==
X-Gm-Message-State: AOAM530fMfWIa8Ckb5WEx/QkYWktQPvK69tLmTG0+obfUAIhmL1D4diD
        Hs1SEF6A3HNtIcrApYE97v4w9xXo4lM=
X-Google-Smtp-Source: ABdhPJwzr3Dl/mx20ndWEISySTeeczW6nlN4zfK9s2GwLiMKJ7WS2EfgRVdou3CIVOg03sn284/lgQ==
X-Received: by 2002:a05:6512:1387:b0:44a:2d7b:adca with SMTP id p7-20020a056512138700b0044a2d7badcamr11261958lfa.680.1648289369338;
        Sat, 26 Mar 2022 03:09:29 -0700 (PDT)
Received: from [192.168.1.40] (91-159-150-194.elisa-laajakaista.fi. [91.159.150.194])
        by smtp.gmail.com with ESMTPSA id h21-20020a0565123c9500b0044a34642bf4sm1011791lfv.7.2022.03.26.03.09.27
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Mar 2022 03:09:28 -0700 (PDT)
Message-ID: <fabde324-383a-622c-7e69-32c9b2d06191@gmail.com>
Date:   Sat, 26 Mar 2022 12:09:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     netfilter-devel@vger.kernel.org
From:   Topi Miettinen <toiwoton@gmail.com>
Subject: Support for loading firewall rules with cgroup(v2) expressions early
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I'd like to use cgroupv2 expressions in firewall rules. But since the 
rules are loaded very early in the boot, the expressions are rejected 
since the target cgroups are not realized until much later.

Would it be possible to add new cgroupv2 expressions which defer the 
check until actual use? For example, 'cgroupv2name' (like iifname etc.) 
would check the cgroup path string at rule use time?

Another possibility would be to hook into cgroup directory creation 
logic in kernel so that when the cgroup is created, part of the path 
checks are performed or something else which would allow non-existent 
cgroups to be used. Then the NFT syntax would not need changing, but the 
expressions would "just work" even when loaded early.

Indirection through sets ('socket cgroupv2 level @lvl @cgname drop') 
might work in some cases, but it would need support from cgroup manager 
like systemd which would manage the sets. This would also probably not 
be scalable to unprivileged users or containers.

This also applies to old cgroup (v1) expression but that's probably not 
worth improving anymore.

Related work on systemd side:
https://github.com/systemd/systemd/issues/22527

-Topi
