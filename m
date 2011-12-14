From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] netfilter: add extended accounting infrastructure
 over nfnetlink
Date: Wed, 14 Dec 2011 17:50:07 +0100
Message-ID: <20111214165007.GA4765@1984>
References: <1323860443-7129-1-git-send-email-pablo@netfilter.org>
 <1323860443-7129-2-git-send-email-pablo@netfilter.org>
 <alpine.LNX.2.01.1112141439180.16886@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu,
	kaber@trash.net, thomas.jarosch@intra2net.com
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49103 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757371Ab1LNQuO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:50:14 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1112141439180.16886@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 14, 2011 at 02:43:40PM +0100, Jan Engelhardt wrote:
> On Wednesday 2011-12-14 12:00, pablo@netfilter.org wrote:
> 
> >Then, you can use one of this accounting objects in several iptables
> >rules using the new NFACCT target (which comes in a follow-up patch):
> >
> > # iptables -I INPUT -p tcp --sport 80 -j NFACCT --nfacct-name http-traffic
> > # iptables -I OUTPUT -p tcp --dport 80 -j NFACCT --nfacct-name http-traffic
> >
> >The idea is simple: if one packet matches the rule, the NFACCT target
> >updates the counters.
> 
> This smells a lot like -m quota2 --grow, except that yours uses 
> netlink instead of procfs and can only update the counters.
> 
> I suggest to turn -j NFACCT into -m nfacct instead, so that we can add 
> counting-down mode and matching capabilities, so as to replace 
> xt_quota*.

This makes sense.

My only concern is that -m nfacct will not really match anything (not
by default at least).

But with -m nfacct, we can use it in one single multi-match rule, which
comes in handy.
