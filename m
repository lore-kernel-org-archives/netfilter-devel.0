Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 320D7C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Dec 2021 13:48:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbhLHNvb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Dec 2021 08:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbhLHNva (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Dec 2021 08:51:30 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6DCC061746
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Dec 2021 05:47:58 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id u3so5771756lfl.2
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Dec 2021 05:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ns1.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=lSBMe7RouMFOapr4mmTCEBsCRhqrrf7enDPfwXJMGoQ=;
        b=V8sL9+ZicUEKb5IIpUh2Xv7+HmlCLnMBYnBt36Bx0Xm16yYgRGYVTjkHPYW2ceFt18
         jOoDdxCN7VtZctgIOMeF5xFjyE7n/K54lpNiZleXhdYZJBhFR6Xax8luoy5m6G77cnMC
         lVaAxi9fegoDstY0gokHOuJuVxl7YHsKKXnywlFGTFWJVIit3BniBrDsPZapXq2CJNZb
         EerGbBo7vW/4jYEb5373VY/tCsUD/9yWTs5fTOMpP24dNYVfzlFWaTUsPXa0o0eP+5Dk
         +nY9o1f4I0Zk0QQ+v8J//DECNDS6Pmq9pZ/Vt/PopqugWk+Y7dLxvg/OszO7+D0IpXiZ
         5jNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=lSBMe7RouMFOapr4mmTCEBsCRhqrrf7enDPfwXJMGoQ=;
        b=IwydN4UNz36ks5lDzC/1NNosoGefA3mBBRHYzYnWnmSKptpWRefHbQwrP7L95W3XIk
         QHVewgwL7BHp63bWX9GDbA5L139qweuco8mNl/64Rv94hz1S3E6LL9xnYFu2AKOh+zbr
         cH60VzpEF5Lz06EKm2C6OxBIgK6zZ3v69qoK2jeqNyvFMkBAB9eXetzrA7PKbPI3LqGt
         SN4h6BtaGcAeDpBkrhx97mqKybnkMndT1hzAIWSyEI4OEsC4FSGMEmZAMLNs4yqz4ICv
         DVgnuWPPCM3usfHLE5IvlTCzab6i3oaQDYUZ7mCfdKIRZr9S+KFRw9SvjwpdbsXmbftT
         vRsQ==
X-Gm-Message-State: AOAM530DwmFW0IwSmdQAWsCn6tJ3GfGSFKYDv7enJ5xKmjzzi1QAsuZT
        PISjlu78fuRZ32/uNYCsNTiEA1nrrWN/JC8G3t5WAiv1q1lEWw==
X-Google-Smtp-Source: ABdhPJw+ivLJ19gXs8CHH4s/j5wOnUViQ6arlbaY7FHwmk32c5SZCqk7YHnTxKA3i+9jo46HPP8ie9IiBoCuZwwRvFo=
X-Received: by 2002:a05:6512:3d10:: with SMTP id d16mr46352679lfv.78.1638971276955;
 Wed, 08 Dec 2021 05:47:56 -0800 (PST)
MIME-Version: 1.0
References: <CA+PiBLyAYMBw-TgdaqVZ_a2agbRcdKnpZjS9OvP02oPAGPb=+Q@mail.gmail.com>
In-Reply-To: <CA+PiBLyAYMBw-TgdaqVZ_a2agbRcdKnpZjS9OvP02oPAGPb=+Q@mail.gmail.com>
From:   Vitaly Zuevsky <vzuevsky@ns1.com>
Date:   Wed, 8 Dec 2021 13:47:46 +0000
Message-ID: <CA+PiBLx2PKt68im24s1wHD7dcyHK-f0pBEhPWQTHsrvenT1f9w@mail.gmail.com>
Subject: Fwd: conntrack -L does not show the full table
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi

I have many conntrack entries:
# conntrack -C
85380
However, I can't see them all:
# conntrack -L
...
conntrack v1.4.4 (conntrack-tools): 7315 flow entries have been shown.

It is not in the man conntrack how to get the rest (85380-7315)
entries. Will it be a bug?

Thank you.
Vitaly Zuevsky
