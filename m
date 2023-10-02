Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06CECE7849A
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Oct 2023 09:07:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235984AbjJBJHs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Oct 2023 05:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235939AbjJBJHq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Oct 2023 05:07:46 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C4991
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Oct 2023 02:07:43 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qnEty-00081H-4s; Mon, 02 Oct 2023 11:07:42 +0200
Date:   Mon, 2 Oct 2023 11:07:42 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, phil@nwl.cc
Subject: Re: [PATCH nf] netfilter: nf_tables: do not refresh timeout when
 resetting element
Message-ID: <20231002090742.GC19898@breakpoint.cc>
References: <20231002090516.3200649-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231002090516.3200649-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> The dump and reset command should not refresh the timeout, this command
> is intended to allow users to list existing stateful objects and reset
> them, element expiration should be refresh via transaction instead with
> a specific command to achieve this, otherwise this is entering combo
> semantics that will be hard to be undone later (eg. a user asking to
> retrieve counters but _not_ requiring to refresh expiration).

Agreed.
