Return-Path: <SRS0=em6Q=62=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57716C2D0F8
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 May 2020 21:25:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3242F20673
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 May 2020 21:25:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dG5yhBEF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731190AbgELVZr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 May 2020 17:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728313AbgELVZr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 May 2020 17:25:47 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC88C061A0E
        for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2020 14:25:47 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id j8so15748974iog.13
        for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2020 14:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xvU4oxQbNTcOIq498Yw+l1mtZyKUpLkWiMZJgcrZo0I=;
        b=dG5yhBEFgwQPH66XklA9auezxk/1PD3pHxArPDs06tp2kMtqPHyMXKkRN+hLLSa50W
         gZZmbP0owFhQlX1fWYREIIuawbrTqP3KfzJEQ/GLrKBCkLvTX75c9O10ug8QK1wJ3mGF
         kH32omurEIbkqLaN/v248ryxJicxu978x0WQjBqjmufGpF20LfQihEHCSbhhkgpYXmjt
         5zBf+yNyUq/fNo4q/wZ+/FDBcCXST+M+ULqVVA916y7i+y7CGpLa1X/jK1fz0xUy9m8Y
         cLcUcokWf3PywHI0GaRt5oQJjTFG9dPdDFaIqtLQEW4eto/uOHI90rw+3/YAmyaqcAkW
         wvyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xvU4oxQbNTcOIq498Yw+l1mtZyKUpLkWiMZJgcrZo0I=;
        b=slMxWQyFCt6zRixhAL4lOpNH6+rqv9X0P6aKPH7rVj8liMUwwX7Rv0NuihzCEvNg1C
         q2q+xYGdVk6aWsh6l8upLQN/lfKTp3X9fJuBdh3i8yHz0x9fzogjIgEy1dQYWITqHgHn
         hwBebb1owtxyirEQpboSliYuvY/f+36dfv4RPjTiM8AnSncfooOZXf4q3lhdv7R+htEw
         eVQDWwBYga2r6yRvReICsXmDNmBrRJmx6SzC3JmqIshLscwojnmFU8sxNwh7Ao7hNLz8
         mcfJrtVZ74InSmGczCBcUwDlrW5DrfINRMLrGc7fmV2G101JHXMOf0fkJExK2eEeF9Ir
         uqLA==
X-Gm-Message-State: AGi0PuYykPmCp/O96ZZIoDBzj58zfB608wwXryE7887YwQ3zC3YtpNWO
        i+iuEFc5Whmvw/tCXv3gvFKApHGbAzjdV+lx3cKntw==
X-Google-Smtp-Source: APiQypKz2rQj1A3qFC17+5Idncjf3UaDYOes30Yhq41u5ixdQustG0JcWIRszOHaNPYTRM16FG5EOH1cdkU4ckTrJXk=
X-Received: by 2002:a02:cd03:: with SMTP id g3mr21945404jaq.61.1589318746139;
 Tue, 12 May 2020 14:25:46 -0700 (PDT)
MIME-Version: 1.0
References: <CANP3RGe3fnCwj5NUxKu4VDcw=_95yNkCiC2Y4L9otJS1Hnyd-g@mail.gmail.com>
 <20200512210038.11447-1-jengelh@inai.de>
In-Reply-To: <20200512210038.11447-1-jengelh@inai.de>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Tue, 12 May 2020 14:25:34 -0700
Message-ID: <CANP3RGdgrYaisD2Ecc9Uqzpay6ADGu+3rmTP0PDohfDT7=7TfQ@mail.gmail.com>
Subject: Re: [PATCH v2] doc: document danger of applying REJECT to INVALID CTs
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Linux NetDev <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Reviewed-by: Maciej =C5=BBenczykowski <zenczykowski@gmail.com>
