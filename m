Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9926C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Oct 2022 15:05:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiJTPF2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Oct 2022 11:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiJTPF0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Oct 2022 11:05:26 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56EC1D8EC7
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Oct 2022 08:05:25 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id w74so23212844oie.0
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Oct 2022 08:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F6ZKp2uwGYAyOtBZK6Opg9/RNckmoml54srjIDROcDg=;
        b=ZQAmHvXMFBX4sQQXA5TPjTYsJEoBEiFOGZ/6/Cr09SisfAak1k36nK2r6N7/XpoUJ3
         A2jpCt4jSZJDg0BmlM8GM9H69Zt6RarXmIYt+PjxKpeNW0pP/wa7OnCGnxx46lvMB1wN
         uvWzyRMfjODu1W6vT/8ECh2FYuFR98fJ6BM/zu81ii31D51z698Zl0qCwmjN5wnXxTr9
         4gJ4qOqnD/7UWgoxC1zqbuzUdzc6d7ILKNnOjlDftQrVqsk102nuS945d5+mysThqujp
         1qprv5ZhJ+HsVigoBTOyzyVuDtiyR4j87RAd/nABZbJAtypKUVSw6simxKiU4PUtuayD
         UN9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F6ZKp2uwGYAyOtBZK6Opg9/RNckmoml54srjIDROcDg=;
        b=ENeEjNuHnzoCurk9GJDME7DILUPxEdXQiBHrnt8h0/Ee7OQE8cIkNYj0pOm16UjQZM
         CEgu+i6XkovRQJhUPlvvSBWg5xzKCK147RLyeG41wIn8StUR0IR/oAfCaz8VMR4yp6li
         ONI5mLyJkEIKxlFxucKdW5HBTRvePkLR1h8Mxw5K2k/nipmRoSCtRcgClnr1iEuiLU00
         h1NR8UARk7naqcVvUyua5u6SgNsXuj58zE2cIUXAujZfATbtirfJPqq3/FF+B1BbLlUv
         wNPKR2v9RQvkm+0C9IYz1O81/v66cZmftV3X+lFQOKYQij+9XamO+d5yaPCiXqkAM6oA
         nVFQ==
X-Gm-Message-State: ACrzQf1sBY35V7kEKi0kpebkOQGBeP2wr8cN4ChZnLgsHlbpz3rzgMuC
        7ssTXqnj1frFqMl6hMyh+k+RUWCpO9s=
X-Google-Smtp-Source: AMsMyM7476KIBo2vqiQ/lSPS8ql2uoOO2ApZO+trrvxAj0FZ04v0KgyaEZcNXf9O/CB2+v4GTiLICQ==
X-Received: by 2002:a05:6808:d4e:b0:355:5438:4ce3 with SMTP id w14-20020a0568080d4e00b0035554384ce3mr6606548oik.130.1666278324620;
        Thu, 20 Oct 2022 08:05:24 -0700 (PDT)
Received: from [172.31.250.1] (192-063-109-134.res.spectrum.com. [192.63.109.134])
        by smtp.gmail.com with ESMTPSA id s23-20020a056870631700b00132f141ef2dsm8959274oao.56.2022.10.20.08.05.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Oct 2022 08:05:23 -0700 (PDT)
Message-ID: <a93c58a1-4006-0aaf-9f5b-7e3c3bba16c1@gmail.com>
Date:   Thu, 20 Oct 2022 10:05:22 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [RFC PATCH 1/1] libnftnl: Fix res_id byte order
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <20221018164528.250049-1-arequipeno@gmail.com>
 <20221018164528.250049-2-arequipeno@gmail.com> <Y0+c2Y3VtyXXFijD@salvia>
From:   Ian Pilcher <arequipeno@gmail.com>
In-Reply-To: <Y0+c2Y3VtyXXFijD@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 10/19/22 01:44, Pablo Neira Ayuso wrote:
> On Tue, Oct 18, 2022 at 11:45:28AM -0500, Ian Pilcher wrote:
>> The res_id member of struct nfgenmsg is supposed to be in network
>> byte order (big endian).  Call htons() in __nftnl_nlmsg_build_hdr()
>> to ensure that this is true on little endian systems.
> 
> LGTM, this is zero all the time at this moment. But it might be useful
> in the future to bump it.

Actually it isn't always zero.  I only noticed this because
nftnl_batch_begin() and nftnl_batch_end() set res_id to
NFNL_SUBSYS_NFTABLES (instead of putting it in the high 8 bits of
nlmsg_type).

It's entirely possible that this is also a bug, as the fact that the
value isn't currently being byte-swapped doesn't seem to make any
difference.

-- 
========================================================================
Google                                      Where SkyNet meets Idiocracy
========================================================================

