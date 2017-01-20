From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf-next v2 1/1] netfilter: nf_tables: Eliminate duplicated
 codes in nf_tables_table_enable
Date: Fri, 20 Jan 2017 18:57:31 +0800
Message-ID: <CAML_gOeZUdDALymX9wnv8P6peNzZ=RRGH1wNutOSzk8VQU1Zdg@mail.gmail.com>
References: <1484824690-46965-1-git-send-email-fgao@ikuai8.com> <CA+6hz4pH1uoyZjJ2-cTv78u1_fLuwALA1SdoDZH90Ch6KtigQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, Feng <fgao@ikuai8.com>
To: Feng Gao <gfree.wind@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:33709 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751642AbdATK6A (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Jan 2017 05:58:00 -0500
Received: by mail-ua0-f193.google.com with SMTP id d5so6839383uag.0
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Jan 2017 02:57:32 -0800 (PST)
In-Reply-To: <CA+6hz4pH1uoyZjJ2-cTv78u1_fLuwALA1SdoDZH90Ch6KtigQw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2017-01-20 15:42 GMT+08:00 Feng Gao <gfree.wind@gmail.com>:
[...]
> In v2 patch, I copied your recommend codes "if (cnt && --cnt == 0)".
> Today I think it is not right to use "--cnt", it should use "cnt--".
> Because when the cnt is 1, the "--cnt" would break directly.
> So I send the v3 patch.

But this "if (cnt && cnt-- == 0) break;" check condition seems still incorrect,
when the cnt is 1, next round cnt will become 0, so we will fail to break the
loop ...
