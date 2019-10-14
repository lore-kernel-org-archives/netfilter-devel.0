Return-Path: <SRS0=Oskt=YH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0FDDECE58F
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Oct 2019 11:02:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B389220650
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Oct 2019 11:02:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731772AbfJNLCH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Oct 2019 07:02:07 -0400
Received: from correo.us.es ([193.147.175.20]:57790 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731503AbfJNLCG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Oct 2019 07:02:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CD56A10328F
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Oct 2019 13:02:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BCDCC1021A4
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Oct 2019 13:02:01 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B15FD1007A2; Mon, 14 Oct 2019 13:02:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A3F56D1911;
        Mon, 14 Oct 2019 13:01:59 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 14 Oct 2019 13:01:59 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 84D5B42EF42B;
        Mon, 14 Oct 2019 13:01:59 +0200 (CEST)
Date:   Mon, 14 Oct 2019 13:02:01 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Edward Cree <ecree@solarflare.com>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 nf-next] netfilter: add and use nf_hook_slow_list()
Message-ID: <20191014110201.6gnd4ewsls7bsmry@salvia>
References: <20191010223037.10811-1-fw@strlen.de>
 <2d9864c9-95d2-02c2-b256-85a07c2b2232@solarflare.com>
 <20191010225433.GK25052@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010225433.GK25052@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Oct 11, 2019 at 12:54:33AM +0200, Florian Westphal wrote:
> Edward Cree <ecree@solarflare.com> wrote:
> > On 10/10/2019 23:30, Florian Westphal wrote:
> > > NF_HOOK_LIST now only works for ipv4 and ipv6, as those are the only
> > > callers.
> > ...
> > > +
> > > +     rcu_read_lock();
> > > +     switch (pf) {
> > > +     case NFPROTO_IPV4:
> > > +             hook_head = rcu_dereference(net->nf.hooks_ipv4[hook]);
> > > +             break;
> > > +     case NFPROTO_IPV6:
> > > +             hook_head = rcu_dereference(net->nf.hooks_ipv6[hook]);
> > > +             break;
> > > +     default:
> > > +             WARN_ON_ONCE(1);
> > > +             break;
> > >       }
> > Would it not make sense instead to abstract out the switch in nf_hook()
> >  into, say, an inline function that could be called from here?  That
> >  would satisfy SPOT and also save updating this code if new callers of
> >  NF_HOOK_LIST are added in the future.
> 
> Its a matter of taste I guess.  I don't really like having all these
> inline wrappers for wrappers wrapped in wrappers.
> 
> Pablo, its up to you.  I could add __nf_hook_get_hook_head() or similar
> and use that instead of open-coding.

I'm fine with your approach, Florian. If new callers are added, this
can be done later on.
