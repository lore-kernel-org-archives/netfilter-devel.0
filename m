From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH -next] netfilter: nf_ct_sctp: validate vtag for new
 conntrack entries
Date: Thu, 26 Nov 2015 16:12:29 +0100
Message-ID: <20151126151229.GA3412@salvia>
References: <85c8c8c570bdbf6f20f56fdef96d8017fea3cc4c.1448478477.git.marcelo.leitner@gmail.com>
 <20151125194234.GA12460@salvia>
 <5656181E.2010001@gmail.com>
 <20151125205830.GC1254@unicorn.suse.cz>
 <20151126095133.GA1612@salvia>
 <20151126141552.GH16828@macbook.localdomain>
 <20151126143328.GC32716@breakpoint.cc>
 <20151126144916.GJ16828@macbook.localdomain>
 <20151126150726.GD32716@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
	Michal Kubecek <mkubecek@suse.cz>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org,
	Vlad Yasevich <vyasevich@gmail.com>,
	Neil Horman <nhorman@tuxdriver.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54706 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbbKZPMg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Nov 2015 10:12:36 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id AA89D613A3
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2015 16:12:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 947EBDA81D
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2015 16:12:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9B278DA801
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2015 16:12:30 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151126150726.GD32716@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 26, 2015 at 04:07:26PM +0100, Florian Westphal wrote:
> I would prefer to NOT force people to use extra connection tracking code
> for sctp if they don't need it.
> 
> Most distributions will ship with all of this as '=m', but IMHO its safe
> to assume that most users will in fact not use sctp (but conntrack for
> udp and tcp).

Enabling features through modprobe seems not to be a good idea
anymore, now we've got namespaces.

We should probably go back to the idea of explicit conntrack
configuration through rules that we discussed many times before.
