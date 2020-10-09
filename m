Return-Path: <SRS0=CfkY=DQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E856BC433E7
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Oct 2020 10:37:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92ACC2222C
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Oct 2020 10:37:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387731AbgJIKha (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Oct 2020 06:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725979AbgJIKha (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Oct 2020 06:37:30 -0400
X-Greylist: delayed 13484 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 09 Oct 2020 03:37:29 PDT
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C824BC0613D2
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Oct 2020 03:37:29 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id AF458CC0130;
        Fri,  9 Oct 2020 12:37:27 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Fri,  9 Oct 2020 12:37:25 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 5F5B4CC0105;
        Fri,  9 Oct 2020 12:37:25 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 5220D340D60; Fri,  9 Oct 2020 12:37:25 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 4DB16340D5C;
        Fri,  9 Oct 2020 12:37:25 +0200 (CEST)
Date:   Fri, 9 Oct 2020 12:37:25 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@blackhole.kfki.hu
To:     Phil Sutter <phil@nwl.cc>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] iptables-nft: fix basechain policy
 configuration
In-Reply-To: <20201009093705.GF13016@orbyte.nwl.cc>
Message-ID: <alpine.DEB.2.23.453.2010091226090.19307@blackhole.kfki.hu>
References: <160163907669.18523.7311010971070291883.stgit@endurance> <20201008173156.GA14654@salvia> <20201009082953.GD13016@orbyte.nwl.cc> <20201009085039.GB7851@salvia> <20201009093705.GF13016@orbyte.nwl.cc>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Fri, 9 Oct 2020, Phil Sutter wrote:

> On Fri, Oct 09, 2020 at 10:50:39AM +0200, Pablo Neira Ayuso wrote:
> [...]
> > Semantics for this are: Flush out _everything_ (existing rules and
> > non-chains) but only leave existing basechain policies in place as is.
> > 
> > I wonder if this is intentional or a side effect of the --noflush support.
> > 
> > I'm Cc'ing Jozsef, maybe he remembers. Because you're reaching my
> > boundaries on the netfilter history for this one :-)

Phil could dig it out from git history :-):

> FWIW, I searched git history and can confirm the given behaviour is like
> that at least since Dec 2000 and commit ae1ff9f96a803 ("make
> iptables-restore and iptables-save work again!")!
> 
> iptables-legacy-restore does:
> 
> | if (noflush == 0) {
> |         DEBUGP("Cleaning all chains of table '%s'\n",
> |                 table);
> |         cb->for_each_chain(cb->flush_entries, verbose, 1,
> |                         handle);
> |
> |         DEBUGP("Deleting all user-defined chains "
> |                "of table '%s'\n", table);
> |         cb->for_each_chain(cb->delete_chain, verbose, 0,
> |                         handle);
> | }
> 
> (Third parameter to for_each_chain decides whether builtins are included or
> not.)
> 
> I guess fundamentally this is due to legacy design which keeps builtin 
> chains in place at all times. We could copy that in iptables-nft, but I 
> like the current design where we just delete the whole table and start 
> from scratch.
> 
> Florian made a related remark a while ago about flushing chains with 
> DROP policy: He claims it is almost always a mistake and we should reset 
> the policy to ACCEPT in order to avoid people from locking themselves 
> out. I second that idea, but am not sure if such a change is tolerable 
> at all.

I don't think such a change in the behaviour could properly be 
communicated to the users, let alone notified them about such a change. It 
could cause such subtle errors out there, which are hard to identify and 
fix: they'll debug the rules/user chains and the very last the base rule 
policy.

I know lots of effort went into backward compatibility, this should be 
included there too.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
