Return-Path: <SRS0=ZPov=US=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BB25C31E5B
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jun 2019 17:58:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 298A32166E
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jun 2019 17:58:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GhErCDSK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbfFSR6M (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Jun 2019 13:58:12 -0400
Received: from mail-qt1-f172.google.com ([209.85.160.172]:33769 "EHLO
        mail-qt1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfFSR6M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jun 2019 13:58:12 -0400
Received: by mail-qt1-f172.google.com with SMTP id x2so100529qtr.0;
        Wed, 19 Jun 2019 10:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0W0itFPfY7xYg7LY+IR5dqlXHG0CFEKKluwnbGZQxeQ=;
        b=GhErCDSKnXlYp6pBkPM00480dl4XcXb27fp9GftJ5Ul/lDSwIGmgGKhX+/z7GNWmWW
         ByM2yg1cCwIS9mKxPYFGXorK93tRIem6/ijEuWrM88dtFgvtUXN4L0N6jfpXLf1OgG7L
         xPVqQ8hkBPK/NSXLqLmGu3YVdSbWnsPrUma4q/7EaWYRc5xfxvUdUrF0ermbheKfoOKk
         SQCBDFaHn5+tZSadVxJPeTO/Rc9hQYypGEKKxIkf1JIG1Xq3nqa+ukRwcrNe9rODEIRj
         fh7NuEnenKAW5zEKDdz9XtLhjEcBLw1foPuEJ2KpV9xgVUCnBCKP8Ussl4JcEPJbM3ZE
         EYjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0W0itFPfY7xYg7LY+IR5dqlXHG0CFEKKluwnbGZQxeQ=;
        b=c0JERv1XeLsItouSOrinV/sT8Or2mDI5Oh+A/AKimwc7/Atno4AdHOh5X3nMbiC4He
         Bt8Eb1yildJ9+dGhvW3AglA4UJJSsjYdMsMPSQ7utIpbc7cAg+CRiZw7PJBxaPtK2t37
         4Wyx38z4bvVa6jYUVjNdOxxnNtlIpLPwMGu2TOHtU6uDnInFEhJfNy/kVUCNzBAp5MHx
         J++Y/1h7DUPx843qgp45ElQwhgh2WoGWaYUgym3LGNTFHZP4Vi97k80ky2Xn/f9MX5cm
         xs66uTB666RLzeN5tJzQ5riXJu5f1ZicFdZxKcqrj6+ewDk31VMfm6O6SB/3Hb6F2LaC
         hFZw==
X-Gm-Message-State: APjAAAUeZbG2hu4OEotXIIs+lBBFlctkgTbzocr5ja5HMREDVAiuwOcR
        hIg0yXkEoR+aLIi8sfEf7jkqGMw=
X-Google-Smtp-Source: APXvYqzbhU2OKh0y/yT5q91FaQ+D3qvbj5zy/GxdOUZHIFS3ikY0bh0O7ELgnL7+LdDEYl2UHLPtlA==
X-Received: by 2002:a0c:bd9a:: with SMTP id n26mr34728869qvg.25.1560967091576;
        Wed, 19 Jun 2019 10:58:11 -0700 (PDT)
Received: from ubuntu ([104.238.32.30])
        by smtp.gmail.com with ESMTPSA id g10sm9643885qki.37.2019.06.19.10.58.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Jun 2019 10:58:11 -0700 (PDT)
Date:   Wed, 19 Jun 2019 13:58:02 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH RESEND nf-next] netfilter: add support for matching IPv4
 options
Message-ID: <20190619175801.GA3859@ubuntu>
References: <20190611120912.3825-1-ssuryaextr@gmail.com>
 <20190619171832.om7losybbkysuk4r@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619171832.om7losybbkysuk4r@salvia>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 19, 2019 at 07:18:32PM +0200, Pablo Neira Ayuso wrote:
> 
> Rules with this options will load fine:
> 
> ip option eol type 1
> ip option noop type 1
> ip option sec type 1
> ip option timestamp type 1
> ip option rr type 1
> ip option sid type 1
> 
> However, they will not ever match I think.
> 
> found is set to true, but target is set to EOPNOTSUPP, then...
> 
> [...]
> > +	err = ipv4_find_option(nft_net(pkt), skb, &offset, priv->type, NULL, NULL);
> 
> ... ipv4_find_option() returns -EOPNOTSUPP which says header does
> not exist.
> 
Yes. My goal in writing this is mainly to block loose and/or strict
source routing. The system also will need to block RA and RR. Others are
not fully supported since we (my employer) don't need it. They can be
added later on if desired...
