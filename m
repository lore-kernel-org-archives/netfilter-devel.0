Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DB68C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Oct 2021 18:48:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 320F8611C3
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Oct 2021 18:48:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234718AbhJESuj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Oct 2021 14:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232869AbhJESuh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Oct 2021 14:50:37 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AEF6C061753
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Oct 2021 11:48:46 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id z20so269563edc.13
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Oct 2021 11:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=A2NgxD1/eVKF5aA/6vOIKBsVzYpDnTEprcND7FDOo0M=;
        b=fFls5kf51lCIVFfkvGfs/xBe5XimbcYmLquWrEgTuzI0E86OeuXyL7p0wYGBeMKXp6
         n2zUmaPptcJGf4ySWE3LboQxkcw2GdxkxT8U487eGeQ/OELckpICsePkKJ7Jb5gQzOMp
         DHouSPks6GOygmlOmWexqYsjUFUsR5vaYJxuA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A2NgxD1/eVKF5aA/6vOIKBsVzYpDnTEprcND7FDOo0M=;
        b=e1hZsLmvlLTjgcsboMfxOCR87zZ6Ndd5uVG2ob15KdxPgAich64BRbpxyitfXaovyW
         uFK86zy+D+dyLs1h+vVPavqXjN+BOToKxaKgBTumJLUb74zcWbb3FwRS76EW+RcByreu
         hDa6DDqJ9iW2VeyaAeMcyLOPvmLRXjW70eWYGi12mMteKA23TgWe69qrQxxDnmoVFdIG
         hU8cs3b8/oiHb6SU8WHRGQ70qkY/qre69y+Ao27fi9Lo1EAXBQLjb9vMTsrwvpyfyt1O
         hbn4PO9eo9NMENVEGoJLkhqZWDuxHS8h6SNKAfzySMDITIfWPTVyGLVzR6xLgNf8EjcU
         JVlw==
X-Gm-Message-State: AOAM533S7/xpBE+5+l47tpvwmQu/8pkbgYMYpqo368wfrBEAr7WoR9lp
        Opi4VTlLDGpTpndhI/3fHT+NYg==
X-Google-Smtp-Source: ABdhPJz9jeqHDl8O0imLWpCr8HeJ8hr/QY2yL6Y9H94zZ/C0athk4E1x91ecMziaL8KCw9LmdzYAMQ==
X-Received: by 2002:a17:906:cec6:: with SMTP id si6mr2070177ejb.270.1633459724617;
        Tue, 05 Oct 2021 11:48:44 -0700 (PDT)
Received: from [192.168.1.149] ([80.208.69.72])
        by smtp.gmail.com with ESMTPSA id lb20sm8091267ejc.40.2021.10.05.11.48.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 11:48:44 -0700 (PDT)
Subject: Re: [RFC][PATCH] rcu: Use typeof(p) instead of typeof(*p) *
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     rostedt <rostedt@goodmis.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "Joel Fernandes, Google" <joel@joelfernandes.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, rcu <rcu@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        coreteam <coreteam@netfilter.org>,
        netdev <netdev@vger.kernel.org>
References: <20211005094728.203ecef2@gandalf.local.home>
 <ef5b1654-1f75-da82-cab8-248319efbe3f@rasmusvillemoes.dk>
 <639278914.2878.1633457192964.JavaMail.zimbra@efficios.com>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <ed3b6265-b073-bab2-4a05-d7a8acf7763d@rasmusvillemoes.dk>
Date:   Tue, 5 Oct 2021 20:48:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <639278914.2878.1633457192964.JavaMail.zimbra@efficios.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 05/10/2021 20.06, Mathieu Desnoyers wrote:
> ----- On Oct 5, 2021, at 2:01 PM, Rasmus Villemoes linux@rasmusvillemoes.dk wrote:
> 
>> I would think that one could avoid that churn by saying
>>
>>  typeof((p) + 0)
>>
>> instead of just "typeof(p)", to force the decay to a pointer.
> 
> Also, AFAIU, the compiler wants to know the sizeof(p) in order to evaluate
> (p + 0). Steven's goal is to hide the structure declaration, so that would
> not work either.

Gah, you're right. I was hoping the frontend would see that +0 could be
optimized away and only affect the type of the expression, but it does
give 'error: invalid use of undefined type ‘struct abc’'. Sorry for the
noise.

Rasmus
