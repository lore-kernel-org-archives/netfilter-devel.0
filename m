From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_ct_sctp: validate vtag for new conntrack
 entries
Date: Wed, 30 Dec 2015 01:03:17 +0100
Message-ID: <20151230000317.GA1480@salvia>
References: <85c8c8c570bdbf6f20f56fdef96d8017fea3cc4c.1449579256.git.marcelo.leitner@gmail.com>
 <20151210120233.GA2084@salvia>
 <56697B14.3010909@gmail.com>
 <20151210134247.GA3942@salvia>
 <20151210140625.GC3886@mrl.redhat.com>
 <20151210170647.GA1547@salvia>
 <20151215190304.GA3724@mrl.redhat.com>
 <20151217110512.GA1863@salvia>
 <567BEA14.9030007@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org,
	Vlad Yasevich <vyasevich@gmail.com>,
	Neil Horman <nhorman@tuxdriver.com>, mkubecek@suse.cz
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44793 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753838AbbL3ADW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Dec 2015 19:03:22 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 996C71022B4
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Dec 2015 01:03:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 88FE7DA7FF
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Dec 2015 01:03:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B3DB9DA814
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Dec 2015 01:03:18 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <567BEA14.9030007@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Marcelo,

On Thu, Dec 24, 2015 at 10:50:28AM -0200, Marcelo Ricardo Leitner wrote:
> I can see how it would work for the vtag-tracking scenario, I think. I'm
> just not seeing the non-tracking one (routers in the middle) yet.
> It doesn't seem it can fit the helper way because it can't prepare
> expectations as it doesn't see the packets in the initial path,
> meaning that we would have to have 2 ways of handling such new
> entries.

We assume that conntrack sees all traffic in our existing helpers,
think of tcp. Otherwise, we may classify packets as invalid if we
don't all packets that belong to the flow.

> It would work like: if the helper is not present, allow heartbeats with any
> vtag like it currently is. Otherwise, for validating vtag too, only allow
> them via expectations.

I'm starting to think the lazy multihoming support is problematic
since you can actually allow pushing holes into the firewall, how easy
would be to push holes with this mode?

You can probably achieve the same effect by allowing heartbearts go
through via NOTRACK and then have some connection pickup from the
middle feature. That, however, would make the user fully aware of the
limitations since it would require explicit configuration.
