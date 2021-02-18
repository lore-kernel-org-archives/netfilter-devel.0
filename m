Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6775C433DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Feb 2021 06:54:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6859964E68
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Feb 2021 06:54:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbhBRGvC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Feb 2021 01:51:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55218 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230469AbhBRGoz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Feb 2021 01:44:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613630608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2TFOD6O1gf7eBt1ZwpCXVt4Z+lBTdV4PDVIQqPvwprI=;
        b=NBeD0LvRcXNi4e8vLSsp4pS26/vbAFHEoheg7eLolq+5izjgdFceBm9pV4PdEEtpahUfG7
        M0WTpyLoHMENtbt7fupzlNYOaSoc6I3b4Kqc4mA+akkhtDlbsCJ/lFCq/E/ZShqs7t7uYW
        wrteTT/g3V6boFtzYL/282NCMRQYfww=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-bjYabuNKMfyj9HOY2O9nJw-1; Thu, 18 Feb 2021 01:39:57 -0500
X-MC-Unique: bjYabuNKMfyj9HOY2O9nJw-1
Received: by mail-ed1-f71.google.com with SMTP id y6so414313edc.17
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Feb 2021 22:39:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2TFOD6O1gf7eBt1ZwpCXVt4Z+lBTdV4PDVIQqPvwprI=;
        b=j1Ej8UEpmb32HiDx9usxDFznu1HNZEVVggx879jegg8sN1vjBQ71QpbqMbNhsczC10
         JGIfab9bidWtYrgfKRjOMLsO9GCkO3C1+px9hOXCTpsOF92jAjzVcQ9DfgKTo4xw1aQF
         Y1l1oFmfx91KWn57UIXeDDBzguGI+A1dmdbbZI6L0qPLqoV3DkVgD3zxzZLrWJ3IEEaa
         oH/fezU4YhfBnHv/KL7D4WRLwyCmCPKZaH3LUz8mBKaMUJ+nXEqEbZ6s9+CiaRk3VN80
         DFUAGadf7PSUCKXgDaT2l7MB7hkoG6224sZD8qeBsVNj4NKurLt2NGk17vxj4ifVvw46
         JQnQ==
X-Gm-Message-State: AOAM532wmzmndk9pHYXcas9WHjxX8Y/tb/s/XzyMcDvn3y9ygno1shvW
        4YhAnEqfeWTgzqLuh2eHO/2V6Zx24vOvIzgPbUUzfejwpw8NAjYQzxNx9feXw4FyIlUIwqAW3fp
        oQM1YtVCp4N+rXqzgnRoTtW8aIP1+0K9VLwkOgRSX7Sx7e/7emGmiF35pBwtftCR8kCA/K+gFz6
        NM0t1B
X-Received: by 2002:a17:906:9bd2:: with SMTP id de18mr684177ejc.191.1613630396301;
        Wed, 17 Feb 2021 22:39:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx6Vfs6bOvJmLbVZjFQQYTzUjYdZT6fcmj+AiOacsa/2b8lW8uz3Isn0+FrkLC1v43vfyrI0w==
X-Received: by 2002:a17:906:9bd2:: with SMTP id de18mr684168ejc.191.1613630396154;
        Wed, 17 Feb 2021 22:39:56 -0800 (PST)
Received: from localhost.localdomain ([2a02:ed3:472:7000::1000])
        by smtp.gmail.com with ESMTPSA id 35sm2145176edp.85.2021.02.17.22.39.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Feb 2021 22:39:55 -0800 (PST)
Subject: Re: [libnftnl PATCH 1/2] Avoid out of bound reads in tests.
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <6b4add9f-7947-9f81-48c9-83b77286d2e6@redhat.com>
 <20210217230006.GA32290@salvia>
From:   Maya Rashish <mrashish@redhat.com>
Message-ID: <4d9778c2-6271-8535-163e-edbe429d04f0@redhat.com>
Date:   Thu, 18 Feb 2021 08:39:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210217230006.GA32290@salvia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On 18/02/21 1:00 am, Pablo Neira Ayuso wrote:
> Hi Maya,
> 
> On Wed, Feb 17, 2021 at 10:45:45PM +0200, Maya Rashish wrote:
>> Our string isn't NUL-terminated. To avoid reading past
>> the last character, use strndup.
> 
> Is this a theoretical problem or some static analisys tool is
> reporting out-of-bound memread?

As background, I had a difficult to diagnose stack corruption
with a patched older version. I was hoping it'd just show up
by running the tests with address sanitizer (I edited the
Makefiles to add CFLAGS=-fsanitize=address and LDFLAGS=-lasan
after configure) but it didn't.

Address sanitizer usually reports actual problems, it runs the
actual code with some elaborate memory map tricks that lets it
detect violations.

But might as well make the tests all run without complaints
from address sanitizer while I am doing this.

