Return-Path: <SRS0=7yxH=7C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1231C433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 May 2020 18:40:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFA262072C
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 May 2020 18:40:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="u3zvcyI7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgETSk7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 May 2020 14:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgETSk6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 May 2020 14:40:58 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB89C061A0F
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2020 11:40:58 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id s21so5364229ejd.2
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2020 11:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gu04BwxFLehQzkmABOcTDiBulPEzSlONSfMwZQcVMtk=;
        b=u3zvcyI7Q++6Mrg+MmoeQfMunW0bnvUUcFgUODN/jYgRJ37WBF4+miKSCA8fdvC/1g
         GUP10vCDN4Z1KSoQoUQDdvUbxLDVG2GPuPrHlZ/3SWU7DPAgvVQ95YtU24hCtcH/xnZH
         MM3FZwWjQ254/VEpuag7ghWygCITtaeuOhAUpLzfmNJnz4Nlpotw/Wr+mUUpmKnnXsO2
         ls9zpoKVCSckhXYfeBugn3yVWwE5hEyKaiE0T4vRXZt5biF7zVJWlWxCZmJUn66vm8k8
         F3vQ7okR866Ttnsg0lXKLFLkEr32xD5v5CcV+zZ0awhI5brIsS9d5FI28DaRnamMCeHt
         +19Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gu04BwxFLehQzkmABOcTDiBulPEzSlONSfMwZQcVMtk=;
        b=YfFiInYu5mRz7zS6JFIX8i+GLjegYdTfIWqpJDO986MJPJZs7/1orzf/1Exj94VYcz
         hLs8yZusneX3hOne04F+i+7er5LHYdCclHgNuk0tGQTi9+V4E91jHvHrtfT9bloi+SDv
         p80YINwBsy0Cnbb/lGR+ODwLO1M/2YJK+sg1vsHzfpyoA1WCMJuLRWWM9Yep5x0nrYtm
         8dHrMEy4ChDHN2AkgjYJ8CDnFmnUkPZ+78PXq/s5YhMwj2kpTFMxFugT1dpenx+LhBKE
         wQQHks+VI2uzq5XKAtv74+TSiFMUy6g0BmbjAyJ3++FOWk8bZ2eUW5N1Z3w9/AADult9
         Ujzw==
X-Gm-Message-State: AOAM5303MDOcgv3uyHrO4xoQs7gEG4/MVaggtHKghmmb5dIVe77SRx6W
        M9Z17yEZ0fbSYQtU4QKTxoCV01lT9Z4bv+cD3TG+
X-Google-Smtp-Source: ABdhPJyl432j3d/8pUxUMZAk69CZRW+QGZ+OUXPSZa5FOTEpEa51O5OI2Wnf9L8vbda23KiNDb/yNHyV/QJBl7Ez13k=
X-Received: by 2002:a17:906:4d82:: with SMTP id s2mr387133eju.542.1590000056930;
 Wed, 20 May 2020 11:40:56 -0700 (PDT)
MIME-Version: 1.0
References: <a585b9933896bc542347d8f3f26b08005344dd84.1589920939.git.rgb@redhat.com>
 <20200520165510.4l4q47vq6fyx7hh6@madcap2.tricolour.ca>
In-Reply-To: <20200520165510.4l4q47vq6fyx7hh6@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 20 May 2020 14:40:45 -0400
Message-ID: <CAHC9VhRERV9_kgpcn2LBptgXGY0BB4A9CHT+V4-HFMcNd9_Ncg@mail.gmail.com>
Subject: Re: [PATCH ghak25 v6] audit: add subj creds to NETFILTER_CFG record
 to cover async unregister
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, twoerner@redhat.com,
        Eric Paris <eparis@parisplace.org>, fw@strlen.de,
        tgraf@infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 20, 2020 at 12:55 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-05-20 12:51, Richard Guy Briggs wrote:
> > Some table unregister actions seem to be initiated by the kernel to
> > garbage collect unused tables that are not initiated by any userspace
> > actions.  It was found to be necessary to add the subject credentials to
> > cover this case to reveal the source of these actions.  A sample record:
> >
> > The uid, auid, tty, ses and exe fields have not been included since they
> > are in the SYSCALL record and contain nothing useful in the non-user
> > context.
> >
> >   type=NETFILTER_CFG msg=audit(2020-03-11 21:25:21.491:269) : table=nat family=bridge entries=0 op=unregister pid=153 subj=system_u:system_r:kernel_t:s0 comm=kworker/u4:2

FWIW, that record looks good.

> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
>
> Self-NACK.  I forgot to remove cred and tty declarations.

-- 
paul moore
www.paul-moore.com
