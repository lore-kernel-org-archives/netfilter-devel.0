Return-Path: <SRS0=WbMd=5D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B0CC4332B
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 21:22:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E118E20772
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 21:22:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="WVqbhFQ0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgCRVW0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Mar 2020 17:22:26 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:45816 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgCRVW0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Mar 2020 17:22:26 -0400
Received: by mail-ed1-f66.google.com with SMTP id u59so4332352edc.12
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2020 14:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+bCjnLS3/3LmRyiYvzCeE/0vqSGm4G29SOPcHPTj9Nk=;
        b=WVqbhFQ0HR48r+Jly83+UZE8P2XU4MXcDvBjdCv/+lZ7WU9Dhpn90tdVquotwAqlz/
         JsqXHb23GLWbxT5koy4F8KNdXAJEqWX20bawxKtIKTk5Quk+0U8wcsUZlpzGHUeIdrNq
         /cpFn9SxnnFWjEmiMWBvgt+2yUugQASTApC6Iz/iguJH+0g7ZZhf4bZoL6vfM/Az7Zhl
         JhdtZcR6edgPvHKH9UOGzHYP6FQB4qy9kHKF7NrZb0LOzwOiU3q9jqM0tq1G6VZFF/sr
         nGUOF/EHJvpDpmOR5MsGL2ks8SxVwzn7ztkRp49TpEw8QcH87mfBkz2rGFpPLehUW8Ns
         ENwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+bCjnLS3/3LmRyiYvzCeE/0vqSGm4G29SOPcHPTj9Nk=;
        b=KZEsJRCSHU+Zp7NjPZbARy/bN3zbALAsCQ62F2IrViZ8nn8a3yhO9eRnV75JmKCd68
         5XqkzLIuQPmJuNrEnsLYu1TCyRrbLahzaBq2xZW1lGzpcwr3IgVonvkOT0mbY/IoSy7R
         GYrvK70GvUO2G+koGDGPyjKFQitpocq1KULbq7o5W7HBwrn0D+Sc16lYASkGwMHKGhEP
         VSzyEohl9Tku0WLpST68HBaNiHvYNEpgWEJkQNEvxeb/lO4Mry7qmb/E3ikiGVQly68J
         YVjmy12yZ8maMUL8hai0H8MZhJ/6DeNYUL76nU7gWbauGWIhYVQAv+pg2gJtsPrsVo89
         Q+aQ==
X-Gm-Message-State: ANhLgQ0JUUDudslPCALBv4mRDHw4lwSUydK77R5Y2dmNYH2clJ/eCIMX
        qJF+mh+J15S7MBp+uS9gE4aFTRUPFDadNKyzH/bD
X-Google-Smtp-Source: ADFU+vvWLUbUOKc99d+nJ2kGsVgRAyeTEiBSorjH6C4MXrjw/aBa+P204vtxxVwDExRc2vW8ycqRFM9YVxibuVJSAck=
X-Received: by 2002:a17:906:7b8d:: with SMTP id s13mr198887ejo.77.1584566543231;
 Wed, 18 Mar 2020 14:22:23 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1584480281.git.rgb@redhat.com> <13ef49b2f111723106d71c1bdeedae09d9b300d8.1584480281.git.rgb@redhat.com>
 <20200318131128.axyddgotzck7cit2@madcap2.tricolour.ca>
In-Reply-To: <20200318131128.axyddgotzck7cit2@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 18 Mar 2020 17:22:12 -0400
Message-ID: <CAHC9VhTdLZop0eT11H4uSXRj5M=kBet=GkA8taDwGN_BVMyhrQ@mail.gmail.com>
Subject: Re: [PATCH ghak25 v3 3/3] audit: add subj creds to NETFILTER_CFG
 record to cover async unregister
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, twoerner@redhat.com,
        Eric Paris <eparis@parisplace.org>, fw@strlen.de,
        ebiederm@xmission.com, tgraf@infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 18, 2020 at 9:12 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-03-17 17:30, Richard Guy Briggs wrote:
> > Some table unregister actions seem to be initiated by the kernel to
> > garbage collect unused tables that are not initiated by any userspace
> > actions.  It was found to be necessary to add the subject credentials to
> > cover this case to reveal the source of these actions.  A sample record:
> >
> >   type=NETFILTER_CFG msg=audit(2020-03-11 21:25:21.491:269) : table=nat family=bridge entries=0 op=unregister pid=153 uid=root auid=unset tty=(none) ses=unset subj=system_u:system_r:kernel_t:s0 comm=kworker/u4:2 exe=(null)
>
> Given the precedent set by bpf unload, I'd really rather drop this patch
> that adds subject credentials.
>
> Similarly with ghak25's subject credentials, but they were already
> present and that would change an existing record format, so it isn't
> quite as justifiable in that case.

Your comments have me confused - do you want this patch (v3 3/3)
considered for merging or no?

-- 
paul moore
www.paul-moore.com
