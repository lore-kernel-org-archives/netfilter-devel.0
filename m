Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D94BC433FE
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Mar 2022 22:46:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343848AbiCGWrh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Mar 2022 17:47:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343882AbiCGWrg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Mar 2022 17:47:36 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3835E6BDF3
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2022 14:46:40 -0800 (PST)
Received: from netfilter.org (unknown [87.190.248.243])
        by mail.netfilter.org (Postfix) with ESMTPSA id 30826601DB;
        Mon,  7 Mar 2022 23:44:49 +0100 (CET)
Date:   Mon, 7 Mar 2022 23:46:35 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
        fw@strlen.de, ozsh@nvidia.com, paulb@nvidia.com
Subject: Re: [PATCH net-next 4/8] netfilter: introduce total count of hw
 offload 'add' workqueue tasks
Message-ID: <YiaLS9rBYKiRmi3B@salvia>
References: <20220222151003.2136934-1-vladbu@nvidia.com>
 <20220222151003.2136934-5-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220222151003.2136934-5-vladbu@nvidia.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Feb 22, 2022 at 05:09:59PM +0200, Vlad Buslov wrote:
> To improve hardware offload debuggability and allow capping total amount of
> offload 'add' in-flight entries on workqueue in following patch extend
> struct netns_nftables with 'count_wq_add' counter and expose it to
> userspace as 'nf_flowtable_count_wq_add' sysctl entry. Increment the
> counter when allocating new workqueue task and decrement it after
> flow_offload_work_add() is finished.

No objections to expose stats as described in patches 4/8, 6/8 and 7/8.
