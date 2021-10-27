Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8C33C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Oct 2021 09:50:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F3E56103C
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Oct 2021 09:50:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236898AbhJ0Jw6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Oct 2021 05:52:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47588 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238828AbhJ0Jw6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Oct 2021 05:52:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635328232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qp5d1y0k3WLVfPE9w4Nb6J20o+9q7rP88yyRbCbHeOg=;
        b=awrgXyxJNaPK1BBOoexjpdsYWt2tChXd7xDRRL2JSR5uykczZLD1BNhIToz7VAyIU9U5Bu
        A+5S0cw2LYlDDbvpGwzbB0hx9whMdK0Iy2Pm3nC4sfex1BQIT4r2hS7kybCFGMXvs1alcb
        wUyn88DciMCzUFBPasmUrdMXxJbRMxY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-574-CGxpNUVyM02UsEKUyTLLXg-1; Wed, 27 Oct 2021 05:50:31 -0400
X-MC-Unique: CGxpNUVyM02UsEKUyTLLXg-1
Received: by mail-ed1-f69.google.com with SMTP id h16-20020a05640250d000b003dd8167857aso1853077edb.0
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Oct 2021 02:50:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :user-agent:date:message-id:mime-version:content-transfer-encoding;
        bh=qp5d1y0k3WLVfPE9w4Nb6J20o+9q7rP88yyRbCbHeOg=;
        b=Nxc4KQSbsjdX8FUA8D6voStgY0cOQ7XZ9SpUiMtHh/LFGuSoQSvrweAjhICDSCPHoe
         /qL3bmcmBxoV9nudz9eOFnF25O8AHDLrSrk6YXoXgDkftQtXcK7NDKxnTFqpQIeFvdmD
         EzSXGxE0TXrrkXREws8wq2AyYqwppMQguhjWx9zcbHfXMWOFjf39CL4Ve/lxW1EPUJQb
         z3THyZQiQJ+jFKCJwCwZVWnWgmyAPFUMR8ibyPVbrAA7QHeckQC8pEht24K12IpUCl1c
         tfJOhSkRoGxMVsw6KtEozCMU+iSvwQpg+pmjud7kdssZiVqvirx1u6IiUMAGRLp8RF+S
         6D7Q==
X-Gm-Message-State: AOAM531zO/sYtKzARtW6TSinCucdz7ic1+lQVwrTELm0axtQH/oBdDZx
        uMA7nNfeADppXDdciUhlxUZcZRpGxE/Wy00lHj7AMBs9MVXa70Q5B5LINx936biPw1xgEiAxA4o
        8JCp1yYZba6Wk/W93o1ERRcXChThA
X-Received: by 2002:a17:906:2505:: with SMTP id i5mr37030571ejb.450.1635328229940;
        Wed, 27 Oct 2021 02:50:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy6Yd6Uu0pcc+dBT+/jIpSdJ3cQQDM/GA6q9OTvEWEqd8jY3CJ4DWPdMUdjegrPJ+xR1mreUw==
X-Received: by 2002:a17:906:2505:: with SMTP id i5mr37030542ejb.450.1635328229676;
        Wed, 27 Oct 2021 02:50:29 -0700 (PDT)
Received: from localhost ([185.112.167.53])
        by smtp.gmail.com with ESMTPSA id a12sm5449241ejx.24.2021.10.27.02.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 02:50:29 -0700 (PDT)
From:   =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/3] tests: shell: README: copy edit
In-Reply-To: <YXkWeFPM3ixQ2cTb@salvia>
References: <20211020124512.490288-1-snemec@redhat.com>
 <20211020150402.GJ1668@orbyte.nwl.cc>
 <20211021103025+0200.945334-snemec@redhat.com>
 <20211021102644.GM1668@orbyte.nwl.cc>
 <20211021130323+0200.342006-snemec@redhat.com> <YXkWeFPM3ixQ2cTb@salvia>
User-Agent: Notmuch/0.33.2 (https://notmuchmail.org) Emacs/29.0.50
 (x86_64-pc-linux-gnu)
Date:   Wed, 27 Oct 2021 11:51:12 +0200
Message-ID: <20211027115112+0200.686229-snemec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 27 Oct 2021 11:06:00 +0200
Pablo Neira Ayuso wrote:

> I also prefer if there is oneline description in the patch. My
> suggestions:
>
> * patch 1/3, not clear to me what "copy edit" means either.

Description proposal:

  Grammar, wording, formatting fixes (no substantial change of meaning).

> * patch 2/3, what is the intention there? a path to the nft executable
>   is most generic way to refer how you use $NFT, right?

No, not since 7c8a44b25c22. I've always thought that 'Fixes:' is mostly
or at least also meant for humans, i.e., that the person reading the
commit message and wanting to better understand the change would look at
the referenced commit, but if that is a wrong assumption to make, I
propose to add the following description:

  Since commit 7c8a44b25c22, $NFT can contain an arbitrary command, e.g.
  'valgrind nft'.

> * patch 3/3, I'd add a terse sentence so I do not need to scroll down
>   and read the update to README to understand what this patch updates.
>   I'd suggest: "Test files are located with find, so they can be placed
>   in any location."

That text was just split to a separate paragraph, it has nothing to do
with the actual change.

> Regarding reference to 4d26b6dd3c4c, not sure it is worth to add this
> to the README file. The test infrastructure is only used for internal
> development use, this is included in tarballs but distributors do not
> package this.

IMO this argument should speak _for_ including the commit reference
rather than omitting it, as the developer is more likely to be
interested in the commit than the consumer.

I thought about making the wording simply describe the current state
without any historical explanations, but saying "Test files are
executable files matching the pattern <<name_N>>, where N doesn't mean
anything." seemed weird.

Please advise.

--=20
=C5=A0t=C4=9Bp=C3=A1n

