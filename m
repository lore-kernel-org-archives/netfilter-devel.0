Return-Path: <SRS0=Al8F=CB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30B6CC433E1
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Aug 2020 12:04:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1033220720
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Aug 2020 12:04:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbgHWMEl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 Aug 2020 08:04:41 -0400
Received: from correo.us.es ([193.147.175.20]:44940 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgHWMEi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Aug 2020 08:04:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 06369DA705
        for <netfilter-devel@vger.kernel.org>; Sun, 23 Aug 2020 14:04:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EA60BDA722
        for <netfilter-devel@vger.kernel.org>; Sun, 23 Aug 2020 14:04:36 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E0082DA73F; Sun, 23 Aug 2020 14:04:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 74E9EDA722;
        Sun, 23 Aug 2020 14:04:34 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 23 Aug 2020 14:04:34 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 589A342EE38F;
        Sun, 23 Aug 2020 14:04:34 +0200 (CEST)
Date:   Sun, 23 Aug 2020 14:04:34 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: Re: nfnetlink: Busy-loop in nfnetlink_rcv_msg()
Message-ID: <20200823120434.GA16617@salvia>
References: <20200821230615.GW23632@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200821230615.GW23632@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Sat, Aug 22, 2020 at 01:06:15AM +0200, Phil Sutter wrote:
> Hi,
> 
> Starting firewalld with two active zones in an lxc container provokes a
> situation in which nfnetlink_rcv_msg() loops indefinitely, because
> nc->call_rcu() (nf_tables_getgen() in this case) returns -EAGAIN every
> time.
> 
> I identified netlink_attachskb() as the originator for the above error
> code. The conditional leading to it looks like this:
> 
> | if ((atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf ||
> |      test_bit(NETLINK_S_CONGESTED, &nlk->state))) {
> |         [...]
> |         if (!*timeo) {
> 
> *timeo is zero, so this seems to be a non-blocking socket. Both
> NETLINK_S_CONGESTED bit is set and sk->sk_rmem_alloc exceeds
> sk->sk_rcvbuf.
> 
> From user space side, firewalld seems to simply call sendto() and the
> call never returns.
> 
> How to solve that? I tried to find other code which does the same, but I
> haven't found one that does any looping. Should nfnetlink_rcv_msg()
> maybe just return -EAGAIN to the caller if it comes from call_rcu
> backend?

It's a bug in the netlink frontend, which erroneously reports -EAGAIN
to the nfnetlink when the socket buffer is full, see:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20200823115536.16631-1-pablo@netfilter.org/

> This happening only in an lxc container may be due to some setsockopt()
> calls not being allowed. In particular, setsockopt(SO_RCVBUFFORCE)
> returns EPERM.

SO_RCVBUFFORCE fails with EPERM if CAP_NET_ADMIN is not available.

> The value of sk_rcvbuf is 425984, BTW. sk_rmem_alloc is 426240. In user
> space, I see a call to setsockopt(SO_RCVBUF) with value 4194304. No idea
> if this is related and how.

Next problem is to track why socket buffer is getting full with
GET_GENID.

firewalld heavily uses NLM_F_ECHO, there I can see how it can easily
reach the default socket buffer size, but with GET_GENID I'm not sure
yet, probably the problem is elsewhere but it manifests in GET_GENID
because it's the first thing that is done when sending a batch (maybe
there are unread messages in the socket buffer, you might check
/proc/net/netlink to see if the socket buffer keeps growing as
firewalld moves on).

Is this easy to reproduce? Or does this happens after some time of
firewalld execution?
