From: Chris Wilson <chris@aptivate.org>
Subject: UDP packets sent with wrong source address after routing change
 [AV#3431]
Date: Thu, 8 Nov 2012 16:35:33 +0000 (GMT)
Message-ID: <alpine.DEB.2.02.1211081627150.6644@lap-x201>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from one-mail.aptivate.org ([87.106.150.205]:47392 "EHLO
	one-mail.aptivate.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756299Ab2KHREx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Nov 2012 12:04:53 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dear sirs,

I think I've found a bug or limitation with the way conntrack works. It's 
been discovered several times:

* http://forum.voxilla.com/threads/pap2t-registers-only-on-manual-port-change.33252/
* http://tomatousb.org/forum/t-272891
* http://community.plus.net/forum/index.php?topic=61369.0;wap2
* http://www.spinics.net/lists/netfilter/msg53056.html
* https://www.google.co.uk/search?q=udp%20conntrack%20source%20address%20changes
* http://www.spinics.net/lists/netfilter/msg53056.html

Summary: UDP devices (e.g. SIP phones) that don't change their source 
port, behind NAT, when routing to their destination changes, keep a 
conntrack entry valid which contains the old (wrong) SNAT-to address and 
reply address, so they are sent with the wrong IP and replies would not be 
forwarded either.

(I apologise if this is already known and fixed; if so I would appreciate
a pointer to the fix or documentation).

The details:

This only seems to happen when you're using a UDP device behind a Linux
NAT router, and your routing to the destination host changes, because:

* You bring up a VPN tunnel and the SIP destination is at the other end of
that tunnel; or

* Your default route changes because you failover to another provider.

We observe packets from the UDP device leaving the router on the new
destination interface, but with the old source address, which is not
appropriate for that interface, and is thus discarded.

Ideally the UDP device would notice that its connection is down and try to
reconnect. If the source port changes (as it does with TCP), this works
around the problem, as a new conntrack entry is created and the old one
eventually discarded. However some UDP devices use a fixed port,
particularly ones that expect incoming connections, such as SIP devices.

One could argue that this UDP device behaviour is broken, but many devices 
do not have the option to use a random or changing source port (e.g. the 
popular Linksys PAP2T) and I think this case could and should be handled 
by iptables.

The logical option seems to be that if the packet matches an existing
conntrack entry, but is going to be sent with a different source address,
then it should not actually match that entry. So the tuple for lookup in
the conntrack table should include the source address and port after SNAT.
However I suspect this is not easily generalisable to other NAT types, and
violates layering (the source address and port after SNAT may not be
available at the time of the lookup) so I guess there may be a more
acceptable solution.

Another option which doesn't violate layering might be to update the 
NAT rule when the outgoing address is known (after routing), if it's 
different to the current outgoing address. This would break existing TCP 
connections if the routing changes, but in most cases the connection is 
already broken by the routing change, and what we're trying to fix is 
that future connection attempts, reusing the same conntrack, should not 
fail as well.

If conntrack-tools worked on centos 5 then I could use it to remove the
stale conntrack entry after the upstream connection fails over, but this
is hacky and specific to my use case, so people will continue to
run into this problem with commodity routers running Linux.

Another option might be to remember the destination interface as part of
the conntrack entry, and continue to send matching packets out of that
interface even if the routing changes. This could probably be hacked
together with fwmark for a fixed set of interfaces. It also doesn't
handle the case where there's a good reason for the failover, e.g. the
original interface has failed or is now down for some reason.

Please let me know if you'd like some more details or there's anything
else I can do to help. It should be fairly easy to create a test case now.

Cheers, Chris.
-- 
Aptivate | http://www.aptivate.org | Phone: +44 1223 967 838
Future Business, Cam City FC, Milton Rd, Cambridge, CB4 1UY, UK

Aptivate is a not-for-profit company registered in England and Wales
with company number 04980791.
