From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: nfnetlink and conntrack extension question
Date: Wed, 30 Nov 2011 18:05:13 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1111301756450.9557@frira.zrqbmnf.qr>
References: <1322668453.4443.24.camel@nessa.odu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:48170 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757620Ab1K3RFP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Nov 2011 12:05:15 -0500
In-Reply-To: <1322668453.4443.24.camel@nessa.odu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2011-11-30 16:54, KOVACS Krisztian wrote:
>
>There are two things remaining that prevent us doing simple out-of-tree
>kernel module builds:
>
>     1. We use nfnetlink for the userspace->kernelspace communication.
>        This works beautifully, however, since NFNL_SUBSYS_COUNT is a
>        compile-time constant there's no way of registering a subsystem
>        with an ID not known at compile time.

You can't even snatch a number because the arrays are just sized
__foobar_max-ly, and those may all be used.

>My question is whether or not removing those limitations and allowing
>runtime registration of both nfnetlink subsystems and conntrack
>extensions would be acceptable upstream? That way out-of-tree modules
>could possibly use those features without having to resort to patching
>and recompiling the kernel.

As for 1, you can use genetlink, just as I do for the copy of ipset
in xtables-addons. Being forced to use nfnetlink has been point of
much discussion and ultimately, nobody was able to provide a
technical reason on why nfnetlink is better.

The last argument made by nfnl proponents was that NETLINK_NETFILTER
was free of multicast messages from other uninteresting subsystems
(e.g. block layer), but I am questioning on whether genl really
forces you to receive (and then ignore) uninteresting mcast messages,
given one has to explicitly subscribe to nlgroups in the first place
anyway.
