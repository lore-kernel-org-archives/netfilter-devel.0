Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1173FC678D4
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Mar 2023 09:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbjCGJWK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Mar 2023 04:22:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbjCGJWC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2023 04:22:02 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA68574E6
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2023 01:21:52 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id i34so49572927eda.7
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Mar 2023 01:21:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678180911;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IEcwepox9RSbt9g8Jcg0fmLm4XPbJfOWiFje+P9ezYg=;
        b=j/Z8elFEZ2WnYtOThumuGICliM8G+M1TPZ/IXrbRKaOD1HKi6q0aZRXY3TT8OXFvGu
         hTqJLVEus6xLzDu3DxZAcMZ9rk8S2p3VGVfIPcO6jVyoIkxcD+p/zhBPYaZ/btEFTKBi
         DyIbzuRXk8i1xoiFzxfB0BLZy0dJi4hM5bMzfZeFCPyPgWFbD9yxpSw3Nel2K6Q4OguX
         AYYWoLclDPq7+6nl1t1U4fLQPzTbrJYViobxiipwntRR+FefGGGRfa0XQt7LLhmWlceT
         pXdMswnvGwTxL3NQ0JvsXI7wWLGEsNWTCE4gKvnmprRrD3moRyVqZMmvQP3ViWhzvG/n
         4a4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678180911;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IEcwepox9RSbt9g8Jcg0fmLm4XPbJfOWiFje+P9ezYg=;
        b=jD4pJ2NWYFYL8BMkd2iigo3tIWM+8SBR5smvKSIcf8lDE3PR5FwaVTQNErTE8qD13p
         gdV6R42CSVxS7zhcQbTM8pXexvtbsmMZIn2EcPu4vsqf+3icc+66lTx7hfvMUGCDSpez
         SnVKv9puCMRRvp0+//UxCCeKk3CkrGXdY/Jcnv398Nq5aD0HOJh5JupTDRhf6HbViivv
         duYSmoByariWdyjBKz35kIWyH+68loElYR3IGuSJ9qLEEmFWfkh6dtftZgyKjYrtVjSV
         OwmIv5dqPU6txRHvi75zPhjPV8wZYEYqqKZxYMRvisVLWRfZ0bsgyKf0Z6BsykK+sqc8
         KCtw==
X-Gm-Message-State: AO0yUKWguiXPKLTjzP9MTRsCPRSwY65963K6WWT70O4QG58GGIO5ttsG
        jYdrIquyguCnjmxt6MGVE1dejkkcSslpDA5MFp4QDw==
X-Google-Smtp-Source: AK7set9H0pBgnxnEy7FdK/uGF4efFP1bXbgwgbsePSmgJ84nyWjf015+RMrJ+GzrYXur12qRiNyT8w==
X-Received: by 2002:aa7:d649:0:b0:4ac:d973:bb2c with SMTP id v9-20020aa7d649000000b004acd973bb2cmr15171378edr.28.1678180910837;
        Tue, 07 Mar 2023 01:21:50 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id h30-20020a50cdde000000b004c10b4f9ebesm6351217edj.15.2023.03.07.01.21.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 01:21:50 -0800 (PST)
Message-ID: <0040d3e5-904d-30a7-fa60-9df58fbf9f6b@blackwall.org>
Date:   Tue, 7 Mar 2023 11:21:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH nf-next 4/6] netfilter: move br_nf_check_hbh_len to utils
Content-Language: en-US
To:     Xin Long <lucien.xin@gmail.com>, netfilter-devel@vger.kernel.org,
        network dev <netdev@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Aaron Conole <aconole@redhat.com>
References: <cover.1677888566.git.lucien.xin@gmail.com>
 <84b12a8d761ac804794f6a0e08011eff4c2c0a3a.1677888566.git.lucien.xin@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <84b12a8d761ac804794f6a0e08011eff4c2c0a3a.1677888566.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 04/03/2023 02:12, Xin Long wrote:
> Rename br_nf_check_hbh_len() to nf_ip6_check_hbh_len() and move it
> to netfilter utils, so that it can be used by other modules, like
> ovs and tc.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  include/linux/netfilter_ipv6.h |  2 ++
>  net/bridge/br_netfilter_ipv6.c | 57 +---------------------------------
>  net/netfilter/utils.c          | 54 ++++++++++++++++++++++++++++++++
>  3 files changed, 57 insertions(+), 56 deletions(-)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>


