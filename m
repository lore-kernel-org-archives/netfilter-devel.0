Return-Path: <SRS0=Vh4p=6F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 929E5C54FC9
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Apr 2020 14:02:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 694FA206F4
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Apr 2020 14:02:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="alUQ643Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbgDUOCF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Apr 2020 10:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728712AbgDUOCE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Apr 2020 10:02:04 -0400
Received: from mail-ua1-x943.google.com (mail-ua1-x943.google.com [IPv6:2607:f8b0:4864:20::943])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD1DC061A41
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Apr 2020 07:02:04 -0700 (PDT)
Received: by mail-ua1-x943.google.com with SMTP id t8so5091728uap.3
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Apr 2020 07:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WqbOxN61nXB5zGZBDuS82MIDt45zl7XVaPZW7hxj7QI=;
        b=alUQ643Z4imji3zmf/asSffqA7DEw4Gzjbmw6guiXI+6JedofV7AD/07MgoKS+1Ajt
         pK4ZC2esqTdkuaR9LVwWe8ApMT0VYz2W5cAdOHtDASKM0/odnqvGjG0ebRyyI4eu14Pc
         yZLPVVzaqV4zZU5OR5RJWaybeLRPWs0RZGjAErhIF/Sj/9c/lkLhO9IqN7S+UCPc+z5S
         8pX8VCuo/lpHTg49MSHg+WrHy5B67/zoTObaXo/mV9zDVVA964xNYlZEktBlB8CCe+HU
         Q6a/zmePfZuIIKeWWJrlb/VAGuxwNKQxwCQjpww/JsSdqmm7AHjoKtpRN+G/+0BWNDah
         iuKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WqbOxN61nXB5zGZBDuS82MIDt45zl7XVaPZW7hxj7QI=;
        b=IpBEkFwleIvlgK2japO42y0LI0voIzptuDAbs8eXym5Yar+b86894vwYMeDq48JVTG
         ahfdw/+C/Bo7sX6tqPBqwU/CvFL0p6NjA839di7cIp9wV4hcm76cRDvXVNM2PK/H9oEL
         KmhLtwij1HzZwCQ1AcDPK1pq02ky908hK+igpKea3U40/cXe1/oFbWzOkRRClSQK3AqA
         +otKEUDQmqE4RAQN4CPs7KjRQvDnbN2ac99Pv6uDKeq6U/A7iEbnbIuqcLastnNEj8MO
         092XgWea13m3cAksp2URIo0VSCYITnushJ9o5o09BJ7/02YtmWiffRzr8myXCebd7AYG
         nPgg==
X-Gm-Message-State: AGi0PuaP3S+X6mwCH8RXRVtfo3057Bglo2VyNL3Gp/JHnRXAS9mcLUM3
        r7+Ug/DRRj1sMonG5tAGVHPsfUmjEBES9Qz3cpqIJXkzGzo=
X-Google-Smtp-Source: APiQypLUGMaSG3mKjGwHFHhUsuvQLIAFiKnW1vQF6fSXPA0+ub7aXz7eQosw7YjrHEXnv/M5S4A4QNOCLICLT6RJu5Y=
X-Received: by 2002:a9f:3765:: with SMTP id a34mr12073609uae.134.1587477722865;
 Tue, 21 Apr 2020 07:02:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200421081507.108023-1-zenczykowski@gmail.com> <20200421104014.7xfnfphpavmy6yqg@salvia>
In-Reply-To: <20200421104014.7xfnfphpavmy6yqg@salvia>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Tue, 21 Apr 2020 07:01:50 -0700
Message-ID: <CANP3RGfBtFhP8ESVprekuGB-664RHoSYC50mHEKYZwosfHHLxA@mail.gmail.com>
Subject: Re: [PATCH] libipt_ULOG.c - include strings.h for the definition of ffs()
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Must be some version of clang - presumably with
-Wimplicit-function-declaration turned on.
I'm honestly not sure quite how to check, but it is whatever is the
default in aosp on master.
