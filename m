Return-Path: <SRS0=LRZR=3U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BB10C33CB2
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jan 2020 03:18:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72B2220705
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jan 2020 03:18:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="p72bhPsq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgAaDSJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Jan 2020 22:18:09 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:42710 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727943AbgAaDSJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Jan 2020 22:18:09 -0500
Received: by mail-ed1-f68.google.com with SMTP id e10so6195210edv.9
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Jan 2020 19:18:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2UFuNa0uGTLSS1K01AHJXT4Immh/ilmwx1a5+JX2kzY=;
        b=p72bhPsqHNefTSK6Ep+tGbjM2dm4qropADYIbAbcPBmXX4btpOIYu/AUklLtW9HlW+
         dD/G19PbLERrH9LJFPYgrkrgnoGLgRydZfUG9raQPMIbnA3IDRUSFwLT90c/JLHmEt0j
         n+R19nbrys+yrn0UOhbRBsTMZAL6NGCtCNiOiL6fsvbBAskEB4v2s9YqP9C4YvuV1PNH
         by/mU9jceZdiFlqAndGuo1BPis8TBbIgMHr6w4CvxbWJwl2NhcMS0JjYXqIduazoC0lA
         LgG1dafhhm9rpDiuaCqZF9Y1kmgCbD1GnsnpJUurEV8iGXZNTMG2N6yv+3642xEriwg3
         9daw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2UFuNa0uGTLSS1K01AHJXT4Immh/ilmwx1a5+JX2kzY=;
        b=HlP573gwEUbVzRaed+Fmo2N7AF+ayvV2SWSwcnD/YzA8CfrN2EmfCidGRRo5pnCSX1
         Ws/hRmkzoGlbcLU54OYgZKdUlJ2V7Hvvjbm8hZ63lmTmDLOjjwVEYvvUAK2TX/iObQAl
         L15n2pOkgTyxpUNsyG7rH3Hv6Y+dvEhOZvsuGzCo7XU3cvsiDMR9zQPmJqhz5iGJjtBy
         0Bvvaz0gUkAE8nzvdEp7Z1mlUUtrv+KRWQ09JmSiynhqhDKg520pFsVXBpfL867tO9Ds
         yN+4Cop2n+g8XuvDtJcqFQwzjMN8OMMFRbcj45KvQ20wz4XpSkXBb1d2MwVgg/LrC/LQ
         Ko3A==
X-Gm-Message-State: APjAAAW+8CVxYNEQsYQH/+kz4maCVneweuyhnAR7JlEvpDHo7/DSfsxt
        QLxbFm+6qwyEK9JpytV3cacS9gQ3fwtqpTjPNi4V
X-Google-Smtp-Source: APXvYqxZYRdy66YBGdH/VpIt3ZboIykO9cetzPypkFQfg4TUGmTfhLVz2mVM4N1TFUn6xMYy7WmQgJiTKAg/wHr3E28=
X-Received: by 2002:aa7:cd49:: with SMTP id v9mr6686444edw.269.1580440687367;
 Thu, 30 Jan 2020 19:18:07 -0800 (PST)
MIME-Version: 1.0
References: <cover.1577830902.git.rgb@redhat.com> <7df83e229cff2518e73425cdc712505fb773a9c2.1577830902.git.rgb@redhat.com>
In-Reply-To: <7df83e229cff2518e73425cdc712505fb773a9c2.1577830902.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 30 Jan 2020 22:17:56 -0500
Message-ID: <CAHC9VhR=KOAJz5F1XtqSiQkX7c90qCf6dzwZp+j+BTL=sfwTFg@mail.gmail.com>
Subject: Re: [PATCH ghak25 v2 3/9] netfilter: normalize ebtables function
 declarations II
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
> Align all function declaration parameters with open parenthesis.
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  net/bridge/netfilter/ebtables.c | 27 ++++++++++++++-------------
>  1 file changed, 14 insertions(+), 13 deletions(-)

My comments from the first patch regarding style changes also applies here.

--
paul moore
www.paul-moore.com
