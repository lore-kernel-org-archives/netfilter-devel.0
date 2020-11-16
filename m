Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF578C63777
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Nov 2020 22:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C3E1223C7
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Nov 2020 22:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728976AbgKPWSW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Nov 2020 17:18:22 -0500
Received: from correo.us.es ([193.147.175.20]:48582 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728889AbgKPWSV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Nov 2020 17:18:21 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1FEAEDED25
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2020 23:18:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 10572DA4C7
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2020 23:18:18 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 05A60DA704; Mon, 16 Nov 2020 23:18:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BD5F0DA730;
        Mon, 16 Nov 2020 23:18:15 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 16 Nov 2020 23:18:15 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9E11B42EF9E0;
        Mon, 16 Nov 2020 23:18:15 +0100 (CET)
Date:   Mon, 16 Nov 2020 23:18:15 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, razor@blackwall.org, jeremy@azazel.net
Subject: Re: [PATCH net-next,v3 0/9] netfilter: flowtable bridge and vlan
 enhancements
Message-ID: <20201116221815.GA6682@salvia>
References: <20201111193737.1793-1-pablo@netfilter.org>
 <20201113175556.25e57856@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201114115906.GA21025@salvia>
 <87sg9cjaxo.fsf@waldekranz.com>
 <20201114090347.2e7c1457@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201114090347.2e7c1457@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Nov 14, 2020 at 09:03:47AM -0800, Jakub Kicinski wrote:
> On Sat, 14 Nov 2020 15:00:03 +0100 Tobias Waldekranz wrote:
> > On Sat, Nov 14, 2020 at 12:59, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > If any of the flowtable device goes down / removed, the entries are
> > > removed from the flowtable. This means packets of existing flows are
> > > pushed up back to classic bridge / forwarding path to re-evaluate the
> > > fast path.
> > >
> > > For each new flow, the fast path that is selected freshly, so they use
> > > the up-to-date FDB to select a new bridge port.
> > >
> > > Existing flows still follow the old path. The same happens with FIB
> > > currently.
> > >
> > > It should be possible to explore purging entries in the flowtable that
> > > are stale due to changes in the topology (either in FDB or FIB).
> > >
> > > What scenario do you have specifically in mind? Something like VM
> > > migrates from one bridge port to another?  
> 
> Indeed, 2 VMs A and B, talking to each other, A is _outside_ the
> system (reachable via eth0), B is inside (veth1). When A moves inside
> and gets its veth. Neither B's veth1 not eth0 will change state, so
> cache wouldn't get flushed, right?

The flow tuple includes the input interface as part of the hash key,
so packets will not match the existing entries in the flowtable after
the topology update. The stale flow entries are removed after 30 seconds
if no matching packets are seen. New flow entries will be created for
the new topology, a few packets have to go through the classic
forwarding path so the new flow entries that represent the flow in the
new topology are created.
