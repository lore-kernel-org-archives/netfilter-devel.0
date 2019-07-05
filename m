Return-Path: <SRS0=b56t=VC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1299C5B57D
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 07:04:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF82721670
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 07:04:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfGEHEm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Jul 2019 03:04:42 -0400
Received: from a3.inai.de ([88.198.85.195]:59286 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725827AbfGEHEm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 03:04:42 -0400
Received: by a3.inai.de (Postfix, from userid 25121)
        id 357C4765DC5; Fri,  5 Jul 2019 09:04:40 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 2359D3BB696A;
        Fri,  5 Jul 2019 09:04:40 +0200 (CEST)
Date:   Fri, 5 Jul 2019 09:04:40 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Baruch Siach <baruch@tkos.co.il>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH libnftnl] Add Libs.private field to libnftnl.pc
In-Reply-To: <b121a93e89d0b9478d4e57430e98c04d490d5af2.1562297544.git.baruch@tkos.co.il>
Message-ID: <nycvar.YFH.7.76.1907050904180.25743@n3.vanv.qr>
References: <b121a93e89d0b9478d4e57430e98c04d490d5af2.1562297544.git.baruch@tkos.co.il>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Friday 2019-07-05 05:32, Baruch Siach wrote:

>diff --git a/libnftnl.pc.in b/libnftnl.pc.in
>index fd5cc6ac5ca4..7fef9215c888 100644
>--- a/libnftnl.pc.in
>+++ b/libnftnl.pc.in
>@@ -12,4 +12,5 @@ Version: @VERSION@
> Requires:
> Conflicts:
> Libs: -L${libdir} -lnftnl
>+Libs.private: @LIBMNL_LIBS@
> Cflags: -I${includedir}

This is incorrect. What should be used is

Requires.private: libmnl.
