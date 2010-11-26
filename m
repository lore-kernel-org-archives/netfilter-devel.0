From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Xtables2 Netlink spec
Date: Fri, 26 Nov 2010 20:48:47 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1011262045410.18201@blackhole.kfki.hu>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr> <4CEE4B94.8010307@netfilter.org> <alpine.LNX.2.01.1011251327140.21752@obet.zrqbmnf.qr> <4CEE70CE.60502@netfilter.org> <alpine.LNX.2.01.1011251525490.3245@obet.zrqbmnf.qr> <4CEF6F12.7080601@netfilter.org>
 <alpine.LNX.2.01.1011261055210.24563@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:37021 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab0KZTss (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Nov 2010 14:48:48 -0500
In-Reply-To: <alpine.LNX.2.01.1011261055210.24563@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 26 Nov 2010, Jan Engelhardt wrote:

> On Friday 2010-11-26 09:25, Pablo Neira Ayuso wrote:
> >
> >>[...] memory needs to be allocated and stored, right before
> >>netlink_dump_start is called. [But] because nlk->cb->cb_args is
> >>inaccessible from outside[...], the lookup and allocation is
> >>currently done inside the dump function[...]
> >
> >What is that initial data handling in dumps for?
> 
> Making an atomic snapshot/copy of the table. A userspace client
> could take almost indefinitely on retrieving a table, so it is
> possible that something else changes tables meanwhile.

Why don't you lock the tables during dumping? That way the tables won't 
change, whatever long time the dump takes. Snapshotting the table looks as 
wasting memory and time.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
