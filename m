Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 167C5C001B3
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Jul 2023 09:36:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjGCJg4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Jul 2023 05:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbjGCJgy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Jul 2023 05:36:54 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F0FCD
        for <netfilter-devel@vger.kernel.org>; Mon,  3 Jul 2023 02:36:52 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-56942442eb0so49525577b3.1
        for <netfilter-devel@vger.kernel.org>; Mon, 03 Jul 2023 02:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688377011; x=1690969011;
        h=content-transfer-encoding:cc:to:from:subject:references
         :mime-version:message-id:in-reply-to:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F0eZiFXW9Ju4K3xie6ZNb6cOckxZbLpuUBrtke5dHQM=;
        b=oU/VLi2mewFAa38gcuCP9A6LzivNVNDH6YOFHLmcsvqB3MbO+n3EFO26iOpboHEnfv
         goOkSsUHMhGGkO6C6Qt7naxU0qQo4Je2DcOtHQgdsUVu9Q3oSkuymfyTvLcJDThjjhBi
         gYfH6R7FK0uHgIWZbjgKIsyz2cBLmIbOlBaHzQmlWLxg1xzIhTXgMSwW8spVqAQShbMo
         hPW7M8NR9T3q84plJUu0ceDjyxX1v4GulxTLUbOn2ljDv4Y+oIqKLw14NA2U2EdO2B2c
         SVAod3k5F/sHhR7HhBYyfhG9B0IeyaZKf+zoIzYI4jaFffzEJJabO6m8ZlE4znWyRTeD
         ADkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688377011; x=1690969011;
        h=content-transfer-encoding:cc:to:from:subject:references
         :mime-version:message-id:in-reply-to:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=F0eZiFXW9Ju4K3xie6ZNb6cOckxZbLpuUBrtke5dHQM=;
        b=izBXA3bweMT7HdWXeaolPfmC00WUFzC0PTrOEVyyQHY8lOSh3EqI9IDElhZlHLNXq5
         L6JKoNxKhDpgfCLnhvRN4OluUCUWBx5up8nfcXT6hr4+QCABEfyRIc54xoK11n2u8PEA
         qHY+yFC7JFwwPUMImPKrdJ7UkUSqkYj8HjNZmEkPNxABkzflmWdSdDc9r7R+ItfQepPN
         tyUUpWSB2OsbMP+gtePs03aifBw2jpUrwZwT4IrnPBE+030M6ogHxnOmqyOCUKx3IAWP
         ApcwfoFTLpPjXzEqXoi6uPGJ4Oh9ovWJ4LkRRuldTjkHlFLzHaGOgfAc2AdzVb0XZg6M
         kIvw==
X-Gm-Message-State: ABy/qLattZm0BsqsG0iXKvjr+/rs9LLllH5HgAIEQ9bbKd12j4OmwJTC
        l5h/QhPKsUnYYM15/WVyhvijHLvfN/w=
X-Google-Smtp-Source: APBJJlF3XLqBeCJ5bRpU5duO0tUjw5cT8D4q0XoqKg5aXVoxD4B+UKNJx4piXDt7kM3ItR+2EAPuk9Huq4M=
X-Received: from sport.zrh.corp.google.com ([2a00:79e0:9d:4:7808:ed7:57d0:c891])
 (user=gnoack job=sendgmr) by 2002:a81:b283:0:b0:577:3b0c:5b85 with SMTP id
 q125-20020a81b283000000b005773b0c5b85mr65333ywh.0.1688377011727; Mon, 03 Jul
 2023 02:36:51 -0700 (PDT)
Date:   Mon, 3 Jul 2023 11:36:48 +0200
In-Reply-To: <338bba9d-6afa-7c6b-2843-b116abb36859@huawei.com>
Message-Id: <ZKKWoS+clQGLF4O4@google.com>
Mime-Version: 1.0
References: <20230515161339.631577-1-konstantin.meskhidze@huawei.com>
 <20230515161339.631577-11-konstantin.meskhidze@huawei.com>
 <20230701.acb4d98c59a0@gnoack.org> <4a733dbd-f6e2-dc69-6c8d-47c362644462@digikod.net>
 <338bba9d-6afa-7c6b-2843-b116abb36859@huawei.com>
Subject: Re: [PATCH v11 10/12] selftests/landlock: Add 11 new test suites
 dedicated to network
From:   "=?iso-8859-1?Q?G=FCnther?= Noack" <gnoack@google.com>
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     "=?iso-8859-1?Q?Micka=EBl_Sala=FCn?=" <mic@digikod.net>,
        "=?iso-8859-1?Q?G=FCnther?= Noack" <gnoack3000@gmail.com>,
        willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 03, 2023 at 11:37:13AM +0300, Konstantin Meskhidze (A) wrote:
> 7/2/2023 11:45 AM, Micka=C3=ABl Sala=C3=BCn =D0=BF=D0=B8=D1=88=D0=B5=D1=
=82:
> > Initially Konstantin wrote tests with TEST_F_FORK() but I asked him to
> > only use TEST_F() because TEST_F_FORK() is only useful when a
> > FIXTURE_TEARDOWN() needs access rights that were dropped with a
> > TEST_F(), e.g. to unmount mount points set up with a FIXTURE_SETUP()
> > while Landlock restricted a test process.
> >=20
> > Indeed, TEST_F() already fork() to make sure there is no side effect
> > with tests.
> >=20
>=20
>  Hi, G=C3=BCnther
>  Yep. Micka=D1=91l asked me to replace TEST_F_FORK() with TEST_F(). Pleas=
e check
> this thread
>=20
> https://lore.kernel.org/netdev/33c1f049-12e4-f06d-54c9-b54eec779e6f@digik=
od.net/
> T

Ah thanks, this makes a lot of sense!
I had not realized that TEST_F would also fork a child process,
I should have double checked the selftest implementation.

=E2=80=94G=C3=BCnther

--=20
Sent using Mutt =F0=9F=90=95 Woof Woof
