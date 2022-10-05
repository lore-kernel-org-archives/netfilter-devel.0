Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8D76C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Oct 2022 19:29:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbiJET3e (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Oct 2022 15:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbiJET3Y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Oct 2022 15:29:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB0E3B727
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Oct 2022 12:29:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFF706175C
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Oct 2022 19:29:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11865C433C1;
        Wed,  5 Oct 2022 19:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664998162;
        bh=VErIylgwxPyL8R+8NjwJ2vj5mwjhiFyateATxdSYpYs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=hLm87sblYb+8XCylFtf2kpAaMuFjF3BprlW4yCOY9UrGhYQmJx+cJQ/km+rUzCj52
         VPtPOnItdyHt1KGkKXYRRxB8lnzPosis7Yd37qNx4J9viePo2PFleUI0dKQXclIj3B
         HqqESqPdcMCbY9k6DPbYaMXMLRq/0iF49IZEv49wi5wiHkMMgIxeGZa5MRPexXUG+e
         PLyviaQWwD05vzIVk88tPe0zqnmkFyTXQvuzYDwTXo2lUxmh7DUME8hxOcAwFpGbdG
         HDK1sl6T7TwvZfPc7Ez5EWuP4CW1DSqefUUjnUbT7DEQyBq4jjWvhAcFgWqtCZZ6Of
         gUF8pB3lF2TLQ==
Message-ID: <8cfd5bd0-e8e2-2d63-c8c1-267a71a81b7c@kernel.org>
Date:   Wed, 5 Oct 2022 13:29:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [nf-next PATCH 2/2] netfilter: rpfilter/fib: Populate
 flowic_l3mdev field
Content-Language: en-US
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Guillaume Nault <gnault@redhat.com>,
        Miaohe Lin <linmiaohe@huawei.com>
References: <20221005160705.8725-1-phil@nwl.cc>
 <20221005160705.8725-2-phil@nwl.cc>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20221005160705.8725-2-phil@nwl.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 10/5/22 10:07 AM, Phil Sutter wrote:
> Use the introduced field for correct operation with VRF devices instead
> of conditionally overwriting flowic_oif. This is a partial revert of
> commit b575b24b8eee3 ("netfilter: Fix rpfilter dropping vrf packets by
> mistake"), implementing a simpler solution.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  net/ipv4/netfilter/ipt_rpfilter.c  | 2 +-
>  net/ipv4/netfilter/nft_fib_ipv4.c  | 2 +-
>  net/ipv6/netfilter/ip6t_rpfilter.c | 9 +++------
>  net/ipv6/netfilter/nft_fib_ipv6.c  | 5 ++---
>  4 files changed, 7 insertions(+), 11 deletions(-)
> 

LGTM

Reviewed-by: David Ahern <dsahern@kernel.org>
