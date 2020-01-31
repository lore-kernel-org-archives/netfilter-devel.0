Return-Path: <SRS0=LRZR=3U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9995C35240
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jan 2020 03:17:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFD5B20CC7
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jan 2020 03:17:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="cjINDer7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgAaDRw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Jan 2020 22:17:52 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:33465 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727926AbgAaDRw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Jan 2020 22:17:52 -0500
Received: by mail-ed1-f65.google.com with SMTP id r21so6273654edq.0
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Jan 2020 19:17:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yOLVgt8fcj2iGYHey3CUUOmMkAYnS7j8tXgJvVrXU7k=;
        b=cjINDer7CEB6XzORhR8of1i8DxX4CJUvcOz+BiVF8rlOvRxcYqqJFssCOje0YNdmLw
         acpDC81YkTWmD7895JLz6xiLO6vmT9csUBCwGj2HL6umCeWeu2o04CC411BxwTxJG/w3
         CX25pbReUUx3lK6oVXm2J4aVSc9Xm90wz4Z1GbVD41D3QLNWo0jntUIDVGFQ5RijP0zU
         lfYi0YTM39PGc2u/cA5FzfxRIC+DhBgCq/0Czc/Xd92Pbkfoo4UvasgayXhb2HRSf5tz
         Bg+zvLhW1BqXaWHohC1sYODzXHjv/ASKhvPdCGCDCkCsZ9IdEpmUxfBX7BnkQPIrkolF
         aGYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yOLVgt8fcj2iGYHey3CUUOmMkAYnS7j8tXgJvVrXU7k=;
        b=MmnvoRJKrNKiRrcLeHGzD92LvgPGafCXYx7jviYafg7YbRzJx8B4sHvg0JL6VXdqPy
         y3ByL+5VCzlMoqS95jvoovlboslQyWfR+iY5FO9RV0WAAVD8OrJCAHjM4j+omykQKz4D
         wbt93hiyOjER+vSn6KWWRs8XfTfYPafEO/4sNy1V7wFHUtSS3fhns2QkoK0B6Ztx+pl/
         g6fAPpqEI/Bc69ak5qlJEOqzKHkweAYC5vW1A3aURZ/Hr+7HJkweW+30LdJ7WQSyxLMM
         PGZDBmyczgYplDBbvFDnXstfCt3iNLzlK6anSfwovRa2ub+PVY15IYygNAFoyYZFKlLO
         +I4w==
X-Gm-Message-State: APjAAAXD5WLHW5mSnRAYyy+VpmapXv0F+n+PERnpaYDiPo94u9ThBYUO
        stSK8dl8Nn4/nmY6z4fJrKYEnIy0mtzT1uN/oNZl
X-Google-Smtp-Source: APXvYqwTUCYi1zTZ6aAj7T9ZR7RSTow6UhKXtTaXdlQwg4TDpQzCRANFe2+jrAzUPpmkZYRiK/VrJJt2rP9aOfwn3Sk=
X-Received: by 2002:a50:a7a5:: with SMTP id i34mr6842376edc.128.1580440668703;
 Thu, 30 Jan 2020 19:17:48 -0800 (PST)
MIME-Version: 1.0
References: <cover.1577830902.git.rgb@redhat.com> <c07cc1ecac3aaa09ebee771fa53e73ab6ac4f75f.1577830902.git.rgb@redhat.com>
In-Reply-To: <c07cc1ecac3aaa09ebee771fa53e73ab6ac4f75f.1577830902.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 30 Jan 2020 22:17:37 -0500
Message-ID: <CAHC9VhQSzJSJz7YKdjHeW_y4nvoWBHjt00yT+ixNRwGM6+ZMsA@mail.gmail.com>
Subject: Re: [PATCH ghak25 v2 2/9] netfilter: normalize ebtables function declarations
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, sgrubb@redhat.com,
        omosnace@redhat.com, fw@strlen.de, twoerner@redhat.com,
        Eric Paris <eparis@parisplace.org>, ebiederm@xmission.com,
        tgraf@infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jan 6, 2020 at 1:55 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> Git context diffs were being produced with unhelpful declaration types
> in the place of function names to help identify the funciton in which
> changes were made.
>
> Normalize ebtables function declarations so that git context diff
> function labels work as expected.
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  net/bridge/netfilter/ebtables.c | 100 ++++++++++++++++++++--------------------
>  1 file changed, 51 insertions(+), 49 deletions(-)

My comments from the first patch regarding style chanes also applies here.

--
paul moore
www.paul-moore.com
