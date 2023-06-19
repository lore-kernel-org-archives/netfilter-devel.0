Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDF5EEB64D9
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Jun 2023 08:00:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjFSIAm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Jun 2023 04:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbjFSH7z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Jun 2023 03:59:55 -0400
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B0F91BC1
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2023 00:59:08 -0700 (PDT)
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-3f8d5262dc8so22348625e9.0
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2023 00:59:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687161545; x=1689753545;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iV4FBy5ZEj9bvb9TUQq4bhXt/Yq+S/xEDSvVzS8KT3Q=;
        b=IEPyrVBKyPc1A/yjJ4roERAf/7b0UTgBHS5YI3hlp5uTj7bDb81zEFjI8VnypzOaae
         RODX+0MywN+Ls7QzkElrjhaLN1jUt1RV3zE2oqgrg4qEgu2wpkUGwD0lVpounTajGHl3
         Ro2NKD6+1h/D00Rxz9GudCTNmG6uO3F37t8zfcVZGWdUXnsGuW1+xv/iN9PS2afmjaIs
         4BO+G6Wpogb6jiswQLfOuJ/pbLtddUuEY5GOgVvDLtlh/fvltdmFzULbFdKEly3M/1j1
         v7gYCWJbjS4JcNNYuOAyjnyXdI46b9nVx1VaEqYLKY4GSlMqbjWtUumjwi6G+jXvCXmJ
         YtbQ==
X-Gm-Message-State: AC+VfDwZh/LwFqdxO2NxUkt+uzU50Cw8cxlhsOUg/TUn1DHYjvz1jjjv
        0PPxJK4KTkMlZkeSFwWhBdnldo3uerA=
X-Google-Smtp-Source: ACHHUZ7M7S6GpQBk9qL12uFpAKJ0eaz5N5jtKXSR6e2dmSi6wsq8vOAP7yEH2GjAQxLTE1tbZp/3hA==
X-Received: by 2002:a05:600c:5101:b0:3f9:bdf:ed7f with SMTP id o1-20020a05600c510100b003f90bdfed7fmr2532737wms.0.1687161544934;
        Mon, 19 Jun 2023 00:59:04 -0700 (PDT)
Received: from ?IPV6:2a0c:5a85:a203:bd00:9084:ea29:8c84:efab? ([2a0c:5a85:a203:bd00:9084:ea29:8c84:efab])
        by smtp.gmail.com with ESMTPSA id c3-20020adffb03000000b0030ab5ebefa8sm30489164wrr.46.2023.06.19.00.59.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 00:59:04 -0700 (PDT)
Message-ID: <d8129d5c-2a6b-25ee-af54-78a47e133842@netfilter.org>
Date:   Mon, 19 Jun 2023 09:59:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH nft] cache: include set elements in "nft set list"
To:     Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
References: <20230618163951.408565-1-fw@strlen.de>
Content-Language: en-US
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
In-Reply-To: <20230618163951.408565-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 6/18/23 18:39, Florian Westphal wrote:
> Make "nft list sets" include set elements in listing by default.
> In nftables 1.0.0, "nft list sets" did not include the set elements,
> but with "--json" they were included.
> 
> 1.0.1 and newer never include them.
> This causes a problem for people updating from 1.0.0 and relying
> on the presence of the set elements.
> 
> Change nftables to always include the set elements.
> The "--terse" option is honored to get the "no elements" behaviour.
> 

Hi,

Would you recommend the debian package backports this fix for 1.0.6/1.0.7 ?

let me know, regards
