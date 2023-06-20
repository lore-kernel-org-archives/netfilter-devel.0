Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 433D7EB64D7
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Jun 2023 16:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjFTQiX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Jun 2023 12:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbjFTQiX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Jun 2023 12:38:23 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A676C0;
        Tue, 20 Jun 2023 09:38:21 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qBeMo-0002WT-Fi; Tue, 20 Jun 2023 18:38:06 +0200
Date:   Tue, 20 Jun 2023 18:38:06 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Igor Artemiev <Igor.A.Artemiev@mcst.ru>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: Re: [lvc-project] [PATCH] netfilter: ebtables: remove unnecessary
 NULL check
Message-ID: <20230620163806.GB3799@breakpoint.cc>
References: <20230620152549.2109063-1-Igor.A.Artemiev@mcst.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230620152549.2109063-1-Igor.A.Artemiev@mcst.ru>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Igor Artemiev <Igor.A.Artemiev@mcst.ru> wrote:
> In ebt_do_table() 'private->chainstack' cannot be NULL
> and the 'cs' pointer is dereferenced below, so it does not make
> sense to compare 'private->chainstack' with NULL. 

?  Why do you think that?

> +	cs = private->chainstack[smp_processor_id()];

Looks like NULL deref to me.  Did you test this?
