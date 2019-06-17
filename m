Return-Path: <SRS0=CDuC=UQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4246BC31E5B
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 20:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E23C420861
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 20:32:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="iISn1COp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbfFQUcc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 16:32:32 -0400
Received: from smtp-out.kfki.hu ([148.6.0.46]:34283 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725844AbfFQUcc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 16:32:32 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp1.kfki.hu (Postfix) with ESMTP id 4673B3C800F0;
        Mon, 17 Jun 2019 22:32:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1560803546; x=1562617947; bh=qHiwXRk2x/
        RmaINCOm0w0RTL48xRXViK9xxP7YNXle4=; b=iISn1COpBgEsk0C6uBumoT1c0y
        NFhqUgidIlpO5bWdZNE/iSTwUSUT5wVRj+rZ7BZCkCBacreBNWtXaOWtF0MCRtSa
        K1U0inbUtE1KAxwwAGUAiHzGxPInv2IVO05Tin1JjhtSCeQ+raNo4DUQSLcvKQSo
        7Mkz0j/snnju4ISmQ=
X-Virus-Scanned: Debian amavisd-new at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
        by localhost (smtp1.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Mon, 17 Jun 2019 22:32:26 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp1.kfki.hu (Postfix) with ESMTP id AD9B63C800DB;
        Mon, 17 Jun 2019 22:32:26 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 7E22E21CBA; Mon, 17 Jun 2019 22:32:26 +0200 (CEST)
Date:   Mon, 17 Jun 2019 22:32:26 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To:     Florian Westphal <fw@strlen.de>
cc:     Anatoly Pugachev <matorola@gmail.com>,
        Sparc kernel list <sparclinux@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        debian-sparc <debian-sparc@lists.debian.org>
Subject: Re: [netfilter-core] [sparc64] possible circular locking /
 deadlock
In-Reply-To: <20190617201104.qv2tm5oezluyg4nv@breakpoint.cc>
Message-ID: <alpine.DEB.2.20.1906172223110.31141@blackhole.kfki.hu>
References: <CADxRZqy=pCbwg6Lyio=GQ6gckR5B5Y=YQ1URPO0qn3YPAnUc0A@mail.gmail.com> <alpine.DEB.2.20.1906171656030.27371@blackhole.kfki.hu> <20190617201104.qv2tm5oezluyg4nv@breakpoint.cc>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

On Mon, 17 Jun 2019, Florian Westphal wrote:

> Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> > >                -> #0 (&table[i].mutex){+.+.}:
> > > [   11.698157]        lock_acquire+0x1a4/0x1c0
> > > [   11.698165]        __mutex_lock+0x48/0x920
> > > [   11.698173]        mutex_lock_nested+0x1c/0x40
> > > [   11.698181]        nfnl_lock+0x24/0x40 [nfnetlink]
> > > [   11.698196]        ip_set_nfnl_get_byindex+0x19c/0x280 [ip_set]
> > > [   11.698207]        set_match_v1_checkentry+0x14/0xc0 [xt_set]
> > 
> > set_match_v1_checkentry() from ipset always assumed that it's called via 
> > the old xtables/setsockopt interface. Thus it calls 
> > ip_set_nfnl_get_byindex() which is then calls 
> > nfnl_lock(NFNL_SUBSYS_IPSET). Here comes the circular dependency.
> 
> But isnt it a false positive?
> 
> > > [   11.698359]        CPU0                    CPU1
> > > [   11.698366]        ----                    ----
> > > [   11.698372]   lock(&net->nft.commit_mutex);
> > > [   11.698381]                                lock(&table[i].mutex);
> > > [   11.698390]                                lock(&net->nft.commit_mutex);
> > > [   11.698400]   lock(&table[i].mutex);
> > > [   11.698408]
> 
> AFAICS CPU0 takes the ipset subsys mutex after taking the nftables 
> transaction mutex (via checkentry of ipset match), while CPU1 took the 
> nftables subsys mutex and then the nftables transaction mutex.
> 
> The only reason why this splat is generated is because nftables and 
> ipset subset mutexes are currently the same from lockdep pov.
> 
> It looks like we need to extend nfnetlink to place the subsystem mutexes 
> in different lockdep classes.

That would be nicer! 

Otherwise I'd need "struct xt_mtdtor_param" and "struct xt_tgdtor_param" 
be extended with "bool nft_compat" to handle all required calls from the 
ip_set module.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
