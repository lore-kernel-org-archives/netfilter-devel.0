From: "Eliot, Wireless and Server Administrator,
	Great Lakes Internet" <support8@greatlakes.net>
Subject: POSTROUTING hooks
Date: Mon, 5 Jun 2006 10:21:47 -0400
Message-ID: <0633E0EDB4F25F43A2D7179CA11FAFAB25544B@xavier.staff.greatlakes.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: "Netfilter Development Mailinglist" <netfilter-devel@lists.netfilter.org>
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


Where in the kernel's packet delivery process does the POSTROUTING chain
hook in?=20

I'm trying to figure out how to write a module to allow matching on the
destination MAC address. From what I have been able to figure out so
far, it looks like the destination MAC is not actually set until right
before the packet goes out of the interface. Now, I have not been able
to find the code that would confirm this, so if anyone can point me to
the exact position where the destination MAC address is set, that would
be helpful. However, from what I have been able to observe with logging
and some quick and dirty modifications to a couple of modules to print
out some extra debugging info, this appears to be the case.=20

What would it take to modify the Netfilter code to make the POSTROUTING
chain hook in AFTER the destination MAC is set, but BEFORE it gets sent
out the interface?=20

If this change is made, what types of things might it break?

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
