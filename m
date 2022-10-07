Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87509C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Oct 2022 13:41:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbiJGNlF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Oct 2022 09:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiJGNlE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Oct 2022 09:41:04 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 700BFB97B3
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Oct 2022 06:41:02 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id fb18so2767608qtb.12
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Oct 2022 06:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UJEfQ0xmWlxtFl0I0KeuWqinB4UP4HOgFmXqCQp4x8A=;
        b=ZmtFvEMVlw+iMlUQwuzhRlNJQd2kyHekMWr7X/ICFuJ0m0o5+y0HBEyoX/bs/w5Zkw
         Y1yAHZUWHtb0rjk/SgYh5q5urD9jsBR4kAv39i5Tv+jcdM7tpK1zAUHa8jbxO+AYHRI/
         X7g/TowPCAUsD0336PgTupzJEXOK6WAZMm/H3Ac0Q7YQnkv9S5eEpx52coQN6Fd5apXW
         heX+BJ8PKguFj6Ys+sCF8nJqYMC/yZ+9Vb8gm38pW2cU4nZ4geBuo/nWJnlpSCgvoeSW
         lHFBu+pSljJGHgPJyaBbhd4dEDVbUlwtZG3hdEo2lQQSbZyas3rTlpIYIL5FajRxJ1yo
         00ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UJEfQ0xmWlxtFl0I0KeuWqinB4UP4HOgFmXqCQp4x8A=;
        b=HSJRqfIQtmxRJEK0VjzFub5W2aFrdBKDVR+P43U5AB7ms8ssAS9R7u4sZZNrCAcbRu
         GTofUG5FlrHYjcGllq74R4jWJA2a1AoX8ShzgCYz5aAMmLvDd/wtL3SzIM8hgUuLmqLt
         E3IU6r5i63gAyKB7PqP3aqqvfHM/wAOwZ4y4Xp/a5KWi0NOHesFkO4fkDUx0N/MNSZJG
         MkGOrqIitTxsvup4xG7O7xcj5HgeocghvgYGceFBwjuPhUNjPqLTfKRmmlbfc2ezM3OC
         7Xwa87fy56MH2a4oFZuy3NBaQ/3nP1MehhHO1bT1EVOzHLDwyp/JVmvUsNNJeXA37UgF
         EYXA==
X-Gm-Message-State: ACrzQf2TZPEjWiBAc3aUOJs7bhn4422wCp2Y0QVI1hZqK5jQO5jEag++
        i9m2R42jwQ7ZJuXjpWgtF4neGyhXBGO2edqvBCw=
X-Google-Smtp-Source: AMsMyM6GhUPsaQ6UdyVh3qU4TwZGfLWThNpobAvFWFHv637CILwlHf+Va0Qdx42bi5yB5VyGKpIV4w==
X-Received: by 2002:a05:622a:4cc:b0:35d:4f2f:9fc7 with SMTP id q12-20020a05622a04cc00b0035d4f2f9fc7mr4108810qtx.203.1665150061557;
        Fri, 07 Oct 2022 06:41:01 -0700 (PDT)
Received: from [192.168.1.30] (pool-108-4-135-94.albyny.fios.verizon.net. [108.4.135.94])
        by smtp.gmail.com with ESMTPSA id u28-20020a05620a085c00b006ceafb1aa92sm1975586qku.96.2022.10.07.06.41.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Oct 2022 06:41:01 -0700 (PDT)
Message-ID: <bb3a25d5-76b4-b0e5-cff6-7098912c4176@sladewatkins.net>
Date:   Fri, 7 Oct 2022 09:40:59 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.2
Subject: Re: bridge:fragmented packets dropped by bridge
Content-Language: en-US
To:     Vyacheslav Salnikov <snordicstr16@gmail.com>,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <CACzz7uzbSVpLu8iqBYXTULr2aUW_9FDdkEVozK+r-BiM2rMukw@mail.gmail.com>
From:   Slade Watkins <srw@sladewatkins.net>
In-Reply-To: <CACzz7uzbSVpLu8iqBYXTULr2aUW_9FDdkEVozK+r-BiM2rMukw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hey there,

On 10/7/22 at 7:21 AM, Vyacheslav Salnikov wrote:
> Why was this patch not accepted in the end?

Huh...

I had to do just a little bit of digging to find the original thread,
but it really doesn't seem to me like there was a consensus on whether
or not to take the patch:
https://lore.kernel.org/lkml/20190730122534.30687-1-rdong.ge@gmail.com/T/#u

Reason I say that is that the thread is rather old, and died off quickly.

Someone involved with that patch may be able to offer the answers you're
looking for, if they haven't forgotten about it after all this time.

-srw
