From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_owner-xt_socket plans
Date: Tue, 22 Jan 2008 00:04:09 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801212347090.25080@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801201914260.14598@fbirervta.pbzchgretzou.qr>
 <479461C2.1060703@balabit.hu> <Pine.LNX.4.64.0801211156320.24186@fbirervta.pbzchgretzou.qr>
 <20080121122044.GA20295@sch.bme.hu> <Pine.LNX.4.64.0801211412380.24186@fbirervta.pbzchgretzou.qr>
 <20080121144655.GB373@sch.bme.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Laszlo Attila Toth <panther@balabit.hu>,
	Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38887 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbYAUXEK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:04:10 -0500
In-Reply-To: <20080121144655.GB373@sch.bme.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 21 2008 15:46, KOVACS Krisztian wrote:
>> 
>> What problem? Maybe it's a bit shortsighted, but I guess if you just
>> use the conntrack origsrc/dst instead of iph->saddr, it should be a
>> no-brainer, no?
>
>For SNAT, this would be possible. It still wouldn't work for DNAT,
>however... (Imagine you have a DNAT rule on nat/PREROUTING and try to do a
>socket match _before_ traversing that chain.)

While you are right, I do not see a use case for combining -m socket
with DNAT.

There are a few cases I can think of:

1. The user wants to do transparent proxying, i.e. rerouting the
   packet a localhost process. That is done with -m socket and -j
   MARK, and a reroute based on fwmark, without DNAT.

2. The user wants to forward the packet. In this case, using -m
   socket does not make much sense because the packet is not going to
   be delivered locally.

3. The packet is directly addressed to the host (e.g. 1.3.3.7) itself.
   The host has a secondary IPv4 address (1.3.3.8), and the user
   does, for whatever reason:

	-t nat -A PREROUTING -d 1.3.3.7 -p tcp --dport 80 \
	-j DNAT --to 1.3.3.8:81

   In this third case, I cannot see a reason why one would want to
   use -m socket in a table that comes before "nat".

You are free to englighten me with a (believable) scenario not listed
here that does depend on socket being in mangle, and uses DNAT :-)
