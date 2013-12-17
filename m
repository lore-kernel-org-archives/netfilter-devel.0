From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: Kill unreplied conntracks by ICMP errors
Date: Tue, 17 Dec 2013 17:58:21 +0100
Message-ID: <20131217165821.GA13951@localhost>
References: <1386861575-121885-1-git-send-email-xiaosuo@gmail.com>
 <2247276.HWz9edslhi@gentoovm>
 <20131217130117.GA8852@localhost>
 <CABa6K_EoH23P8OYEDRhA4ihgKeZ-0OtW4gU0CcRLh2jDk3=8OA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>,
	xiaosuo@gmail.xom,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53717 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814Ab3LQQ61 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Dec 2013 11:58:27 -0500
Content-Disposition: inline
In-Reply-To: <CABa6K_EoH23P8OYEDRhA4ihgKeZ-0OtW4gU0CcRLh2jDk3=8OA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 17, 2013 at 10:52:02PM +0800, Changli Gao wrote:
> On Tue, Dec 17, 2013 at 9:01 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > Indeed. You can configure those two NATs to make them more
> > hole-punching friendly by dropping UDP packets to local closed ports,
> > so that conntrack entry won't be created.
> 
> Yes. But it requires the explicit configuration. Why not make it work
> by default, although it may fail in some situation? Less is better
> than none, isn't it?

With this patch, an ICMP destination unreachable - fragmentation
needed coming after a big UDP packet will trigger the removal of the
UDP conntrack entry, that should not happen.
