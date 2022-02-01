Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9696BC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Feb 2022 12:05:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237661AbiBAME7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Feb 2022 07:04:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237651AbiBAME7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Feb 2022 07:04:59 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C251C061714
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Feb 2022 04:04:59 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nEru2-0003zK-Re; Tue, 01 Feb 2022 13:04:54 +0100
Date:   Tue, 1 Feb 2022 13:04:54 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Pham Thanh Tuyen <phamtyn@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: PROBLEM: Injected conntrack lost helper
Message-ID: <20220201120454.GB18351@breakpoint.cc>
References: <f9fb5616-0b37-d76b-74e5-53751d473432@gmail.com>
 <3f416429-b1be-b51a-c4ef-6274def33258@iogearbox.net>
 <0f4edf58-7b4e-05e8-3f13-d34819b8d5db@gmail.com>
 <20220131112050.GQ25922@breakpoint.cc>
 <2ea7f9da-22be-17db-88d7-10738b95faf3@gmail.com>
 <YfkLnyQopoKnRU17@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfkLnyQopoKnRU17@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Feb 01, 2022 at 10:08:55AM +0700, Pham Thanh Tuyen wrote:
> > When the conntrack is created, the extension is created before the conntrack
> > is assigned confirmed and inserted into the hash table. But the function
> > ctnetlink_setup_nat() causes loss of helper in the mentioned situation. I
> > mention the template because it's seamless in the
> > __nf_ct_try_assign_helper() function. Please double check.
> 
> Conntrack entries that are created via ctnetlink as IPS_CONFIRMED always
> set on.
>
> The helper code is only exercised from the packet path for conntrack
> entries that are newly created.

I suspect this is the most simple fix, might make sense to also
update the comment of IPS_HELPER to say that it means 'explicitly
attached via ctnetlink or ruleset'.

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2313,6 +2313,9 @@ ctnetlink_create_conntrack(struct net *net,
 
 			/* not in hash table yet so not strictly necessary */
 			RCU_INIT_POINTER(help->helper, helper);
+
+			/* explicitly attached from userspace */
+			ct->status |= IPS_HELPER;
 		}
 	} else {
 		/* try an implicit helper assignation */
