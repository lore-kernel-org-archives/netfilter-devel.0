Return-Path: <SRS0=l45K=UY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEA80C48BD4
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 16:53:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC8112064A
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 16:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728328AbfFYQxr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jun 2019 12:53:47 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:34706 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726599AbfFYQxq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jun 2019 12:53:46 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hfohU-0003UP-A2; Tue, 25 Jun 2019 18:53:44 +0200
Date:   Tue, 25 Jun 2019 18:53:44 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
Subject: Re: 4.19: Traced deadlock during xfrm_user module load
Message-ID: <20190625165344.ii4zgvxydqj663ny@breakpoint.cc>
References: <20190625155509.pgcxwgclqx3lfxxr@intra2net.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190625155509.pgcxwgclqx3lfxxr@intra2net.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thomas Jarosch <thomas.jarosch@intra2net.com> wrote:
> we're in the process of upgrading to kernel 4.19 and hit
> a very rare lockup on boot during "xfrm_user" module load.
> The tested kernel was 4.19.55.
> 
> When the strongswan IPsec service starts, it loads the xfrm_user module.
> -> modprobe hangs forever. 
> 
> Also network services like ssh or apache stop responding,
> ICMP ping still works.
> 
> By chance we had magic sysRq enabled and were able to get some meaningful stack 
> traces. We've rebuilt the kernel with LOCKDEP + DEBUG_INFO + DEBUG_INFO_REDUCED, 
> but so far failed to reproduce the issue even when hammering the suspected 
> deadlock case. Though it's just hammering it for a few hours yet.
> 
> Preliminary analysis:
> 
> "modprobe xfrm_user":
>     xfrm_user_init()
>         register_pernet_subsys()
>             -> grab pernet_ops_rwsem
>                 ..
>                 netlink_table_grab()
>                     calls schedule() as "nl_table_users" is non-zero
> 
> 
> conntrack netlink related program "info_iponline" does this in parallel:
>     netlink_bind()
>         netlink_lock_table() -> increases "nl_table_users"
>             nfnetlink_bind()
>             # does not unlock the table as it's locked by netlink_bind()
>                 __request_module()
>                     call_usermodehelper_exec()
>             
> 
> "modprobe nf_conntrack_netlink" runs and inits nf_conntrack_netlink:
>     ctnetlink_init()
>         register_pernet_subsys()
>             -> blocks on "pernet_ops_rwsem" thanks to xfrm_user module
>                 -> schedule()
>                     -> deadlock forever
> 

Thanks for this detailed analysis.
In this specific case I think this is enough:

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 92077d459109..61ba92415480 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -578,7 +578,8 @@ static int nfnetlink_bind(struct net *net, int group)
        ss = nfnetlink_get_subsys(type << 8);
        rcu_read_unlock();
        if (!ss)
-               request_module("nfnetlink-subsys-%d", type);
+               request_module_nowait("nfnetlink-subsys-%d", type);
        return 0;
 }
 #endif


