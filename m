Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A6EAC4167B
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Nov 2022 03:04:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiKODEO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Nov 2022 22:04:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237718AbiKODDW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Nov 2022 22:03:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BDC167E3;
        Mon, 14 Nov 2022 19:02:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93B4E61520;
        Tue, 15 Nov 2022 03:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7053C433B5;
        Tue, 15 Nov 2022 03:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668481360;
        bh=ZEDgwqjBwp0CkvQfDHiESt3vEeEYW1xP+s/HSzcn07o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MQeqNdlf9i4xqw8nR1B/Nkdiwvq3TsOLbQxzQykLkEYXP93LWxM/5j05z+h1GS0qV
         BKQ67fk/fXae+RkSOHTh+G2vYdP7QNcjXlkiQNyEaohXLPiAJ0uRoNp8nKXoBCaGbO
         QJjeh07nfFWK1tQcqJODejFCD9OHW6cy9qas36WDb97cRCwZJs3R/Algo2eocP3mLL
         TmRIJg5jOazuZBIQHKgF3uxCFd9z5dJi4i0vp7u6zn3DDuTHcG79o6W81Lh5kOTygg
         Dvy0PSLUqBBnABngjAqvn6+tcz2zkhoB8jVpRkO0E8zg3JAlCA88HQo0jTzos2dFpU
         mMNt/dIOWe48Q==
Date:   Mon, 14 Nov 2022 19:02:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: Re: [PATCH net-next 6/6] netfilter: conntrack: use siphash_4u64
Message-ID: <20221114190238.693af399@kernel.org>
In-Reply-To: <20221114104106.8719-7-pablo@netfilter.org>
References: <20221114104106.8719-1-pablo@netfilter.org>
        <20221114104106.8719-7-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 14 Nov 2022 11:41:06 +0100 Pablo Neira Ayuso wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> This function is used for every packet, siphash_4u64 is noticeably faster
> than using local buffer + siphash:
> 
> Before:
>   1.23%  kpktgend_0       [kernel.vmlinux]     [k] __siphash_unaligned
>   0.14%  kpktgend_0       [nf_conntrack]       [k] hash_conntrack_raw
> After:
>   0.79%  kpktgend_0       [kernel.vmlinux]     [k] siphash_4u64
>   0.15%  kpktgend_0       [nf_conntrack]       [k] hash_conntrack_raw
> 
> In the pktgen test this gives about ~2.4% performance improvement.

Hi, Mr Nit Pick here, can we silence the spatse warnings?

net/netfilter/nf_conntrack_core.c:222:14: warning: cast from restricted __be16
net/netfilter/nf_conntrack_core.c:222:55: warning: restricted __be16 degrades to integer
