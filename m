Return-Path: <SRS0=CfkY=DQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C064C433DF
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Oct 2020 19:05:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 399DE22314
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Oct 2020 19:05:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388349AbgJITF2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Oct 2020 15:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388317AbgJITF1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Oct 2020 15:05:27 -0400
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6A4C0613D2
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Oct 2020 12:05:27 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 2DBABCC012C;
        Fri,  9 Oct 2020 21:05:26 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Fri,  9 Oct 2020 21:05:24 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id BE968CC011F;
        Fri,  9 Oct 2020 21:05:23 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id B564B340D60; Fri,  9 Oct 2020 21:05:23 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id B144B340D5C;
        Fri,  9 Oct 2020 21:05:23 +0200 (CEST)
Date:   Fri, 9 Oct 2020 21:05:23 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@blackhole.kfki.hu
To:     Phil Sutter <phil@nwl.cc>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] iptables-nft: fix basechain policy
 configuration
In-Reply-To: <20201009120455.GJ13016@orbyte.nwl.cc>
Message-ID: <alpine.DEB.2.23.453.2010092056500.19307@blackhole.kfki.hu>
References: <160163907669.18523.7311010971070291883.stgit@endurance> <20201008173156.GA14654@salvia> <20201009082953.GD13016@orbyte.nwl.cc> <20201009085039.GB7851@salvia> <20201009093705.GF13016@orbyte.nwl.cc> <alpine.DEB.2.23.453.2010091226090.19307@blackhole.kfki.hu>
 <20201009120455.GJ13016@orbyte.nwl.cc>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Fri, 9 Oct 2020, Phil Sutter wrote:

> On Fri, Oct 09, 2020 at 12:37:25PM +0200, Jozsef Kadlecsik wrote:
> [...]
> > I know lots of effort went into backward compatibility, this should be 
> > included there too.
> 
> Certainly doable. Some hacking turned into quite a mess, though:
> 
> When restoring without '--noflush', a chain cache is needed - simply 
> doable by treating NFT_CL_FAKE differently. Reacting upon a chain policy 
> of '-' is easy, just lookup the existing chain's policy from cache and 
> use that. Things then become ugly for not specified chains: 
> 'flush_table' callback really deletes the table. So one has to gather 
> the existing builtin chains first, check if their policy is non-default 
> and restore those. If they don't exist though, one has to expect for 
> them to occur when refreshing the transaction (due to concurrent ruleset 
> change). So the batch jobs have to be created either way and just set to 
> 'skip' if either table or chain doesn't exist or the policy is ACCEPT.

I think the main problem is the difference between nft and iptables when 
printing the base chains and their policy, as you wrote:

> But that is a significant divergence between legacy and nft:
> 
> | # iptables -P FORWARD DROP
> | # iptables-restore <<EOF
> | *filter
> | COMMIT
> | EOF
> | # iptables-save
>
> With legacy, the output is:
> 
> | *filter
> | :INPUT ACCEPT [0:0]
> | :FORWARD DROP [0:0]
> | :OUTPUT ACCEPT [0:0]
> | COMMIT
> 
> With nft, there's no output at all. What do you think, should we fix
> that? If so, which side?

It looks as nft would loose the DROP policy of FORWARD! That looks like 
definitely wrong. It was explicitly set, so it should be printed/saved. 

Also, if nft in >legacy mode< would print the base chains with their 
policy (regardless of the value), couldn't then restore mode handle those 
properly?
 
> But first I need more coffee. %)

Me too... :-)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
