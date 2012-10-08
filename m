From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: iptables-dev Source Example
Date: Mon, 8 Oct 2012 11:42:11 -0700
Message-ID: <CAHo-OoyUUHju8du-Otd6vfgv_ORz-Y_PrPB0VDKbU74jYy9hjg@mail.gmail.com>
References: <5072D6F8.2010707@iit.demokritos.gr>
	<20121008152237.GA8350@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Katia Sarsempagieva <katias@iit.demokritos.gr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37657 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab2JHSmM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2012 14:42:12 -0400
Received: by mail-vc0-f174.google.com with SMTP id fo13so4951699vcb.19
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Oct 2012 11:42:12 -0700 (PDT)
In-Reply-To: <20121008152237.GA8350@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> What I want to do is to write my very own program using the iptables
>> library to query the interface information
>> of various machines (queues, lost packets, total packets etc).

I'm also not sure why you're even thinking about the 'iptables'
library - it has to do with firewall management.
Sounds like what you're wanting to query is basic interface statistics.
I would suggest looking at programs like ip (iproute / iproute2)
and/or netlink libraries (or worst case the obsolete ifconfig).

- Maciej
