Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ADDAC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Dec 2021 17:42:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbhLWRmX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Dec 2021 12:42:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbhLWRmX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Dec 2021 12:42:23 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BCD5C061401
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Dec 2021 09:42:22 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id j11so12161347lfg.3
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Dec 2021 09:42:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ns1.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bYHV5tj4vvSHDsb6FUa5Z8GAdB7ROxEoa/9drfK4eFc=;
        b=Nz9DrBwNxTr9Ip7NO62gr4+n4N5wMUS5J/r/0AW+POS+pKa1esIXqUSXnEIJFwj4yv
         LyWkWAVKU+eBDsI9RK4j73r5ehiujIRUw7rMc3WkUmlScL5LNZiKpf29jy+SuCQzbX4x
         XUpazc2OJFzfR75c6qTrUb4c0cdF3xucAtYcmXRgMjqZyF/qEQ/0oawpzCAMeoprZXl8
         ONS4LBfQ8p12GFKh1H5d43bjzPYN8YYmPdUl363B0oQ1Z8ghDvykhjev4jPvsGMr0+eg
         +GeK9FzYkikuveHr7dNZEbVSNeU+Ywd2Ndl4V34XMgaBkqTR9cYNQ8VC5GOttBdoZ/0q
         uIAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bYHV5tj4vvSHDsb6FUa5Z8GAdB7ROxEoa/9drfK4eFc=;
        b=i1+sxmbiJQySmoxIQaez7yrVKSFFltLZqCHioIcw+cFnr/mxjSJXqkpXKH9x6AwkQO
         jvv6mX2NzQK/u++KXk7uP1SD2RWAlv6o9RfNcCJWWkmBqFGvcLH6kHE2Zx7/9bE2XOhk
         BbizZacsv/98dYeyz4TgQKHQO8RluXQUTUcCJ4cEv2qI/7MXpRHwFNTscZSZgiHh8BuI
         0WRibYvBNFTuHTuBsuiLy/pm2kie8LzarowQxpG6zHBLh77UBB5nbMGc1rV43y1M2RHq
         XWrj2WOCq4NHEYUnBJMFlnctbIQtuO+nKejqrTvz3IpGlpw6e0wGf8EdTDndCTL2RSCq
         /4xQ==
X-Gm-Message-State: AOAM532lMs5s1GDn+iMPTn/N6d5kHs6Vg/oGPXoXFc+F+wPDUBZrboq3
        Mi4qtDfmLQvftTnuQhR07guxS6zCdY7IlE2BPFKrQZWzhOAKW3Pd
X-Google-Smtp-Source: ABdhPJxMv33YzgmK33NRQ+CvQwdxMxxxhS35M9f4FNysEoo6CMscMiZYa+sbFHt3dCEJrGnikLSP3aEKQATLlek9XXI=
X-Received: by 2002:ac2:5f0d:: with SMTP id 13mr2514174lfq.584.1640281339832;
 Thu, 23 Dec 2021 09:42:19 -0800 (PST)
MIME-Version: 1.0
References: <20211209163926.25563-1-fw@strlen.de> <CA+PiBLw3aUEd7X3yt5p7D6=-+EdL3EtFxiqSV8FDb5GuuyyxaQ@mail.gmail.com>
 <20211209171152.GA26636@breakpoint.cc> <CA+PiBLzz6Y0_Ok_dKxK-OUneNu5gxOm6_e2049277NroYoWQmA@mail.gmail.com>
 <CA+PiBLze0Qu-AdAeu_0K++HcHaaN+7p383drNyx3y0RdO2FCuA@mail.gmail.com>
 <20211217190417.GC17681@breakpoint.cc> <CA+PiBLzQ4HmFDVhxPwDc7fr58jbfQ0j-6GF67rdiVwq7k-A-og@mail.gmail.com>
In-Reply-To: <CA+PiBLzQ4HmFDVhxPwDc7fr58jbfQ0j-6GF67rdiVwq7k-A-og@mail.gmail.com>
From:   Vitaly Zuevsky <vzuevsky@ns1.com>
Date:   Thu, 23 Dec 2021 17:42:09 +0000
Message-ID: <CA+PiBLxW_CHEPL=zHi4Ff_VY5ngfkOxqq_Vnwyg4KRH_7=W7CQ@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: ctnetlink: remove expired entries first
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian

Further to our investigation, I have identified the cause of confusion:

# conntrack -C
141412
# conntrack -L >/dev/null
conntrack v1.4.4 (conntrack-tools): 8342 flow entries have been shown.
# conntrack -f ipv6 -L >/dev/null
conntrack v1.4.4 (conntrack-tools): 124358 flow entries have been shown.

so -C option implicitly sums up ipv4 and ipv6 counts, and -L option
defaults to ipv4. This is neither a consistent UX practice nor
properly documented. I am happy to bring it up - Christmas present xD
