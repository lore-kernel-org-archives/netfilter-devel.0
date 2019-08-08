Return-Path: <SRS0=+PqO=WE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E12CAC433FF
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Aug 2019 20:39:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D08D2089E
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Aug 2019 20:39:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=metaloft-com.20150623.gappssmtp.com header.i=@metaloft-com.20150623.gappssmtp.com header.b="SBqbAVY3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732427AbfHHUjf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Aug 2019 16:39:35 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:36015 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbfHHUjf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Aug 2019 16:39:35 -0400
Received: by mail-pf1-f177.google.com with SMTP id r7so44748392pfl.3
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Aug 2019 13:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaloft-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Qe618w1gb2v2P2WVG1nyO34p+PP0OQLsAs+1ze9S7w0=;
        b=SBqbAVY3IqHAASnu4gsj4j208N9H9ERAnrCXpj7J/Y5a4+dZ7Keo6hLnWkCJ9uPVwp
         4HJXVGZ4lL92J8LFI23dCFcYiiOr9pXLJoFeCYAU/imf5yhJBl491CcCsQbomz6/mOMo
         fYnJ0Bo2RuObuCQzsOhRCyqqsgnBaT5jXOno26WAnNGt2yxW9N2cBUBWJiQEqDwUrHHC
         rnHvaGqAUVjL4YbQFFq/xHDpy3LzZ1/nQEtupwRDqZ7QJhdc36qDKFLG6NgCUNdguSJS
         JLx0q1u7NXz/vujc67If9JVl6+j5eWM+WbochjCTPoJikvqaJ+M9KJdvkIPvff3+lSMi
         BOlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Qe618w1gb2v2P2WVG1nyO34p+PP0OQLsAs+1ze9S7w0=;
        b=oldrmMPZTyWrDsEG72LkgwVHJdu7VAiZWb2H7XknKaBiEINlPxYXnouk8l0TzfqlgI
         yGUN71llRuEcjTj745ppfcC9+raZuUWu2ZjlrRYdGtx6L7MwDeiCatHWWhADevly2jI4
         9OvY8Ez1mHTMT5BwVljnIF6UE0kvdci4LF1O1M9aI4xnpBgHSbSeRyimk+5SwVdceB3t
         VJNmZ60qwH4akUCN03PhaofDTsH2mN68VdqbrCPQK5hImdQ8SzPsux1F0dVjPgWscwRh
         l/jmZEbmqHr8rqpybH5edVDhbfuQ//JBVtRB+pyYDUxBVKoDPxv1KBMpFyKs/iST+SB+
         wAHA==
X-Gm-Message-State: APjAAAVjf1bHDl4TZTXKSWq2Exkn2vh0lAuqO+vpiV73wdB8xzPELPjM
        mYln9jZQ3S6qS2SKFa0LzMebK/wxVG4=
X-Google-Smtp-Source: APXvYqwpRt285dBKzJKOorOWX9Yedj0MB2iRlwcqtx0e5IF8gfgpblpEJdeIl1B9JXwWsch01VthiQ==
X-Received: by 2002:a63:e70f:: with SMTP id b15mr14410655pgi.152.1565296774014;
        Thu, 08 Aug 2019 13:39:34 -0700 (PDT)
Received: from ?IPv6:2600:6c4e:2200:6881::3c8? (2600-6c4e-2200-6881-0000-0000-0000-03c8.dhcp6.chtrptr.net. [2600:6c4e:2200:6881::3c8])
        by smtp.gmail.com with ESMTPSA id v7sm56605425pff.87.2019.08.08.13.39.33
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 13:39:33 -0700 (PDT)
Subject: Re: [PATCH net v2] netfilter: Use consistent ct id hash calculation
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
References: <42f0ed4e-d070-b398-44de-15c65221f30c@metaloft.com>
 <20190808202805.ugyzrexglauwzwgn@breakpoint.cc>
From:   Dirk Morris <dmorris@metaloft.com>
Message-ID: <a1e881ac-0ba3-ec30-5c3e-1d7ace068f35@metaloft.com>
Date:   Thu, 8 Aug 2019 13:39:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190808202805.ugyzrexglauwzwgn@breakpoint.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 8/8/19 1:28 PM, Florian Westphal wrote:


> Looks good, but can you also fix up the comment at the top of this
> function?  (Alternatively, delete those things that are not relevant
> anymore).

doh! Sorry should have thought of that.
Yes will also make the other changes and submit v3.
