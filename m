Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 337EBC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Sep 2021 00:57:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12272611EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Sep 2021 00:57:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238410AbhI1A6v (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Sep 2021 20:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238467AbhI1A6u (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Sep 2021 20:58:50 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58574C061575
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Sep 2021 17:57:12 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id s16so17542946pfk.0
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Sep 2021 17:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=cn8dfM6IVgvC24+a8NLaG8bfECkD1TtPscH0Qz9K1Zw=;
        b=VYWhLMU94vzuPGBzEQYnfBgTxLiYZtLr2nPsSrkbangDQuR+yjNuHF43FP6XHRzXBM
         0GIeWAakrQya3+NTMt9RR56KNh082Nv/oDaedMgbEAFtKoztwRSxnjuxnHm+420PI8mW
         /Ve9eAz1x/yBl69F9TisAQrTcLIPqdFBL8Blra+7NDnYLz6p3HjirVjp/JOjZMhyPFRg
         CJ2+SVpyGinnsYusItt0DmXoKocqWQUDvbBMtQQ+PkKVl1qubyyfyKl39UDA3Mm3PGkt
         vA07IgG2JzJkvEu4YrTu7n+xTWlfTgFj5sswRuDxMzqqAvkT8T5oqjHvUX79yKrvVzRb
         wRlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=cn8dfM6IVgvC24+a8NLaG8bfECkD1TtPscH0Qz9K1Zw=;
        b=T1OjGh87NlTZv4fOGUXX5JRZT+HiYhGXoOdErKqa2HISTgC32KtVZqPXHMEGD4PI8F
         USirp8Y418MSFe3Ypb0mP2jVewVscKkeKjeMneHjmXOtTMVSUW+yS397mCjl+l6nCUX9
         283Lc4lDQY7uDqPg7jK2C7I1ynu8w1pu/EZaxyGOWOfaoPB+EGWSsJ9O76gSNRk9STjR
         QzUphwGGAkilr2FEQZBPQjxVDkS/TniI8HUbzTECyYiPq1K9910Jh69lMeKfBCZr8Ez1
         2H6kZuZlNYYJ4m8T7s/UhTmv+NaTgnFFNUF7wCPrfTGk3i5CK6oEu/Qqk+z6A+K0K2q4
         +HwQ==
X-Gm-Message-State: AOAM532XYtYeMtBp1lJ1QxivpyEPC1jrKGwWHU6oVIEcjDKIvrV1I6C7
        umN6Gs1SGHhplI03XOsDA0OYgDmuXck=
X-Google-Smtp-Source: ABdhPJzH1FkOLvJj2b3kpwZzD0d1aVJbzElC7nUV4JRUYUIe+oJCaDM7d+xw01X3MU3J0E68RNs3ZA==
X-Received: by 2002:a63:dc03:: with SMTP id s3mr2169894pgg.88.1632790631849;
        Mon, 27 Sep 2021 17:57:11 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id mv6sm534901pjb.16.2021.09.27.17.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 17:57:11 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Tue, 28 Sep 2021 10:57:07 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v3 1/4] src: doc: revise doxygen for
 all other modules
Message-ID: <YVJoYyfEZloaFQs6@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210927035330.11390-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210927035330.11390-1-duncan_roe@optusnet.com.au>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

Sorry - the title line should have "PATCH libnetfilter_log" instead of
"PATCH libnetfilter_queue".

Would you prefer if I re-posted the series?

Please advise,

Cheers ... Duncan.
