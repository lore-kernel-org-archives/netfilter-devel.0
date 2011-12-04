From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: nfnetlink and conntrack extension question
Date: Sun, 4 Dec 2011 22:06:12 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1112042202420.5627@frira.zrqbmnf.qr>
References: <1322668453.4443.24.camel@nessa.odu> <alpine.LNX.2.01.1111301756450.9557@frira.zrqbmnf.qr> <20111130182209.GB20336@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: KOVACS Krisztian <hidden@balabit.hu>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:47823 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754521Ab1LDVGO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 Dec 2011 16:06:14 -0500
In-Reply-To: <20111130182209.GB20336@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2011-11-30 19:22, Pablo Neira Ayuso wrote:
>> 
>> As for 1, you can use genetlink, just as I do for the copy of ipset
>> in xtables-addons. Being forced to use nfnetlink has been point of
>> much discussion and ultimately, nobody was able to provide a
>> technical reason on why nfnetlink is better.
>
>Well, few differences. With genetlink:
>
>* you have to send a message to look up for the ID first (to guess the
>  multicast group and subsystem IDs).

That is to be expected and rather ok (usernames<->UID mapping is
the very same issue in many a program).

Adding myself, from the previous discussions,

* one needs to listen for ID changes

=> I hope that genetlink can be tuned so as to pin modules while
any socket to them is open, so that there will be no change.

>* you don't know how many users will using the genetlink bus. You'll
>  have to share the bandwidth with them.

That is rather a non-argument - you won't know many nfnetlink users
there will be either. But anyway, this would only apply to mcast
messages, and then only when you actually subscribed, does it not?
