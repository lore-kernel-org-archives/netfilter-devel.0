Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47989C46CA6
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Nov 2023 23:14:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbjKNXOv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Nov 2023 18:14:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbjKNXOu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Nov 2023 18:14:50 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B436ED9
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Nov 2023 15:14:47 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-5aa7172bafdso4103669a12.1
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Nov 2023 15:14:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700003687; x=1700608487; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DMIsgSklNu0qC3COok6Thi5dCPXKRxXeWFICK+RLoEk=;
        b=h77T1/By3Vmv6ndiS13/zLltROYZMOSLFgkPg8FHjynW/qiO72d0XFJs1Ol7vdPB8X
         8PA7OZCw19v47rdhNX0xrdFPmfYoF3bXygU5vCrwfO0/ajwiUkfO5ECJS9nGhVcOzmZx
         /4TUv/6A0V9xfjpkJAE+RA7csfUQq1uhcM9kk8KuvmZqp+jv/INa1om/DGuYP3dWYxmw
         AbX5jc1ilzXVpu2D5s/AM+wT6++YdbHVJBfts7ROoS37GbX70DRJKaFHBsDtYDz0ETmI
         OuT80RU58lHv5G/nfDJ1yOVHf+mvaxIfnuBOlveoB9+9tE8c+zD2mUA0N+DB6gWINN9K
         aboA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700003687; x=1700608487;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DMIsgSklNu0qC3COok6Thi5dCPXKRxXeWFICK+RLoEk=;
        b=jcePSZDwHXrte4xDyDdNf0knHfRq3C0zee2HRCNbu+HnwhZ+Z0CJK9s3aee0jDWTkL
         sNyzDO4A0/ws0elSOLTF77CDe4tOLvae5JMDos+vFdT2tTGx0PchS7/I3CDZL56EvJYm
         I7UiQ5/RHuhTaqzsH1/HFWdLD56YIbVW2sONHepxGpAw9QS5DSPIab6DTi8Yogd1xo53
         zRNMUiTgSaNsRP31Lk9rWVAIQuJx2zGkOsGPVdSvegaKJ0dBZ7Z/R+vl/26ZdzMh5zR0
         iQXxKlJE7q4N95uZ2YkGQUzbrJW8S1dZClswP/CV2p5PnhWZQnyqysESb9Ef/Ski7EBo
         lgNg==
X-Gm-Message-State: AOJu0Yz8UMB13sBXwbq2xc92BgVm+96DUAIbIlmdayJeWEIi82DY/PoJ
        KvJKH3ieW0TXmt3aKM1iu9tlM779gMw=
X-Google-Smtp-Source: AGHT+IFhirbdclKdGv6OqtL1zxi9b4hLPcmVFoDDDlte/2bXhliWQLj0Not+tteeP0CBijz5nTp5vg==
X-Received: by 2002:a05:6a20:6a04:b0:186:7c17:62ce with SMTP id p4-20020a056a206a0400b001867c1762cemr7126565pzk.61.1700003687147;
        Tue, 14 Nov 2023 15:14:47 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id c3-20020a17090ad90300b002805740d668sm7681369pjv.4.2023.11.14.15.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 15:14:46 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date:   Wed, 15 Nov 2023 10:14:43 +1100
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: libnfnetlink dependency elimination (doc)
Message-ID: <ZVP/YwVnHtFvdxE5@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20231112065922.3414-1-duncan_roe@optusnet.com.au>
 <ZVORGxjxolo3vnz1@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZVORGxjxolo3vnz1@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Tue, Nov 14, 2023 at 04:24:11PM +0100, Pablo Neira Ayuso wrote:
> On Sun, Nov 12, 2023 at 05:59:21PM +1100, Duncan Roe wrote:
> > Some of these documented changes haven't happened yet.
>
> Then we have to start by changes first, not the other way around.

It's my development model to document before coding. That way:
 - I know what I'm working towards
 - The documentation often improves with time. That would be unlikely if I left
   it until last

Could you therefore just treat these patches as RFC (for now) and reply if you'd
like to see changes,

There wiil be a v2 of this one with a more positive take on using the nfnl API.

Cheers ... Duncan.
