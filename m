Return-Path: <SRS0=chdK=V2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E92BCC7618B
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Jul 2019 11:15:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC1942070D
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Jul 2019 11:15:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20150623.gappssmtp.com header.i=@resnulli-us.20150623.gappssmtp.com header.b="SeBtfXAx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387575AbfG2LPO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 29 Jul 2019 07:15:14 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37004 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387554AbfG2LPO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Jul 2019 07:15:14 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so36296092wrr.4
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Jul 2019 04:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=znSGiK7PbMchvYU9Af1rZtjhPWnspUvLSiDGFYWJu00=;
        b=SeBtfXAxSwLxkrU3XfrPxkSAWAEEWI4elXP6/20hP/dmCvIM005tIzEmdDZ/8RS4u4
         ffCd8SrPEppPrg6KYi+CSuRSoGjCSQiikjlwrigB1Pi1Tk77upYgvyAX7f2tDF70P6ge
         Oeiv0dTEjJTyZTOM1yDl4ePyWVqfxp/36XAgiZba5HmPQzybJ+5tpkPZyy6hj8zECNWn
         tlEuCWUvermt/rAa7Ph99frgDbWuWSY/qr6sxu8Sb6JSrMNdaodqAEdnz9ljSoILMFdk
         EeAi3ufdmaJ7NcTnuQk9Mcj9PM+vwBw59TVGOt9PeIz2qotNaKeJudNBhvwjQnsD8HkJ
         okWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=znSGiK7PbMchvYU9Af1rZtjhPWnspUvLSiDGFYWJu00=;
        b=bu6EoD2NYJ9dnSyDODEqSNqKyaVy9mg14V5UTrI3Dp3ghNVAaMLVk9BLIDcJKRK9fa
         iVtewhvYVFUB/y+tNqjZloMjJN0ohez2owqOSWwQRb2tADe6zRqCES5u4IeuPUQI8Mu2
         sPMIvMw6jpvfeNkjOzwt15Und+1EVkpRDE5hPtTXTOwg2aahL5Gq7MYmBRoYR3LA6jbj
         i5Uw4mwzIOc0OlUaCkmCWCAT9epvLusBIEYni3fYfsWB28JRkg10QkRw3W0zGGxXpMJS
         48DqboZm4pzK415rf6dLZlQoUknBwxwXgsnrcAX8tCzzy+H5uwyP8v8/igL6NIn3SBUS
         W23w==
X-Gm-Message-State: APjAAAX9es9grFzjsnPwDVsoiGxp9Dq71niXRNV9nTQGAQWLjXUy+FmI
        iIv8Px3mSYjVSDBQShtCixCTDDgJ
X-Google-Smtp-Source: APXvYqz+SMe9OLJGzHQWaIWVKZJuza1/I/IzNq97uy3uoBpchELTDro3SV8S1rqDWF4WxZ8GI09cgQ==
X-Received: by 2002:a5d:4b91:: with SMTP id b17mr205222wrt.57.1564398912252;
        Mon, 29 Jul 2019 04:15:12 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id r15sm64793570wrj.68.2019.07.29.04.15.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 04:15:11 -0700 (PDT)
Date:   Mon, 29 Jul 2019 13:15:10 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     wenxu@ucloud.cn
Cc:     pablo@netfilter.org, fw@strlen.de, jakub.kicinski@netronome.com,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 1/3] flow_offload: move tc indirect block to
 flow offload
Message-ID: <20190729111510.GF2211@nanopsycho>
References: <1564296769-32294-1-git-send-email-wenxu@ucloud.cn>
 <1564296769-32294-2-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564296769-32294-2-git-send-email-wenxu@ucloud.cn>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sun, Jul 28, 2019 at 08:52:47AM CEST, wenxu@ucloud.cn wrote:
>From: wenxu <wenxu@ucloud.cn>
>
>move tc indirect block to flow_offload and rename

A sentence should start with capital letter.


>it to flow indirect block.The nf_tables can use the

There should be a space between "." and first letter of the next
sensence.


>indr block architecture.
>

[...]
