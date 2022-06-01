Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93B7DC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Jun 2022 17:05:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344702AbiFARFe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Jun 2022 13:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354482AbiFARFd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Jun 2022 13:05:33 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5D5A0D17
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2022 10:05:31 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 579935872CA7E; Wed,  1 Jun 2022 19:05:28 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 5523860070EA5;
        Wed,  1 Jun 2022 19:05:28 +0200 (CEST)
Date:   Wed, 1 Jun 2022 19:05:28 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Nick <vincent@systemli.org>
cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] Revert "Simplify static build extension loading"
In-Reply-To: <1678505c-aa11-6fcf-87b4-eeaa0113af62@systemli.org>
Message-ID: <o9845rrn-onrq-23r-3638-24r6no4s1so9@vanv.qr>
References: <20220601134743.14415-1-vincent@systemli.org> <YpdvYPV5L7Mxs3VQ@orbyte.nwl.cc> <1678505c-aa11-6fcf-87b4-eeaa0113af62@systemli.org>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wednesday 2022-06-01 16:22, Nick wrote:

> More Information:
> https://github.com/openwrt/openwrt/pull/9886#issuecomment-1143191713


iptables offers three configurations off the bat:

 - default: extensions are shipped as 124 plugin files

 - ALL_INCLUSIVE: 0 plugin files (instead, code is built into xtables proper);
optional extra .so files (e.g. from xt-addons) can still be loaded from the fs.

 - NO_SHARED_LIBS: as above but dlopen is completely disabled


openwrt patches iptables to the point that all shipped extensions are grouped
into *five* .so files. It's a custom modification, and not upstream,
so if it breaks, one gets to keep the pieces.

I do not really see the point of that patch. There was something about tiny
libcs missing (being compiled without) IPv6 functions maybe 15 years ago. But
neither libxt_*.c nor libip6t_*.c were really vetted for missing C library
functions. Quite frankly, we could just name all plugins in iptables
libxt_*.c and almost nothing would change.
