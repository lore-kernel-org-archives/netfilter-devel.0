Return-Path: <SRS0=LKNA=RU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF137C43381
	for <netfilter-devel@archiver.kernel.org>; Sun, 17 Mar 2019 17:56:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB41320857
	for <netfilter-devel@archiver.kernel.org>; Sun, 17 Mar 2019 17:56:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbfCQR45 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 17 Mar 2019 13:56:57 -0400
Received: from a3.inai.de ([88.198.85.195]:60174 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726349AbfCQR45 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 17 Mar 2019 13:56:57 -0400
Received: by a3.inai.de (Postfix, from userid 25121)
        id D81083BAB009; Sun, 17 Mar 2019 18:56:55 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id D153F3BB4347;
        Sun, 17 Mar 2019 18:56:55 +0100 (CET)
Date:   Sun, 17 Mar 2019 18:56:55 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Luis Ressel <aranea@aixah.de>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] configure.ac: Clean up AC_ARG_{WITH,ENABLE}
 invocations
In-Reply-To: <20190317171912.14194-2-aranea@aixah.de>
Message-ID: <nycvar.YFH.7.76.1903171856180.12959@n3.vanv.qr>
References: <20190317171912.14194-1-aranea@aixah.de> <20190317171912.14194-2-aranea@aixah.de>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Sunday 2019-03-17 18:19, Luis Ressel wrote:
> ])
>-AC_SUBST(with_libxtables)
>-AM_CONDITIONAL([BUILD_XTABLES], [test "x$with_libxtables" == xyes])
>+AM_CONDITIONAL([BUILD_XTABLES], [test "x$with_xtables" == xyes])

Not sure when this was introduced, by it needs to be a single = after all.
