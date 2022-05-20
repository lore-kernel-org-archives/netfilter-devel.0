Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0517C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 May 2022 04:55:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238465AbiETEzd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 May 2022 00:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345472AbiETEzc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 May 2022 00:55:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574E814ACB1;
        Thu, 19 May 2022 21:55:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 970AF61D34;
        Fri, 20 May 2022 04:55:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8F0C385A9;
        Fri, 20 May 2022 04:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653022530;
        bh=CLCqcVk8oQ5AHlPKjIgApjPYQLlW/8o8kBv2dtOfex4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g38HcaJp5SXG3RVQf7m/sdIL8Z9iFIfBC2ziJfOL3Fnb47BnjLJXj0znD6sEhnQxj
         PhWeZkEU37nUsnCy/fVSY2go9fVrc0PXD8m1Wjl4ZkvPNZYxBeD0tuVt7UrlN1EhPK
         iRDyOz19G2GegFyO5E+pwjfXvooM7ZfS3upaaDGhYT97zQz3dnd78W/xLrrfHxpQRs
         vUEf4tNKKomThOyeUzk9eBc3plmhVABSUBI6maHA16fjXNjv5to9CCKTuQ69qDQXt8
         S73rJNMCpjCMLbCnuRKFmL3ARpQuDUETzcxAj9Zyn10IzaUumzed87vBKuuPYcJbPG
         74yCVj0sWgvEQ==
Date:   Thu, 19 May 2022 21:55:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next 06/11] netfilter: nf_flow_table: count and
 limit hw offloaded entries
Message-ID: <20220519215528.34949f73@kernel.org>
In-Reply-To: <20220519161136.32fdba19@kernel.org>
References: <20220519220206.722153-1-pablo@netfilter.org>
        <20220519220206.722153-7-pablo@netfilter.org>
        <20220519161136.32fdba19@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 19 May 2022 16:11:36 -0700 Jakub Kicinski wrote:
> On Fri, 20 May 2022 00:02:01 +0200 Pablo Neira Ayuso wrote:
> > To improve hardware offload debuggability and scalability introduce
> > 'nf_flowtable_count_hw' and 'nf_flowtable_max_hw' sysctl entries in new
> > dedicated 'net/netfilter/ft' namespace. Add new pernet struct nf_ft_net in
> > order to store the counter and sysctl header of new sysctl table.
> > 
> > Count the offloaded flows in workqueue add task handler. Verify that
> > offloaded flow total is lower than allowed maximum before calling the
> > driver callbacks. To prevent spamming the 'add' workqueue with tasks when
> > flows can't be offloaded anymore also check that count is below limit
> > before queuing offload work. This doesn't prevent all redundant workqueue
> > task since counter can be taken by concurrent work handler after the check
> > had been performed but before the offload job is executed but it still
> > greatly reduces such occurrences. Note that flows that were not offloaded
> > due to counter being larger than the cap can still be offloaded via refresh
> > function.
> > 
> > Ensure that flows are accounted correctly by verifying IPS_HW_OFFLOAD_BIT
> > value before counting them. This ensures that add/refresh code path
> > increments the counter exactly once per flow when setting the bit and
> > decrements it only for accounted flows when deleting the flow with the bit
> > set.  
> 
> Why a sysctl and not a netlink attr per table or per device?

Let me do something unorthodox and pull just the first 4 patches 
for now so the warning goes away...
