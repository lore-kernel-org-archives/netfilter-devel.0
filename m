From: alex@dhost.ro
Subject: [Fwd: Re: [netfilter-core] Bug on conntrack?]
Date: Thu, 19 Nov 2009 18:03:01 +0200
Message-ID: <422110e23c4d48d73c9162967345ea58.squirrel@mail.dhost.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.dhost.ro ([94.52.43.166]:7617 "EHLO mail.dhost.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756859AbZKSQKA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Nov 2009 11:10:00 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


 Hy i'm trying to add a rule in firewall but i receive this error:

 iptables v1.4.2: conntrack: Bad value for "--expires" option: "1:1000"
 Try `iptables -h' or 'iptables --help' for more information.
 iptables v1.4.2: conntrack: Bad value for "--expires" option: "1:1000"
 Try `iptables -h' or 'iptables --help' for more information.

 The lines that i want to add are:
 $IPTABLES -A RST_LOOP_OUT -d $IP_LOOP -p tcp --sport $PORT_LOOP
--tcp-flags ALL PSH,ACK -m conntrack --ctexpire 1:1000 -j REJECT
--reject-with tcp-reset

 $IPTABLES -A RST_LOOP_OUT -d $IP_LOOP -p tcp --sport $PORT_LOOP
--tcp-flags ALL FIN,PSH,ACK -j REJECT -m conntrack --ctexpire 1:1000
--reject-with tcp-reset

 If  i give a single value to --ctexpire it works (ex: --ctexpire 1 ) I've
searched on google a lot of days but without any result. could you help
me? Thank's





