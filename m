Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6854CC433B4
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Apr 2021 12:26:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BBB36144E
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Apr 2021 12:26:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237040AbhDUM0e (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Apr 2021 08:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235145AbhDUM0e (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Apr 2021 08:26:34 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6878C06174A
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Apr 2021 05:26:01 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id p12so29647116pgj.10
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Apr 2021 05:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6nzf15ye4+p0RZ665FGG4nUoejGY/knvSaO1ZgwgvzQ=;
        b=r9T7Sw7Sm+1GXM89LRkW4OWWl4hCoAsL+u0ekccwaiLLD1YB1h1HI7gAl6KrtJCuyx
         D9R2ANl+zd2HIyVcFKyoZfw+KiBduFKVN83lt4no0q0dIr4Ux8trdLJbPKLGnBXf5tSG
         K1iCzWVSqj0KkGJlcc+zeuHeJRoKnDXvfE5EGcB/cIKtJBdr8fc1MEKXlsS4pgKqTqJ0
         PbuN7H+I/bAKcNADXjB4S+D8ElELfwm3+OgscKtu5bgd+r9iRfNi8TrAm4LW7b98BX69
         aKdgv2JMxEs6M4YyQW62LS83nzaemcwsDa/h0yTrGkXm0ECr47Is7Ulk7EcswV4TpXJ4
         K/Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=6nzf15ye4+p0RZ665FGG4nUoejGY/knvSaO1ZgwgvzQ=;
        b=c4saf9iUsnI7T6b+GafXXO3iAdXyCQm1qeKIRdPe4BmJ81ZjB7DXkVY6nppRsNmg0t
         HpzkrAfUxS5aqIPhwzOxZ7HknxRIe6omUDBXZ1aIASNXBDsTcsb2cQZvltEBlLNhhuTv
         VTHypuGeD4FS43QtnWqiG+vj4ADUQFgTx3PD56HB67Ff8jCVTU0+x7IapkWimDM2xR4v
         6sNUEASvNTBl0MWi+LBL6ifEnTPvPsKCvg0JZ15UPv+r3uATvaHfWl4458S2nriNNgix
         1Y4nKlzYgLNPzcgzZ382PWV/1m45UATZXCd1GgL4//GgQl/Ejeatxcfq1AHKtK5M1wGc
         hhYw==
X-Gm-Message-State: AOAM530Pvaj4ux3dFBPfQt6MLSPr4jsy8UFwuF5POOTgtdRz6r1GaVpM
        SjHbaqZpKFDK6kEOmMBtOCrEGY1Z2TMg3Q==
X-Google-Smtp-Source: ABdhPJycLEwLrQTaeVMABJ1fKhFyVl25ibO6DC4WdYyEMgzlQkvw3Rib9w5D6LZ3jEfSerW0EqaX5w==
X-Received: by 2002:a63:5222:: with SMTP id g34mr22195635pgb.309.1619007961201;
        Wed, 21 Apr 2021 05:26:01 -0700 (PDT)
Received: from smallstar.local.net (n49-192-36-100.sun3.vic.optusnet.com.au. [49.192.36.100])
        by smtp.gmail.com with ESMTPSA id o127sm1831928pfd.147.2021.04.21.05.25.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Apr 2021 05:26:00 -0700 (PDT)
From:   Duncan Roe <duncan.roe2@gmail.com>
X-Google-Original-From: Duncan Roe <dunc@smallstar.local.net>
Date:   Wed, 21 Apr 2021 22:25:56 +1000
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue 1/1] build: doc: `make distcheck`
 passes with doxygen enabled
Message-ID: <20210421122556.GA12005@smallstar.local.net>
Mail-Followup-To: Jan Engelhardt <jengelh@inai.de>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210420042358.2829-1-duncan_roe@optusnet.com.au>
 <20210420042358.2829-2-duncan_roe@optusnet.com.au>
 <3219so45-rsq1-8093-77pr-39oo80or6q@vanv.qr>
 <20210421021745.GA9334@smallstar.local.net>
 <8044rs51-qqq5-223o-q410-q46nsn566pqo@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8044rs51-qqq5-223o-q410-q46nsn566pqo@vanv.qr>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jan,

On Wed, Apr 21, 2021 at 09:21:26AM +0200, Jan Engelhardt wrote:
>
> On Wednesday 2021-04-21 04:17, Duncan Roe wrote:
> >> >+if test -z "$DOXYGEN"; then
> >>
> >> If you use AS_IF above, you could also make use of it here :)
> >
> >Happy to do that, but could you spell out the actual line please? My grasp of m4
> >is tenuous at best - I only copy stuff that I see working elsewhere.
>
> AS_IF([test -z "$DOXYGEN], [what if true], [what if false])
>
Can I use HAVE_DOXYGEN instead? Is this right:

AS_IF(HAVE_DOXYGEN, [what if true], [what if false])

or this?

AS_IF($HAVE_DOXYGEN, [what if true], [what if false])
>
[...]

Cheers ... Duncan.
