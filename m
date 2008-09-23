From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Getting IPVS and Netfilter SNAT to play together
Date: Tue, 23 Sep 2008 08:33:27 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809230827410.29878@fbirervta.pbzchgretzou.qr>
References: <f4845fc0809230313y14e69dc6s7b5e3e2f33f6beae@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, Simon Horman <horms@verge.net.au>,
	Joseph Mack NA3T <jmack@wm7d.net>
To: Julius Volz <juliusv@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56949 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbYIWMd3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Sep 2008 08:33:29 -0400
In-Reply-To: <f4845fc0809230313y14e69dc6s7b5e3e2f33f6beae@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-09-23 06:13, Julius Volz wrote:
>
>Any ideas why the first packets never appear in the POSTROUTING chain
>but the ACK does?

It is not the first packet of the TCP connection that will show up
in the nat table, it is the first packet of the *tracked* connection,
which may not match the boundary of the classical connection.

Like...
	-t raw -A PREROUTING -p tcp --tcp-flags SYN,ACK,RST,FIN SYN -j NOTRACK
	-t raw -A PREROUTING -p tcp --tcp-flags SYN,ACK,RST,FIN SYN,ACK -j NOTRACK

Will cause the exact behavior that the 3rd packet that would match
--tcp-flags SYN,ACK,RST,FIN ACK will be the one showing up in the nat table.

As such, it might be worth looking at the LOGMARK target in Xtables-addons
which will print out whether such a connection even exists/has been untracked.
Alternatively, if you don't mind typing lots,

	-t mangle -A PREROUTING -m conntrack --ctstate INVALID \
		-j LOG --log-prefix "this won't shop up in nat: "
	-t mangle -A PREROUTING -m conntrack --ctstate UNTRACKED \
		-j LOG --log-prefix "neither will this: "
