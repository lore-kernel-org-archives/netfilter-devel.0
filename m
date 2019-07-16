Return-Path: <SRS0=/Fuh=VN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D627C76188
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 09:11:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B60F20659
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 09:11:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731413AbfGPJLQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Jul 2019 05:11:16 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:55262 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727105AbfGPJLQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jul 2019 05:11:16 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hnJUN-0003YP-F8; Tue, 16 Jul 2019 11:11:11 +0200
Date:   Tue, 16 Jul 2019 11:11:11 +0200
From:   Florian Westphal <fw@strlen.de>
To:     wenxu@ucloud.cn
Cc:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v5 0/8] netfilter: nf_flow_offload: support
 bridge family offload for both
Message-ID: <20190716091111.bqjnoqcfd4aykbqc@breakpoint.cc>
References: <1563238066-3105-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1563238066-3105-1-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

wenxu@ucloud.cn <wenxu@ucloud.cn> wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> wenxu (8):
>   netfilter:nf_flow_table: Refactor flow_offload_tuple to destination
>   netfilter:nf_flow_table_core: Separate inet operation to single
>     function
>   netfilter:nf_flow_table_ip: Separate inet operation to single function
>   bridge: add br_vlan_get_info_rcu()
>   netfilter:nf_flow_table_core: Support bridge family flow offload
>   netfilter:nf_flow_table_ip: Support bridge family flow offload
>   netfilter:nft_flow_offload: Support bridge family flow offload
>   netfilter: Support the bridge family in flow table

Note that net-next is closed, and therefore nf-next, so it may
take longer than usual for this series to get feedback.
