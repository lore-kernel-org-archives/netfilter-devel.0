Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54334C433ED
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Apr 2021 17:27:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F6CA61166
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Apr 2021 17:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233836AbhDNR1m (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Apr 2021 13:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233556AbhDNR1m (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Apr 2021 13:27:42 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD7AC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Apr 2021 10:27:20 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id w21-20020a9d63950000b02901ce7b8c45b4so20028846otk.5
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Apr 2021 10:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cRq2/rsY3WQFUeHOhv86/vBgWk1/Ck7jGRDBEaR4+1A=;
        b=klEfurYPkqeZAmJ/S2YYLG7cciQxmwYJIx2PAam7MtI7pExB+mv6wH7/zftoBu6aXG
         KIXdy1L30fywDYv+r4mD3QYKQbyFmXf4lUglZvu5PCRh9wYitPwrX+pSD2kO4EfYE+g1
         VCn9pXjV5KDPohLNJTCe3Sutv/EpD3RiL4S6qTtat+mrVVRaLSLn2pW/AEFcI7i873F7
         vQ8a2w9UkA4v7A4XPJhZPQjAG0JTTydcUsAWhohx4iQRl/CH4swQpYJBVJUc/06Dqt0k
         rNVm3IP4NP2zJl40xyYizZyJxQX4SdDh5FZybwNVajJgyM/Og+9GINmkOI8k9YKCIn1r
         nrNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cRq2/rsY3WQFUeHOhv86/vBgWk1/Ck7jGRDBEaR4+1A=;
        b=WgMKtMCYkD965YDHOAOXUXPtUx84W9Z0HsP+02IOkA0aWLXls2Jq58kdWY2vI9MDlS
         Uedq1O0VmII3Sz+5JVhx1+gu3yYatlJh5jTCwTf4puKTMsGOODgw1/ovBFMUC14ZB/8T
         FzZ3DpjYQ7O2sS2Wzv+QEg/igq1jGWiFDY/hZ7KQwSGSdg3O/8PDrSohfgxyrAHbuwMf
         EKPDBYqG10o5hyHSEU16+5g7PY8om5PK14TVsg1Nh9yEAors1vpfJWb009mWnYJwXWcg
         9coT9OcXnT7SXNgQxcjro9YFQag/HlTmqxmIvE/O64N/o1o/2lFPBHaAcpTgB7uDig7u
         7brA==
X-Gm-Message-State: AOAM531QrkQ6HKs5/DIGRv3SLZpxIS5rBXhqsTjhE5vhiFDcP/QoOBKm
        ytmTCQ5R2OOrMTVr0Emd9yA=
X-Google-Smtp-Source: ABdhPJykId0enh4AOq5+bNTSQXk4AzZkZqiXddMWyCdNqm1fcTXNMKGv167Vs4DtlJFVxBdI1jQd0Q==
X-Received: by 2002:a9d:12e:: with SMTP id 43mr10427322otu.90.1618421240448;
        Wed, 14 Apr 2021 10:27:20 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.42.70])
        by smtp.googlemail.com with ESMTPSA id w10sm36197oth.71.2021.04.14.10.27.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Apr 2021 10:27:20 -0700 (PDT)
Subject: Re: [PATCH nf-next v2 2/2] selftests: fib_tests: Add test cases for
 interaction with mangling
To:     Ido Schimmel <idosch@idosch.org>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        roopa@nvidia.com, nikolay@nvidia.com, msoltyspl@yandex.pl,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20210414082033.1568363-1-idosch@idosch.org>
 <20210414082033.1568363-3-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4e05edd4-e03c-bf95-0375-68970815d523@gmail.com>
Date:   Wed, 14 Apr 2021 10:27:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210414082033.1568363-3-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 4/14/21 1:20 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Test that packets are correctly routed when netfilter mangling rules are
> present.
> 
> Without previous patch:
> 
>  # ./fib_tests.sh -t ipv4_mangle
> 
>  IPv4 mangling tests
>      TEST:     Connection with correct parameters                        [ OK ]
>      TEST:     Connection with incorrect parameters                      [ OK ]
>      TEST:     Connection with correct parameters - mangling             [FAIL]
>      TEST:     Connection with correct parameters - no mangling          [ OK ]
>      TEST:     Connection check - server side                            [FAIL]
> 
>  Tests passed:   3
>  Tests failed:   2
> 
>  # ./fib_tests.sh -t ipv6_mangle
> 
>  IPv6 mangling tests
>      TEST:     Connection with correct parameters                        [ OK ]
>      TEST:     Connection with incorrect parameters                      [ OK ]
>      TEST:     Connection with correct parameters - mangling             [FAIL]
>      TEST:     Connection with correct parameters - no mangling          [ OK ]
>      TEST:     Connection check - server side                            [FAIL]
> 
>  Tests passed:   3
>  Tests failed:   2
> 
> With previous patch:
> 
>  # ./fib_tests.sh -t ipv4_mangle
> 
>  IPv4 mangling tests
>      TEST:     Connection with correct parameters                        [ OK ]
>      TEST:     Connection with incorrect parameters                      [ OK ]
>      TEST:     Connection with correct parameters - mangling             [ OK ]
>      TEST:     Connection with correct parameters - no mangling          [ OK ]
>      TEST:     Connection check - server side                            [ OK ]
> 
>  Tests passed:   5
>  Tests failed:   0
> 
>  # ./fib_tests.sh -t ipv6_mangle
> 
>  IPv6 mangling tests
>      TEST:     Connection with correct parameters                        [ OK ]
>      TEST:     Connection with incorrect parameters                      [ OK ]
>      TEST:     Connection with correct parameters - mangling             [ OK ]
>      TEST:     Connection with correct parameters - no mangling          [ OK ]
>      TEST:     Connection check - server side                            [ OK ]
> 
>  Tests passed:   5
>  Tests failed:   0
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  tools/testing/selftests/net/fib_tests.sh | 152 ++++++++++++++++++++++-
>  1 file changed, 151 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

Thanks, Ido.

