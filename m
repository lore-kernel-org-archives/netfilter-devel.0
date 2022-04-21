Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 525C4C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Apr 2022 16:35:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbiDUQiC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Apr 2022 12:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbiDUQiB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Apr 2022 12:38:01 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F698275
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Apr 2022 09:35:11 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id bq30so9687803lfb.3
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Apr 2022 09:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0IhV5LYpmMKlaSFiP0D6B9e8Pa6mrpQ8aC0GFAJjhD8=;
        b=Nom8fuaqWSE4hNICEYO+E+98blfsQFhUS8RiPWgG4N37TOlohVnBa27/+f1wUxQg+W
         DnSVnzYL3dy6GlfJTsNYtdE2iLEucNxB5wH1wvd0tEqdtNUNF5eWgJJjQlx7QCuTdQbh
         1d4pT8HPCdVhsoeCkggftx/cjJIpzH2cTc8427pieu6fUqIjczQ7q3G9oHMOQNEfKqEw
         5/fgAMBYa6jxsx9zX5cquxBLLCooQ8J2tofC2MvQz1ZOUbl/WCDyiZrOiveX0H1q2DL9
         FJwxiTPJORPCkrxssyH2ODlYRu+B7adHoj+RoMN+IReFQKD4fxvu3RqoxnU8DhiwRVbc
         dqdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0IhV5LYpmMKlaSFiP0D6B9e8Pa6mrpQ8aC0GFAJjhD8=;
        b=S6//cYkPEKAhNwFNR3d/5KjDge/2Rn71FlFqa/grzJ7/qpQmJOL1KHkxdGGHHj5ebt
         9+frUxttw01gd+qFfipBD5ZMvkXb7fylFIu+LRdZBzPIHZlssZ7ZFUWy163odMtlIepT
         ouEU3vQVdXBvputvqDaDOmt5gMF3Ex4RrAJ/SAKwMahL3V5x+uUF90tINxC3QKfIS6CY
         ifkHsa5Y5xPpQMThlKsH2fENj9/irMks5o6AfwY3A0jVBbGTm5Zz7f6cGG9qoFy1HWc3
         5x3rv/C835Pw6lRxhy5MR5YlkE6MKzRU0OeZ+VDh4IjuoFh5t3qcdrT39HeUIB/QLhpU
         QGNg==
X-Gm-Message-State: AOAM530Tzq7gh1QiykPvrEUx6joR7moqevn4CX+4DVQHXS65EH2KgWEo
        JLZEVNLEUTyisoRWF88ujWS76ekqEUPnXg==
X-Google-Smtp-Source: ABdhPJyLUY7uNTMNnmPYY7ibDGdQWB6IqfjJ3bpwi5UeDQCu5/84qYIcHz4tNX7PFCksxNWmMxJHqA==
X-Received: by 2002:a19:5e07:0:b0:44a:48f8:b495 with SMTP id s7-20020a195e07000000b0044a48f8b495mr230218lfb.512.1650558909921;
        Thu, 21 Apr 2022 09:35:09 -0700 (PDT)
Received: from [192.168.1.38] (91-159-150-194.elisa-laajakaista.fi. [91.159.150.194])
        by smtp.gmail.com with ESMTPSA id c21-20020a2ea795000000b0024ee0f8ef92sm437682ljf.36.2022.04.21.09.35.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 09:35:09 -0700 (PDT)
Message-ID: <42cc8c5d-5874-79a2-61b6-e238c5a1a18f@gmail.com>
Date:   Thu, 21 Apr 2022 19:35:06 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] netfilter: nft_socket: socket expressions for GID & UID
Content-Language: en-US
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org
References: <20220420185447.10199-1-toiwoton@gmail.com>
 <6s7r50n6-r8qs-2295-sq7p-p46qoop97ssn@vanv.qr>
From:   Topi Miettinen <toiwoton@gmail.com>
In-Reply-To: <6s7r50n6-r8qs-2295-sq7p-p46qoop97ssn@vanv.qr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 21.4.2022 0.15, Jan Engelhardt wrote:
> 
> On Wednesday 2022-04-20 20:54, Topi Miettinen wrote:
> 
>> Add socket expressions for checking GID or UID of the originating
>> socket. These work also on input side, unlike meta skuid/skgid.
> 
> Why exactly is it that meta skuid does not work?
> Because of the skb_to_full_sk() call in nft_meta_get_eval_skugid()?

I don't know the details, but early demux isn't reliable and filters 
aren't run after final demux. In my case, something like "ct state new 
meta skuid < 1000 drop" as part of input filter doesn't do anything. 
Making "meta skuid" 100% reliable would be of course preferable to 
adding a new expression.

> 
>> +	case NFT_SOCKET_GID:
>> +		if (sk_fullsock(sk)) {
>> +			struct socket *sock;
>> +
>> +			sock = sk->sk_socket;
>> +			if (sock && sock->file)
>> +				*dest = from_kgid_munged(sock_net(sk)->user_ns,
>> +							 sock->file->f_cred->fsgid);
> 
> The code is quite the same as nft_meta_get_eval_skugid's, save for the BH
> locking and skb_to_full_sk. Perhaps nft_socket.c could still call into a
> suitably augmented nft_meta_get_eval_skugid function to share code.

Makes sense.

-Topi
