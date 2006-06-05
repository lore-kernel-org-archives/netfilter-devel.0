From: "Eliot, Wireless and Server Administrator,
	Great Lakes Internet" <support8@greatlakes.net>
Subject: RE: POSTROUTING hooks
Date: Mon, 5 Jun 2006 12:46:52 -0400
Message-ID: <0633E0EDB4F25F43A2D7179CA11FAFAB255453@xavier.staff.greatlakes.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: "Patrick Schaaf" <bof@bof.de>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

> -----Original Message-----
> From: Patrick Schaaf [mailto:bof@bof.de]
> Sent: Monday, June 05, 2006 12:01 PM
> To: Eliot, Wireless and Server Administrator, Great Lakes Internet
> Cc: Netfilter Development Mailinglist
> Subject: Re: POSTROUTING hooks
>=20
> > Where in the kernel's packet delivery process does the POSTROUTING
chain
> > hook in?
>=20
> You can get a pretty accurate answer, for any kernel version, by doing
> 	grep NF_HOOK /usr/src/linux-whatever/net/ipv?/*.c
>=20
> For the 2.4.18 kernel I'm looking at, there are three calls to
> NF_IP_POST_ROUTING in net/ipv4/ip_output.c. Two of them are
> obviously concerned with multicast, leaving one call in
> ip_finish_output.
>=20
> So, POST_ROUTING is called when the packet leaves the IP stack.
>=20
> As you can see there, only after POST_ROUTING is the packet queued
> to some network device. And only after that is ARP done, and only
> then is a destination MAC known (temporarily, until ARP changes
> something under your feet).
>=20

Well, then how about we use a different approach. In my case, I don't
need to be guaranteed that the MAC address returned is the correct one
at all times. All I need to know is that it is very likely to be the
correct one.

So, given that the kernel keeps a mapping of the IP->MAC and the packet
contains the destination IP, why can't we just look up the destination
MAC for that IP in the kernel table, if it exists. Once the connection
is established this type of matching would work because ARP has already
happened for some packets on the network to this destination. Therefore,
there should be an entry in the table (assuming it has not already timed
out).=20

Obviously, this only works when the router is on the destination network
that the destination IP is on. Also, this will obviously not match the
first packet sent to the destination IP (since ARP has not occurred).=20

But, if the router is on the same network the destination IP is on, and
if ARP has already occurred, then this will give as good of an
estimation of what the destination MAC address is as is possible given
the circumstances.=20

If we cannot look up the MAC, the module will not return a match. If we
cannot look up the MAC associated with the destination IP, we don't
match. We also don't do any active stuff to try to figure it out. This
would be a completely passive process. Only in certain circumstances
would this yield a result, but in those circumstances, it would be
extremely useful. In my case, it would give me what I needed.=20

Is there anything flawed in this logic? Any other things about the Linux
kernel IP stack that might throw a kink in my plans?
=20
Eliot Gable
Certified Wireless Network Administrator (CWNA)
Certified Wireless Security Professional (CWSP)
Cisco Certified Network Associate (CCNA)
CompTIA Security+ Certified
CompTIA Network+ Certified
Network and System Engineer
Great Lakes Internet, Inc.
112 North Howard
Croswell, MI 48422
(810) 679-3395
(877) 558-8324
=20
Now offering Broadband Wireless Internet access in Croswell, Lexington,
Brown City, Yale, Worth Township, and Sandusky. Call for details.
