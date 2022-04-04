Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2BE6C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 07:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377850AbiDDIBb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 04:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233822AbiDDIBa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 04:01:30 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E30120BF
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 00:59:34 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id v12so11784739ljd.3
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Apr 2022 00:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LzmX19txYddBm5Va95yPC6FiRb+/2HipOt2XVGXbeNo=;
        b=yZS+kRfSiT1rcQJ6xDiohsU7b7DmL8N6YCCnK7qaaUQDDnPfw2rAGCqee+0DloIaKn
         Z1STv6PZuOPAho+rdM0w55/a3fCoxbHcYxocaaeG94tw+xc45dK3mJo2oIDUIJFPMnHq
         nTM4DaFdAOL7Z3OebQAtqxmvRQj2xGVj37AUwfgArjqX47mejOaIxcX8LjKO+aE7yWol
         NPv85sOj/reZYjqitvVB4F3cIuhBmJjRcizn7VF4xvWgWj4iodn9BWBwTsr198EMLT2h
         9toZjDCiD9ijayBFV/p1gAropPFxlfCMxex6/fZ6qsavcxKfKW8a6EEdoZ+VPgLS4VjS
         bCzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LzmX19txYddBm5Va95yPC6FiRb+/2HipOt2XVGXbeNo=;
        b=21HCnSHitpYur6EU86fre/FpeDPXCgtMgOUomtPA2WpOfgx3La20UpBhAbPKOg/rb1
         a5wM9gSMR4NKllL03d50ToL9zffvz3m0K5LwkBqfMfeDMc+HAsrEGDCYDkzK+W6kyhWi
         mq8rbCOUu00qarelxSZ+nHNQQV1+WglsLM7PuIP/nbGbIwtCyOSFKYBFq1sVP9btiFCI
         hcf2N8SacPE8GrOAmcDn/JHZVR+ZUNCN7LOA+Ac0ZvbjY1lVwER2y6AHKYJNtNBOby7O
         rty4FTGhMVN/wWNW3scc4Lr8ZkSJDCSWhVqhuCqXT98M00L3eTPc5jWY5a5n4eY1Ifo9
         JzgA==
X-Gm-Message-State: AOAM530tqWsessZNJOl4FXXfGzfanuc2PB6WxyRIM+GCZVHceWeFOzza
        jOwRBEpiIMRAe+ACVuBgubw9OTvwwF7bOaxX
X-Google-Smtp-Source: ABdhPJyk35h4zByCChrq0P2GIP4PPySWp9rcfvk633SCVDEslmcAtoSDjOW5BqZHMgDTlgtZOxmZhQ==
X-Received: by 2002:a2e:611a:0:b0:249:83e5:9f9b with SMTP id v26-20020a2e611a000000b0024983e59f9bmr21152160ljb.165.1649059172684;
        Mon, 04 Apr 2022 00:59:32 -0700 (PDT)
Received: from [192.168.1.65] ([46.188.121.177])
        by smtp.gmail.com with ESMTPSA id p17-20020a056512313100b0044a34f4b4b5sm1048924lfd.268.2022.04.04.00.59.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Apr 2022 00:59:32 -0700 (PDT)
Message-ID: <cea73159-ee13-6eba-52e0-b55aaf79be4e@openvz.org>
Date:   Mon, 4 Apr 2022 10:59:31 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: troubles caused by conntrack overlimit in init_netns
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, kernel@openvz.org
References: <de70cc55-6c11-d772-8b08-e8994fd934a0@openvz.org>
 <20220402111157.GD28321@breakpoint.cc>
From:   Vasily Averin <vvs@openvz.org>
In-Reply-To: <20220402111157.GD28321@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 4/2/22 14:11, Florian Westphal wrote:
> But, why do you need conntrack in the container netns?
> Normally I'd expect that if packet was already handled in init_net,
> why re-run skb through conntrack again?

OpenVz and LXC containers are used for hosting:
so init_netns is controlled by Hoster admins for system-wide purposes,
the container is under the control of the end user, who can configure
any rules for the internal firewall.

Thank you,
	Vasily Averin

