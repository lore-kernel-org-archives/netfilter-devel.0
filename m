Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EE59C433DB
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Feb 2021 13:49:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C428664E94
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Feb 2021 13:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbhBANtD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Feb 2021 08:49:03 -0500
Received: from correo.us.es ([193.147.175.20]:51082 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231405AbhBANtA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Feb 2021 08:49:00 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 969D715C102
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2021 14:48:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8494DDA72F
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2021 14:48:16 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 79FA6DA704; Mon,  1 Feb 2021 14:48:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3D8E6DA78B;
        Mon,  1 Feb 2021 14:48:14 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 01 Feb 2021 14:48:14 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1F6EE42DC6DF;
        Mon,  1 Feb 2021 14:48:14 +0100 (CET)
Date:   Mon, 1 Feb 2021 14:48:13 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nftables: introduce table ownership
Message-ID: <20210201134813.GA24566@salvia>
References: <20210127021928.2444-1-pablo@netfilter.org>
 <20210201122455.GE12443@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210201122455.GE12443@breakpoint.cc>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Feb 01, 2021 at 01:24:55PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > A userspace daemon like firewalld might need to monitor for netlink
> > updates to detect its ruleset removal by the (global) flush ruleset
> > command to ensure ruleset persistence. This adds extra complexity from
> > userspace and, for some little time, the firewall policy is not in
> > place.
> > 
> > This patch adds the NFT_MSG_SETOWNER netlink command which allows a
> > userspace program to own the table that creates in exclusivity.
> > 
> > Tables that are owned...
> > 
> > - can only be updated and removed by the owner, non-owners hit EPERM if
> >   they try to update it or remove it.
> > - are destroyed when the owner send the NFT_MSG_UNSETOWNER command,
> >   or the netlink socket is closed or the process is gone (implicit
> >   netlink socket closure).
> > - are skipped by the global flush ruleset command.
> > - are listed in the global ruleset.
> > 
> > The userspace process that sends the new NFT_MSG_SETOWNER command need
> > to leave open the netlink socket.
> > 
> > The NFTA_TABLE_OWNER netlink attribute specifies the netlink port ID to
> > identify the owner.
> 
> At least for systemd use case, there would be a need to allow
> add/removal of set elements from other user.

Then, probably a flag for this? Such flag would work like this?

- Allow for set element updates (from any process, no ownership).
- nft flush ruleset skips flushing the set.
- nft flush set x y flushes the content of this set.

The table owner would set on such flag.

Would this work for the scenario you describe below?

> At the moment, table is created by systemd-networkd which will update
> the masquerade set.
> 
> In case systemd-nspawn is used and configured to expose container
> services via dnat that will need to add the translation map:
> 
> add table ip io.systemd.nat
> add chain ip io.systemd.nat prerouting { type nat hook prerouting priority dstnat + 1; policy accept; }
> [..]
> # new generation 2 by process 1378 (systemd-network)
> add element ip io.systemd.nat masq_saddr { 192.168.159.192/28 }
> # new generation 3 by process 1378 (systemd-network)
> add element ip io.systemd.nat map_port_ipport { tcp . 2222 : 192.168.159.201 . 22 }
> # new generation 4 by process 1512 (systemd-nspawn)
> 
> > +struct nft_owner {
> > +	struct list_head	list;
> > +	possible_net_t		net;
> > +	u32			nlpid;
> > +};
> 
> I don't see why this is needed.
> Isn't it enough to record the nlpid in the table and set a flag that the table is
> owned by that pid?

I'll have a look.

> > +		    nft_active_genmask(table, genmask)) {
> > +			if (nlpid && table->nlpid && table->nlpid != nlpid)
> > +				return ERR_PTR(-EPERM);
> > +
> 
> i.e., (table->flags & OWNED) && table->nlpid != nlpid)?
> 
> On netlink sk destruction the owner flag could be cleared or table
> could be auto-zapped.

Default behaviour right now is: table is released if owner is gone.

It should be possible to add a flag to leave the ruleset in place
(owner flag would be cleared from NETLINK_RELEASE event path).
