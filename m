Return-Path: <SRS0=DEFU=WP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1380C3A5A0
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Aug 2019 14:08:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E56C206BB
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Aug 2019 14:08:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IDyt6ujE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbfHSOIc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Aug 2019 10:08:32 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:43998 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbfHSOIc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Aug 2019 10:08:32 -0400
Received: by mail-io1-f68.google.com with SMTP id 18so4499826ioe.10
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2019 07:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3t73STValRqs8B4tNG6xV6cAYGmqp2o4ZMsXTep/DT4=;
        b=IDyt6ujE+2U8Zbqns7FxqKMlCUUQWISLEDbKh37dfPDDGhMHDeVUzTYG/SKUVWXGnU
         QZfhiwgPdlBuMK2pLD/lXd+L/gwRQm0jNM5cWJzrg+pG9GMCFeZ8rseTEwLxkAy1Vf35
         wXg1b70I7CNBfB4UQrLhnsDUTX+zGOauYkrb6R0r1wqu62wvBP+ZEwLz0U7gBwNJTTlU
         VdOoW/oMV9lOClfVhio9k6IvkUN0rMqjpqPh+f59B6o21QKVG5sG6BGmCdCowUf8uYx2
         3KrFdbRMChnK90bPLwT7R7Znnd7gwHJJEU0ugdxvsC6jtX9Fpy/nVSdQUbEus5HqbHPn
         hmlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3t73STValRqs8B4tNG6xV6cAYGmqp2o4ZMsXTep/DT4=;
        b=Im25BDGnL+Fbbq/yvvawmmnnzjOsAXiiEdyxBILtsZQZdR1Cb8wGnM4dsSoZ5ZIVhU
         14nur/tjyu5SNfivGyOkQxrASGJqkzwN0I9lEDcf2zB+BeGaETrmzEI6tfhJTAdjbRvz
         IA3BlWfnXNlrXG7KOQszgPH25DRxnKHxuhm0+HAgmTtWMYaAk5zaTf4uqG8TOpdmuz3J
         suYly9Z5e6Mnkr9koS5cpr+FNI98rIXSUH974VK4vUdC0fMwyMReNdpzgj4EvUCzoQnu
         gUAuzboxO9u0tskRBQRZ4XiL8T669HTcc16G8MgezIYeqXAPl12FOb1iHeQEqF055JyP
         YtiQ==
X-Gm-Message-State: APjAAAXFouuaojbENOhj7GB3fXE18kN8Y0nH5ssDfGgmsV/o3N1OuXZX
        dGcu0giEr3OOk3QROuYpcAd+0gsU7rDTyWyRYZPa9Q==
X-Google-Smtp-Source: APXvYqxf24XR1yaoMcx36bV0OVBCJeI8SbLpXVrw02oNMvoV6r0QVJD3mVw/dGdYUvnxZYq4MidgbsXGVh+lcTwYu8A=
X-Received: by 2002:a6b:e90c:: with SMTP id u12mr14832467iof.221.1566223710970;
 Mon, 19 Aug 2019 07:08:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190817111753.8756-1-a@juaristi.eus> <20190817111753.8756-2-a@juaristi.eus>
 <CAGdUbJFMCT9aXqPKVEVF-vvLzser+58R62mSZRZLRfaR5eJpSQ@mail.gmail.com> <18f3faaf-97f8-ef8c-b049-3a461c1c524c@juaristi.eus>
In-Reply-To: <18f3faaf-97f8-ef8c-b049-3a461c1c524c@juaristi.eus>
From:   Jones Desougi <jones.desougi+netfilter@gmail.com>
Date:   Mon, 19 Aug 2019 16:08:19 +0200
Message-ID: <CAGdUbJE_ZF3Sa6WMfo_j9JRME9mZteKsGgws31c0i+ASPza=8Q@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] netfilter: nft_meta: support for time matching
To:     Ander Juaristi <a@juaristi.eus>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Aug 18, 2019 at 8:22 PM Ander Juaristi <a@juaristi.eus> wrote:
>
> On 17/8/19 15:43, Jones Desougi wrote:
> >> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> >> index 82abaa183fc3..b83b62eb4b01 100644
> >> --- a/include/uapi/linux/netfilter/nf_tables.h
> >> +++ b/include/uapi/linux/netfilter/nf_tables.h
> >> @@ -799,6 +799,9 @@ enum nft_exthdr_attributes {
> >>   * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
> >>   * @NFT_META_BRI_IIFPVID: packet input bridge port pvid
> >>   * @NFT_META_BRI_IIFVPROTO: packet input bridge vlan proto
> >> + * @NFT_META_TIME_NS: time since epoch (in nanoseconds)
> >> + * @NFT_META_TIME_DAY: day of week (from 0 = Sunday to 6 = Saturday)
> >
> > This would be clearer as NFT_META_TIME_WEEKDAY. Just day can mean a
> > lot of things.
> > Matches nicely with the added nft_meta_weekday function too.
>
> I agree with you here. Seems to me WEEKDAY is clearer.
>
> >
> >> + * @NFT_META_TIME_HOUR: hour of day (in seconds)
> >
> > This isn't really an hour, so why call it that (confuses unit at least)?
> > Something like NFT_META_TIME_TIMEOFDAY? Alternatively TIMEINDAY.
> > Presumably the added nft_meta_hour function also derives its name from
> > this, but otherwise has nothing to do with hours.
> >
>
> But not so sure on this one. TIMEOFDAY sounds to me equivalent to HOUR,
> though less explicit (more ambiguous).

HOUR is a unit, much like NS, but its use is quite different with no
clear hint as to how. Unlike the latter it's also not the unit of the
value. From that perspective the name comes up empty of meaning. If
you already know what it means, the name can be put in context, but
that's not explicit at all.

That said, weekday is more important.


>
> >>   */
> >>  enum nft_meta_keys {
> >>         NFT_META_LEN,
> > ...
> >
>
>
