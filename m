Return-Path: <SRS0=3cJm=SY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F207C10F11
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 13:49:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2200620685
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 13:49:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="KaqBsNHa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727598AbfDVNtT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Apr 2019 09:49:19 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41227 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727403AbfDVNtS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Apr 2019 09:49:18 -0400
Received: by mail-lj1-f193.google.com with SMTP id k8so10351051lja.8
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Apr 2019 06:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XQFBYGnZg0XEWFn8CSrqp3+QoiwOdJuLikT3CHYKNBo=;
        b=KaqBsNHaf1fLNIyoAV4UgByrrjlXmfDPNTDRqyyDHApsk39c4Ef08efn45bhHmFu9w
         mjeWWOudfEkVDN0jASnuSyqIw/9MeuiHuyRjKBwlZIxLQzFhcx0NFauB8xotuVmWuk7R
         nTrSwvPjCOQO3+NbZRort0YJMNjpfI8pbhw6hlx4qTn5Et+KND0LKW8AJtWXkAqIQli3
         WO5hC25IT8a1/CpuodGQvHLeNEdGWGGJDOmAJO6ZY7mJ6p317EJT5L+c/RPyeEg7C6G8
         qStUSsUtRkQ0NtXQRmyUwTEmdceNtmJBWLevhuk7rbUTz5aLq6duXWiDfFemQzyYlvsF
         jtwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XQFBYGnZg0XEWFn8CSrqp3+QoiwOdJuLikT3CHYKNBo=;
        b=th9TB+kLWCtz3fs4M2FFPv5X6f7b5AvvoItOj0lTCUn8d4FYj79CpsJz3hxr4yVYx9
         KIUcVqbcO1jVsHolWDPdNNDLLOW0bu1uwVKrw8kesTao0UFQ3PlaPYi5/TEZN9hcr7k6
         5bqJKUO05sKUPUolNBO3OZXIyJOPzHoTJFs2OxFtLDo9Bmy5WgqZLOOc34X6A22VeJ6y
         2PYtebvlO+daIqyyg0nGmoY3Frb25aqZtPb5cuGPpOG7paI+VlEvbZI4eCJkCixrPYcL
         ouR7/3nuN3W9TfRHaXCwA0Pu6a0jqzEugunqgw6e1B4YHVgs1uB6KMxPT/5tnPPevbqQ
         a10A==
X-Gm-Message-State: APjAAAW4cLiIF3bzUzxBkgMGxEtLZvLxLi4jmBoqysBBbosBZGGtNsir
        uOPxDb5zK2rLvMVL2XsjD5oU2SKagr5tcS51sTuh
X-Google-Smtp-Source: APXvYqxqtfV+UJ/PwH6ynGSFzEbVXb/DDeEsctmCUNCswoOTK4fexb41Lr6AXRYbkTAn9Kx31EzBIaykN/Mp+ImlEBw=
X-Received: by 2002:a2e:88c5:: with SMTP id a5mr10242632ljk.5.1555940956344;
 Mon, 22 Apr 2019 06:49:16 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1554732921.git.rgb@redhat.com> <20190422113810.GA27747@hmswarspite.think-freely.org>
In-Reply-To: <20190422113810.GA27747@hmswarspite.think-freely.org>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 22 Apr 2019 09:49:05 -0400
Message-ID: <CAHC9VhQYPF2ma_W+hySbQtfTztf=K1LTFnxnyVK0y9VYxj-K=w@mail.gmail.com>
Subject: Re: [PATCH ghak90 V6 00/10] audit: implement container identifier
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Apr 22, 2019 at 7:38 AM Neil Horman <nhorman@tuxdriver.com> wrote:
> On Mon, Apr 08, 2019 at 11:39:07PM -0400, Richard Guy Briggs wrote:
> > Implement kernel audit container identifier.
>
> I'm sorry, I've lost track of this, where have we landed on it? Are we good for
> inclusion?

I haven't finished going through this latest revision, but unless
Richard made any significant changes outside of the feedback from the
v5 patchset I'm guessing we are "close".

Based on discussions Richard and I had some time ago, I have always
envisioned the plan as being get the kernel patchset, tests, docs
ready (which Richard has been doing) and then run the actual
implemented API by the userland container folks, e.g. cri-o/lxc/etc.,
to make sure the actual implementation is sane from their perspective.
They've already seen the design, so I'm not expecting any real
surprises here, but sometimes opinions change when they have actual
code in front of them to play with and review.

Beyond that, while the cri-o/lxc/etc. folks are looking it over,
whatever additional testing we can do would be a big win.  I'm
thinking I'll pull it into a separate branch in the audit tree
(audit/working-container ?) and include that in my secnext kernels
that I build/test on a regular basis; this is also a handy way to keep
it based against the current audit/next branch.  If any changes are
needed Richard can either chose to base those changes on audit/next or
the separate audit container ID branch; that's up to him.  I've done
this with other big changes in other trees, e.g. SELinux, and it has
worked well to get some extra testing in and keep the patchset "merge
ready" while others outside the subsystem look things over.

-- 
paul moore
www.paul-moore.com
