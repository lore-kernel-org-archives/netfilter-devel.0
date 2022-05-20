Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65932C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 May 2022 23:16:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353994AbiETXQi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 May 2022 19:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbiETXQf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 May 2022 19:16:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF1D57138;
        Fri, 20 May 2022 16:16:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B185B82B7D;
        Fri, 20 May 2022 23:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A9BC385A9;
        Fri, 20 May 2022 23:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653088589;
        bh=OudlFS3YzZaVhYSU9lua7CNuPQ09jzvipFopxtTi9GU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oDmSPU4WoLPyZKbHivtGdys247jq13bb2f/D/s2pYfDwnSmP/3qNwCgYKJooj8hjk
         6fO5FTpfLI/F7dKYLqWfc710dplNcHd1SeNFeaocNKoeCEUI+RhL1e5Q511vOPn1LI
         gJNRbaWHXjbltj07QGOGiy/aclIw13NcwR/n+wXEZzqET6NL0YQ/ZVAepTxU/0ztZq
         k+cAyUf5UFP5GOg7y0VqKUa1n8abd41Q9NC5fY/Y02K/XKl58KuYIdWYJXHqAH/r3l
         ljVTEUh52viL8DCANbQYOHmde0Ah8v2iRX3gQEP3rTPLthsvHlDbTyJamz1457AyIv
         aXl56//NHKs6Q==
Date:   Fri, 20 May 2022 16:16:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com,
        Felix Fietkau <nbd@nbd.name>, Oz Shlomo <ozsh@nvidia.com>,
        paulb@nvidia.com, vladbu@nvidia.com
Subject: Re: [PATCH net-next 06/11] netfilter: nf_flow_table: count and
 limit hw offloaded entries
Message-ID: <20220520161627.6d587791@kernel.org>
In-Reply-To: <YogTfOYGwY5IVhGn@salvia>
References: <20220519220206.722153-1-pablo@netfilter.org>
        <20220519220206.722153-7-pablo@netfilter.org>
        <20220519161136.32fdba19@kernel.org>
        <YodG+REOiDa2PMUl@salvia>
        <20220520105606.15fd5133@kernel.org>
        <YogTfOYGwY5IVhGn@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, 21 May 2022 00:17:32 +0200 Pablo Neira Ayuso wrote:
> Policy can also throttle down the maximum number of entries in the
> hardware, but policy is complementary to the hard cap.
> 
> Once the hw cap is reached, the implementation falls back to the
> software flowtable datapath.

Understood.

> Regarding the "magic number", it would be good if devices can expose
> these properties through interface, maybe FLOW_BLOCK_PROBE to fetch
> device properties and capabilities.

Fingers crossed, however, if the device is multi-user getting exact
cap may be pretty much impossible. Then again the user is supposed
to be able to pull the cap for sysfs out of the hat so I'm confused.

What I was thinking of was pausing offload requests for a jiffy if we
get ENOSPC 3 times in a row, or some such.

> In general, I would also prefer a netlink interface for this, but for
> tc ct, this would need to expose the existing flowtable objects via a
> new netlink command. Then, I assume such cap would be per ct zone
> (there is internally one flowtable per conntrack zone).
> 
> BTW, Cc'ing Oz, Paul and Vlad.

Ah, thanks, I added Felix just in case but didn't check if authors 
are already on CC :S

> Meanwhile, what do you want me to do, toss this patchset?

Yeah, if you don't mind.. We're too close to the merge window to
tentatively take stuff that's under discussion.
