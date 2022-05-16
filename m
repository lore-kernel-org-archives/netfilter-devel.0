Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A94F7C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 May 2022 10:29:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbiEPK3H (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 May 2022 06:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242864AbiEPK2n (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 May 2022 06:28:43 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D90713F69
        for <netfilter-devel@vger.kernel.org>; Mon, 16 May 2022 03:28:36 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 4342058FAB475; Mon, 16 May 2022 12:28:34 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 4121E6164E07B;
        Mon, 16 May 2022 12:28:34 +0200 (CEST)
Date:   Mon, 16 May 2022 12:28:34 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Nick Hainke <vincent@systemli.org>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] treewide: use uint* instead of u_int*
In-Reply-To: <20220516064754.204416-1-vincent@systemli.org>
Message-ID: <9n33705n-4s4r-q4s1-q97-76n73p18s99r@vanv.qr>
References: <Yn/iZyTrZvj++6ZA@orbyte.nwl.cc> <20220516064754.204416-1-vincent@systemli.org>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Monday 2022-05-16 08:47, vincent@systemli.org wrote:

>From: Nick Hainke <vincent@systemli.org>
>
>Gcc complains about missing types. Two commits introduced u_int* instead
>of uint*. Use uint treewide.

I approve of this.

There are, however, a few more instances of u_int* in the source tree, they
could be fixed up in the same go.
> extensions/libxt_conntrack.c | 2 +-
> iptables/xshared.c           | 2 +-
> iptables/xshared.h           | 2 +-
> 3 files changed, 3 insertions(+), 3 deletions(-)

