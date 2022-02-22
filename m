Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58C58C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Feb 2022 15:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232786AbiBVP3K (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 10:29:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbiBVP3J (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 10:29:09 -0500
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FE915F60B
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Feb 2022 07:28:44 -0800 (PST)
Received: by mail-wr1-f48.google.com with SMTP id u1so33997272wrg.11
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Feb 2022 07:28:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WC3hB5YdAcwA4PPTA7heNcgmq7uChnqcIlR9jpxbL8A=;
        b=bcqJpBo2ltZZSLmphBupbqSSr8K07x1N6JmSTDpuT9D5lYrzgqmkQLd8cLjdhkyAZP
         58GPw/e4MYnsBhG+qpLL8ZAh5KFjM+SlQNciR4qHOKoaFssRSbcUkGo7rEcqK3MUhECR
         i+IpuobiXG3YNzIMisxsQjOC5mx1assQxUsDM9dxmEN5a/OCkfR/hhcYR6+IF6AmQL2f
         mzC70F/x/Zet6e+dWDwRfXn5mn1jGzYC7bxFakqEqRdNFwfYod2y0wFcBXhmhYt+sFxl
         pyKw4eoe6hIQ1heMi3brmtQGJLqZ0t6eDycM+fJ4LC1i5r9ZjcU30rdgfnMWn3Msth9O
         2mSQ==
X-Gm-Message-State: AOAM531ZkGsdMsm2Kl62yO5rE2MmlwGRWi8zFLMiZxZFbtECGUR2D1U1
        aSyWl1GU4JW51c5ctFH1jKY2eHUVN3IJtQ==
X-Google-Smtp-Source: ABdhPJzo9pb1++EU+Jjys+n72xRPWuu0KFZGcX3J146qzsa/mYADGOa2B5HfYcXIx1wgNvU/0iSzDw==
X-Received: by 2002:a5d:4450:0:b0:1e6:8d72:b88e with SMTP id x16-20020a5d4450000000b001e68d72b88emr20339777wrr.632.1645543722498;
        Tue, 22 Feb 2022 07:28:42 -0800 (PST)
Received: from [192.168.1.198] ([213.194.137.246])
        by smtp.gmail.com with ESMTPSA id b10sm61087329wrd.8.2022.02.22.07.28.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Feb 2022 07:28:41 -0800 (PST)
Message-ID: <7c75325e-f7c0-2354-3217-2735d8c3bbb6@netfilter.org>
Date:   Tue, 22 Feb 2022 16:28:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [ANNOUNCE] nftables 1.0.2 release
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
References: <YhO5Pn+6+dgAgSd9@salvia>
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
In-Reply-To: <YhO5Pn+6+dgAgSd9@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 2/21/22 17:09, Pablo Neira Ayuso wrote:
> Hi!
> 
> The Netfilter project proudly presents:
> 
>          nftables 1.0.2
> 


Hi there,

this release doesn't build out of the box:

[..]
Making all in examples
make[3]: Entering directory '/<<PKGBUILDDIR>>/examples'
gcc -DHAVE_CONFIG_H -I. -I..   -Wdate-time -D_FORTIFY_SOURCE=2  -g -O2 
-ffile-prefix-map=/<<PKGBUILDDIR>>=. -fstack-protector-strong -Wformat 
-Werror=format-security -c -o nft-buffer.o nft-buffer.c
gcc -DHAVE_CONFIG_H -I. -I..   -Wdate-time -D_FORTIFY_SOURCE=2  -g -O2 
-ffile-prefix-map=/<<PKGBUILDDIR>>=. -fstack-protector-strong -Wformat 
-Werror=format-security -c -o nft-json-file.o nft-json-file.c
nft-json-file.c:3:10: fatal error: nftables/libnftables.h: No such file 
or directory
     3 | #include <nftables/libnftables.h>
       |          ^~~~~~~~~~~~~~~~~~~~~~~~
compilation terminated.
nft-buffer.c:3:10: fatal error: nftables/libnftables.h: No such file or 
directory
     3 | #include <nftables/libnftables.h>
       |          ^~~~~~~~~~~~~~~~~~~~~~~~
compilation terminated.
[..]


Some options:
* make the missing header file properly available to the example files
* don't build the examples unless explicitly requested, not as part of 
the main program build

What do you suggest?
