Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F281C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Oct 2022 13:06:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiJFNGi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Oct 2022 09:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiJFNGh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Oct 2022 09:06:37 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EAE9DD97;
        Thu,  6 Oct 2022 06:06:36 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id 13so4470729ejn.3;
        Thu, 06 Oct 2022 06:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date;
        bh=WNVZGKjo+uE7F/ccvbkuviPpZXjJ8VIWrqX3EooaZAQ=;
        b=FgQSACS3apPzm23eyqVnydhinYOI0GEJss9V2IovMJfTRhm2K2YtxUu80f4jsEvDFX
         /KYU4tWyw3ovWA2NGNlFizqRrC4OD6FxiCWpWUufCp1FeiZctjL6aD7jgvY4SvRWAQ8t
         RhXFwcGZ0HRFwEhqYRgH+TyKIu7uZ/1ZipS+tdf81g5BqPQ3OOyyRb52tMGw1PNmrQJp
         lsj8rVENFS6LImevBF9VtAtDfkByELxK3bbI1FTLu5cjbW9y2FQLaFt7LlBlEMgREvN9
         3PlSjGx67JyCb+2GCBibbbJx4r1dCUaJKGCBPwzTQRCgjmdvJcFHJ0m3M+KXf8hwRLes
         8kcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=WNVZGKjo+uE7F/ccvbkuviPpZXjJ8VIWrqX3EooaZAQ=;
        b=2SMRhHKgxoPKLimtHlTW5tzlZtWBz+tqlKUd/5P3dTU+TOojhxz1o8VIJTwClTj6pq
         9ZWCPjtOHNg0tKPYaNK6aWUNykIzYTjLcg5DVEYptkxTuMNOe0wSc400Ntdy2O7GmEa0
         m0zUNZrsFS9KYVuyNPJxhGBF5RuepcBY8h7JX9ewi086HMbfbxjm6OESC8e6PNXG2QO6
         Xl72EXzfZCKCGVsEZENkmheIpITK8HGefzpP2Jdg6motfIQ3y8W/qm9385eYUKF+jGLC
         s1L3TycUN2dlUQkg/pUlAWEFQONI9yIikbjymTrmu1dBwPucQDG3IA0cJxwEIUPH/s6g
         yHgQ==
X-Gm-Message-State: ACrzQf1KCy+9EYwp9cw1Zi65a9hQpyigMvef+gPToQxtbxHuG2qvpj+L
        RdMz9T9Iy6iwiYBkeHwXVGCXC3lhXoc=
X-Google-Smtp-Source: AMsMyM7AeYGklsz5oOzJNEZZ+mdbw5LLJo4NFJhZvKt75wtYMy4Vk3jByILKS6DhKYJVfIAQXFaIpQ==
X-Received: by 2002:a17:906:eecb:b0:73c:5bcb:8eb3 with SMTP id wu11-20020a170906eecb00b0073c5bcb8eb3mr3934469ejb.284.1665061594716;
        Thu, 06 Oct 2022 06:06:34 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id bj25-20020a170906b05900b0073d83f80b05sm10343455ejb.94.2022.10.06.06.06.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Oct 2022 06:06:33 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: Kernel 6.0.0 bug pptp not work
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <Yz7SWCDFjFLommZY@salvia>
Date:   Thu, 6 Oct 2022 16:06:31 +0300
Cc:     Florian Westphal <fw@strlen.de>, Paolo Abeni <pabeni@redhat.com>,
        netfilter-devel@vger.kernel.org,
        netfilter <netfilter@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <740D71A8-710D-4445-B215-99C0AFA592FF@gmail.com>
References: <3D70BC1B-A19E-45E3-B6BC-6B2719BA9B46@gmail.com>
 <20221006111811.GA3034@breakpoint.cc>
 <0DF040F3-ACC8-447E-99DA-BB77FEE03C7E@gmail.com>
 <BDFD3407-955E-4FB4-B124-229978690BFF@gmail.com> <Yz7SWCDFjFLommZY@salvia>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo : 

conntrack -E expect
conntrack v1.4.6 (conntrack-tools): 0 expectation events have been shown.


m

> On 6 Oct 2022, at 16:04, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> On Thu, Oct 06, 2022 at 03:57:23PM +0300, Martin Zaharinov wrote:
>> Hm.. in kernel 6.0-rc7 
>> 
>> Pablo Neira Ayuso (2):
>>      netfilter: nfnetlink_osf: fix possible bogus match in nf_osf_find()
>>      netfilter: conntrack: remove nf_conntrack_helper documentation
> 
> No, it was earlier in the 6.0-rc process.

