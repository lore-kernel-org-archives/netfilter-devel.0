Return-Path: <SRS0=46WK=DW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14F16C433E7
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Oct 2020 03:02:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDEB02222E
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Oct 2020 03:02:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="k+4SOOKN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgJODCH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Oct 2020 23:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726361AbgJODCG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Oct 2020 23:02:06 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3689FC0613D2
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Oct 2020 20:02:05 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id t12so2467500ilh.3
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Oct 2020 20:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JE37yiXefAPuWdOvXCxECs8BTHKeK76YuEhnWlDbpwo=;
        b=k+4SOOKNx1rO/LBOD7BT3yOb7lmbfJwQgep7TIo5grne3cBSlnHHLzBVr2DDxyT8v2
         Twe5JLel24/2t229GtyKyKZYb+Bkm+mw/s0NDWPPittJ/EeD1bb/4YleFanrgizR8fLJ
         eZ8JFL0z3YTOYpSrXDiB0FVryT4A94S4ClVArEESMi7XQhcr1TaJ20PBNkCi3G0b2IMs
         U+Ii7tbkh8tEEmOY1FH98Qk7xDwUFZcftvHayY3s+3+5YisjHbwcuzhmKRV+q3vSnTNY
         A50YoE+vZA0UrWAm9p7puIfoTn16Z8hBDEQ7ZglGfmW5IsEw0VIeQRCqWPFBZNAPPFp5
         7DJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JE37yiXefAPuWdOvXCxECs8BTHKeK76YuEhnWlDbpwo=;
        b=iw6EWWxb3tRmy21i0+LqPicDovvgQSWBBZjN3sqY9m7Wv3ZLg8q12AqjuoWNXLJqmh
         aIw1FTOuT6/ZoFg8CqVIYTieBGbA8esFEfOnSuCwF8xCg3GoapbS6nJxFTu99aUGjeXf
         fSYcd3xjP+VWTRZVne04gXpxNiZuJ9hz0XPN3xurWPfzwwbMEQBZ4Yjp/F7v2Y5Ec/i2
         /RafGAsVhYX8gon6y7fY1JKNZa+mVByZ3CuwxijTnfjsxpE0+TBDQiDQmyTlud83iD5F
         H8C8BkZws/1g7v/tjH5luS17YACwNFbprQvAOVAYvNIlX8VVbTqY6WUo6rsgi8xAymFW
         vC1Q==
X-Gm-Message-State: AOAM530wFBJIbr2wvfs5zC0heEgZS3ekRK0vRd6x5HAZZFEY8ZDSMBCw
        E+fze85PXIOeFQguhdFZ0UbpOtM2q8q19F+yQixGHA==
X-Google-Smtp-Source: ABdhPJxtJ8xfLbGX5R7RGysvv/WdX3cvUvH9P/82SA5nT+JuPN/1E9QJ150Dqu8NvMgFOtDQV4i5oWT0snQaSy2PQNs=
X-Received: by 2002:a05:6e02:bf4:: with SMTP id d20mr1615013ilu.252.1602730924068;
 Wed, 14 Oct 2020 20:02:04 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYv=zPRGCKyhi9DeUsvyb6ZLVVXdV3hW+15XnQN2R3ircQ@mail.gmail.com>
 <20201014193034.GA14337@salvia>
In-Reply-To: <20201014193034.GA14337@salvia>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 15 Oct 2020 08:31:52 +0530
Message-ID: <CA+G9fYsnPH4nQWoY0bpdw+DS5sqO4xcxDXuu-tfEHxXEGrMyUA@mail.gmail.com>
Subject: Re: selftests: netfilter: nft_nat.sh: /dev/stdin:2:9-15: Error:
 syntax error, unexpected counter
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>, lkft-triage@lists.linaro.org,
        Florian Westphal <fw@strlen.de>, fabf@skynet.be,
        Shuah Khan <shuah@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 15 Oct 2020 at 01:00, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Wed, Oct 14, 2020 at 05:19:33PM +0530, Naresh Kamboju wrote:
> > While running kselftest netfilter test on x86_64 devices linux next
> > tag 20201013 kernel
> > these errors are noticed. This not specific to kernel version we have
> > noticed these errors
> > earlier also.
> >
> > Am I missing configs ?
>
> What nftables version are you using?

nft --version
nftables v0.7 (Scrooge McDuck)

- Naresh
