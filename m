From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables-addons - problem including nf_nat.h in userspace
 plugin
Date: Mon, 22 Nov 2010 14:52:31 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011221447001.18089@obet.zrqbmnf.qr>
References: <20101121224731.22fced2b@catus>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Marek Kierdelewicz <marek@piasta.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49334 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604Ab0KVNwc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Nov 2010 08:52:32 -0500
In-Reply-To: <20101121224731.22fced2b@catus>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2010-11-21 22:47, Marek Kierdelewicz wrote:
>
>I'm writing a new netfilter module and I'm using xtables-addons[...]
>Iptables userspace plugin for the module needs definition of "struct
>nf_nat_multi_range", so I added following line to libxt_xxxx.c:
>#include <net/netfilter/nf_nat.h>
>Unfortunately I get following message during make: 
>warning: net/netfilter/nf_nat.h: No such file or directory
>... and compilation fails.
>I was able to make it work by copying nf_nat.h and nf_conntrack_tuple.h
>to extension directory in xtables-addons tree and by modifying include
>in libxt_xxxx.c to "nf_nat.h", but this doesn't seem to be the proper
>way of doing things.

Well, iptables also copies them rather than properly relying on
something from <linux/*>. Yes, it's not proper. Patrick should know
the details about the what and why.

As for xt-a, preferable location is

linux-src/include/net/netfilter/nf_nat.h ->
xtables-addons/include/net/netfilter/nf_nat.h

Then #include <net/...> should work.
