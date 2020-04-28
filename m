Return-Path: <SRS0=gJ4i=6M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBCB7C83007
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 08:11:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A301206B9
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 08:11:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="La/2aXII"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgD1ILA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Apr 2020 04:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726523AbgD1ILA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 04:11:00 -0400
Received: from mail-ua1-x943.google.com (mail-ua1-x943.google.com [IPv6:2607:f8b0:4864:20::943])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17968C03C1A9
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 01:11:00 -0700 (PDT)
Received: by mail-ua1-x943.google.com with SMTP id z16so20402853uae.11
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 01:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VKzL0ctpLRiMcnXOC76MNxzPVGyCpONZLSh9LTqY6Qo=;
        b=La/2aXII2kZ5jud5y+a+Kwl+poMKPtiZurRzX0I5P1bwlM0kS/bDro3b0cfh8iQHZD
         oh4GebwwSBm+w0fFQWSEcDDSqua7UVyGxYt4pT+F1gHk6r8Ah13HcKhOfwPTIzLeLqoj
         ytee4qPC6AZ+R92Jc21Z5mMXpB1FYJrolWWqdhkJA3LC640JABYPqcBMdOfJJVGpn8MC
         lqmTd8DdOUK5xfHq0BhTHVxmzxJoJiB7X/WlLq4WrZX/hMCKmBnlMBcJpLHEiV6OY+By
         /oTxYTChMZjM5+bv5pFDH1GsLdwq87EPEYbErVHehRNVFfN1LK4xR3AKT0V0Dz4n85dO
         mbZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VKzL0ctpLRiMcnXOC76MNxzPVGyCpONZLSh9LTqY6Qo=;
        b=KbJCUJ1dHlDMOZoVGAFY23rihZ9oozlEW8/wutYAxwrFzmVAUzmkDXVXmCs1il5mQd
         SxwJf0FkS10laOHI1HTpESodbEEUiV6U3stfrh8YD+7Y6m4teSz8Pm/oefA+BZNrtP0b
         XtWhChpZGwEijCJ3uHjEPsgibtL6t2aw5BHlfQHI7t5Ns/jGizCLv/zf655Yp0PGDbzs
         79WyYq+fCi3GQrDoQcZqGzgDl1iE849s9HbUTFG+KN9f0h3hloWfbIwUEV/pO1/KNY0v
         JP1YHu51Llvpn51p+um9R3AtYvo8SfRJPx+QiJ/b0IEiKttcY5nqHlC/ivWKHOO0I9Ow
         2/vg==
X-Gm-Message-State: AGi0PuafljLGorxIlJXyitofOUMx7RboOAEs0TfoqT6FLnFeLuUwlCzL
        pLaa0NiZBtfjbAnkquqIKZswvYXs2Q/oPKve2/qKeQ==
X-Google-Smtp-Source: APiQypLnE/0yZYp6oGAEC6aN+2HrOwN8aOdYXDU9cbreJHjKIXLgswmkhYBHTosNypWOXFt1Muid88MChIQK67l7+Jo=
X-Received: by 2002:a67:c217:: with SMTP id i23mr20167839vsj.217.1588061459238;
 Tue, 28 Apr 2020 01:10:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200407180124.19169-1-ydahhrk@gmail.com> <CAF90-Wg=uGXVOPu-OXupkFYYL0xDYTfV8vTNRvUQgspFMamL=w@mail.gmail.com>
 <CAA0dE=XPuEv=Gye9MXz+aC9s8=izd066+=yJfYTe9vtZgQtLnA@mail.gmail.com>
 <CAF90-WhkRhsY6D+NgUCjVxaT2G+hzfgaP_UP4_MUusADUPA1xQ@mail.gmail.com> <CAA0dE=VK=YusbgKS3O_h2N2YQ-edCdPFHtmDn_y4h57A64StmQ@mail.gmail.com>
In-Reply-To: <CAA0dE=VK=YusbgKS3O_h2N2YQ-edCdPFHtmDn_y4h57A64StmQ@mail.gmail.com>
From:   Laura Garcia <nevola@gmail.com>
Date:   Tue, 28 Apr 2020 10:10:47 +0200
Message-ID: <CAF90-Wi3d-CGqQO=PsfXdi6OAAABahcd2edp2Tru=UMmrJV7Sw@mail.gmail.com>
Subject: Re: [nft PATCH 2/2] expr: add jool expressions
To:     Alberto Leiva <ydahhrk@gmail.com>
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 28, 2020 at 2:29 AM Alberto Leiva <ydahhrk@gmail.com> wrote:
>
> Ok. This looks doable. I expect to run into trouble along the way, but
> I don't have any more objections for now.
>
> Did you receive my second mail from that day?
> (https://marc.info/?l=netfilter-devel&m=158700165716521&w=2)
> I won't hold it against you if you refuse the bridge, I just need
> something to tell my users.
>

Hi Alberto,

Please don't get me wrong, I'm not refusing anything. Just expressing
my opinion. The coreteam is who had to decide.

I truly want NAT64/46 to be implemented in Netfilter but in a
definitive way, not something temporary.

I got your second email but I had nothing to add. I consider it very
unlikely to integrate an API that you already know that could be
obsolete anytime soon.

Cheers.
