From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: Kill unreplied conntracks by ICMP errors
Date: Thu, 19 Dec 2013 20:51:14 +0100
Message-ID: <20131219195114.GA4617@localhost>
References: <1386861575-121885-1-git-send-email-xiaosuo@gmail.com>
 <2247276.HWz9edslhi@gentoovm>
 <20131217130117.GA8852@localhost>
 <CABa6K_EoH23P8OYEDRhA4ihgKeZ-0OtW4gU0CcRLh2jDk3=8OA@mail.gmail.com>
 <20131217165821.GA13951@localhost>
 <CABa6K_HEpVyE5uppsUKWGowJ_aiqSggZwgc5A0eVD7P-yjcbgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>,
	xiaosuo@gmail.xom,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38683 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754993Ab3LSTvT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Dec 2013 14:51:19 -0500
Content-Disposition: inline
In-Reply-To: <CABa6K_HEpVyE5uppsUKWGowJ_aiqSggZwgc5A0eVD7P-yjcbgg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 19, 2013 at 12:29:02PM +0800, Changli Gao wrote:
> On Wed, Dec 18, 2013 at 12:58 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > With this patch, an ICMP destination unreachable - fragmentation
> > needed coming after a big UDP packet will trigger the removal of the
> > UDP conntrack entry, that should not happen.
> 
> I don't think this is a problem, as the conntrack is unreplied and the
> original packet is dropped. That means the no virtual circuit is setup
> along the path, so why do we keep the partial circuit? And the later
> restranmitted packet will set up a new conntrack in anyway.

There are protocols like RTP running over UDP which do not require to
see traffic in both directions, so that partial circuit assumption
sounds wrong to me. The behaviour that this patch introduces is
sloppy, the flow state information would be released and the counters
would be lost in that case.
