Return-Path: <SRS0=xWIb=V6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3D92C433FF
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 02:56:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77AEB2084C
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 02:56:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="hsdn6aqq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729582AbfHBC4e (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Aug 2019 22:56:34 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43118 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729531AbfHBC4e (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Aug 2019 22:56:34 -0400
Received: by mail-qk1-f194.google.com with SMTP id m14so28017751qka.10
        for <netfilter-devel@vger.kernel.org>; Thu, 01 Aug 2019 19:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=AGcsiVskghKXKTPwmk4P4JA0sIIcQz2X4jy5Em4AmC8=;
        b=hsdn6aqqkOnymE2HgFmv9WV2k1diZ5VIWvhfEVFicAI+f5QcIe8ovHPyufx8cXq2AU
         oJOoC+rANwmmnA2yAN+lICss4ugdRztzzv7fhukfFVtMb5AactqVbujYzoKSBZeqVxte
         pkBoMBj9TuCo7siwxi2DlaT62jiRDW8FOkdJlAYDwueRkwUX9yBlakwuMB6v+Stan0LK
         XC7iZKbaTN+RiLjmviwi3v01RdVYvMHQVLusBF2MW8VVM1cIZj2/8o4NUeSM8PGpVmGt
         L4kyOH2tkf2/ubdf5XY5h9cigQBP4rnBL0e0APIpPo8juxcAUijO6l1sgoVM/mXZ/knT
         XRAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=AGcsiVskghKXKTPwmk4P4JA0sIIcQz2X4jy5Em4AmC8=;
        b=ifDobNhy4BtBZ06EtAF14e1TQpjR5erRstGUuuiJaPu4sIOYClmjyuK9dFp27Eew0b
         DNCJNv5VyEE7fvXXXukaMRg/ee4bCCvO0m5Zmng8uhxiLK6pShTpBvSIB/xbfIT4K665
         ScMEToBg/uWY9zBuNzkl8+a1OkMkssg11QXKJ0CLGCCcwY3vSX7o57Rs7HB8+sxjkteq
         IpAn+iLBIr8gODpTiEeAitJayGXCphq4g/P95Wo1ePhAdNEQDhWzg0fQ/9vc4r5fx/++
         Tfy47dPFQhepZPAQwsVIC+tVakUZMkHmlOczWl8Y22shn8JqjpU5MAH6he6E5f3eAXji
         nmfA==
X-Gm-Message-State: APjAAAUa6EPyU7JzsTWSGhB+mSYevBmiukiKaM5/PBkDinOJ24fGUFQH
        pze/oZumuZjnZdNbV8x4JJ2TDW+3nJo=
X-Google-Smtp-Source: APXvYqyYZi4yt1e1ehHUYDiKwdTUpM0xPNEVpILsB7fjpu4rSy2YTQxg25vtKeU2tM7Zn6waReWrSg==
X-Received: by 2002:ae9:f801:: with SMTP id x1mr79486878qkh.242.1564714593159;
        Thu, 01 Aug 2019 19:56:33 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id e125sm30096769qkd.120.2019.08.01.19.56.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 19:56:33 -0700 (PDT)
Date:   Thu, 1 Aug 2019 19:56:14 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     wenxu <wenxu@ucloud.cn>
Cc:     jiri@resnulli.us, pablo@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        John Hurley <john.hurley@netronome.com>
Subject: Re: [PATCH net-next v5 5/6] flow_offload: support get flow_block
 immediately
Message-ID: <20190801195614.0742c12b@cakuba.netronome.com>
In-Reply-To: <43995d3c-dff5-3000-317c-09b119c61565@ucloud.cn>
References: <1564628627-10021-1-git-send-email-wenxu@ucloud.cn>
        <1564628627-10021-6-git-send-email-wenxu@ucloud.cn>
        <20190801161129.25fee619@cakuba.netronome.com>
        <43995d3c-dff5-3000-317c-09b119c61565@ucloud.cn>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 2 Aug 2019 10:47:26 +0800, wenxu wrote:
> > After all the same device may have both a TC block and a NFT block.  
> 
> Only one subsystem can be used for the same device for both indr-dev and hw-dev
> the flow_block_cb_is_busy avoid the situation you mentioned.

AFAIU that's a temporary limitation until drivers learn to manage
multiple tables.
