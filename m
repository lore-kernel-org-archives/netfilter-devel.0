Return-Path: <SRS0=PMCV=CL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F1B0C433E7
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Sep 2020 16:54:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C6A720767
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Sep 2020 16:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbgIBQyq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Sep 2020 12:54:46 -0400
Received: from correo.us.es ([193.147.175.20]:40868 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbgIBQyq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Sep 2020 12:54:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AB26B8C3C46
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Sep 2020 18:54:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9BF6EDA73D
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Sep 2020 18:54:44 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 918C6DA72F; Wed,  2 Sep 2020 18:54:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8022DDA73F;
        Wed,  2 Sep 2020 18:54:42 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 02 Sep 2020 18:54:42 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 648B642EF42B;
        Wed,  2 Sep 2020 18:54:42 +0200 (CEST)
Date:   Wed, 2 Sep 2020 18:54:42 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        eric@garver.life
Subject: Re: [PATCH nf,v3] netfilter: nf_tables: coalesce multiple
 notifications into one skbuff
Message-ID: <20200902165442.GA19460@salvia>
References: <20200902163743.18697-1-pablo@netfilter.org>
 <20200902163934.GF23632@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200902163934.GF23632@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 02, 2020 at 06:39:34PM +0200, Phil Sutter wrote:
> On Wed, Sep 02, 2020 at 06:37:43PM +0200, Pablo Neira Ayuso wrote:
> > On x86_64, each notification results in one skbuff allocation which
> > consumes at least 768 bytes due to the skbuff overhead.
> > 
> > This patch coalesces several notifications into one single skbuff, so
> > each notification consumes at least ~211 bytes, that ~3.5 times less
> > memory consumption. As a result, this is reducing the chances to exhaust
> > the netlink socket receive buffer.
> > 
> > Rule of thumb is that each notification batch only contains netlink
> > messages whose report flag is the same, nfnetlink_send() requires this
> > to do appropriately delivery to userspace, either via unicast (echo
> > mode) or multicast (monitor mode).
> > 
> > The skbuff control buffer is used to annotate the report flag for later
> > handling at the new coalescing routine.
> > 
> > The batch skbuff notification size is NLMSG_GOODSIZE, using a larger
> > skbuff would allow for more socket receiver buffer savings (to amortize
> > the cost of the skbuff even more), however, going over that size might
> > break userspace applications, so let's be conservative and stick to
> > NLMSG_GOODSIZE.
> > 
> > Reported-by: Phil Sutter <phil@nwl.cc>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Acked-by: Phil Sutter <phil@nwl.cc>

Thanks, I'll place this into nf.git

BTW, I assume this mitigates the problem that Eric reported? Is it
not so easy to trigger the problem after this patch?

I forgot to say, probably it would be good to monitor
/proc/net/netlink to catch how busy the socket receive buffer is
getting with your firewalld ruleset.

Thanks.
