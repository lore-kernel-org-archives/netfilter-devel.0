Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E676C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Mar 2022 23:47:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiCBXsY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Mar 2022 18:48:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiCBXsV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Mar 2022 18:48:21 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF4DC80918
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2022 15:47:23 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9ED7462FE6;
        Thu,  3 Mar 2022 00:28:04 +0100 (CET)
Date:   Thu, 3 Mar 2022 00:29:33 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH nf-next v2 0/3] Conntrack GRE offload
Message-ID: <Yh/93TOu7at8428k@salvia>
References: <20220225015309.2576980-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220225015309.2576980-1-toshiaki.makita1@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Feb 25, 2022 at 10:53:06AM +0900, Toshiaki Makita wrote:
> Conntrack offload currently only supports TCP and UDP.
> Thus TC/nftables/OVS cannot offload GRE packets.

Series applied to nf-next, thanks

If you prefer to route this through different tree, just let me know.
