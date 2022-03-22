Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5877EC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Mar 2022 10:25:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbiCVK1C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Mar 2022 06:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbiCVK1B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Mar 2022 06:27:01 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978F920F50;
        Tue, 22 Mar 2022 03:25:34 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nWbhj-0002lV-KV; Tue, 22 Mar 2022 11:25:31 +0100
Date:   Tue, 22 Mar 2022 11:25:31 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Vasily Averin <vasily.averin@linux.dev>
Cc:     Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        kernel@openvz.org
Subject: Re: [PATCH v2] memcg: enable accounting for nft objects
Message-ID: <20220322102531.GC24574@breakpoint.cc>
References: <20220228122429.GC26547@breakpoint.cc>
 <f359be78-c95d-555a-67ec-f665f90e93b8@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f359be78-c95d-555a-67ec-f665f90e93b8@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Vasily Averin <vasily.averin@linux.dev> wrote:
> nftables replaces iptables, but it lacks memcg accounting.
> 
> This patch account most of the memory allocation associated with nft
> and should protect the host from misusing nft inside a memcg restricted
> container.

LGTM.

Acked-by: Florian Westphal <fw@strlen.de>
