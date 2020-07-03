Return-Path: <SRS0=cAfZ=AO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9C9FC433DF
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jul 2020 13:41:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B621F20772
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jul 2020 13:41:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="shE8AZUM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgGCNlV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Jul 2020 09:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726035AbgGCNlT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Jul 2020 09:41:19 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A40D7C08C5C1
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Jul 2020 06:41:19 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id f12so8053602eja.9
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Jul 2020 06:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7uF7g65N0fhkNRDQWLvCnLMIuNK+JZWHI0AnyxJK8Ns=;
        b=shE8AZUMuHa+plAY8kdqJ26qAxglWyfSH6fdVPYwlmVcDEkh1j5qvjrIp7eKosz+aC
         dIYm0vFYM6EQarWE6oLSjSqIQXZ/XdjNmF6ijeWHIb0NW6dUA9cyVWIePctQG7+n9wTn
         OT2EcWhiP253VfIZbu0p6lTC2/SnRSrZ4McxgnQJ4YJEphTSHdYJ+SJ1puzMQbe0ZkW+
         iSi6HCpVGvhvrfQ7wwXQaVMsqq0EJi9OXgZ1c+ik+MtmyydS/FtDF/pzV5t7sllg/oBL
         zRTxMAKK7hR772F5HS3HiJniRdTDt2QTuHQmLs3slrpI3HAyb2xVrvi1uFiQASPj/yos
         naaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7uF7g65N0fhkNRDQWLvCnLMIuNK+JZWHI0AnyxJK8Ns=;
        b=TsBMeoXrwWspYfsflPRJ3u+ZIiXNwMuyj6dppdqYEpaq4r+N/GFnvuErz5yKunnhT6
         k60PpintsMpYdOKpGaxtwSf8P/1w6XgOAoekBnsbiH/HxX1nm70gZVzdSFxUR3r3FMA1
         DavVNB4tARN4TBvGDNGBjI+i9E/ueWkDM/56r9/sGDe+HETwQu8Pl90o49kljymj/JbO
         RrqswHv4q+qmIthvv56vMXpzOi2FHKPitci4/VG9CPIkYkY+Pp0QffEkmvEPdysSi/sC
         SwQBsNMvlb0lCZYQaZUgR9nFVdqS/JUpHTsXkrABagnPUJc9jSeh8qtRkPFnv/FfQfps
         NaJg==
X-Gm-Message-State: AOAM530wBIvoAAnv6Oejxgpex2ztIoX0IxTev3eisIhuKFsFrpI6P85Q
        a9WV2yRZplWTCM3wy5MQsuiQ7HZLoNpQfaraBKkp
X-Google-Smtp-Source: ABdhPJzEh3lYbHXZEZtaKYGhHDXIHK+g9iZaSuhvY5ttt1AM1p+O7sOeZk0mCwWZe6VIAYYHBFBu95zncE/y13PnKdA=
X-Received: by 2002:a17:906:456:: with SMTP id e22mr26778131eja.178.1593783678300;
 Fri, 03 Jul 2020 06:41:18 -0700 (PDT)
MIME-Version: 1.0
References: <3eda864fb69977252a061c8c3ccd2d8fcd1f3a9b.1593278952.git.rgb@redhat.com>
 <CAGdUbJEwoxEFJZDUjF7ZwKurKNibPW86=s3yFSA6BBt-YsC=Nw@mail.gmail.com>
In-Reply-To: <CAGdUbJEwoxEFJZDUjF7ZwKurKNibPW86=s3yFSA6BBt-YsC=Nw@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 3 Jul 2020 09:41:07 -0400
Message-ID: <CAHC9VhTYy5Zd6kB77xYL6HbnqL29AL6jF8RzVAN6=UC6eVLqCg@mail.gmail.com>
Subject: Re: [PATCH ghak124 v3fix] audit: add gfp parameter to audit_log_nfcfg
To:     Jones Desougi <jones.desougi+netfilter@gmail.com>,
        Richard Guy Briggs <rgb@redhat.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, sgrubb@redhat.com,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Florian Westphal <fw@strlen.de>, twoerner@redhat.com,
        Eric Paris <eparis@parisplace.org>, tgraf@infradead.org,
        dan.carpenter@oracle.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jul 3, 2020 at 8:41 AM Jones Desougi
<jones.desougi+netfilter@gmail.com> wrote:
>
> Doesn't seem entirely consistent now either though. Two cases below.

Yes, you're right, that patch was incorrect; thanks for catching that.
I just posted a fix (lore link below) that fixes the two problems you
pointed out as well as converts a call in a RCU protected section to
an ATOMIC.

https://lore.kernel.org/linux-audit/159378341669.5956.13490174029711421419.stgit@sifl

-- 
paul moore
www.paul-moore.com
