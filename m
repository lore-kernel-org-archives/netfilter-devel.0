Return-Path: <SRS0=n2xU=WN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5E00C3A59B
	for <netfilter-devel@archiver.kernel.org>; Sat, 17 Aug 2019 13:43:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E21820880
	for <netfilter-devel@archiver.kernel.org>; Sat, 17 Aug 2019 13:43:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kDeczDQU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbfHQNnk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 17 Aug 2019 09:43:40 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:35464 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfHQNnj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 17 Aug 2019 09:43:39 -0400
Received: by mail-io1-f68.google.com with SMTP id i22so11896919ioh.2
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Aug 2019 06:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hvGFC1OdCZDcm//O9vnqLLa55K9y3UKTeVFr0x8drRw=;
        b=kDeczDQUmJ9Vtf0Ol+77fn+H0oZUxqaLgeej+VI7sqwk6tYabP3Ntq/qseyZuORRS3
         wRWEYyvA+Yc3UYbIlTMw9EQlu7fsHwskwSRUrqUeiKvQWffTU/fl3QQmN4Ae8f3AsMXG
         zIBp4jfbn7EGEGOc9HLAB4/iTsz8hdO2IehfXr2JhlNNkJYI81Lf8OKSOq+tYA2FLSYs
         sRpl82v5GslyT2I9ulSkmMNCCkgcSNmlLRW9BpzbIhAy1a5x28LCC3empW+BrlSf3m4e
         bYSyIrt75VeV743Gkdp0bLaaORQgw5x2FLaJHiQx8EMyffmPuPlhicCkfuJCvOn4Ja2s
         j4Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hvGFC1OdCZDcm//O9vnqLLa55K9y3UKTeVFr0x8drRw=;
        b=eiVBKAOS0LgPzeFoSfjImlOeZ/FQJ2ga6hbAR2mYdStUfzSRtjrwiythz+OGMVkJeo
         Soth1vCUU7byCD4GR8ALdt4WT8oQQBVsyUkgr9YijlQHeJrVp6z2m+NtyKdpHNH34L3Q
         uF2N1OLo2LNfTUUpmbG10nC6YAcpgDoQi5+w+/o/xhUAmTy/7PZxi/XSCCJ3Dp//LCDY
         FGRQAi9GwL4q9pVCauylHG0SDP0m8++HUeSN7V7cZsPEQqtiuhA5AbtkWemF299p6R5q
         uZHOZxof2Pjj9mvA41c9CUYGKQduhSy8GimaNiVYfrwgQQWC72ca9N2owrI6fmrd9Ngs
         G4zA==
X-Gm-Message-State: APjAAAXyqiUw8pCn+uykJAbXEy4f+C4e+zzK1KUYWSe2YQEZolPoe1OC
        540Bqjth+b+sOXtevmEXFhu8Z++o7dBfcO/RedO1m8zo
X-Google-Smtp-Source: APXvYqwOCDYuny3Z25Sn8lj2F4FvxKUK20JlGzTO6hJfWZEh03lL9aTZRn/8qqLiBTzwjSgmzlPG6xhZCDfL5Nw32UA=
X-Received: by 2002:a02:22c6:: with SMTP id o189mr10828954jao.35.1566049418804;
 Sat, 17 Aug 2019 06:43:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190817111753.8756-1-a@juaristi.eus> <20190817111753.8756-2-a@juaristi.eus>
In-Reply-To: <20190817111753.8756-2-a@juaristi.eus>
From:   Jones Desougi <jones.desougi+netfilter@gmail.com>
Date:   Sat, 17 Aug 2019 15:43:26 +0200
Message-ID: <CAGdUbJFMCT9aXqPKVEVF-vvLzser+58R62mSZRZLRfaR5eJpSQ@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] netfilter: nft_meta: support for time matching
To:     Ander Juaristi <a@juaristi.eus>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The naming of the new meta keys seem a bit confusing.

On Sat, Aug 17, 2019 at 1:19 PM Ander Juaristi <a@juaristi.eus> wrote:
>
> This patch introduces meta matches in the kernel for time (a UNIX timestamp),
> day (a day of week, represented as an integer between 0-6), and
> hour (an hour in the current day, or: number of seconds since midnight).
>
> All values are taken as unsigned 64-bit integers.
>
> The 'time' keyword is internally converted to nanoseconds by nft in
> userspace, and hence the timestamp is taken in nanoseconds as well.
>
> Signed-off-by: Ander Juaristi <a@juaristi.eus>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |  6 ++++
>  net/netfilter/nft_meta.c                 | 46 ++++++++++++++++++++++++
>  2 files changed, 52 insertions(+)
>
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 82abaa183fc3..b83b62eb4b01 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -799,6 +799,9 @@ enum nft_exthdr_attributes {
>   * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
>   * @NFT_META_BRI_IIFPVID: packet input bridge port pvid
>   * @NFT_META_BRI_IIFVPROTO: packet input bridge vlan proto
> + * @NFT_META_TIME_NS: time since epoch (in nanoseconds)
> + * @NFT_META_TIME_DAY: day of week (from 0 = Sunday to 6 = Saturday)

This would be clearer as NFT_META_TIME_WEEKDAY. Just day can mean a
lot of things.
Matches nicely with the added nft_meta_weekday function too.

> + * @NFT_META_TIME_HOUR: hour of day (in seconds)

This isn't really an hour, so why call it that (confuses unit at least)?
Something like NFT_META_TIME_TIMEOFDAY? Alternatively TIMEINDAY.
Presumably the added nft_meta_hour function also derives its name from
this, but otherwise has nothing to do with hours.

>   */
>  enum nft_meta_keys {
>         NFT_META_LEN,
...
