Return-Path: <SRS0=6+Vk=V4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3096BC32751
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Jul 2019 22:58:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 059CC206A2
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Jul 2019 22:58:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="JQNyCZnH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730472AbfGaW6C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Jul 2019 18:58:02 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:44016 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729805AbfGaW6B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Jul 2019 18:58:01 -0400
Received: by mail-qk1-f195.google.com with SMTP id m14so24806214qka.10
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Jul 2019 15:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=b6LcCyJhbsqjpOjfwkJdnYtVb3I9MsaRbx275CE2vjI=;
        b=JQNyCZnHmvF+qza5HzimpNP5PKfaegR5bTgKGIMVxOT5tZKPgOZQAoVA5G5PtMFjSq
         NHzEXgrAErQ/BKwMDKkEuxZicJRxViTuDLFS30iNhJtM45W2J+zxv6GaNIb0Jemp3qnY
         gVxpne3AWAvSeSX39bq/W9E6j6A5pyqiRQZTvywcJpOJcrgwHzkr4KnAj2ZDofLKsX8M
         eK9wKIXWnTvfqxQLlKwYwRXHeG1jfp+5wpE9AmL/xtdXwLMnJr13Umij1eazHkE74cbS
         GaSzqIP7imLsDYjGuAK1S2dCKTx1XUgByaayG3P9KrOEsbEWakvMDhNnfCsDRNdZTw4b
         CX0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=b6LcCyJhbsqjpOjfwkJdnYtVb3I9MsaRbx275CE2vjI=;
        b=FyS+q33Ra3S/aUXyaMfLYT0NhFZ710GDyQXonCugWQP36mgcKLrQa/Gdy5NKkgb+au
         aRG4Hol7ysfLKVrkO5NKqoLCevEgu/Fe2jSYwqnouJOilpBVG42xEDwq//lpdET9HHg6
         sMDqJpvb/T/kL/sK1MfVs6gJDFZ7WB3oXCvoGWS6uvlb5TGLCr4hn6qZD1kbQBzttzmw
         6Kcc7kIQ43UQpHl9x47iokqc+1Tnh/cb+9ORiKDwovtCQn0p5aHSOIeWe3oXXFgPZguz
         /FY1/Qpgw//wW5FU9+w0D42cQ/g6zYFSSvjiqSTbhw3t/mCBEgfB/3L2k2vJ0XzmXHvG
         TQ6A==
X-Gm-Message-State: APjAAAVpEftf4/r1SBbV2hlhX7KC5BnHM1SgT5gAV2FELPUyg1q0i7fQ
        v9sqUq5804WnDIbsar/PVgjMDg==
X-Google-Smtp-Source: APXvYqyZodVCXBtb1KrIZr2Gvk1tSXPt/Wn+t7xVqNCWBJ2ckMskzpYKjB/7WKeJnnU6FVW2NXfSSQ==
X-Received: by 2002:a37:5445:: with SMTP id i66mr86428489qkb.369.1564613880901;
        Wed, 31 Jul 2019 15:58:00 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x8sm31383737qka.106.2019.07.31.15.57.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 15:58:00 -0700 (PDT)
Date:   Wed, 31 Jul 2019 15:57:46 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, marcelo.leitner@gmail.com,
        wenxu@ucloud.cn, jiri@resnulli.us, saeedm@mellanox.com,
        gerlitz.or@gmail.com, paulb@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH nf,v2] netfilter: nf_tables: map basechain priority to
 hardware priority
Message-ID: <20190731155746.40c6d612@cakuba.netronome.com>
In-Reply-To: <20190731121656.27951-1-pablo@netfilter.org>
References: <20190731121656.27951-1-pablo@netfilter.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 31 Jul 2019 14:16:56 +0200, Pablo Neira Ayuso wrote:
> This patch adds initial support for offloading basechains using the
> priority range from -8192 to 8191.
> 
> The software priority -8192 is mapped to the hardware priority
> 0xC000 + 1. tcf_auto_prio() uses 0xC000 if the user specifies no
> priority, then it subtracts 1 for each new tcf_proto object. This patch
> reserves the hardware priority range from 0xC000 to 0xFFFF for
> netfilter.
> 
> The software to hardware priority mapping is not exposed to userspace,
> so it should be possible to update this / extend the range of supported
> priorities later on.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

I don't know the nft code, so perhaps my question on v1
was nonsensical, nonetheless I'd appreciate a response.
NFT referring to tcf_auto_prio() is a bit of a red flag.
