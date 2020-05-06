Return-Path: <SRS0=4pKc=6U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80ACCC28CBC
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 11:44:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60EA5206D5
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 11:44:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20150623.gappssmtp.com header.i=@resnulli-us.20150623.gappssmtp.com header.b="pA8bF/vi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgEFLoV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 May 2020 07:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727067AbgEFLoU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 May 2020 07:44:20 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 017B8C061A10
        for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2020 04:44:19 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id v12so501379wrp.12
        for <netfilter-devel@vger.kernel.org>; Wed, 06 May 2020 04:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8X+uswMd3Ue41z8ou11oNKd0muZNoaKFdUHY8+P2zA8=;
        b=pA8bF/viTyvxTFfWwDe62ORMxBpZwxRyoaNvh0DaqixnFVatYVlpFeJVk2zaS828Py
         w2MO0YC2wO3Ad/r7g25UoLd3yN7GWuX5fN22APFAeYytIpF39+Rt91LI/9QtGYfsbwuY
         HeMA5+lE63kpDSWBHTcDLFkX7wX/O4iJXSIKSnsa4/MsjcQ00ilVeeztjXry3wwpTYwr
         FoZ9amn6i74jlkaqabfz0wEPFJPilwFWX2E2mPL31IPfJdPiMWja7LS9XcJJqTxILCYE
         BfJI/S3RVAuCYL4HYTBEfPw/Iov2sCxf6HpUr2bPpUcUCMwcMuJd2D5raPlDXptnWkuu
         F6KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8X+uswMd3Ue41z8ou11oNKd0muZNoaKFdUHY8+P2zA8=;
        b=ftsjpvpAznx8cyYplvbnxPFhTtx6QrTyDeFn/hlMy9KM0g0uj9kUTWih+1TNibyRfM
         yRtmmpzO2Jf1nhGWbeNbPWgmI4SoNpwyzmj5ATzKzcZFTyhrHuWJ5dr4pITP83QrjPeP
         GvmS6QdYuPIBCe5YIgxkliVz66ei9Vdwlxy3+HXa1oa+vemhLxjITAJBUeQwJ7wix9cS
         dHneGZEDW9FzJOROfuhKWrt0+dK8PgnpEfkRwKBH2tW1r+ro0ywS0aVSYIcXT/LtH+Ow
         IbNtTL/bgrc9mBXjquuzshJ5Uh91TAFdblKpF2dv6eOIshjF9H/mxQJWhfHhWbQ9guFb
         jMwg==
X-Gm-Message-State: AGi0PuYUh5jqfRUwFsConfIDtf2n79cEE/v6eOkTq/3BwLo7UXGC6NuC
        DqBQ7ah7Xog84cXOX3/Rr17uFg==
X-Google-Smtp-Source: APiQypKSH2zWEu3df/nXmoqoqU6Yjt7bs4z5pBruM/kPIqVj56zCXFoeTlVuko8f6BFcxRbVCpuRRQ==
X-Received: by 2002:adf:91e4:: with SMTP id 91mr9143007wri.356.1588765458658;
        Wed, 06 May 2020 04:44:18 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id z1sm2657647wmf.15.2020.05.06.04.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 04:44:18 -0700 (PDT)
Date:   Wed, 6 May 2020 13:44:17 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net,v2] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DONT_CARE
Message-ID: <20200506114417.GB2269@nanopsycho.orion>
References: <20200505174736.29414-1-pablo@netfilter.org>
 <20200505114010.132abebd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200505193145.GA9789@salvia>
 <20200505124343.27897ad6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200505214321.GA13591@salvia>
 <20200505162942.393ed266@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <e8de6def-8232-598a-6724-e790296a251b@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8de6def-8232-598a-6724-e790296a251b@solarflare.com>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Wed, May 06, 2020 at 01:33:27PM CEST, ecree@solarflare.com wrote:
>On 06/05/2020 00:29, Jakub Kicinski wrote:
>> IIRC we went from the pure bitfield implementation (which was my
>> preference) to one where 0 means disabled.
>>
>> Unfortunately we ended up with a convoluted API where drivers have to
>> check for magic 0 or 'any' values.
>Yeah, I said something dumb a couple of threads ago and combined the
> good idea (a DISABLED bit) with the bad idea (0 as magic DONT_CARE
> value), sorry for leading Pablo on a bit of a wild goose chase there.
>(It has some slightly nice properties if you're trying to write out-of-
> tree drivers that work with multiple kernel versions, but that's never
> a good argument for anything, especially when it requires a bunch of
> extra code in the in-tree drivers to handle it.)
>
>> On Tue, 5 May 2020 23:43:21 +0200 Pablo Neira Ayuso wrote:
>>> And what is the semantic for 0 (no bit set) in the kernel in your
>>> proposal?
>It's illegal, the kernel never does it, and if it ever does then the
> correct response from drivers is to say "None of the things I can
> support (including DISABLED) were in the bitmask, so -EOPNOTSUPP".
>Which is what drivers written in the natural way will do, for free.
>
>>> Jiri mentioned there will be more bits coming soon. How will you
>>> extend this model (all bit set on for DONT_CARE) if new bits with
>>> specific semantics are showing up?
>If those bits are additive (e.g. a new type like IMMEDIATE and

They are additive.


> DISABLED), then all-bits-on works fine.  If they're orthogonal flags,
> ideally there should be two bits, one for "flag OFF is acceptable"
> and one for "flag ON is acceptable", that way 0b11 still means don't
> care.  And 0b00 gets EOPNOTSUPP regardless of the rest of the bits.
>
>>> Combining ANY | DISABLED is non-sense, it should be rejected.
>It's not nonsense; it means what it says ("I accept any of the modes
> (which enable stats); I also accept disabled stats").
>
>-ed
