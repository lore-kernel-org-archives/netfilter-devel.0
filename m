Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3B77C433F5
	for <netfilter-devel@archiver.kernel.org>; Sun, 20 Mar 2022 00:44:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244499AbiCTAqB convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Mar 2022 20:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244506AbiCTAqA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Mar 2022 20:46:00 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8388C25EC9B;
        Sat, 19 Mar 2022 17:44:34 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nVjgL-0006H8-TO; Sun, 20 Mar 2022 01:44:30 +0100
Date:   Sun, 20 Mar 2022 01:44:29 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jakob Koschel <jakobkoschel@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mike Rapoport <rppt@kernel.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: Re: [PATCH] netfilter: nf_tables: replace unnecessary use of
 list_for_each_entry_continue()
Message-ID: <20220320004429.GD13956@breakpoint.cc>
References: <20220319202526.2527974-1-jakobkoschel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20220319202526.2527974-1-jakobkoschel@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jakob Koschel <jakobkoschel@gmail.com> wrote:
> Since there is no way for the previous list_for_each_entry() to exit
> early, this call to list_for_each_entry_continue() is always guaranteed
> to start with the first element of the list and can therefore be
> replaced with a call to list_for_each_entry().
> 
> In preparation to limit the scope of the list iterator to the list
> traversal loop, the list iterator variable 'rule' should not be used
> past the loop.
> 
> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
>  
> -	list_for_each_entry_continue(rule, &chain->rules, list) {
> +	list_for_each_entry(rule, &chain->rules, list) {
>  		if (!nft_is_active_next(net, rule))
>  			continue;

You could also replace the first entry_continue and get rid of the
preceeding
	rule = list_entry().
