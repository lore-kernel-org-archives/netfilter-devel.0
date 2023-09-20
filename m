Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B03EACE79CD
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 11:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234271AbjITLUw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 07:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234342AbjITLUv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 07:20:51 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB05BB4;
        Wed, 20 Sep 2023 04:20:44 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id F076A593D1974; Wed, 20 Sep 2023 13:20:42 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id EE79D61FD76AC;
        Wed, 20 Sep 2023 13:20:42 +0200 (CEST)
Date:   Wed, 20 Sep 2023 13:20:42 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
cc:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [ANNOUNCE] ipset 7.18 released
In-Reply-To: <55c2bf9d-ec58-8db-e457-8a36ebbbc4c0@blackhole.kfki.hu>
Message-ID: <382279q3-6on5-32rq-po59-6r18os6934n9@vanv.qr>
References: <55c2bf9d-ec58-8db-e457-8a36ebbbc4c0@blackhole.kfki.hu>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Tuesday 2023-09-19 20:26, Jozsef Kadlecsik wrote:
>
>I'm happy to announce ipset 7.18, which brings a few fixes, backports, 
>tests suite fixes and json output support.

The installation of the pkgconfig file is now broken.

>  - lib/Makefile.am: fix pkgconfig dir (Sam James)

Aaaaagh.. that change completely broke installation and must be reverted.

[   44s] RPM build errors:
[   44s]     Installed (but unpackaged) file(s) found:
[   44s]    /usr/usr/lib64/pkgconfig/libipset.pc
