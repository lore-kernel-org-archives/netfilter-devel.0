From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Xtables-addon compile failure agains iptables-git (works agains
 v1.4.2)
Date: Thu, 12 Feb 2009 16:08:16 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902121604240.5658@fbirervta.pbzchgretzou.qr>
References: <1234451039.21893.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers <netfilter-devel@vger.kernel.org>
To: Jesper Dangaard Brouer <jdb@comx.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49043 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759984AbZBLPIS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2009 10:08:18 -0500
In-Reply-To: <1234451039.21893.14.camel@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-02-12 16:03, Jesper Dangaard Brouer wrote:

>Hi Jan,
>
>I wanted to try out your Xtables-addon tree (at
>git://dev.medozas.de/xtables-addons).
>
>It fails compiling it against the latest iptables git tree, but works
>against tag v1.4.2.

Yes, known issue.

>The problem is that:
> 1. param_act() has been renamed to xtables_param_act()
> 2. flags has been renamed P_* -> XTF_*
> 3. string_to_number() converted to xtables_strtoui()
> 4. strtonum() is renamed to xtables_strtoui()
>
>I tracked down the problem to some of your own commits:
>
> a41545ca7cde: libxtables: prefix/order - param_act
> 5f2922cfc0bb: libxtables: prefix/order - strtoui
>
>How do you want to keep Xtables-addon compatible between v1.4.2 and
>v1.4.3?

I decided I do not want to. Once 1.4.3 goes live, Xtables-addons moves
with it. That makes it easier for me...

As for the user of whom we should be aware too: it is easier to
upgrade iptables than it is to upgrade the kernel, hence I think it
is a viable option to spend the time gained by doing so at keeping
the kernel-level code workable in a wide range of kernel versions.
