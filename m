Return-Path: <SRS0=uN83=25=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CE59C33CA1
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jan 2020 16:47:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 045F620692
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jan 2020 16:47:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b="TE9//4Kr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729451AbgAHQrP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Jan 2020 11:47:15 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52571 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728329AbgAHQrP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Jan 2020 11:47:15 -0500
Received: by mail-wm1-f65.google.com with SMTP id p9so3226104wmc.2
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Jan 2020 08:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ODlM0CIKkuqbvn6TyFqbyKvykYoCZutfBb6M9KByNfE=;
        b=TE9//4Kr2iBqUOZFqMt6oBcxiqw8769O1G828j6Sbl0flSOvPsxKmVhauaas8UBgta
         JsjQ3RsWvQzWlZayk+un3QGUrIblPk/+4f0Tzl6aftQ/JCmHXdZsWHHnAHpUYXEg7c1S
         50k5GQy69hVVSPYWfGG0NxXeH0t9Ul5CsV3EPFn5XsswVNthreSjJGYB+2O/1il8hEDV
         evY42PO1xaZju9+Xx1UHodn0/RZcr8X2JbNUMjzuqCwqaqUfC21rUhHiYgtMQple7YoK
         iHFc7vt1SqqrN5HGLKFeZ6TJh3t8rkkew2tLRPRO+3XBMsIGK6Lbuau1hebpd6su+1GC
         DQhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ODlM0CIKkuqbvn6TyFqbyKvykYoCZutfBb6M9KByNfE=;
        b=iHByR3OosB+WajNpZC2bGYxV8wqNRv8HDia1LFqpgI26iFMC6t2iF3Z19AegWvjsyg
         ln//i9Zf+mXwp27HDKO+Ee/4scw5oPhCpKdxWAYks5uv4XJoMG595DSOBIDWvkA0zbY5
         dxhRKmROSuj31OWuv7/0Ps+nCnxbvLENJEGchgXmHiSYeowxpnxr6KTsVaaX3dgV52G2
         qVvrKxgaobSru/IGfiEPZeIHKeYSiqlQBoanXRLLRVIJABvBogBdGcpmm4IiJ/W4bYXc
         cbltkXBgDlSP1QBn+yA45C+2DwnMEhSJdd/+eHgp1xSnnmkWNX/yp0merhvF/HxGWs1R
         d5KA==
X-Gm-Message-State: APjAAAXcfxvfbMh4rBrqduOFv1aGaGAyQ2ATLbJkjT4RoDOMQb0siijQ
        +MCwYjqySaqaMz8vu4GNzL2S5g==
X-Google-Smtp-Source: APXvYqwZeX/npX9kHmTB5Cavy4RpYUSbhK4sKOk4mLYZ4U3ylpICSKaWpvMvA+XXctckGNlnulHp4g==
X-Received: by 2002:a7b:c949:: with SMTP id i9mr4939006wml.131.1578502033588;
        Wed, 08 Jan 2020 08:47:13 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:2427:34d:af57:5d8? ([2a01:e0a:410:bb00:2427:34d:af57:5d8])
        by smtp.gmail.com with ESMTPSA id p15sm4156718wma.40.2020.01.08.08.47.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 08:47:12 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH ghak25 v2 1/9] netfilter: normalize x_table function
 declarations
To:     Richard Guy Briggs <rgb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, fw@strlen.de, twoerner@redhat.com,
        eparis@parisplace.org, ebiederm@xmission.com, tgraf@infradead.org
References: <cover.1577830902.git.rgb@redhat.com>
 <194bdc565d548a14e12357a7c1a594605b7fdf0f.1577830902.git.rgb@redhat.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <f8ee5829-f094-96b8-40c2-b0278f93fb03@6wind.com>
Date:   Wed, 8 Jan 2020 17:47:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <194bdc565d548a14e12357a7c1a594605b7fdf0f.1577830902.git.rgb@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le 06/01/2020 à 19:54, Richard Guy Briggs a écrit :
> Git context diffs were being produced with unhelpful declaration types
> in the place of function names to help identify the funciton in which
> changes were made.
Just for my information, how do you reproduce that? With a 'git diff'?

> 
> Normalize x_table function declarations so that git context diff
> function labels work as expected.
> 
[snip]
> 
> -- 
> 1.8.3.1
git v1.8.3.1 is seven years old:
https://github.com/git/git/releases/tag/v1.8.3.1

I don't see any problems with git v2.24. Not sure that the patch brings any
helpful value except complicating backports.

Regards,
Nicolas
