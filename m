Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41715C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Nov 2023 10:16:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjKFKQx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Nov 2023 05:16:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbjKFKQw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Nov 2023 05:16:52 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A0CDB
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Nov 2023 02:16:49 -0800 (PST)
Received: from [78.30.35.151] (port=55868 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qzwey-00ERnW-HM
        for netfilter-devel@vger.kernel.org; Mon, 06 Nov 2023 11:16:46 +0100
Date:   Mon, 6 Nov 2023 11:16:43 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v3] netfilter: nf_tables: remove catchall element in
 GC sync path
Message-ID: <ZUi9C6oJlsKSPaks@calendula>
References: <20231106101345.11694-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231106101345.11694-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Nov 06, 2023 at 11:13:45AM +0100, Pablo Neira Ayuso wrote:
> The expired catchall element is not removed from GC sync path. This path
> holds mutex so just call nft_setelem_catchall_remove() before queueing
> the GC work.

Scratch this too, this is not correct.
