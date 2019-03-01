Return-Path: <SRS0=xc7Z=RE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B02AC43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Mar 2019 08:44:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 170552087E
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Mar 2019 08:44:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cogentembedded-com.20150623.gappssmtp.com header.i=@cogentembedded-com.20150623.gappssmtp.com header.b="XKVl5KlS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728136AbfCAIn6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Mar 2019 03:43:58 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46868 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbfCAIn5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Mar 2019 03:43:57 -0500
Received: by mail-lj1-f195.google.com with SMTP id v16so19633718ljg.13
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Mar 2019 00:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dHgrxAerKH54EZRV7lKiut97ONmA2OZmvWj2BlwqLOY=;
        b=XKVl5KlSMJdjz3CJzWWeLj4dzdU4PtQR3/sfXrzoeTK8wBSGK+ksybq+laZTGF2KhH
         khrHg7ldJmB451J1av30w2FMnjo7+3EOtgkMFVrvwg8SNMFkbsgZdnbsYCZRsUDAyddP
         CUC37IoSuZWUPcPiwvCWiECqRn38c/URe5/8NagxZfiDiHag5lYeop5flUEzZ8zGjzl6
         j0YLJkzCbJNqHJ3wwcsy5ZF+VnKftGSMgMT9JN3Nkft8l8xynp0bqxPEzMzq3IlkkR3V
         0gCwwc7wvM0uxi83HjNBkQAuK9GWy5jGw9PUKglRioOieksQKOwv5PpQLywn+2M77hjQ
         b+1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dHgrxAerKH54EZRV7lKiut97ONmA2OZmvWj2BlwqLOY=;
        b=qQT6MehmBSZuPzUz4iqFjyUMu5oCnFTz3LFYLjWQ6uZ30VOBoE3G7VGykjeUfMj9fu
         02v9pGfOOjxxb6zsrZFsCCZrnoerjssSE3HpBdpU+c9IOZq9iB9+v6JeoVrcqCmzJy6d
         TzBx/tJhONNd6SJ/cTByYVg3LCR4om8mqbtG7jVzQj7t/pjigxzz/aLCAu6mvskZHimq
         srFr6k8q5cb+wwtaNTvpQPo67953xdzOfVCYdq6nBrgAnoYYd0FmGqaQ/ZUAGEl/MhpT
         Vb1qqEhINIMA0c1OkxTalvT56R3aY7s+diIhO3MaMRXdGD0hnULj0Savsb7ekpTUGjTk
         wNXQ==
X-Gm-Message-State: APjAAAXR31R1XOp3EgzBkK6iQzVJbgZRCCsE260rkQu9fuYHMHBlauZc
        JPPlD4yVym2T4JT7QjSLQ3ZlRw==
X-Google-Smtp-Source: APXvYqyduSqNJSMaOgFcCE2INrR9e84+FFK4Ti4nhBs1TO68842Ad3eR6RLU8mJ1Ka84XKi4rw4neQ==
X-Received: by 2002:a2e:9117:: with SMTP id m23mr1909761ljg.94.1551429835517;
        Fri, 01 Mar 2019 00:43:55 -0800 (PST)
Received: from [192.168.0.199] ([31.173.84.89])
        by smtp.gmail.com with ESMTPSA id a26sm1322361lfl.45.2019.03.01.00.43.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Mar 2019 00:43:54 -0800 (PST)
Subject: Re: [PATCH] netfilter: nf_ct_helper: Fix possible panic when
 nf_conntrack_helper_unregister is used in an unloadable module
To:     Su Yanjun <suyanjun218@163.com>, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     suyj.fnst@cn.fujitsu.com
References: <1551419766-1039-1-git-send-email-suyanjun218@163.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <e420b6c0-bebf-a2fc-a2ee-7b3e0023d833@cogentembedded.com>
Date:   Fri, 1 Mar 2019 11:43:43 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <1551419766-1039-1-git-send-email-suyanjun218@163.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello!

On 01.03.2019 8:56, Su Yanjun wrote:

> From: Su Yanjun <suyj.fnst@cn.fujitsu.com>
> 
> Because nf_conntrack_helper_unregister maybe used in an unloadable module,
> it uses 'synchronize_rcu' which may cause kernel panic.
> 
> According to the artical:

    Article?

> RCU and Unloadable Modules
> https://lwn.net/Articles/217484/
> 
> When we have a heavy rcu callback load, then some of the callbacks might be
> deferred in order to allow other processing to proceed. sychnorize_rcu does
> not wait rcu callback complete and module may be unloaded before callback
> done.
> 
> This patch uses rcu_barrier instead of synchronize_rcu will prevent this
                                                         ^ that/which missed?

> situation.
> 
> Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
[...]

MBR, Sergei
