Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAD51C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jan 2022 03:19:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiAUDTm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jan 2022 22:19:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbiAUDTh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jan 2022 22:19:37 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999FBC061574
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jan 2022 19:19:36 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id e28so3217861pfj.5
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jan 2022 19:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:date:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=HBTtahI4wH+Av92gdQEm+8IJagwpU23XoMsjACDdEG4=;
        b=NgdPw9aL15PfHdpVXFXWKQpoub4DVEZkQJE/v3OJ5PBIE4/EVuGaykNsUJHXo+WlqF
         kdAvsF9AWMBqqPZuKVKBhbJaRkz7f7rN3mjKNfUSxm3LuVvhXdjGPDIiNtvBKlEtnRw3
         af4WuFIFXkGlhzHbKPb6BUC2oI6MABFZOKK5l54QzWjiWyWAWTfvmndzfjz78vSsmBMi
         bp1GtA+YErOws0nDS8ZTCOLWJCdihce9KiPaZ8KSwHXz6EAAR8juNhv5s5/oUUOJ60mc
         EvmBvi6k2OMgP5r6VSK/MH36RVA3XNZwpOJ/woSkcqFqe/ymXb6kyDgRH548oP9vza1K
         tGnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :reply-to:mail-followup-to:references:mime-version
         :content-disposition:in-reply-to;
        bh=HBTtahI4wH+Av92gdQEm+8IJagwpU23XoMsjACDdEG4=;
        b=H/74mnqg0tAfalPYNPOTYohx20qto/qWVDt+YtlX7jzKBZWgMdWe3nb5HGSqvTHYB0
         ucVfYDq5iftBdZh3qfaHOFCcY2aScTVm4Jy+WXcLIo+dlQT3Gbdbm9n7wP/cEdyWO104
         b0LX+Diyksbi0UWv2JOVJIRJKLXvDAYaZ67ze3MASob4sHAPqoQ32e8JXb2OiYf5Xrfa
         3SxmhxHBGAMyNsyKUCevSUAC9h3pzWnH6BtqJVssCeF3m+RBZWTFEU82I3za5A8w3EJv
         6RmdeGUXcbuIUeEv54HtuB7irpyt4OgHeiGyvFJswmF1mPmJXg/LlW2QTPkuUGAkoCKR
         PSLw==
X-Gm-Message-State: AOAM53045716jLxdy5IcOjeRD+n4135r5GBNYc6TyJcjIVpsccCmoOvj
        F53IxxOuEtF3j2CLeOUud1WEE8CciDA=
X-Google-Smtp-Source: ABdhPJwRbhgbtZkd1K1dAKlzph9TuUl6ZuwN9mkRplajUIcCGKHkKJ/2KaBvTVOsOR7bim2iFmajRQ==
X-Received: by 2002:a63:af48:: with SMTP id s8mr1482810pgo.615.1642735176123;
        Thu, 20 Jan 2022 19:19:36 -0800 (PST)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id m13sm3601144pjl.39.2022.01.20.19.19.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 19:19:35 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Fri, 21 Jan 2022 14:19:31 +1100
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v3 1-5/5] src: Speed-up
Message-ID: <YeomQ68e9yjr9I51@slk1.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20220109031653.23835-1-duncan_roe@optusnet.com.au>
 <20220109031653.23835-6-duncan_roe@optusnet.com.au>
 <YeYClrLxYGDeD8ua@slk1.local.net>
 <YeYTzwpxiqLz8ulb@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeYTzwpxiqLz8ulb@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jan 18, 2022 at 02:11:43AM +0100, Pablo Neira Ayuso wrote:
>
> We should untagged as deprecated libnetfilter_queue old interface in
> the documentation, it's fine to keep it there, it should be possible
> to make it work over libmnl.
>
Agreed. The question is, what to do instead.

We need *some* form of tagging to show whih are old interface and which are new
interface functions. You write a program using either old or new: they don't
mix. It's an early design decision which to use so we need to make it as clear
as we can.

Perhaps tag every module as NEW or OLD, with an explanation near the top of the
Main page as to what is the difference. Ideally would have libnetfilter_queue.7
man page as well.

Suggestions welcome,

Cheers ... Duncan.
