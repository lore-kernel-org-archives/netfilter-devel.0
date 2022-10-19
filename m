Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30399C4332F
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Oct 2022 17:54:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiJSRyQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Oct 2022 13:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiJSRyP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Oct 2022 13:54:15 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05AD71CC3D5
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Oct 2022 10:54:14 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id r14so29425594lfm.2
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Oct 2022 10:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:from:content-language:to
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zqOPXcu7sOH/vWd3cX22vB6AeLp8q+IOm/YhNnmp1/I=;
        b=YaryscOMIsMFXh21gx4wHs6jKxzJTbm41drLgmOi3V1TF0913hOec+QwvhroSzKJDG
         cxydzx6FuYFzy7WbScGkylJqNvZBICRRAd4nC5etwv48I0mUU41pZEvNKn+07JbCmkPw
         kkeitIXs+ylbH35V9EhNdDZm/L+dTzn2+IR5+ocGIOhdr+gA2lsw3cItO6OZVMlVWu6b
         m3Ssfx4uRnKg0TXf2IB+3BC3MTfZN/HnZBuqJI/ZY5W3w1BvHoZJ1T8tqeT2ewkQ3KA8
         PAvcEFN+EYdokeuiHbbWGzqaManY2tGHeiMuXqIGZnIiqxzxyaop8fdopFEpaC9apDS6
         K+mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:content-language:to
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zqOPXcu7sOH/vWd3cX22vB6AeLp8q+IOm/YhNnmp1/I=;
        b=jToTHakcJYHqsQkpLZYA8kYrVKm8x/Ser3mVxfuA1dGKASHnp5cHWPMS54C/ps3poX
         KvXnaDnUnwRD6iwGqW+343f26G4tZch56plAOsX3HMdN/RQh9GbZuaQNS+zfMhvSnZUX
         7FGg0RttbKehrsV4lwdbLSiHaS9nhMr6xhqxW2qIufYVSwr5Zy/hBjimKav0k+M+QPm8
         bFMVaMt59/fhiHXe8Hep7mH7VSh6kxvu5fRS3h1RR9VLvLwMHfSM8qH43NjFsXdb9pr7
         bSUyIuDxn6LE2nsKWCIMjLDHXX+F56u2mpgGkoJFlXk9tygqibWr6uKmLM1qaHKvdcO/
         4J6w==
X-Gm-Message-State: ACrzQf3pB2ukxOJ2ksZnFB+KSIoKspWV++XJHFOcosFB4lOcJbd0uY1m
        C5/688fx7Qg1R8OMf5RAjUyY8lhtGbU=
X-Google-Smtp-Source: AMsMyM4QkSh3GzTEawO9+sXgZ3C0Wx34YsyFl8qZ9S63Bp8Z+rP1sATkXTyTJrwgF9bIaVIeKQzvJw==
X-Received: by 2002:ac2:592c:0:b0:4a2:3cde:ef7d with SMTP id v12-20020ac2592c000000b004a23cdeef7dmr3033479lfi.251.1666202051090;
        Wed, 19 Oct 2022 10:54:11 -0700 (PDT)
Received: from [192.168.1.10] (mail.dargis.net. [62.80.227.49])
        by smtp.gmail.com with ESMTPSA id r13-20020a2e8e2d000000b0026dffd032b8sm2456757ljk.2.2022.10.19.10.54.09
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 10:54:10 -0700 (PDT)
Message-ID: <4fbbbf44-c6b0-bce1-6dbd-934ad2b9c20e@gmail.com>
Date:   Wed, 19 Oct 2022 20:54:09 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
To:     netfilter-devel@vger.kernel.org
Content-Language: en-US
From:   Vincas Dargis <vindrg@gmail.com>
Subject: Status of UID GID maching support in INPUT
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I've found a thread [0] about implementing UID, GID matching, but I am not sure what is the status of that patch.

What is the status of UID, GID maching in input hook?

Firewalld developer hinted that there might be some progress about this [1], but maybe you could clarify/confirm/deny that?

Thanks!

[0] https://lore.kernel.org/netfilter-devel/20220420185447.10199-1-toiwoton@gmail.com/
[1] https://github.com/firewalld/firewalld/issues/725#issuecomment-1245342595
