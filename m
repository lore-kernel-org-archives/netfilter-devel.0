Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76475C433B4
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 May 2021 02:50:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41ACE61244
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 May 2021 02:50:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhEDCvB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 May 2021 22:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhEDCvB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 May 2021 22:51:01 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B59B9C061574
        for <netfilter-devel@vger.kernel.org>; Mon,  3 May 2021 19:50:06 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id s20so4008708plr.13
        for <netfilter-devel@vger.kernel.org>; Mon, 03 May 2021 19:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZJXFuSHDhxAYtFcIeDm89H6jqD2oy7kcTYvGUaq3jrw=;
        b=a+axv7WK05Rpi06kJCPKt1MNpcCiSmtp+RjGeAfRUUmULfuWoUSS99w7HC9Mk+2DmI
         zxqyhKva5ZWs3Px5Hs/SDvx5C8f+Wb8/c855MV7x3OlXc+2QOAyemxWdKHAFY41rGzXk
         Ndcs0bp4ZkvC2NHLM7dBZTnXX4jw02RSGEpgduvLCydEuczt3iDYy+ch9t7MVV4TzXob
         GhXt6LWA8ZkxdPb7eUazCzJc+eoJ82TRqfLXdCAbiulcevIzYiagFF9/DX5mMvVpLMuH
         YVeNTTnGqur73arZdw+DiyVbegbG22/OJgCE+ugiDvFE/I0lhaTHtM3Tt/VVQXGYlg0J
         GQkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=ZJXFuSHDhxAYtFcIeDm89H6jqD2oy7kcTYvGUaq3jrw=;
        b=GhIqyorQcA8EkMXhVv9OgfwgMOneidRi9nr4D4w9oiSBGLzyADoZNaSsd6gR3RBOhZ
         q77ocitWp5bH/fETUXDXNUJEV2B8bV30Aw6rDL1CTvhIT2T5S8KrAQ67I407wzSAGcal
         AiGSzUEm2KTgRqx58oygWO9JbxISYUVTEj5fVYF8g8Dh3NneGMJ94ujG4Qs33eaqTGVk
         Hf40/BCcB9ULqkWvZVdrphcp7eO8d+KnmU22/7qWKZFDkT87uULIMed9ceihu9YaWENR
         1Z3DbyTO1c4ZMI/WI+7jjVEc8TEmYu/9ySMPwsFLbMNqDD0Ctb59xfcoGEt2bZ7GoXkK
         bSSg==
X-Gm-Message-State: AOAM533qHQbDU0IOTDsFOyExaNm6A5LuF43plkIhcwlDqwMCEBkI257/
        F0IV5hFlULSS3i3xp3SuJFI=
X-Google-Smtp-Source: ABdhPJzb9yj+xCFkP8iGwe2l8pH/hBfFH3eYXZwNiKgAWbj64EmbopuMipXfPEmxYlRrVsicYdOd9w==
X-Received: by 2002:a17:903:248e:b029:ec:b399:7d75 with SMTP id p14-20020a170903248eb02900ecb3997d75mr23505091plw.35.1620096606329;
        Mon, 03 May 2021 19:50:06 -0700 (PDT)
Received: from smallstar.local.net (n49-192-228-163.sun4.vic.optusnet.com.au. [49.192.228.163])
        by smtp.gmail.com with ESMTPSA id a128sm10584243pfd.115.2021.05.03.19.50.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 May 2021 19:50:05 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@smallstar.local.net>
Date:   Tue, 4 May 2021 12:50:01 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH RFC libnetfilter_queue 0/1] Eliminate packet copy when
 constructing struct pkt_buff
Message-ID: <20210504025001.GA2528@smallstar.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20210504023431.19358-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504023431.19358-1-duncan_roe@optusnet.com.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 04, 2021 at 12:34:30PM +1000, Duncan Roe wrote:
> Hi Pablo,
>
> This is item 2 of 4 after which I think we could do a new release.
>
[...]

Item 1 was "`make distcheck` passes with doxygen enabled", applied.

Cheers ... Duncan.
