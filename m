From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Fwd: iptables-1.4.1-1.4.2 change "Warn about use of DROP in nat
 table"
Date: Tue, 13 Jan 2009 10:30:23 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901131016120.7823@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0901131012390.7823@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55027 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064AbZAMJaY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Jan 2009 04:30:24 -0500
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id 32EE31C00DB2F
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Jan 2009 10:30:23 +0100 (CET)
In-Reply-To: <alpine.LSU.2.00.0901131012390.7823@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-01-13 10:13, Jan Engelhardt wrote:
>
>Is there any particular reason for removing DROP target from nat table?
>Some people may be using this functionality (like me).

It is a hack, not a functionality. All the the user is supposed to do
with the NAT table is decide whether or not some address
transformation should happen. It is _not_ an access control
mechanism, because there is no standards-level guarantee that all
packets you want to police would go through it, and NOTRACK is just
the most obvious one. I would go as far as saying that DROP is not
guaranteed to drop it at all - look at the BROUTING table.

>Access
>control for lan clients on my routers is done in PREROUTING chain of nat
>table in following way (in great simplification):
>- DNAT to infoHost:infoPort1 tcp packets to port 80 from IP/MAC pair in
>ipset INFO-GRP1
>- RETURN packets from IP/MAC pair in ipset
>- DNAT tcp packets to port 80 to infoHost:infoPort2
>- DROP rest of the packets

You simply use -t filter -m conntrack ! --ctstate DNAT -j DROP instead
of the last rule.

>I know DROPping in nat table isn't perfect (doesn't filterout already
>established "connections"), but it should be less cpu-intensive as it's
>done for the first packet of a "connection".

And what would be the excuse if you had IPv6 traffic? ;-)

If you are _that_ concerned about CPU usage (and I remember there
being an analysis of Netfilter's speed compared to other solutions; a
document somewhere on people.netfilter.org), you would have done it
in the mangle table, not in nat, short of saying that that is
probably not the purpose of mangle either.

There were once thoughts to combine some tables because of the
redundancy, but the thought timed out :)
