From: Philip Craig <philipc@snapgear.com>
Subject: Re: PPTP conntracking saga continued
Date: Wed, 17 Sep 2003 10:52:34 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F67B052.8060707@snapgear.com>
References: <44AD3126A8CE26439BBD21AB2F9CC1D81286D2@commsserver.itpartners.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Craig Box <craig@itpartners.co.nz>
In-Reply-To: <44AD3126A8CE26439BBD21AB2F9CC1D81286D2@commsserver.itpartners.co.nz>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Craig Box wrote:
> I've been trying to figure out PPTP connection tracking for some time,
> and spent half a day battling with old versions of the patches and then
> finally got the modules to compile, before reading that Harald has a new
> version out due out any day now.  

I have had success with the following:

1. Start with Linux 2.4.22
2. Apply patch-o-matic/pending/63_getorigdst-tuple-zero.patch
3. Apply patch-o-matic/extra/pptp-conntrack-nat.patch
4. Copy in the files from netfilter-extensions/helpers/pptp
5. Apply the patches from:
http://lists.netfilter.org/pipermail/netfilter-devel/2003-September/012362.html

> If I have a standard kernel.org kernel running iptables/netfilter (no
> patch-o-matic patches), I can observe the following behaivour:
> 
> * I have a DNAT on the firewall machine to send all VPN traffic (1723
> TCP/GRE) to an internal Windows PPTP server
> * From inside my LAN I can connect out to any other Windows PPTP server
> and establish a connection (the GRE replies are matched by the
> connection tracking and sent back to the internal machine, not blindly
> routed to the Windows server

Yes, because the DNAT rule is only used for packets that are not part
of an existing connection.

> * If I disconnect there is a 10 min time out in which I can't connect
> from any other machine behind my NAT (understandably; the timeout is
> counting down in /proc/net/ip_conntrack) - can someone confirm that this
> problem is worked around by the PPTP conntrack patches in p-o-m?

This is because it is using the generic protocol conntrack, which can
only distinguish between gre connections by IP address, and has a 10
minute timeout.  The pptp conntrack patch will fix this since it can
distinguish between gre connections using the call ID.

> - However -
> 
> * If I connect _outward_ to a Poptop VPN server, same network, the
> initial GRE replies come back and are DNAT'd to the internal Windows
> PPTP server, therefore the connection does not create

This is most likely because the Poptop server is faster than your client,
and it is sending an incoming GRE packet before your client sends the
outgoing packet.  There will be no existing conntrack for the incoming
packet, so it will match the DNAT rule.

> I am not sure if this is the fault of Poptop or the connection tracking.
> I would assume that, because the conntracking handles Windows servers
> right, that Poptop is at fault, and people on this list speak of a
> connid patch to Poptop that addresses this (although I can find no other
> mention of it.)

The Poptop connid bug is only a problem once you try multiple
simultaneous connections.

> Strangely enough, reading poptop's website, their FAQ
> (http://poptop.sourceforge.net/dox/qna.html) says:
> 
> "The only way to distinguish between those two clients is to filter them
> by destination call ID number found in the GRE header. In order for the
> client NAT firewall to correctly rewrite the PPTP server's replies,
> please check Philip Craig's netfilter pptp helper module available from
> the Netfilter CVS server. [..] It will be integrated in KernelMod, but
> until then, you'll have to build it yourself"
> 
> Are they referring to the same thing as Harald's PPTP conntracking
> patch?  Is there indeed a new version (that will compile cleanly against
> 2.4.22) due out soon?  Is poptop at fault, or is connection tracking?

I've never written a netfilter pptp helper, just submitted patches
for existing ones.  Harald's pptp conntracking patch is the only
one that will work, and it will fix the problems you are having.

-- 
Philip Craig - philipc@snapgear.com - http://www.SnapGear.com
SnapGear - Custom Embedded Solutions and Security Appliances
