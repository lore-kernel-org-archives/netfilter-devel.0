Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38417C43334
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jun 2022 03:53:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiFHDxj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Jun 2022 23:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233257AbiFHDwJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Jun 2022 23:52:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E460D14ACB0;
        Tue,  7 Jun 2022 18:00:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB04061886;
        Wed,  8 Jun 2022 01:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0326CC34114;
        Wed,  8 Jun 2022 01:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654650026;
        bh=3mo9MeBkgwHJ8jYycaKBT1Y3o0lYPvtMRiU1ngR9ibY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LSHa7RPq3cXbKYftW6O7/z+VpRevToenQR6OehInxRvqdu3D+KP3DisXAp3ZZlXkp
         bLZ5hgq32FBRq6r97NssnQ+QhPZAdAJoTJIBoEJhe3MXLtPlGS6wFHuAnhM59NnQf8
         qP/rdz6AMkDYjJinDpnBtu/rv5vYO5FERQWXKZtV/t6rPGMT65xfighN4ME0qrlRZp
         pYcSwj7tLA6y5HnP7D2UQRxn2P/AhOQsBjjVRwsufplkEnKarIC1pd1y2NTRL4Iw1a
         PMDUXeHHMERwpmFDDPu5dhK1JVubUEwCLElaVsq+YU1AyXrjLHMksrYfPzYtTqZMDy
         UoY04gJvZz/kQ==
Date:   Tue, 7 Jun 2022 18:00:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: Re: [PATCH net 7/7] netfilter: nf_tables: bail out early if
 hardware offload is not supported
Message-ID: <20220607180025.6bd26267@kernel.org>
In-Reply-To: <20220606212055.98300-8-pablo@netfilter.org>
References: <20220606212055.98300-1-pablo@netfilter.org>
        <20220606212055.98300-8-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon,  6 Jun 2022 23:20:55 +0200 Pablo Neira Ayuso wrote:
> If user requests for NFT_CHAIN_HW_OFFLOAD, then check if either device
> provides the .ndo_setup_tc interface or there is an indirect flow block
> that has been registered. Otherwise, bail out early from the preparation
> phase. Moreover, validate that family == NFPROTO_NETDEV and hook is
> NF_NETDEV_INGRESS.

The whole series is pretty light on the "why". This patch is
particularly bad, no idea what the user visible bug was here.
