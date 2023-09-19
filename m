Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE821CE79A8
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Sep 2023 20:50:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjISUuM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Sep 2023 16:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbjISUuL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Sep 2023 16:50:11 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB064B3
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Sep 2023 13:50:05 -0700 (PDT)
Received: from [78.30.34.192] (port=56412 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qihfW-00034x-4h; Tue, 19 Sep 2023 22:50:04 +0200
Date:   Tue, 19 Sep 2023 22:50:01 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Kyle Zeng <zengyhkyle@gmail.com>
Subject: Re: [PATCH 0/1] ipset patch for nf tree
Message-ID: <ZQoJeRxjUiuqiev8@calendula>
References: <20230919180445.3384561-1-kadlec@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230919180445.3384561-1-kadlec@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jozsef,

On Tue, Sep 19, 2023 at 08:04:44PM +0200, Jozsef Kadlecsik wrote:
> Hi Pablo,
> 
> Please apply the next patch against your nf tree so that it'll get 
> applied to older stable branches too.
> 
> - Kyle Zeng reported that there is a race between IPSET_CMD_ADD and IPSET_CMD_SWAP:
>   when the schedule point was added to call_ad(), the wrong reference counter was
>   used. For long taking operations initiated from userspace the ref_netlink reference
>   counter must be used to exclude concurrent clashing operations.

Thanks.

Florian is taking care of this round of nf.git fixes, he will be
collecting this by tomorrow.
