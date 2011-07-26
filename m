From: Rainer Weikusat <rweikusat@mobileactivedefense.com>
Subject: Re: [PATCH] netfilter: add per-namespace logging to nfnetlink_log.c (updated)
Date: Tue, 26 Jul 2011 12:22:15 +0100
Message-ID: <8739hti8wo.fsf@sapphire.mobileactivedefense.com>
References: <8739i3fp6s.fsf@sapphire.mobileactivedefense.com>
	<20110718191956.GA2489@p183.telecom.by>
	<87hb6je5nh.fsf@sapphire.mobileactivedefense.com>
	<20110718.124638.30010338187296272.davem@davemloft.net>
	<87d3h7e43n.fsf@sapphire.mobileactivedefense.com>
	<alpine.LNX.2.01.1107182218170.9579@frira.zrqbmnf.qr>
	<878vruymq6.fsf@sapphire.mobileactivedefense.com>
	<87sjq1xab8.fsf_-_@sapphire.mobileactivedefense.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mss-uk.mssgmbh.com ([217.174.251.109]:39785 "EHLO
	mss-uk.mssgmbh.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab1GZLW1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jul 2011 07:22:27 -0400
In-Reply-To: <87sjq1xab8.fsf_-_@sapphire.mobileactivedefense.com> (Rainer Weikusat's message of "Wed\, 20 Jul 2011 16\:04\:43 +0100")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Rainer Weikusat <rw@sapphire.mobileactivedefense.com> writes:
> Presently, the nfnetlink_log.c file contains only very nominal support
> for network namespaces:

I'm going to do a second 'updated' version of that which rectifies a
couple of more-or-less minor issues with the first one (purpose of
this mail is to document the changes). Specifically,

	- the instances_via_skb function should now also compile when
          network namespace support is not supposed to be included in
          a kernel and the compiler doesn't remove the 'dead code'
          before compiling it (Some kernel data structures include a
          struct net * unconditionally, some include it only
          conditionally. In particular, struct sock and struct
          net_device belong to the latter group)

	- the nfulnl_recv_config routine now gets the net namespace to
          use by examining the ctnl argument since it is kind of
          stupid to use the more complicated route via struct skbuff
          if a simpler alternative is available

	- the unregister_pernet_subsys call has been moved to the end
          of nfnetlink_log_fini so that the init and fini codepaths
          are again axis-symmetric to each other

NB: Except in the fairly unlikely case that something like an actual
error turns up in this code, I won't send this patch again (or over
and over again :-) because I cannot possibly justify making more
essentially cosmetic changes to something which is working code I need
to solve a specifc problem I've encountered as part of my present job.
