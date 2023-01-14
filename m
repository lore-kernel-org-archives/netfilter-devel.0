Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65FF4C46467
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Jan 2023 21:19:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbjANVTC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 14 Jan 2023 16:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbjANVTB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 14 Jan 2023 16:19:01 -0500
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E2369EC7
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Jan 2023 13:18:59 -0800 (PST)
Received: by mail-wm1-f48.google.com with SMTP id g10so17433705wmo.1
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Jan 2023 13:18:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:cc:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SlADbflfY+2xio5ocBK4uHp8ymtYt/2MvXGMArKZnN0=;
        b=B138asqoNtsfryV7tpx9C3FXn/83sV90Gu4benLmAcXuonMIo1o3ZHcwGutShDSs22
         OtCYJTiRdsGL8N7hfBS/adYmaHD9L0WwYNxu2hKzCGs4+k/zEt0IqCBRPSIbOXCDTG9z
         xkHu+jQ10KbqMKqehT7kNvz+/Tl49lc0WFWhG08aAd6WdFEvoQf0VYA8q0o4SE21DjCq
         Kj3ykXNR3FRI3ZhXa8L1+2fS8IYzxu9Ze0bTYloJZflg2AnbPOfaHYP2ksagPvDX51J0
         s0afg9mIQoRZMYjpRNyvlT1T3zEQR3sFm857IJhEMoS/SWOlib1hBvAVxvooBLWxwdu0
         ygnA==
X-Gm-Message-State: AFqh2kpElbMxObYcNBj3FYZnSpmbSItKQAQ3TXA6wAptEHl6IPGGfbeO
        hAirreI8HTOsbm57y2gZO3DReI4W458=
X-Google-Smtp-Source: AMrXdXvFeI7wH/KxlzGVbMqdOP41r9FJ0K1ep7fbKG0nqLO6W4NiNjd77s1g7bmRu76ge8frmrkX+w==
X-Received: by 2002:a05:600c:4f90:b0:3da:2a59:8a4f with SMTP id n16-20020a05600c4f9000b003da2a598a4fmr2505466wmq.38.1673731137740;
        Sat, 14 Jan 2023 13:18:57 -0800 (PST)
Received: from ?IPV6:2a0c:5a85:a202:ef00:af78:1e88:4132:af3? ([2a0c:5a85:a202:ef00:af78:1e88:4132:af3])
        by smtp.gmail.com with ESMTPSA id r16-20020a05600c35d000b003d2157627a8sm36146196wmq.47.2023.01.14.13.18.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Jan 2023 13:18:57 -0800 (PST)
Message-ID: <e0357e53-8eda-9d9d-d1d6-4f8669759181@netfilter.org>
Date:   Sat, 14 Jan 2023 22:18:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [ANNOUNCE] iptables 1.8.9 release
Content-Language: en-US
To:     Phil Sutter <phil@netfilter.org>
References: <Y7/s83d8D0z1QYt1@orbyte.nwl.cc>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
In-Reply-To: <Y7/s83d8D0z1QYt1@orbyte.nwl.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 1/12/23 12:20, Phil Sutter wrote:
> Hi!
> 
> The Netfilter project proudly presents:
> 
>          iptables 1.8.9
> 

Hi Phil,

thanks for the release!

I see the tarball includes now a etc/xtables.conf file [0]. Could you please clarify the expected usage of this file?

Do we intend users to have this in their systems? If so, what for.
It appears to be in nftables native format, so who or what mechanisms would be responsible for reading it in a system that
has no nftables installed?

Perhaps the file is only useful for development purposes?

This information would help me decide what to do with the file in the official Debian package.

regards.

[0] https://git.netfilter.org/iptables/tree/etc/xtables.conf
