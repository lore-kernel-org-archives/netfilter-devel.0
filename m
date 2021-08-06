Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6082BC4338F
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Aug 2021 22:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 326E6611B0
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Aug 2021 22:33:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhHFWeO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Aug 2021 18:34:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232031AbhHFWeN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Aug 2021 18:34:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4661861181;
        Fri,  6 Aug 2021 22:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628289237;
        bh=8CvfS4Q4Yg/v3TtJJHxNOOwDp7fwO9outeVvtTPZVQQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fBvPw75amq4qR6hdFg7tPvAxyowzWuqKw9mt/abiyEFKJNPYh7z3VqDySAO7Ac0BV
         t3FKOcMExq/6pxSOA0tctpCEp1ja9G9CrvS3aIhM/6tFMHvbrG4oWuksBMR/Xs3l9o
         i/2zyrKe1kyhSPDCdjxxPFG4p4zF+e2tSdiPPFc/a58V77usCbKi8DdJ+BI/iv8weO
         zqgqsGxNcgwX7wDbRKsj4Op55yXpb2grAkUpCATsRuI8lmF8nl++ePTco/YTL7CZ8a
         +7N0rwKxTb8S6OHnq5bCIO0Tne9QlWqrq8QNOYneDdnbfaHe1DW2wlWwESDCJgmoq2
         VznOn8s2aDAPA==
Date:   Fri, 6 Aug 2021 15:33:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 0/9,v2] Netfilter fixes for net
Message-ID: <20210806153356.1d045a3b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210806151149.6356-1-pablo@netfilter.org>
References: <20210806151149.6356-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri,  6 Aug 2021 17:11:40 +0200 Pablo Neira Ayuso wrote:
> 1) Restrict range element expansion in ipset to avoid soft lockup,
>    from Jozsef Kadlecsik.
> 
> 2) Memleak in error path for nf_conntrack_bridge for IPv4 packets,
>    from Yajun Deng.
> 
> 3) Simplify conntrack garbage collection strategy to avoid frequent
>    wake-ups, from Florian Westphal.
> 
> 4) Fix NFNLA_HOOK_FUNCTION_NAME string, do not include module name.
> 
> 5) Missing chain family netlink attribute in chain description
>    in nfnetlink_hook.
> 
> 6) Incorrect sequence number on nfnetlink_hook dumps.
> 
> 7) Use netlink request family in reply message for consistency.
> 
> 8) Remove offload_pickup sysctl, use conntrack for established state
>    instead, from Florian Westphal.
> 
> 9) Translate NFPROTO_INET/ingress to NFPROTO_NETDEV/ingress, since
>    NFPROTO_INET is not exposed through nfnetlink_hook.

Looks like the bot doesn't want to respond :S

Pulled in the morning already, thanks!
