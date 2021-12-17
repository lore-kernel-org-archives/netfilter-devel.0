Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0E69C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Dec 2021 08:09:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233643AbhLQIJp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 03:09:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233543AbhLQIJo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 03:09:44 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98007C061574
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Dec 2021 00:09:44 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id x1-20020a17090a2b0100b001b103e48cfaso3760555pjc.0
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Dec 2021 00:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=cvqEoS2VlTfZwaz2oW7r9ui2SBaNHz2zeIr9C+9jqSw=;
        b=oLLvLltakV5ttxLSVGWMcQR6+rC5oZo/yzqQlk9TYBFoQimZFo63BlWHI4ra7nUhEQ
         sYR49QL4GtG3mL/PtmJwX6EzuNrGalH4JtYb+BYG9UHdvszJU66d3MeT+Z/8at52cWFH
         wFWB4nywBxB11Sv+1FPA065O+g/3G36gfhCPTor00Qd/gGwkiOlKbXR9jZbqmGPwJ387
         s1hl7CFODjcIW4ruE3UtSHCyQ8u7R5EmSU1R2DwueQShQu43/2TIT2zQNmqidcVZhXpS
         5FxTgSQU6y2EI9i4ovzom6BGks5cSd86atQFseLYFb96D2hNUfdyiGJZdO2AbyePXBce
         /dZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=cvqEoS2VlTfZwaz2oW7r9ui2SBaNHz2zeIr9C+9jqSw=;
        b=1VlMbvVcsy4JGtM7GzZug8+b+SXrdPObE6VSx+5ZJF4AxpwK/VLJ6sVfYYb+m3OnPu
         pqs2F4zZvfuq2tQ5tjS9sxjJdlBdlgH/maLxfeIocrnuoPZDM+g3obZ79szA8ukLUQ6D
         7x7KWlQlyCcoV/zh0BwbnWvJlmEuAeH95X3oJ7fnAdxqAZjTh3BsnD1BvzmnNNDAMuzJ
         A6E73X+sLJlKKC51sAiJWfXixH40RI5xRJiDMpuHTZbCLu4XExOWfnNzA3hkZPi8dQa+
         HjCYKh0bn/ODcDrWRnvd2w4xR1UNLyS56ptF1nrxyl83+DgpJ8Xu2Iskjm43xn4pGL/H
         mYcA==
X-Gm-Message-State: AOAM531I1rqLWgEhBkhnkBbUV+aQ1OqntUHqp4AejaoM/6sogPdcYOAQ
        mE3GIs0UNo/iNavwI60pSek=
X-Google-Smtp-Source: ABdhPJy2D95BN0ext4qRUrwsk+hExF9U70HGx9+6BDyTvZtcp2OiqRxaZ3Gr58H/n3TM18N3u5ycqQ==
X-Received: by 2002:a17:90b:390e:: with SMTP id ob14mr10898438pjb.44.1639728584149;
        Fri, 17 Dec 2021 00:09:44 -0800 (PST)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id m6sm6787783pgb.31.2021.12.17.00.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 00:09:43 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Fri, 17 Dec 2021 19:09:39 +1100
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: graphviz.SlackBuild
Message-ID: <YbxFw6c2cG/aDsc6@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20200910040431.GC15387@dimstar.local.net>
 <20211217080229.23826-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217080229.23826-1-duncan_roe@optusnet.com.au>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

Sorry about this post - please ignore

(ran git send-email in wrong CWD)

Cheers ... Duncan.

On Fri, Dec 17, 2021 at 07:02:28PM +1100, Duncan Roe wrote:
> Hi Adrius,
>
> Do you still want to maintain the graphviz SBo package?
>
[...]
