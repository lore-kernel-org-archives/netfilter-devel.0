Return-Path: <SRS0=mIA1=V7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB07AC0650F
	for <netfilter-devel@archiver.kernel.org>; Sat,  3 Aug 2019 00:22:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1C9920880
	for <netfilter-devel@archiver.kernel.org>; Sat,  3 Aug 2019 00:22:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="RzDTgJab"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388777AbfHCAWQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Aug 2019 20:22:16 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34680 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388474AbfHCAWQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Aug 2019 20:22:16 -0400
Received: by mail-qt1-f195.google.com with SMTP id k10so6583513qtq.1
        for <netfilter-devel@vger.kernel.org>; Fri, 02 Aug 2019 17:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=/AsxNX/HoiCUTitgu7Zhub4nXA9wkO6WI1FPkvPAZO4=;
        b=RzDTgJabyerl3vdx1kIKMxh/tHGv2muBmet8U/xA+dZkaLu2rOeUztjTgWs5oERUiQ
         MgL/39L5coy2iW+yPmpfxSZ+Lli1Xz6jgEa17jdQXcFFPCFJgw8Xse678EoHsomL2xVm
         zlSSAHQ3IVlU8vsoqmKT2aTR+1K3OIMc4FGvyu1/SYa04baeJz1YyPog4K4Kqyx/yhgn
         mpQjCx/wn6R8Tq586bM6MK7JUAAz4e2uH+NlthYh7BGyIWg0iZ6MPAFWuCamF+RkZry0
         1HdMfv0rdTUrcVAq++gY9XS0vkRKl9b2BT+MWuTg6He4CC0B+rrMh1328cSxEBYXKuIk
         ijxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=/AsxNX/HoiCUTitgu7Zhub4nXA9wkO6WI1FPkvPAZO4=;
        b=DsyWZ+5o7DZ5vOMDFB8m/ilB3NnSF+kdJRHptmDyzZ7wdWZo/5vrNz72MqhDZh9Pcl
         dkOj07l0i9rAbIIsh8k/FIKq9lfvNed+fIR7uMm/MqKrpfa9jRhE47FiBH9z36JAnha+
         x2WPKbFzldRmUnQWhwo+tmnYAabzMNktq6LfSL3IiowhVwRNkkIfhF4gmv9IPTtnE4Ml
         GjdBSiMAOgAz5FDCZXkkV5SY0B69jVUtHpiz/F6Tu4ZOSac9u1GCnfA46HjIFIjK/Sjf
         BvClQkAccjfiwQWjga6zY91eatoyxr/ycmxAl3GBujj2L5wiIYiNAglJgYqYFOQqV4Ug
         YGLw==
X-Gm-Message-State: APjAAAUX2pH8lkyQUqVQ/EAufC34oZYn1U92D9JcicAqwkJNY5demXRl
        +9HrIXoVJ+fThViiDKtIu0qJYERHUxU=
X-Google-Smtp-Source: APXvYqz4U2PA6UBDmArGdcdkCyRLC4FBXI+2UX6SDy50EtxpWhrV57FEoTIDbobfxn6BxqpxKJVH6A==
X-Received: by 2002:aed:3747:: with SMTP id i65mr99964140qtb.166.1564791735391;
        Fri, 02 Aug 2019 17:22:15 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m27sm37873964qtu.31.2019.08.02.17.22.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 17:22:15 -0700 (PDT)
Date:   Fri, 2 Aug 2019 17:21:55 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     wenxu <wenxu@ucloud.cn>
Cc:     jiri@resnulli.us, pablo@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        John Hurley <john.hurley@netronome.com>
Subject: Re: [PATCH net-next v5 5/6] flow_offload: support get flow_block
 immediately
Message-ID: <20190802172155.7a36713d@cakuba.netronome.com>
In-Reply-To: <45660f1e-b6a8-1bcb-0d57-7c1790d3fbaf@ucloud.cn>
References: <1564628627-10021-1-git-send-email-wenxu@ucloud.cn>
        <1564628627-10021-6-git-send-email-wenxu@ucloud.cn>
        <20190801161129.25fee619@cakuba.netronome.com>
        <bac5c6a5-8a1b-ee74-988b-6c2a71885761@ucloud.cn>
        <55850b13-991f-97bd-b452-efacd0f39aa4@ucloud.cn>
        <20190802110216.5e1fd938@cakuba.netronome.com>
        <45660f1e-b6a8-1bcb-0d57-7c1790d3fbaf@ucloud.cn>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, 3 Aug 2019 07:19:31 +0800, wenxu wrote:
> > Or:
> >
> > device unregister:
> >   - nft block destroy
> >     - UNBIND cb
> >       - free driver's block state
> >   - driver notifier callback
> >     - free driver's state
> >
> > No?  
> 
> For the second case maybe can't unbind cb? because the nft block is
> destroied. There is no way to find the block(chain) in nft.

But before the block is destroyed doesn't nft send an UNBIND event to
the drivers, always?
