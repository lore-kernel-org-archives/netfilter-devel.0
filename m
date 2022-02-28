Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6732C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Feb 2022 02:47:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbiB1Crk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 27 Feb 2022 21:47:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbiB1Crk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Feb 2022 21:47:40 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9551CB37
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Feb 2022 18:47:01 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id ev16-20020a17090aead000b001bc3835fea8so10106594pjb.0
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Feb 2022 18:47:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=p4DuBazrb7D0hf/pnc8Py+IwRXsklF8VD90NnF9fR+I=;
        b=XfMPdOyHy16G0sogh0u4ybRyrZ5Tz5ImIunlHn5Aipissz4hcff6F5uwwOFnI3JTVT
         T3ioVwk5KQoYxjxRk2boi385IdR5UAppz88ce026yn6UnepCG0aZjVjzuD8k+7OJ2QHx
         VufIqwBmETJz++6rFnM81BPetZz6CMWTGh7Toq8O9zlLqNlFrxegxnjvN9mFEAVvn48j
         y8PUoccOLiXsZBbPa/C0hID5ll8uXCSctJpUk4HNWhBLKYs/8Q6vw74WLe8zPEv2xMAB
         ZAaLyWjpCHOk3IzaHZ5yjw90Tl5yGMno0of7bJHJqKIvqTOPJ+P1NlJKgoTml+XxTXYl
         tztw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=p4DuBazrb7D0hf/pnc8Py+IwRXsklF8VD90NnF9fR+I=;
        b=TaJNdUDuYrKjBWnuhjZGGpfdzrh+01JZePMVgk5gFDXrJjFdvwk+6dxxs+p+IYr1oB
         MI6PRdJ1JZ1+kk2P2d99wv3Dl2B4B0DPXQtCeufg0z5aq2up6GALRQNQOh7QYKgFsNnb
         XLbmvFxjZySDfi7x3u9aQ6FfMMSZo4JxiD+6mfKhvfpXTnzq1FS24GOfZrfmG8QkZ+4q
         s9PwmZh8y9zwBRvahLKkC04wqQTw10XWTYibvnl11cc/baEwdLcuE14WbCnnYtl0+sD9
         3U/UpaeDYMhx7y0zvS12vWuBI2CXA7Giy8qp3tkjJOiNU49rqTwEp99gEkEQYmKsnRoS
         EVsw==
X-Gm-Message-State: AOAM533m4LppKpeV/mnGY6HcNObtqKSsyzphQtw0iw4Wm3jpBzmnM8mj
        y3azqAnSUWNFPK8OzOYvM7T/R8CHXOA=
X-Google-Smtp-Source: ABdhPJzDH1kFRTUs4/xjkh0MxkFaLjOd4WB3Viipnb647nm7Kv+FdyrptrHqaksLY8Zpup8VZxZ1cw==
X-Received: by 2002:a17:90a:6688:b0:1bc:5492:6373 with SMTP id m8-20020a17090a668800b001bc54926373mr14279907pjj.161.1646016421427;
        Sun, 27 Feb 2022 18:47:01 -0800 (PST)
Received: from [192.168.86.21] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id 23-20020a17090a0d5700b001bc3c650e01sm19114426pju.1.2022.02.27.18.47.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Feb 2022 18:47:00 -0800 (PST)
Message-ID: <8cd10394-ae9c-a727-2b33-dd89516ac5b9@gmail.com>
Date:   Sun, 27 Feb 2022 18:46:59 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v2 nf] netfilter: nf_queue: don't assume sk is full socket
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc:     Oleksandr Natalenko <oleksandr@redhat.com>
References: <20220225130241.14357-1-fw@strlen.de>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20220225130241.14357-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 2/25/22 05:02, Florian Westphal wrote:
> There is no guarantee that state->sk refers to a full socket.
>
> If refcount transitions to 0, sock_put calls sk_free which then ends up
> with garbage fields.
>
> I'd like to thank Oleksandr Natalenko and Jiri Benc for considerable
> debug work and pointing out state->sk oddities.
>
> Fixes: ca6fb0651883 ("tcp: attach SYNACK messages to request sockets instead of listener")
> Tested-by: Oleksandr Natalenko <oleksandr@redhat.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>   v2: fix build failure with CONFIG_INET=n.
>   No difference for CONFIG_INET=y build.
>
>   net/netfilter/nf_queue.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
> index 6d12afabfe8a..5ab0680db445 100644
> --- a/net/netfilter/nf_queue.c
> +++ b/net/netfilter/nf_queue.c
> @@ -46,6 +46,15 @@ void nf_unregister_queue_handler(void)
>   }
>   EXPORT_SYMBOL(nf_unregister_queue_handler);
>   
> +static void nf_queue_sock_put(struct sock *sk)
> +{
> +#ifdef CONFIG_INET
> +	sock_gen_put(sk);
> +#else
> +	sock_put(sk);
> +#endif
> +}
> +
>   static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
>   {
>   	struct nf_hook_state *state = &entry->state;
> @@ -54,7 +63,7 @@ static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
>   	dev_put(state->in);
>   	dev_put(state->out);
>   	if (state->sk)
> -		sock_put(state->sk);
> +		nf_queue_sock_put(state->sk);
>   
>   #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
>   	dev_put(entry->physin);


OK but it looks like there might be an orthogonal bug.

The sock_hold() side seems suspect, because there is no guarantee

that sk_refcnt is not already 0.

Not sure how netfilter would react with stats->sk set to NULL ?

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 
6d12afabfe8a35069f5355ceb57e8147cf59d187..46da92e3bb436ceaec8f9339fc5be7a9c372ce64 
100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -93,8 +93,9 @@ void nf_queue_entry_get_refs(struct nf_queue_entry *entry)

         dev_hold(state->in);
         dev_hold(state->out);
-       if (state->sk)
-               sock_hold(state->sk);
+
+       if (state->sk && !refcount_inc_not_zero(&state->sk->sk_refcnt))
+               state->sk = NULL;

  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
         dev_hold(entry->physin);

