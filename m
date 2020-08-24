Return-Path: <SRS0=keFs=CC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72E16C433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Aug 2020 10:48:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56D1F2071E
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Aug 2020 10:48:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgHXKr7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Aug 2020 06:47:59 -0400
Received: from correo.us.es ([193.147.175.20]:51608 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725968AbgHXKr5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Aug 2020 06:47:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 34796114807
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Aug 2020 12:47:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 20B4DDA730
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Aug 2020 12:47:49 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 16050DA704; Mon, 24 Aug 2020 12:47:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ED980DA730;
        Mon, 24 Aug 2020 12:47:46 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 24 Aug 2020 12:47:46 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D315942EE38E;
        Mon, 24 Aug 2020 12:47:46 +0200 (CEST)
Date:   Mon, 24 Aug 2020 12:47:46 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: nfnetlink: Busy-loop in nfnetlink_rcv_msg()
Message-ID: <20200824104746.GA22845@salvia>
References: <20200821230615.GW23632@orbyte.nwl.cc>
 <20200822184621.GH15804@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200822184621.GH15804@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

Sorry, I overlook your reply.

On Sat, Aug 22, 2020 at 08:46:21PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Starting firewalld with two active zones in an lxc container provokes a
> > situation in which nfnetlink_rcv_msg() loops indefinitely, because
> > nc->call_rcu() (nf_tables_getgen() in this case) returns -EAGAIN every
> > time.
> > 
> > I identified netlink_attachskb() as the originator for the above error
> > code. The conditional leading to it looks like this:
> > 
> > | if ((atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf ||
> > |      test_bit(NETLINK_S_CONGESTED, &nlk->state))) {
> > |         [...]
> > |         if (!*timeo) {
> > 
> > *timeo is zero, so this seems to be a non-blocking socket. Both
> > NETLINK_S_CONGESTED bit is set and sk->sk_rmem_alloc exceeds
> > sk->sk_rcvbuf.
> > 
> > From user space side, firewalld seems to simply call sendto() and the
> > call never returns.
> > 
> > How to solve that? I tried to find other code which does the same, but I
> > haven't found one that does any looping. Should nfnetlink_rcv_msg()
> > maybe just return -EAGAIN to the caller if it comes from call_rcu
> > backend?
> 
> Yes, I think thats the most straightforward solution.
> 
> We can of course also intercept -EAGAIN in nf_tables_api.c and translate
> it to -ENOBUFS like in nft_get_set_elem().
> 
> But I think a generic solution it better.  The call_rcu backends should
> not result in changes to nf_tables internal state so they do not load
> modules and therefore don't need a restart.

Handling this from the core would be better, so people don't have to
remember to use the nfnetlink_unicast() that I'm proposing.

Looking at the tree, call_rcu is not enough to assume this: there are
several nfnetlink subsystems calling netlink_unicast() that translate
EAGAIN to ENOBUFS, from .call and .call_rcu. The way to identify this
would be to decorate callbacks to know what are specifically GET
commands.

So either do this or just extend my patch to use nfnetlink_send()
everywhere to remove all existing translations from EAGAIN to ENOBUFS.
