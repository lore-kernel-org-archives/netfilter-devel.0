Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63F1EC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Sep 2021 09:03:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C31761029
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Sep 2021 09:03:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbhINJEj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 05:04:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32022 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231520AbhINJEh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 05:04:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631610200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SXrOB3fWbDIwSUd1UMMpbZ0OteuP2ukesRsDS96TS/E=;
        b=SwQrQ/PN15NM0Qx/4qD7zSs+kqZctvyjpGEQvwNbATAVUoORftw3aJuPhBxRfiwpCGxWTO
        KgR7WmkiiG/iR2FyFr/7djnoOymNXbOsDMgo08TkDs/cxnRZOSuawKhdeKqaLTp2Hl76Kh
        9FuBBXvCtXxuS8e2CH1Os7SPTI2bOCg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-JgmawhOoMOi016U7kQEw_w-1; Tue, 14 Sep 2021 05:03:19 -0400
X-MC-Unique: JgmawhOoMOi016U7kQEw_w-1
Received: by mail-wm1-f69.google.com with SMTP id u14-20020a7bcb0e0000b0290248831d46e4so460454wmj.6
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Sep 2021 02:03:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :user-agent:date:message-id:mime-version:content-transfer-encoding;
        bh=SXrOB3fWbDIwSUd1UMMpbZ0OteuP2ukesRsDS96TS/E=;
        b=KxXmgnb8s0EpHcZpgXQclUQ/7bw41Bu16FQJFSWAwLmgJiFhnOXYWOXr6xHzM0TOOG
         HRhuUydDocbnloag9F8crU0/eqZdi0VKJN8F8cBUwDZ2lZIdRBS4YkqMBzgJceUUqH7m
         EcNa3M/dBouAygFkXVxKn8xf5bBmxXH2ndp9pmurN3Dx1eNhNhpYH9lihwrAacJdSG9V
         C/6R+ftmtjeETa2b42ahbHB9pTgkLyMioTiDTiZSukxLTNqL1L86UINxu/hdBvDXdHrK
         gsfOpj6HVzUys8Vl/ZbyZD94uyBklSkotepnvP2tcfY1OJQdJ5f0JTA9N6h+7VKLyPca
         0AAA==
X-Gm-Message-State: AOAM530G6LrfIml5aEVpQ9AZ1OmTN0KFzA3CI4Sq3Ba51Z4rkJm6OdEV
        534BcySLTcXoIBFGYgklC9JF+L+2iq6YPttAEiICLN/iaSUAYrFa0s7bVo+HAfAa2POeDy5efOh
        tKp2As2T4zknnBDNeu5G6kFJNEtph
X-Received: by 2002:adf:e810:: with SMTP id o16mr13255814wrm.219.1631610198172;
        Tue, 14 Sep 2021 02:03:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyjKjK7FDF6dkVdxeyQKikd7Aclj8ysaKfVnXqxQICp8+f21LPf1G/XsP6XfOI6NuM5JNabjw==
X-Received: by 2002:adf:e810:: with SMTP id o16mr13255792wrm.219.1631610197936;
        Tue, 14 Sep 2021 02:03:17 -0700 (PDT)
Received: from localhost ([185.112.167.47])
        by smtp.gmail.com with ESMTPSA id l2sm1268837wmi.1.2021.09.14.02.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 02:03:17 -0700 (PDT)
From:   =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] iptables-test.py: print with color escapes
 only when stdout isatty
In-Reply-To: <20210913150533.GA22465@orbyte.nwl.cc>
References: <20210902113307.2368834-1-snemec@redhat.com>
 <20210903125250.GK7616@orbyte.nwl.cc>
 <20210903164441+0200.281220-snemec@redhat.com>
 <20210903153420.GM7616@orbyte.nwl.cc>
 <20210906110438+0200.839986-snemec@redhat.com>
 <20210913150533.GA22465@orbyte.nwl.cc>
User-Agent: Notmuch/0.32.3 (https://notmuchmail.org) Emacs/28.0.50
 (x86_64-pc-linux-gnu)
Date:   Tue, 14 Sep 2021 11:03:42 +0200
Message-ID: <20210914110342+0200.713702-snemec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 13 Sep 2021 17:05:33 +0200
Phil Sutter wrote:

> Applied, thanks!

Thank you.

I see that you've pushed your series including the change to print error
messages to stdout [1] in the meantime.

I don't have a strong opinion on whether output of a script whose
(only?) purpose is to print diagnostic messages should go to stdout or
stderr, but I do think that having the "ERROR"s go to stderr and "OK"s
go to stdout is more confusing than useful: was that really intentional?

As a side effect of that change, my patch will act funny depending on
which output stream is being redirected, too.

(I'm sorry I haven't pointed this out earlier; I just skimmed your
patches and didn't notice this until double checking the conflict/merge
with my patch now.)

--=20
=C5=A0t=C4=9Bp=C3=A1n

[1]
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210906163038.1=
5381-4-phil@nwl.cc/

