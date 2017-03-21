From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] [RESENT]netfilter: nfnetlink_cthelper: Fix memory leak
Date: Tue, 21 Mar 2017 12:59:38 +0100
Message-ID: <20170321115938.GA7809@salvia>
References: <1490080030-6799-1-git-send-email-jeffy.chen@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Douglas Anderson <dianders@chromium.org>,
        Brian Norris <briannorris@chromium.org>,
        netfilter-devel@vger.kernel.org, zlpnobody@163.com
To: Jeffy Chen <jeffy.chen@rock-chips.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46802 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757017AbdCUL7u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 07:59:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 24DB511ADCA
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 12:59:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 173ECEBAF2
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 12:59:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5E5C9FAB58
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 12:59:42 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1490080030-6799-1-git-send-email-jeffy.chen@rock-chips.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 21, 2017 at 03:07:10PM +0800, Jeffy Chen wrote:
> We have memory leaks of nf_conntrack_helper & expect_policy.
> 
> Signed-off-by: Jeffy Chen <jeffy.chen@rock-chips.com>
> ---
> 
>  net/netfilter/nfnetlink_cthelper.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
> index de87823..99d4bd7 100644
> --- a/net/netfilter/nfnetlink_cthelper.c
> +++ b/net/netfilter/nfnetlink_cthelper.c
> @@ -191,6 +191,8 @@ nfnl_cthelper_parse_expect_policy(struct nf_conntrack_helper *helper,
>  		if (ret < 0)
>  			goto err;
>  	}
> +
> +	kfree(helper->expect_policy);
>  	helper->expect_policy = expect_policy;

This is fixing the leak, however this is not safe since a packet may
be still walking on the older helper->expect_policy.

        old_expect_policy = helper->expect_policy);
        helper->expect_policy = expect_policy;
        kfree(old_expect_policy);

We need to protect this with RCU if we want to support expectation
policy updates properly.

I'm going to take this patch, but we have to follow up on this.
