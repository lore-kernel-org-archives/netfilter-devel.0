Return-Path: <SRS0=iiCe=TW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AAFDC072A4
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 May 2019 08:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BDDD204EC
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 May 2019 08:34:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DUeKFSp5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbfEVIez (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 May 2019 04:34:55 -0400
Received: from mail-vk1-f169.google.com ([209.85.221.169]:34225 "EHLO
        mail-vk1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728406AbfEVIez (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 May 2019 04:34:55 -0400
Received: by mail-vk1-f169.google.com with SMTP id d7so320618vkf.1
        for <netfilter-devel@vger.kernel.org>; Wed, 22 May 2019 01:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7AtQSb+8nap+TI6DayoCjN1heLIur68xcwoZH+QTbe8=;
        b=DUeKFSp5WajH/dXc6VbZA+lyhVz6PURLXdJ4TesyEcIKdIW8tMWD9ELdjlyInOYM3e
         C+MPLHpNT4BgBLEyKvikZ2Wk3yJZVPqXjr9w4TdQSqmxykWcPVe7RxgT+Zlw682X9WLZ
         J/v8f6J/EPu5xU2o2Q+78+kL/xrQ3OmS/iG+I/c+aMGTV+p8SzoP5nDr1rdbVMa4/Mbi
         GXBOfUhn27TlRfXZmgib0AeSewaRA5bNwZvEVyWVBq3Q4OH88OGMmGG0JSJf9HiC7Ujr
         12lvGgWZPEsHV6sxeCDba+cWOHhT17vF8TKJi9JBA84pYNdEx8all5HviBY+tcoOntZg
         CVmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7AtQSb+8nap+TI6DayoCjN1heLIur68xcwoZH+QTbe8=;
        b=NoZMw/v/YmJhF+mM9CU8SaPNxiRg7HSxeS6gMxFZTLLseJp5KY8og2cepUhEEIeRRc
         LrAooeI04wjRf1J7TBaaQzPvnJusiDnuvDLHODJe+FUO3CW8pXICFYjVZ2tu2KqNSczV
         gM5OLkX2XKyBmmTmRZwI8jKDbz54YqNwy8Z7wGeLQg+7yDUJfF7I0ft5oW61z3gwOG7F
         EyxmIYoWwVRZCarfrZLK8P4tn7utOPJGxSKoI4jQIxP6k+f1+z7opb7MA8WJ+DMgBBWF
         z9xO0jfaGCibliIiHId2XLjUqd7g5XausFVb6OiTNqBRY6Zot0Rp8AOpcvtYJYte3s+/
         YWyg==
X-Gm-Message-State: APjAAAU7OebDbzs/TAxVpag1p74N8rSYMAUUKmrm62jcSfjxIccmJJTi
        wKKUGblJILJcHspe6xGAukqGtqdCwmKcTev5BXylAw==
X-Google-Smtp-Source: APXvYqxxV9mFUImmJwmCBgWjV0sSDDn+NHQwsb482zorB+hjUSNfGqENHaGO9Zko8Z9bpNMBnXx0uMvlCulprvSVCyI=
X-Received: by 2002:a1f:a54f:: with SMTP id o76mr14681092vke.86.1558514094499;
 Wed, 22 May 2019 01:34:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAFs+hh7TAWAG9T9kgB2SS8m-xcQQWD4ormR8VT98RXe84MQREg@mail.gmail.com>
 <20190519201440.sb4ajpd6nuuczrkr@breakpoint.cc> <CAFs+hh6D5nj7UNBfXt+KPO4vOsWOZHkRY1Lpd1UxwiQJ=5Y-dA@mail.gmail.com>
 <20190522064213.sh54v25tazvofewz@breakpoint.cc>
In-Reply-To: <20190522064213.sh54v25tazvofewz@breakpoint.cc>
From:   =?UTF-8?Q?St=C3=A9phane_Veyret?= <sveyret@gmail.com>
Date:   Wed, 22 May 2019 10:34:43 +0200
Message-ID: <CAFs+hh5r7OP45bdwNpNKraTH58n=fTHLN_jn7aQDjDHbQGkjPg@mail.gmail.com>
Subject: Re: Expectations
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le mer. 22 mai 2019 =C3=A0 08:42, Florian Westphal <fw@strlen.de> a =C3=A9c=
rit :
> Oh?  It looked complex to me:
> https://www.rfc-editor.org/rfc/rfc7826.txt
>
> but perhaps you only need a subset of this..?

Well, as far as I saw, most of the RFC is not significant for the
traffic filtering. But if you think this is not a useful addition, no
problem, I'll give up. :-)

> No, the idea is to parse the RTSP data in the proxy, then inject the
> expectations based on the exchanged/requested information.

Would this mean writing some code for the proxy? If so, do you know a
functional example I can look at?

> nf-next is closed at this time, I expect that it will open in the next
> few days and that your patch will be accepted or given feedback by then.

Great, thank you!

St=C3=A9phane.
