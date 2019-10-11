Return-Path: <SRS0=pLNN=YE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77D2BECE596
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Oct 2019 00:41:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 527302053B
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Oct 2019 00:41:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="G3J9DjEz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbfJKAlB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Oct 2019 20:41:01 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35295 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728049AbfJKAlB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Oct 2019 20:41:01 -0400
Received: by mail-lj1-f194.google.com with SMTP id m7so8076121lji.2
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Oct 2019 17:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CfDaZT4bXkWgxnluWp+WhmE+OpX1r8BSHHGhbM539S4=;
        b=G3J9DjEzJwvLYCWfemWN27LvdJrNNcUTEOJesbm+hDT6nSc4AxxnauaNC5OPkYNWHv
         EwPZHD9Hg/H8ArC5g3+ik5/9zXU1YiSGtHEwF2ExCsLHGakwfvrA0Ss46FpefN5CZre8
         cUJMn5kmLSF2zvecYGh+jg7shNGju9rCNctKgpBJFWyc6C3B7IH4U92epYuprDdI76Oj
         Tz27IJHKhtslTrB9KtusXYzKqXkPMFJZDZG+8oUypn/sHfPJnp3q981Jw25+qra8yJxN
         QY9kgc07gEjemDQPV77JrgVmoJ9X1PfcEz9wdswo05ZA7ud1WugjIM3O6/+JaEug5MVn
         IDvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CfDaZT4bXkWgxnluWp+WhmE+OpX1r8BSHHGhbM539S4=;
        b=ZgctswkNe55xS3w53vpOgMuc0C1TQRQfGBLyHwEKiZtY772wWkpEJS2H8KDAZ6KeOh
         J0254DBgnbeG0ebK/1hZpLFfSv1Qmh4WQ8z43GQJyi83myNEeldcoOohRkuUdZurrTLu
         9O5kqgvxiLgY6Jn1o+ghf+lBgh7q8fSPNYkAhXNP9IxADkDlM0ZcInjyHdrkRwd+Rowz
         4MzhFkRyqCi4GXeWfmbcBlPUFOe+Brs4v0l+jaZOPPZDdC8K4mTmVgDIOztf15MYfK5q
         2irycIhK0Bgw/IQkaKgcCJREeP/mqClQkqqyctPrsS/e3zqxhyBefeulVaBRvv++4AhQ
         fTyw==
X-Gm-Message-State: APjAAAWpQ7d4+uhjZaN42uaAxXmpq2XWSQE877p9ATR6vXC2XzL8GY39
        T8C1t6MEg5sbIhNYLA147qpdi6qA/iIvIQ74XMVS
X-Google-Smtp-Source: APXvYqzYZFKZde2jj/9GQoDK0Z4ns4uY9vTPu7Bp/zGHrqgX2RFr1p2j3XCc2e9Pvk/AmyCJXkusYSvrW8G5t9z7Nts=
X-Received: by 2002:a2e:286:: with SMTP id y6mr8034574lje.184.1570754459003;
 Thu, 10 Oct 2019 17:40:59 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1568834524.git.rgb@redhat.com> <6cef16c2a019e61e49f4d62497b5ca8dab79b45f.1568834525.git.rgb@redhat.com>
In-Reply-To: <6cef16c2a019e61e49f4d62497b5ca8dab79b45f.1568834525.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 10 Oct 2019 20:40:47 -0400
Message-ID: <CAHC9VhRtZc0R6Lo9Ea4pz+h8XtOD5LE2wKuCpnQHeb8aTBerWg@mail.gmail.com>
Subject: Re: [PATCH ghak90 V7 17/21] audit: add support for loginuid/sessionid
 set/get by netlink
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>,
        mpatel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 18, 2019 at 9:27 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> Add the ability to get and set the login uid and to get the session id
> using an audit netlink message using message types AUDIT_GET_LOGINUID
> 1024, AUDIT_SET_LOGINUID 1025 and AUDIT_GET_SESSIONID 1026 in addition
> to using the proc filesystem.
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/uapi/linux/audit.h |  3 +++
>  kernel/audit.c             | 62 ++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 65 insertions(+)

This is completely independent of the audit container ID work, yes?
If so, it shouldn't be part of this patchset.

--
paul moore
www.paul-moore.com
