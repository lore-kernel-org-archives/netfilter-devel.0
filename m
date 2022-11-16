Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F3A2C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Nov 2022 17:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238693AbiKPRml (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Nov 2022 12:42:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234618AbiKPRmf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Nov 2022 12:42:35 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8092B5E3DE
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Nov 2022 09:42:34 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id u24so27634618edd.13
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Nov 2022 09:42:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:from:content-language:to
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b5x7RFTGmfFvFuO+uvDhR5hsnJsh3vXazZluYs6O79o=;
        b=G0XvrHkWSTOaIcGkvrfyHUcVsScr8nlltX883kxqVquYHTnL+jCLh874AOLJ7KLp6s
         6ZMIi0DL/os3HI2TFWjpk9J5SdgRjTCBkvDpXcpNClNcmwH5XUJGPJOOLDWe0BDMIWc/
         O62aizeW2pBPmkQmNZKqAffn/vsRjhRHJCeQxLqw9aRrMaH2hu94NdU19FACu13eQIbI
         46VwQcf0PTNZRmW9MfAiXX4ah4qCVbSNzpsPrNOeuvZ1S8ZEB7L9qatuiT5cTsjCbs3C
         TCyjgRzO9E9pGFKfurj9IiR3mwwCnI0iehrrmMVAd57OLHmtTxy2k+S5Nd7iYV3o+Lav
         wtvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:content-language:to
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=b5x7RFTGmfFvFuO+uvDhR5hsnJsh3vXazZluYs6O79o=;
        b=aUy0zMNIiqemPHMZRKdQ20IJCzPIfTQFmEtRg4Z2bEpZYCOrN3yPImcZ+2Z5xu279w
         C+ImGYaqMdZE/z93JUO9kDH5dWPkWoPQRJCoELvsSJ7J1CKbOcSq6DgL4bSRjP4gG+/K
         lqL8aIHdUvHIz6jZI+iBWnTKRsyTepLmQwhw0WAVhCOaW0RIoSrLaQHDxISd7wYz5KIZ
         jXfdOgb6I4SgaAhbbiEF35luSxE+fAb57cuyQBtCvJqT6AoIUVamo4qBke+wnG/tPqDz
         zksLwU2gLP2usUhAFATb4BPJMZVdkpaNDhYEcTyJ6FXozwO2pq661NKp9rog1tsIZMGp
         nRkw==
X-Gm-Message-State: ANoB5pmmJrvwo3nSATFAru2ik3qLwMtcR1/nBIgvrEcrZcBgPmsZsAe0
        1IZt+C+SCABFICjEcCVYrV4fRAq0Ck8=
X-Google-Smtp-Source: AA0mqf4OMfRIXxWB6qT7oDHKgMladBMrLZd5Z9Q7h/H4BSxYR64BYt1lz407C3R8/7jrQSIUAWfz7w==
X-Received: by 2002:a05:6402:5511:b0:468:dc9:ec08 with SMTP id fi17-20020a056402551100b004680dc9ec08mr10479361edb.17.1668620553138;
        Wed, 16 Nov 2022 09:42:33 -0800 (PST)
Received: from [192.168.151.190] ([89.136.166.99])
        by smtp.googlemail.com with ESMTPSA id f6-20020a17090631c600b0073ae9ba9ba8sm7154328ejf.3.2022.11.16.09.42.32
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Nov 2022 09:42:32 -0800 (PST)
Message-ID: <15e85292-dfce-edf4-794e-410d8cffaf33@gmail.com>
Date:   Wed, 16 Nov 2022 19:42:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
To:     netfilter-devel@vger.kernel.org
Content-Language: en-US
From:   Shockedder <shockedder@gmail.com>
Subject: Missing definition of struct "pkt_buff" for libnetfilter_queue
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

I'm running with a slightly older version of "libnetfilter_queue" (1.0.2).

I have installed both the standard and devel packages, along with the 
same for "libnfnetlink"
I can't for the life of me find the definition of "struct pkt_buff" in 
any of the source or headers.

Due to that I'm getting errors when trying to compile accessing 
structure members:

"etf_nq.c:78:93: error: dereferencing pointer to incomplete type ‘struct 
pkt_buff’
        fprintf(stdout,"[PACKET] UDP pB->th pointer val=%p pktb_tail 
pointer val=%p\n",pktBuff->transport_header,pktb_tail(pktBuff));"

And also having issues accessing the payload for UDP (null pointer 
exception).

What am I missing ? Does something else also needs to be installed ?

Please help.

Kind regards,

    -V



