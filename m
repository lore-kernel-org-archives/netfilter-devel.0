Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F68CC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Mar 2022 01:06:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbiCIBHQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Mar 2022 20:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiCIBHK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Mar 2022 20:07:10 -0500
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1008513A1C5
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Mar 2022 16:46:45 -0800 (PST)
Received: by mail-oo1-xc2f.google.com with SMTP id u30-20020a4a6c5e000000b00320d8dc2438so1012303oof.12
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Mar 2022 16:46:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=Q6UWOgLuGhFsaKV3J3X+W0i2/puX6lZTv6WWjjklL60=;
        b=hPe3vDEl8sUgpYUQBBmhvEuNgpuDan4bhE9VO958Zxq0L6sDPFVstbcPeBKh5KY+GG
         yk2PWb7jYxnxPjiiIEfK+FQdmFe9e3e1JlJ+lRshQTzMx6m7KwDA6aDy7Z6XDbh8iYMj
         9Z/oZD3685/hi/kd1unO3+VjDpC9/LRtU2bo2Cdefbc7Tnx+ccIuk8Fk3bLGxteSigfJ
         1tRj0ECHvot6+SqKaG5T36yHD41Ne41xyNffCGJpwg4gs/v2fh3Y7ZCneJNr7/Vq0nwY
         xQ+CQf7NuTz6DZYobLsuDSP9A2Vd+epacp0yA4eb1uQk88gyMTBXLeFWtgDBwgQaHECM
         7tkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=Q6UWOgLuGhFsaKV3J3X+W0i2/puX6lZTv6WWjjklL60=;
        b=wWXDg9i3HF8BrUS1VpBrS6ZoPJ1L2VvC5JSkEslWkAH8hSSNJXH6dqTQwHT7+cZGqg
         8CHznSNyTOU6XXquRvqh+cb5OUQSdqdz+jMOPq91ealb0pAdwHOnRIEtStja0UYrppI2
         Cnxf5FzbnIfVamEDJLSB6CP2wPj8numHDmgI+upWypvaaBmrLP9Hr623F8jlXUe1gugc
         XiSW1mUfz8VUb5Q+yzJeJxQRtdt0NC5TACU2m8ICSnenuviD8H1Vde9311DK4vsx+r5O
         +pPdn7qrS6fWEnvQd7fG3Y2TRdXU0Bt66ECKIGjggZ7FyhVE9XWn4OXfIzN4FR8MbI7W
         uq+g==
X-Gm-Message-State: AOAM531h/TWviwZ5I0O1DJoc9BMj2KQv79VGUASwr+I3qXWahYlfd0ws
        VhKlWZrnrbFytNeQ4uE9n3M98wEyVYI=
X-Google-Smtp-Source: ABdhPJx1i/e+WSgFie+ljf1bm2bmzEPxAmhtfoU1gC3UhfH2ZjYXfMOZoRZ1MmPeD132MB6dylIJHw==
X-Received: by 2002:a05:6808:20a4:b0:2d5:1d0f:bba3 with SMTP id s36-20020a05680820a400b002d51d0fbba3mr4505315oiw.55.1646782831086;
        Tue, 08 Mar 2022 15:40:31 -0800 (PST)
Received: from [172.31.250.1] ([47.184.51.90])
        by smtp.gmail.com with ESMTPSA id 60-20020a9d0642000000b005b22a82458csm105503otn.55.2022.03.08.15.40.30
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 15:40:30 -0800 (PST)
Message-ID: <32c1b5d3-59f9-8bf2-ee22-f4b6708d57be@gmail.com>
Date:   Tue, 8 Mar 2022 17:40:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     netfilter-devel@vger.kernel.org
From:   Ian Pilcher <arequipeno@gmail.com>
Subject: Looking for info on ipset set type revisions
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I am working on a C program that uses libmnl to do some basic ipset
manipulation - namely create a set of type hash:ip,port and then add
entries.

The best technique I've found to figure out the exact messages required
is to use strace with the ipset command.  strace does a pretty good job
of decoding the netlink messages, and I can generally figure out the
significance and meaning of other constants by looking at the various
header files.

The one thing that I haven't yet been able to figure out is set type
revisions.  When I use ipset to create a hash:ip,port set, I see that
it is passing 6 as the IPSET_ATTR_REVISION.  I can also that 6 is the
latest revision in lib/ipset_hash_ipportip.c, which is fine when using
the ipset command or calling libipset.

What about programs that don't use libipset?  How can an application
determine the latest/correct revision of a particular set type?  I
haven't been able to find anything in any of the header files that
seems relevant, nor do I see any way for an application to discover this
information at runtime.

Should I just hardcode 6?

Thanks!

-- 
========================================================================
Google                                      Where SkyNet meets Idiocracy
========================================================================
