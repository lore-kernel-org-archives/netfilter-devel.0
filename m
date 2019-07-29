Return-Path: <SRS0=chdK=V2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBC41C7618B
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Jul 2019 16:51:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95507206A2
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Jul 2019 16:51:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="XcXC2jFt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbfG2QvL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 29 Jul 2019 12:51:11 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41064 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728899AbfG2QvK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Jul 2019 12:51:10 -0400
Received: by mail-pl1-f193.google.com with SMTP id m9so27627192pls.8
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Jul 2019 09:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=PZ4zdSXRjhVVczI0hnigI3cAI+Gv8l4oPfWHJOpfRNw=;
        b=XcXC2jFtR8VKPsPPv5LVAqaP0fS39y2ORYmiTgMo4YgxmN/ThBrUMerqNHdvVbk6/e
         9OxGtSEwN8LoZMfNWi6AeKQTZe4AndCSgbWWwBz/v1amP1d8tWwDyu/BKJZSNMtgLZOI
         zBlSc4HyRf3lSK4NnO7xghmK0Tymf4XSWEZEEJfwGdQ8uF+Aj9oevhfiy16QDhmQI630
         iYD0YfeEOW/hPDrnaF2DnrXZ4m1yv0PWmqTsDBb5j3/rP1tWu90hGz6mTBw6q1Y4D7iZ
         5gWnM2XpzyB9xgmpy5v612br0hQhnoN6e+vb+KHBEco8whUSEYaAj68dN7gfsESF7AP0
         V8Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=PZ4zdSXRjhVVczI0hnigI3cAI+Gv8l4oPfWHJOpfRNw=;
        b=sjl2PxQP1N7Y71bievf8uMLvyxF0rnxNK9P+xRUsKgQT9zuGlKMInsLRwFGyY32YWJ
         0Ltsy9PDnm5Qwjlm7gqheV8DPk4m8N3BENW1M8YvFNQGU69NO6qE3/XOOsGSc349HvYB
         bsTwH46HvA92qUZUK6gMjimO01ncPpyp0G3IIDsSEizh/Srpg8xkBNEAP6fOTkjZKvZu
         3VjEDcGcjYztyE2sT3M2r13Vhr9PSmdZj3EL7zCrfDN1sB35medATX75erqzJmE10utL
         WlPclZzgWi0Md2Gc9MtlJBTLkKKaRZExhf0kJgOCqlzmxHItJBmrQ3NEk7UFA6hzrUMq
         wopw==
X-Gm-Message-State: APjAAAVRe1p0+oi2kpRzb2lzQ95wzE8z8/PyHmb5TRv8l/alIWjf2anN
        9neI/RWbehwWAspTpZC7YzYZGA==
X-Google-Smtp-Source: APXvYqwXLY8i6VZ1vyAcN34jmpHxHou3rK2owBAG7SGsSd9d7yXF87SUmWGN+c5iDQp1wrELpuTwwg==
X-Received: by 2002:a17:902:2be8:: with SMTP id l95mr103118749plb.231.1564419070126;
        Mon, 29 Jul 2019 09:51:10 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id u69sm80063511pgu.77.2019.07.29.09.51.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 09:51:09 -0700 (PDT)
Date:   Mon, 29 Jul 2019 09:51:00 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     wenxu <wenxu@ucloud.cn>
Cc:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 2/3] flow_offload: Support get default block
 from tc immediately
Message-ID: <20190729095100.5d03a521@cakuba.netronome.com>
In-Reply-To: <c405ff42-dfc5-6f3f-061c-7788e1204afa@ucloud.cn>
References: <1564296769-32294-1-git-send-email-wenxu@ucloud.cn>
        <1564296769-32294-3-git-send-email-wenxu@ucloud.cn>
        <20190728131653.6af72a87@cakuba.netronome.com>
        <5eed91c1-20ed-c08c-4700-979392bc5f33@ucloud.cn>
        <20190728214237.2c0687db@cakuba.netronome.com>
        <c405ff42-dfc5-6f3f-061c-7788e1204afa@ucloud.cn>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 29 Jul 2019 15:05:34 +0800, wenxu wrote:
> On 7/29/2019 12:42 PM, Jakub Kicinski wrote:
> > On Mon, 29 Jul 2019 10:43:56 +0800, wenxu wrote: =20
> >> On 7/29/2019 4:16 AM, Jakub Kicinski wrote: =20
> >>> I don't know the nft code, but it seems unlikely it wouldn't have the
> >>> same problem/need..   =20
> >> nft don't have the same problem.=C2=A0 The offload rule can only attac=
hed
> >> to offload base chain.
> >>
> >> Th=C2=A0 offload base chain is created after the device driver loaded =
(the
> >> device exist). =20
> > For indirect blocks the block is on the tunnel device and the offload
> > target is another device. E.g. you offload rules from a VXLAN device
> > onto the ASIC. The ASICs driver does not have to be loaded when VXLAN
> > device is created.
> >
> > So I feel like either the chain somehow directly references the offload
> > target (in which case the indirect infrastructure with hash lookup etc
> > is not needed for nft), or indirect infra is needed, and we need to take
> > care of replays. =20
>=20
> So you mean the case is there are two card A and B both can offload vxlan.
>=20
> First vxlan device offload with A.=C2=A0 And then the B driver loaded, So=
 the rules
> should replay to B device?

That'd be one example, yes.
