Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 649CAEB64DC
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Jun 2023 12:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjFUMmC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Jun 2023 08:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbjFUMmB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Jun 2023 08:42:01 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B6C184
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Jun 2023 05:41:59 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id 5614622812f47-39fc0e3f0f2so1845323b6e.1
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Jun 2023 05:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1687351319; x=1689943319;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gEnN1eHhs1tN7/Y7t6he6p9VJhq0VBCBjTgHlWlf5vI=;
        b=HZWfECMgE6MPIaSwTX+cstHxlqQcjci/Cx/EUw7h7RJ21GngIXSeLbaxr1PzBgj/OV
         xGpGnb2+A6VkoT7tktNpSs1a5xqAxWu51LRmuYqq851vfPliIPKJArYjU8jh+MEv/nKQ
         1OMcvACGuNQWIWCp3vi0JOtGzQ5TjxoB9VgXU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687351319; x=1689943319;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gEnN1eHhs1tN7/Y7t6he6p9VJhq0VBCBjTgHlWlf5vI=;
        b=IiKxQgcMzQoBNBtzviouzDZXQXpeojfpLPmMgtIi95Y96Gwq+RDfaWqTJY5wA+YytW
         tvQVMEkOlLzg4hZLQY4v1iL1e7WTeQQuS2BY2+/cbkdsSlaIUVY2VcI5CAWyha9IxL21
         4+xn3dnqGvLA+HELalQ7ID7zCYOOVlK5cgC78xF8i3Q7TgKCj3qaxks35U0+KhRpiWL5
         Zq+oN5pEkvP2icFutVsGh1dXGdWRPsblk5Se0WnVulF1+czSY7BcrtQFocLpNfEedV2N
         0wDbK1JgIoT5Tg2RAH7kVELfdV4p2+UYkAS0rHL/hHWJHV/Ywrivx5vPixhVuTW17DaB
         8NOQ==
X-Gm-Message-State: AC+VfDyaMlz+i1IrF1Y8tyy28/mPN+R38mFXoP3EQ6H5BajKrUAhBWIZ
        0cVO7n6oN5jTVQJG1MMWDg1PKOSSpAJ6U2Bzsuje7w==
X-Google-Smtp-Source: ACHHUZ7Lgbb/KL+C7uMlNHS0la3DKKGcJ/COXaSKZuAoRMdzSFtGhs5NNtbL0yuxXHyxxaWj05O6ICB82oBeoWWr5d4=
X-Received: by 2002:a05:6808:120a:b0:39e:b985:b47e with SMTP id
 a10-20020a056808120a00b0039eb985b47emr15650678oil.36.1687351319039; Wed, 21
 Jun 2023 05:41:59 -0700 (PDT)
MIME-Version: 1.0
References: <20230615152918.3484699-1-revest@chromium.org> <ZJFIy+oJS+vTGJer@calendula>
 <CABRcYmJjv-JoadtzZwU5A+SZwbmbgnzWb27UNZ-UC+9r+JnVxg@mail.gmail.com> <ZJLbDiwsQnQkkZvy@calendula>
In-Reply-To: <ZJLbDiwsQnQkkZvy@calendula>
From:   Florent Revest <revest@chromium.org>
Date:   Wed, 21 Jun 2023 14:41:47 +0200
Message-ID: <CABRcYmLgOn9=nNA151ibvRFeAGCzORAymmGsppjRPo9jPrF1ag@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: conntrack: Avoid nf_ct_helper_hash uses
 after free
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lirongqing@baidu.com, wangli39@baidu.com,
        zhangyu31@baidu.com, daniel@iogearbox.net, ast@kernel.org,
        kpsingh@kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 21, 2023 at 1:12=E2=80=AFPM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
>
> On Wed, Jun 21, 2023 at 12:20:44PM +0200, Florent Revest wrote:
> > On Tue, Jun 20, 2023 at 8:35=E2=80=AFAM Pablo Neira Ayuso <pablo@netfil=
ter.org> wrote:
> > > nf_conntrack_ftp depends on nf_conntrack.
> > >
> > > If nf_conntrack fails to load, how can nf_conntrack_ftp be loaded?
> >
> > Is this maybe only true of dynamically loaded kmods ? With
> > CONFIG_NF_CONNTRACK_FTP=3Dy, it seems to me that nf_conntrack_ftp_init(=
)
> > will be called as an __init function, independently of whether
> > nf_conntrack_init_start() succeeded or not. Am I missing something ?
>
> No idea, nf_conntrack init path invokes nf_conntrack_helper_init()
> which initializes the helper hashtable.

Yes

> How is it that you can nf_conntrack_helpers_register() call before the
> initialization path of nf_conntrack is run, that I don't know.

No, this is not what happens. I tried to describe the problem in the
following paragraph (I'm open to suggestions on how to explain this
better!)

> > > On Thu, Jun 15, 2023 at 05:29:18PM +0200, Florent Revest wrote:
> > > > If register_nf_conntrack_bpf() fails (for example, if the .BTF sect=
ion
> > > > contains an invalid entry), nf_conntrack_init_start() calls
> > > > nf_conntrack_helper_fini() as part of its cleanup path and
> > > > nf_ct_helper_hash gets freed.

Said differently (chronologically, I hope that helps)

First, nf_conntrack_init_start() runs:
- it calls nf_conntrack_helper_init() (this succeeds and initializes
the hashmap)
- it calls register_nf_conntrack_bpf() (this fails)
- goto err_kfunc
- it calls nf_conntrack_helper_fini() (this frees the hashmap and
leaves a dangling nf_ct_helper_hash pointer)
- it returns back an error such that nf_conntrack_standalone_init() fails

At this point, the builtin nf_conntrack module failed to load.

But now, nf_conntrack_ftp_init() also runs:
- it calls nf_conntrack_helpers_register()
  - this calls nf_conntrack_helper_register()
    - this accesses the hashmap pointer even though the hashmap has
been freed already. That's where the use-after-free is.

I proposed we fix this by not accessing a freed hashmap (using NULL as
a clear indication that this is now an invalid pointer) but I suppose
there are other ways one could go about it such as checking if
nf_conntrack initialized successfully early in nf_conntrack_ftp_init()
etc... I'm open to suggestions.
