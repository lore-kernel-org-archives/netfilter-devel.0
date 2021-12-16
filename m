Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA64C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Dec 2021 11:54:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233946AbhLPLyF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 06:54:05 -0500
Received: from mail-wm1-f44.google.com ([209.85.128.44]:45578 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbhLPLyE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 06:54:04 -0500
Received: by mail-wm1-f44.google.com with SMTP id g191-20020a1c9dc8000000b0032fbf912885so17982258wme.4
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Dec 2021 03:54:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HUghnC33qcWlObghuT5LjJT7S+a/Gy924nKfyjhSaIE=;
        b=DEURbbdDBOCutUD4nZmjYCjSGP0EtMJjAloG0umJevE9EJhmmIB9uJitOSh/su6KbR
         NjwDTrYBLr8+PwUIxiS9uueGWotOuLpO4WGcapMxCrSZITrG+6eNQWLIhQdGLWw+67rV
         S4vP5A7ni49QPNd09o4lZdK2xRgJt1R+BEXCwm2/HQEgLRstQfyC0OyYdmXDYTL138s3
         3fCD4wOVudJJUBLAp+BPXPU4uymKLQa2iYe21J2E1+LY1lkNoE2wZnWPCLZvq6fvVrbR
         BubTsuG0WomC/5DoTnvw9MMakr8BYrQk6doZScHaYMofOTiVeiisBtF6+EBTMJ+xNa09
         OAwA==
X-Gm-Message-State: AOAM533e9h0YLmSDJiyw8vixyp2/Ps1/PqwRYQNQ4edfbeMIRFCjnGr5
        deI2XIrReEy6Yfy7jdV6RXKqETVlXvZLXw==
X-Google-Smtp-Source: ABdhPJxbyFqJAO0eMNCc5HOKLisBRFqJ3Ohtx5uNTvVfV8NirAxXByNa0lDn4CV5qPIbtkdKW14lfQ==
X-Received: by 2002:a05:600c:1d28:: with SMTP id l40mr4584295wms.192.1639655643463;
        Thu, 16 Dec 2021 03:54:03 -0800 (PST)
Received: from [10.239.43.214] (79.red-80-24-233.staticip.rima-tde.net. [80.24.233.79])
        by smtp.gmail.com with ESMTPSA id d2sm4537312wra.61.2021.12.16.03.54.02
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Dec 2021 03:54:03 -0800 (PST)
Message-ID: <d878f630-adff-1522-c953-ec845d72a89c@netfilter.org>
Date:   Thu, 16 Dec 2021 12:54:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH nft 0/3] ruleset optimization infrastructure
Content-Language: en-US
To:     netfilter-devel@vger.kernel.org
References: <20211215195615.139902-1-pablo@netfilter.org>
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
In-Reply-To: <20211215195615.139902-1-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 12/15/21 20:56, Pablo Neira Ayuso wrote:
> Hi,
> 
> This patchset adds a new -o/--optimize option to enable ruleset
> optimization.
> 

Thanks for working on this. From what I see in the community, this feature will 
be of high value to some folks: users often struggle with doing this kind of 
optimizations by hand.

> The ruleset optimization first loads the ruleset in "dry run" mode to
> validate that the original ruleset is correct. Then, on a second pass it
> performs the ruleset optimization before adding the rules into the
> kernel.
> 

Could you please describe how to work with this if all I want is to check how an 
optimized version of my ruleset would look like, but not load it into the kernel?

The use case would be: I just need a diff between my ruleset.nft file and 
whatever the optimized version would be, without performing any actual change.

Of course this can be added later on if not supported in this patch.

> This infrastructure collects the statements that are used in rules. Then,
> it builds a matrix of rules vs. statements. Then, it looks for common
> statements in consecutive rules that are candidate to be merged. Finally,
> it merges rules.

clever!

Is this infra extensible enough to support scanning non-adjacent rules in the 
future?

ie, being able to transform:

* ip daddr 1.1.1.1 counter accept
* tcp dport 80 accept
* ip daddr 2.2.2.2 counter accept

into:

* ip daddr { 1.1.1., 2.2.2.2 } counter accept
* tcp dport 80 accept
