From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PACTH nf-next] netfilter: nf_reject_ipv4: don't send tcp RST if
 the packet is non-TCP
Date: Tue, 21 Jun 2016 16:03:01 -0300
Message-ID: <20160621190301.GI18341@localhost.localdomain>
References: <1466429188-3942-1-git-send-email-zlpnobody@163.com>
 <20160620154829.GD18341@localhost.localdomain>
 <CAML_gOf0ofzsnsxP=8xW7tYfv+H91yMthLykUbOphBL0JEgJqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liping Zhang <zlpnobody@163.com>, pablo@netfilter.org,
	netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbcFUTDG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jun 2016 15:03:06 -0400
Content-Disposition: inline
In-Reply-To: <CAML_gOf0ofzsnsxP=8xW7tYfv+H91yMthLykUbOphBL0JEgJqQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 21, 2016 at 09:35:55AM +0800, Liping Zhang wrote:
> Hi Marcelo,
> 
> 2016-06-20 23:48 GMT+08:00 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>:
> >
> > A different check/log is made for ip6:
> > nf_reject_ip6_tcphdr_get():
> >         /* IP header checks: fragment, too short. */
> >         if (proto != IPPROTO_TCP || *otcplen < sizeof(struct tcphdr)) {
> >                 pr_debug("proto(%d) != IPPROTO_TCP or too short (len = %d)\n",
> >                          proto, *otcplen);
> >                 return NULL;
> >         }
> >
> > Would be nice to have some consistency on this log message as it
> > increases debug-ability.
> >
> 
> Thanks for your opinion.
> 
> But you can see, there are many inconsistent things between
> nf_reject_ip6_tcphdr_get and nf_reject_ip_tcphdr_get.

That's true, yet sooner or later we can catch up the differences.

> 
> For example, when tcp->rst is set, reject_ip6 will call
> pr_debug("RST is set\n"), while there's nothing in reject_ip4.
> 
> IMO, these debug informations are almost useless, so there's
> no need to add this debug info only for consistent with nf_reject_ip6.

Fair enough. Although I did the comment, I don't have a strong opinion
on this.

Thanks,
Marcelo

