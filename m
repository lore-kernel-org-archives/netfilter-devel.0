Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57D36C4338F
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Aug 2021 07:57:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CD3861053
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Aug 2021 07:57:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbhHIH56 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Aug 2021 03:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233476AbhHIH55 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Aug 2021 03:57:57 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABBADC0613CF
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Aug 2021 00:57:36 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id l11so3853898plk.6
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Aug 2021 00:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=vVHAfyLrznpy2EApMKOKSoYIMVcq/TVtrAy1OevbPWs=;
        b=UaZAgXQlpGJA7Y7DltbmmJkpqA3U+d4aDmQ5bpTcD7N10G+jyJ2R7miuGw5lQAGGYv
         qlvfeEVl5ATol0fr5/wyKpeuHOSia74VuHeJE5PfGLflBWeFwMWsFWdIDtmNWM8ZEu4e
         t6vJb8Ar0DXZIWBymh2xhEzW/FXbjh7e9daQVicz8UzjqJU2ZIq7ZPs3TYT+0rS5D7KS
         g5aMVBE32dqXI7ShI3P5QUMMVnZOJAYpEEeEDx/2SHR8UxGJDH3Yprnjiehytcl1vGrr
         tAfS2KpJMBPZKJMLVFzy/BrnyDH2mpQftEGvjPEFPtsbe1aNY99BvIg/+vS44rQScEpk
         TrKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=vVHAfyLrznpy2EApMKOKSoYIMVcq/TVtrAy1OevbPWs=;
        b=npKO6Yu382YZhF1ldbXJHRtpW5Iezd6vBU5rELhq+qKrmHxozVQWjAw/7Z6wyQL39F
         WfhnzbMkH+6ohOTsA8990atyK5/q8pr8mNFE7Y4XbaqBUBsXZI9AJQwOyxu0KqxCo+vK
         sukREkPoWh/rK0amK4RakaY0Rxn3JGW3HSYIRm81fkKoNgncKVekWNFAn7s9adzc8/op
         kD+hZSfHV17Utm9FRfJtuAXBRWeJzGTeCWKVpn484Y2SW4NN4YmTN7igcylprUxov9q0
         IEze6FSmw76mLobwt54RSD+aMdT/SjkxSSsjSeTRRVwUT26hca8lakCWHmprhNhaOi5j
         U1Pw==
X-Gm-Message-State: AOAM531xQ3moVYmCpAgKnpSdFuujyk6gFtPmcacSzok+Tj5vJPTQZLgK
        yNko9llPacTl2rjOHj5Y+C4=
X-Google-Smtp-Source: ABdhPJyg0C9DVknCvH58+bnETsjFowriiKEl/LzfpIT8evGm/RQLjS1TyTMtjfOrdnbjXoewHEhu8A==
X-Received: by 2002:a05:6a00:2142:b029:3b9:e5df:77ab with SMTP id o2-20020a056a002142b02903b9e5df77abmr17201458pfk.52.1628495856304;
        Mon, 09 Aug 2021 00:57:36 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id n20sm17867163pfa.101.2021.08.09.00.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 00:57:35 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Mon, 9 Aug 2021 17:57:29 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue] build: doc: Fix NAME entry in man
 pages
Message-ID: <YRDf6ZQfpkTfU1Qx@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210809074607.11277-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809074607.11277-1-duncan_roe@optusnet.com.au>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Aug 09, 2021 at 05:46:07PM +1000, Duncan Roe wrote:
> Make the NAME line list the functions defined, like other man pages do.
> Also:
> - If there is a "Modules" section, delete it
> - If "Detailed Description" is empty, delete "Detailed Description" line
> - Reposition SYNOPSIS (with headers that we inserted) to start of page,
>   integrating with defined functions to look like other man pages
> - Delete all "Definition at line nnn" lines
> - Insert spacers and comments so Makefile.am is more readable
>
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
Sorry Pablo, sent this one twice by accident.

Cheers ... Duncan.
