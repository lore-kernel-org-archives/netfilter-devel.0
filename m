Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE189C001B0
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Jul 2023 19:07:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjGATHg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Jul 2023 15:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjGATHf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Jul 2023 15:07:35 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786CF1710;
        Sat,  1 Jul 2023 12:07:34 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-98de21518fbso341018866b.0;
        Sat, 01 Jul 2023 12:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688238453; x=1690830453;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bX/i0mHNTV00ab1SFTJ1jI7uVLuMRqDQB1VZHYQEjNs=;
        b=PdTEY2J0Zvl+CBJDdJ6OS+HpggZcJ7yA/F+XAJJejPGqecYp7tzOo9kmzcARlA8jPd
         7omvd4byZPccp3t57CCGyXNHlVfhoTNgeAUJCfDtzz41baX+aGTZDsHch/mybqQLhps4
         61FGnbGZp66S/6U6CHwI1/ZGCzs3+MxYoZQ6MdFgjI7V2a5fxthMVMPM9VlnT794V7U9
         piANfdilrBO7ENcgzVHWeuRe5jr6YB7LupHEnVBQb7vuVqUx6yEZpicNLojNyx4YrzU0
         9ZxYbi+dInMu7Ru1Mz6uM4gyZkqZX+SMYZke3bzSnktBXcAB8nitlhw3kTq+nlcw0XHE
         aktg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688238453; x=1690830453;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bX/i0mHNTV00ab1SFTJ1jI7uVLuMRqDQB1VZHYQEjNs=;
        b=Fpj+4E6qirNmLquh4oSzEbiVymCxpyUHYa9muB96dhCgeeFIcyQUVG7ca2DW8bXDEn
         zxmNQa/UerbmqVhRWiRcGSN6GYevkPGE5wk7UV/fJ4FDaVihmGvue8sg5NeSwbvGwtDb
         3Pf5qpuTq9VFIMbUHag7BJ25HsTZcl4kqrQwIMM4aKUd++KvoZe0uY6W88PudZVhparS
         lxs93AGagvWT6mfoPU0S+547Cx6rnTjnbfrDT1fw5y4uPSlfASng/XqZBWCRpuefrDeC
         kMHhlhWSJ3x31gh2ZldxRpKdyn7Vm9sXMKqauPgBdmGSdtd3WTy5oIYU+yi9TauQ5tOt
         JDNA==
X-Gm-Message-State: ABy/qLZoW71JKr0UankgVGstqvDuoywkKJquewisYZB4qwUDlwJaOZHr
        oEUDjZKDCbmanwpuL7gdmwk=
X-Google-Smtp-Source: ACHHUZ6omcfkIxZRLXA2gpUB1C+HvSks0LRIXKnKVI9EGAJVEnWPw/RS7n3FbP7gxEHFc0V/dBN6DQ==
X-Received: by 2002:a17:906:bcc1:b0:98e:1deb:caf8 with SMTP id lw1-20020a170906bcc100b0098e1debcaf8mr3990662ejb.57.1688238452588;
        Sat, 01 Jul 2023 12:07:32 -0700 (PDT)
Received: from localhost ([2a02:168:633b:1:9d6a:15a4:c7d1:a0f0])
        by smtp.gmail.com with ESMTPSA id k25-20020a17090666d900b009737b8d47b6sm9562030ejp.203.2023.07.01.12.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Jul 2023 12:07:32 -0700 (PDT)
Date:   Sat, 1 Jul 2023 21:07:12 +0200
From:   =?iso-8859-1?Q?G=FCnther?= Noack <gnoack3000@gmail.com>
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     mic@digikod.net, willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
Subject: Re: [PATCH v11 10/12] selftests/landlock: Add 11 new test suites
 dedicated to network
Message-ID: <20230701.acb4d98c59a0@gnoack.org>
References: <20230515161339.631577-1-konstantin.meskhidze@huawei.com>
 <20230515161339.631577-11-konstantin.meskhidze@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230515161339.631577-11-konstantin.meskhidze@huawei.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi!

On Tue, May 16, 2023 at 12:13:37AM +0800, Konstantin Meskhidze wrote:
> +TEST_F(inet, bind)

If you are using TEST_F() and you are enforcing a Landlock ruleset
within that test, doesn't that mean that the same Landlock ruleset is
now also enabled on other tests that get run after that test?

Most of the other Landlock selftests use TEST_F_FORK() for that
reason, so that the Landlock enforcement stays local to the specific
test, and does not accidentally influence the observed behaviour in
other tests.

The same question applies to other test functions in this file as
well.

–Günther
