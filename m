From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [IPTABLES] the same options for different kinds of matches don't
 work
Date: Fri, 15 Aug 2008 15:36:48 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808151535100.10478@fbirervta.pbzchgretzou.qr>
References: <412e6f7f0808150951u2f2d58afn8340c64fed9de2a2@mail.gmail.com> <Pine.LNX.4.64.0808152127180.20054@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Changli Gao <xiaosuo@gmail.com>, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47192 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759872AbYHOTgt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Aug 2008 15:36:49 -0400
In-Reply-To: <Pine.LNX.4.64.0808152127180.20054@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-08-15 15:31, Jozsef Kadlecsik wrote:
>> For example:
>> 
>> iptables -t mangle -A PREROUTING -m a --mac-source 00:11:22:33:44:55
>> -m b --mac-source 00:11:22:33:44:55 -j ACCEPT
>> 
>> the above command will fail due to the later match.
>
>Yes: you should use match-specific options, like
>
>iptables -t mangle -A PREROUTING -m a --a-mac-source 00:11:22:33:44:55
>-m b --b-mac-source 00:11:22:33:44:55 -j ACCEPT

I disagree. If you chain multiple matches, e.g.

-m condition --name FOO -m conidtion --name BAR

you can't choose a different option name naturally. Hence I am of the opinion
that different matches should also support this syntax.
