Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C6BEEE4996
	for <netfilter-devel@archiver.kernel.org>; Sun, 20 Aug 2023 21:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbjHTVem (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 20 Aug 2023 17:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbjHTVem (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 20 Aug 2023 17:34:42 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1280CA4
        for <netfilter-devel@vger.kernel.org>; Sun, 20 Aug 2023 14:34:39 -0700 (PDT)
Received: from [78.30.34.192] (port=54124 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qXq4B-00Azdq-6K
        for netfilter-devel@vger.kernel.org; Sun, 20 Aug 2023 23:34:38 +0200
Date:   Sun, 20 Aug 2023 23:34:34 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: libnetfilter_queue patch ping
Message-ID: <ZOKG6nnqEY9v6ctp@calendula>
References: <ZOAvByRubG+0lVHX@slk15.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZOAvByRubG+0lVHX@slk15.local.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Aug 19, 2023 at 12:55:03PM +1000, Duncan Roe wrote:
> There is a libnetfilter_queue patch of mine from the March 2022 that is still
> under review in Patchwork:
> 
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20220328024821.9927-1-duncan_roe@optusnet.com.au/
> 
> I tested recently with 63KB packets: overall CPU decrease 20%, user CPU decrease
> 50%.

I just took the bare minimum of this patch to provide more control on
memory management as you request, it is here:

http://git.netfilter.org/libnetfilter_queue/commit/?id=91d2c947b473b3540be5474c7128a5fa4ce60934

I have removed the extra callback wrapper which does not provide much
but an extra layer to the user.

> This patch could open an avenue to having libnetfilter_queue handle tunneling.
> E.g. for tcp over udp, you could have 2 pktbuff structs (because the data area
> can be anywhere, rather than residing after the pktbuff head).

Please, do not pursue this approach, this pkt_buff structure is
mocking the sk_buff API in the kernel in a very simplistic way. You
can still implement such tunnel handling in your application.

Thanks.
