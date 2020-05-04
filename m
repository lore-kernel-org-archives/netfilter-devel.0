Return-Path: <SRS0=zdgi=6S=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10120C3A5A9
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 May 2020 19:37:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E125520705
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 May 2020 19:37:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=wifirst-fr.20150623.gappssmtp.com header.i=@wifirst-fr.20150623.gappssmtp.com header.b="esaR8a6j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgEDTho (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 May 2020 15:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726334AbgEDTho (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 May 2020 15:37:44 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A3CC061A0E
        for <netfilter-devel@vger.kernel.org>; Mon,  4 May 2020 12:37:43 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id h4so779597wmb.4
        for <netfilter-devel@vger.kernel.org>; Mon, 04 May 2020 12:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=wifirst-fr.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=byHvchrom3S9uCougjs973yPBW+PJn/b8RxodRP69H8=;
        b=esaR8a6jDLCFbd9ss4On8Y2Ro3WLPnu6eNIkJ8nhGI16GGei9ceHV2b108yfv/u7t4
         UB+0lOpmcjDC1EQ3HmXCjb+oQ2XMrpDt6Gxcy3WlvSEgZPw9WqCU3axfPDyazwgqE9Ez
         TXxqUw9535u+uDVTyhv/abcxHz+ZvdjcIVee7HqsmuoYF7nqhzkaDVhTasnmo/1HtrZp
         Gn3MV0MMBigib3F+KBgtvXJ7zbelvNeVWPtDc0PyPWgFwGbRY9+yCLSSEuPmLiIb0+Qk
         72ZOroE8yD2FKibZXHA3u4X1ZoRhachhJ2jokKD29G3a2ScZ/Iq9AQsQyzqh5YS7Payb
         OJRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=byHvchrom3S9uCougjs973yPBW+PJn/b8RxodRP69H8=;
        b=GC7/I83mCLSNMxmWTKg8iE1iKmxrAgk2nAQx7ZeDGzWWD50XHu88if4TvnJ/4o2omg
         SUKPpdjPKLsM0dOfajqgBIQGjCJhdE4Nm4qUslkSJQPOSHynIlcvRTvCTAHGUfaF3JZI
         LfEzaEy5UX8+MUcDkoxO7KeZzm1xJoLsJC9Opk5cOVGy0GeJy8qmvfEdMUFALMHZAsFY
         qWVgKdShj6+AWZoc25p45ts/UVaBIy3FFcvTgNm31oczRIngEagtb/wW7H/h6bQHE3iU
         plfBy7ss1ebrM1Mnhg5UN0xSK/XALa4b8xyC9aLpMJdwP/bM5i2Q2XCUWw5q9r8+6JPX
         RQkQ==
X-Gm-Message-State: AGi0Pubb6Hp0VF56iNHrmqSmzlqbNfyKIJUFXoLFaFeHH61sKm101Hy/
        6v8LAAtNBFJRlNSNk+lHoH4HQ3z89KY=
X-Google-Smtp-Source: APiQypIrD3v42PHaVZ6BHtaWoBXCM55Gn+/8Kvujv1IxsPcKVtB60vTVCkFpCy5guLsyUPjydCSqxQ==
X-Received: by 2002:a1c:1983:: with SMTP id 125mr16002380wmz.43.1588621062461;
        Mon, 04 May 2020 12:37:42 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ec08:2c60:126b:c5b8:d304:f770? ([2a01:e34:ec08:2c60:126b:c5b8:d304:f770])
        by smtp.gmail.com with ESMTPSA id t16sm20726957wrm.26.2020.05.04.12.37.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 12:37:41 -0700 (PDT)
Subject: Re: [PATCH nf-next v5 1/1] netfilter: ctnetlink: add kernel side
 filtering for dump
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Romain Bellan <romain.bellan@wifirst.fr>
Cc:     netfilter-devel@vger.kernel.org
References: <20200330204637.11472-1-romain.bellan@wifirst.fr>
 <20200426214338.GA2276@salvia>
From:   Florent Fourcot <florent.fourcot@wifirst.fr>
Message-ID: <66100a4b-a879-a8f4-f684-2b098a89cdc8@wifirst.fr>
Date:   Mon, 4 May 2020 21:37:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200426214338.GA2276@salvia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello Pablo,

We just posted a v6. We hope that this one will be the good one.


> 
> The test this needs to be compiled via:
> 
>          gcc -lnetfilter_conntrack test-conntrack.c -o test
> 

Thanks for the pointer, it helped us a lot, it was not clear before for 
us how to test it.

We applied patch on top of current net-next HEAD and it looks good for 
this one (OK: 122 BAD: 0).

Best regards,

-- 
Florent.
