Return-Path: <SRS0=q6zd=2F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16875C43603
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Dec 2019 17:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF0762467A
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Dec 2019 17:47:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="omVX78D4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfLORr5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 Dec 2019 12:47:57 -0500
Received: from mail-il1-f181.google.com ([209.85.166.181]:33309 "EHLO
        mail-il1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbfLORr5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Dec 2019 12:47:57 -0500
Received: by mail-il1-f181.google.com with SMTP id r81so3606408ilk.0
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Dec 2019 09:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=ae4zkCBSmHgdofdd/A+PTU4781xyZaqC3ZAUxHlTrLc=;
        b=omVX78D4e29UqwXNpr+6PhaudpWOfhaq6fqwbiPTuqb4+2i4NFyTRCFVgdeWFoRSxs
         ZLcP74NPQ2ulUbW+WGv9qnepp9HCMJKNJNc51Rf6dNKbSGhH4GqNFuLadnEifpaNBGx/
         P5WunlPSI0BxtwLLWLPqX5/krRtsV64fJx4D3HT0UTm+1Wi2R4AWAiiruDKefsccF/Sy
         DqKzQ79bZJ9jSLfuSjPI6IztgDzLiOA6OczkkF0UuMDvHMe9ceMTSPXsYK8C4xOuf5wY
         UH/uShj3JOsxXmKEsPXcXDw1pjKcFdaOXawfO2yuHdkFXfVAfqGx53Idn433J0AjfFOL
         oOxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ae4zkCBSmHgdofdd/A+PTU4781xyZaqC3ZAUxHlTrLc=;
        b=i5K548COO1JjjYVS15+E9lnwv0uwWL8woXnn3Z6fp/1X3nrKvQDUUhxlkhANvxwo3c
         K7AL63mLR1bbEyH21yiZPBLH2gtmDXFgQ+Fde08FybxS2YmZdT90UUqpenwoAyEUc7w8
         uo099E0DsA65gZKzUoIuFntB81/M0veGuKqpY93GcdlirrVvL10F8+e/IY2+iC2Y0VTW
         ninQVZiSRKwqBcFci+8ULVKbc2MB8vRpRgg8ara+mvIwrccU7bi27T3zj1cGoWL+HjBI
         aiPzixDG2FWgjzaqsNiaFIFfRHgZPL+jcfF0XxCkKNRqa3u/uFHNU9spVbXmz8iDBOKG
         jzhA==
X-Gm-Message-State: APjAAAXT/SdUoQJhPxbI9fwDuKSnoFt1Dtueo5uJNRRvjxL7gWcWIGXt
        V9KVK/B+ZhnB+7TWcktacEt+1eE/5QmFYoCDyU+kNBpP
X-Google-Smtp-Source: APXvYqxuL9S6lks6iyw8mx/ibBeczJHLPB8+lKH7dvqw8IoWwAYcBds78HYQrA0giIFv4XsC+PHjPaGYXtTE6xnd7hM=
X-Received: by 2002:a92:1648:: with SMTP id r69mr9494493ill.43.1576432076120;
 Sun, 15 Dec 2019 09:47:56 -0800 (PST)
MIME-Version: 1.0
From:   Jaswanth Bommidi <jassu.bommidi@gmail.com>
Date:   Sun, 15 Dec 2019 23:18:35 +0530
Message-ID: <CAKtsLfdDsuyGsA4TqF5Eokudq-grxxPCWcgrL0cbrg9VWf+P0w@mail.gmail.com>
Subject: Introduction to Community
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Everyone,

I am Jaswanth Bommidi from Kerala, India. I am currently pursuing my
B.Tech Degree in Computer Science from Amrita University. I am into
the field of Network Security & Forensics for the past one and a half
years. I am also a member of Team bi0s(bi0s.in), an Academic CTF team
from India. I found the nftables project really interesting, and I am
looking forward to join the community and contribute to the project.

--
Thanks & Regards,
Jaswanth B
CS-Undergrad, Amritapuri
Team bi0s
LinkedIn (https://www.linkedin.com/in/jaswanth-bommidi-28b835178/) |
Twitter (https://twitter.com/_f41c0n)
