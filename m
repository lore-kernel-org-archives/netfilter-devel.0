Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FC45C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Apr 2022 10:33:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235601AbiDBKfk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Apr 2022 06:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiDBKfj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Apr 2022 06:35:39 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590E962A1F
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Apr 2022 03:33:47 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id a30so6828594ljq.13
        for <netfilter-devel@vger.kernel.org>; Sat, 02 Apr 2022 03:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=BPUGpiwpI3NqosV0Ck3zGpzbEEIoP/GpERHMuUJv26c=;
        b=XTgRAzA06DdKiM3mHBTtSGAK1yF3qAq2EkVVUYowtUi8/Y8rsOyqX7kVu0HkwyF81V
         2apxPKg+poKzvqI0zUjeoh/76zdEwoVt5AnRRfwBUCRoZhPq/76h6Ykdp+EOuBfZNexv
         x6GFK88q640ouSQW9/jON5JsmmsDC+e6AfRqQYm4NEe+14rC9qqxTqz2CNOB0dmhBBKs
         vPCCJ5DyZJZtx+GkuRSRc32AAU9KuVhiVMmiaktCjnwM7Lm8pxLd9rdrITYtZB7mGRJZ
         3X3TDx60lg97HxAeMIG7ASwLMF/6CElUkZ0psAyllV4ayzgtpQJPfOkbZUJmD7dRcy1I
         7knA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=BPUGpiwpI3NqosV0Ck3zGpzbEEIoP/GpERHMuUJv26c=;
        b=2y4dcuiYjr6w7foLEHohO1pSlCGymZzwNbuYFDHkE9/1BUqm+xe+zULTJ+tnGDjROf
         OMbSZ1/8ZhDXlgRGdeoaUew+o04PMtC+0Tr+UCWdmUup33XYZsiOTgU3D+fodpGfw5Oy
         cXx0LZZsFzrk80K9//fMFJoL5nbdYrEZlewjtUt/Y7uKWs+34M6DWVDFMC60llhheOF9
         e0OC6ZmvvRSgFMYJsAP5i3+35aE0RlQakUxZ4fTliCTlXxl+XsGkR9boCk093YI4RNZC
         QzOi/GadsOgBeFvXyhYqrW4iXj5OO3y4XteWJE2rsFc7A2t8Cm+p0WQUo1XY1c5SuCJi
         6DwA==
X-Gm-Message-State: AOAM530fArGR11abR8C6yIr/Bd9RUeFocVXkiMrObhMvk7XBwMxBT5nj
        JnF7idWXRofuuHXsXSU+/z0beWZavTnxxUU+
X-Google-Smtp-Source: ABdhPJyWK5M6HhquzMON8QqOQEM1VPREVT2rL1nPNBNuOIO2g49L4b9/eR/I9BjGYkIaiHxVBt6MiQ==
X-Received: by 2002:a2e:b054:0:b0:24b:108d:3792 with SMTP id d20-20020a2eb054000000b0024b108d3792mr652741ljl.444.1648895625570;
        Sat, 02 Apr 2022 03:33:45 -0700 (PDT)
Received: from [192.168.1.65] ([46.188.121.177])
        by smtp.gmail.com with ESMTPSA id u12-20020a19600c000000b0044a2e4ce20esm483448lfb.193.2022.04.02.03.33.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Apr 2022 03:33:45 -0700 (PDT)
Message-ID: <de70cc55-6c11-d772-8b08-e8994fd934a0@openvz.org>
Date:   Sat, 2 Apr 2022 13:33:44 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, kernel@openvz.org
From:   Vasily Averin <vvs@openvz.org>
Subject: troubles caused by conntrack overlimit in init_netns
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo, Florian,

There is an old issue with conntrack limit on multi-netns (read container) nodes.

Any connection to containers hosted on the node creates a conntrack in init_netns.
If the number of conntrack in init_netns reaches the limit, the whole node becomes
unavailable.

To avoid it OpenVz had special patches disabled conntracks on init_ns on openvz nodes, 
but this automatically limits the functionality of host's firewall.

This has been our specific pain for many years, however, containers are now 
being used much more widely than before, and the severity of the described problem
is growing more and more.

Do you know perhaps some alternative solution?

Thank you,
	Vasily Averin
