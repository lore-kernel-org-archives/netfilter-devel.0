Return-Path: <SRS0=0Xdd=RL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5AFEC43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 15:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84D5520868
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 15:59:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfCHP7j (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 10:59:39 -0500
Received: from mail.us.es ([193.147.175.20]:53886 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbfCHP7j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 10:59:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7BD225E539C
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Mar 2019 16:59:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6617CDA86E
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Mar 2019 16:59:37 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5B698DA844; Fri,  8 Mar 2019 16:59:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0DCC0DA864;
        Fri,  8 Mar 2019 16:59:35 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 08 Mar 2019 16:59:35 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D9AFD4265A2F;
        Fri,  8 Mar 2019 16:59:34 +0100 (CET)
Date:   Fri, 8 Mar 2019 16:59:34 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Su Yanjun <suyanjun218@163.com>
Cc:     kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        suyj.fnst@cn.fujitsu.com
Subject: Re: [PATCH] netfilter: nf_ct_helper: Fix possible panic when
 nf_conntrack_helper_unregister is used in an unloadable module
Message-ID: <20190308155934.vfx2ah4k4guqvhyu@salvia>
References: <1551419766-1039-1-git-send-email-suyanjun218@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1551419766-1039-1-git-send-email-suyanjun218@163.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Mar 01, 2019 at 01:56:06PM +0800, Su Yanjun wrote:
> From: Su Yanjun <suyj.fnst@cn.fujitsu.com>
> 
> Because nf_conntrack_helper_unregister maybe used in an unloadable module,
> it uses 'synchronize_rcu' which may cause kernel panic.
> 
> According to the artical:
> RCU and Unloadable Modules
> https://lwn.net/Articles/217484/
> 
> When we have a heavy rcu callback load, then some of the callbacks might be
> deferred in order to allow other processing to proceed. sychnorize_rcu does
> not wait rcu callback complete and module may be unloaded before callback
> done.
> 
> This patch uses rcu_barrier instead of synchronize_rcu will prevent this
> situation.
> 
> Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
> ---
>  net/netfilter/nf_conntrack_helper.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
> index 274baf1..0ee9378 100644
> --- a/net/netfilter/nf_conntrack_helper.c
> +++ b/net/netfilter/nf_conntrack_helper.c
> @@ -397,8 +397,15 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
>  
>  	/* Make sure every nothing is still using the helper unless its a
>  	 * connection in the hash.
> +	 *
> +	 * 'synchronize_rcu' may have problem when rcu callback function
> +	 * is used in unloadable modules. Use rcu_barrier instead, so that
> +	 * it will wait until rcu callback completes before modules are
> +	 * unloaded.
> +	 * More detail about rcu_barrier please see:
> +	 * https://lwn.net/Articles/217484/
>  	 */
> -	synchronize_rcu();
> +	rcu_barrier();

Are you sure this is correct?

IIRC rcu_barrier() makes sure no pending callback is still waiting in
the queue to run. We have don't use call_rcu() in this code, which is
what rcu_barrier() is meant for.

Please correct me if I'm mistaken.

Thanks!

>  
>  	nf_ct_expect_iterate_destroy(expect_iter_me, NULL);
>  	nf_ct_iterate_destroy(unhelp, me);
> @@ -406,7 +413,7 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
>  	/* Maybe someone has gotten the helper already when unhelp above.
>  	 * So need to wait it.
>  	 */
> -	synchronize_rcu();
> +	rcu_barrier();
>  }
>  EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
>  
> -- 
> 2.7.4
> 
> 
