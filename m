Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D715CD8CA5
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Oct 2023 15:24:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbjJJPYO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Oct 2023 11:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbjJJPYN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Oct 2023 11:24:13 -0400
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D2ECC
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Oct 2023 08:24:12 -0700 (PDT)
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-405505b07dfso40790025e9.0
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Oct 2023 08:24:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696951450; x=1697556250;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b9WMagtFG4/UgLIjCwh96pTgFcEjUCvW06LHpwzk/Wo=;
        b=vaBiyCxr6GCCi84gD0Z/As77cpq/31gSI558NaGUp3FIiwds1u16FhJbS6i/pODbD6
         a2G2H1Zzbzzc3pVJhZtLKyLU5LApBZcExs8iIyRshA0hRDxAI8G6UWPLjyRovTrSDhCH
         poNKIiXXl9LJOYPOLfQ0S3j2Ikf6Ag2HC7qoNfDtW9IqbtBIpPdhMEi8KmCNF3bqb8OW
         OdUgbcoeoxdYOlKxMpn1uRkk1mmiSyWe2aW7cmmicKDbiglyGXdgWnXhmnyEl+EBHF9W
         jraatdJ+MiE4udksb/vK6wv5x+SbrftlKATPT/b1V+9KHzMe8DKWdLJIjlQMhJlYMpDU
         bzZw==
X-Gm-Message-State: AOJu0Ywc8xywWcw1KJFUA5S8pRh65tU+9AL6UEuDuJbzVW3AXSGycwMY
        HHuo8WLJCGJiz99BKcBPaJA=
X-Google-Smtp-Source: AGHT+IHpvgiJn9i48p/8GgdhTOPpHlOtMh2Ykr/pMhYWAipe90Qn/1xXtf/RP5zb0TigjPk5xFxUZQ==
X-Received: by 2002:a05:600c:220a:b0:405:251f:8455 with SMTP id z10-20020a05600c220a00b00405251f8455mr12088655wml.7.1696951450214;
        Tue, 10 Oct 2023 08:24:10 -0700 (PDT)
Received: from ?IPV6:2a0c:5a85:a208:7600:a657:b45c:b042:3e77? ([2a0c:5a85:a208:7600:a657:b45c:b042:3e77])
        by smtp.gmail.com with ESMTPSA id v16-20020a1cf710000000b003fefaf299b6sm14405307wmh.38.2023.10.10.08.24.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Oct 2023 08:24:09 -0700 (PDT)
Message-ID: <8dce8a29-0718-4e63-ac85-1efa4202da95@debian.org>
Date:   Tue, 10 Oct 2023 17:24:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] nftables 1.0.6 -stable backports
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jeremy Sowden <jeremy@azazel.net>,
        netfilter-devel@vger.kernel.org
References: <ZSPZiekbEmjDfIF2@calendula>
 <e11f0179-6738-4b6f-8238-585fffad9a57@debian.org>
 <20231009111543.GB27648@breakpoint.cc> <ZSPm7SQhO/ziVMaw@calendula>
 <ZSUNswK5nSC0IUvS@orbyte.nwl.cc>
Content-Language: en-US
From:   Arturo Borrero Gonzalez <arturo@debian.org>
Autocrypt: addr=arturo@debian.org; keydata=
 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
 EXgmBmyUKrJkh/zvupp9t9Y2ioPbcMObRIEXio4=
In-Reply-To: <ZSUNswK5nSC0IUvS@orbyte.nwl.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 10/10/23 10:39, Phil Sutter wrote:
> An upcoming 1.0.9 might be a good chance to switch upstream numbering
> scheme

Further, I would suggest adopting any numbering scheme and sticking to it.
Any, well defined (and easy to follow) pattern would work.

For netfilter userspace software in particular, maybe I'd suggest the simplest: 
consecutive numbers with no special semantics. And a dot for stable releases. 
This is similar to what systemd does.

Example:
* version 14
* version 15
* version 14.1 with some additional patches to v14
* version 16

If you do change the versioning scheme, please make an announcement of it so all 
downstream are aware.

Also, if you change the versioning scheme, please don't conflict with previous 
released versions. So maybe start from something >= 2.
