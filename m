Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42815C432BE
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Aug 2021 01:33:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 150BF60F91
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Aug 2021 01:33:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbhH3Bei (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 29 Aug 2021 21:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhH3Bei (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Aug 2021 21:34:38 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBFCC061575
        for <netfilter-devel@vger.kernel.org>; Sun, 29 Aug 2021 18:33:45 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id n12so7585339plk.10
        for <netfilter-devel@vger.kernel.org>; Sun, 29 Aug 2021 18:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=Cw1E/VWbYUWMMFoATzS1rIvNi1Fspcgd3HNLNmSTyMY=;
        b=UuxoPw1xV8IbgDzocxrDT2yTjV+97udZ6aUMUXZYcOXKlH4uTMdH7ur6oA9uXKIJf8
         3LX28NWYRkQD5p0oJVP/CaDlHRnvRJTsclzoXJebuiD4GERM4ZXS5zqc7QBhbequUpyu
         3/c8V46MDZuBknww83K72wYQzPcH7syidmkEZmzL9yVQa1khDt3tqvtsyWzoqwiCFslR
         Miu3lW4XwiEA4a/ZH2lPA3eHcWobEoTRuYC1pj7k77DScLSNYF3WGnki65oCN5Tw5qWz
         +eDukzarCYboWf2Vyp1ZYo2IHy/GzBozbjPPbBQziEUxsiKDQ17PO4irLGp9mRUaL3VR
         sqsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=Cw1E/VWbYUWMMFoATzS1rIvNi1Fspcgd3HNLNmSTyMY=;
        b=c+sNj17HDBddz8Hn47FWjdyNbc4ktfxunvOXw/4z532ISIqc9DpM8Og2qUiy4OuEAS
         0PxNFKt8FIiCq9gY/ijw71p6NCZhsQ6bY59G7VruW+PJmHtfJbC0VPBakLQcENwjDB4H
         m8zLyDyJVMeJ8p0f9+xdXB8V42a+NEe424JjcunhYQ4fkX5eihNcrf5pHXCXFhYS1y0C
         a1W3R8P9xD6OyUVJnQM0aS0uf3KCkxZ5EGpeKVLer3KFZrayyVmESr7723f9o8nNTK4u
         p2Cwasf7aTSOO6qhRsN6AkvGuNMQw2B4anbSR/meVTOCbEAVWvOTCrPB9WunHXn+Lexd
         gDVA==
X-Gm-Message-State: AOAM5337XzBqCue+GEAV6CDnJVAm513ux0Mww8iPYNsUDjkwVOEcq2AP
        DVl3X8oKPqpiluo/B1doevdymGXbyQ8=
X-Google-Smtp-Source: ABdhPJxfo58usepRYOE3rf6VeD+mJzMZ9XbBQ+rzRcCdT76Rc47AoAyVUpT94Qu2/nexUqUk3uft8w==
X-Received: by 2002:a17:902:e0cc:b0:134:7191:f39 with SMTP id e12-20020a170902e0cc00b0013471910f39mr19709933pla.36.1630287224832;
        Sun, 29 Aug 2021 18:33:44 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id u5sm12323051pjn.26.2021.08.29.18.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 18:33:44 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Mon, 30 Aug 2021 11:33:40 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>,
        Jeremy Sowden <jeremy@azazel.net>
Subject: Re: [PATCH libnetfilter_log 0/6] Implementation of some fields
 omitted by `ipulog_get_packet`.
Message-ID: <YSw1dN3aO6GeIPWq@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>,
        Jeremy Sowden <jeremy@azazel.net>
References: <20210828193824.1288478-1-jeremy@azazel.net>
 <20210830001621.GA15908@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830001621.GA15908@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Aug 30, 2021 at 02:16:21AM +0200, Pablo Neira Ayuso wrote:
> On Sat, Aug 28, 2021 at 08:38:18PM +0100, Jeremy Sowden wrote:
> > The first four patches contain some miscellaneous improvements, then the
> > last two add code to retrieve time-stamps and interface names from
> > packets.
>
> Applied, thanks.
>
> > Incidentally, I notice that the last release of libnetfilter_log was in
> > 2012.  Time for 1.0.2, perhaps?
>
> I'll prepare for release, thanks for signalling.

With man pages?

Cheers ... Duncan.
