From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: H.323 behavior
Date: Fri, 13 Apr 2007 06:45:40 -0500
Message-ID: <925A849792280C4E80C5461017A4B8A210B5E5@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
To: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
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

I was doing some h.323 testing a while ago and noticed some strange
behavior.  After thinking about it a while, I think I have an idea
what's going on. =20
=20
First test case:
=20
Linux 2.6.17.2 on one site, 2.6.18.1 on the other side.  Both sides use
proxy ARP to Polycom V500 H.323 codecs with public IP Addresses.  So it
looks like this:
=20
Polycom------Firewall with----Internet----Firewall with----Polycom
V500         2.6.18.1                     2.6.17.2         V500
Public IP   (Proxy ARP)                  (Proxy ARP)      Public IP

When either side hangs up a call and then immediately tries to call the
other side again, the call does not go through.  Tcpdump on the
firewalls shows a conversation with TCP port 1720, but the UDP packets
never start flying back and forth.  After a couple of minutes, the
problem seems to clear up and both sides can establish a call again. =20

Other test cases use the Linux system on my side and generally just an
h.323 codec directly connected to the Internet on the other side.  So
far, I have not been able to reproduce this timeout behavior in the
other test cases.  I can hang up and call right back and the other side
always answers. =20

I have a hunch this is what's going on:

The firewall on the side that hangs up the call shuts down all the
appropriate connection tracking info for the call.  But the firewall on
the other side does not shut down its connection tracking stuff.
Instead, it waits some period of time for a timeout and once this
timeout passes, then it resets its conntrack info as well.  This is just
a hunch to explain the behavior I see - I don't have proof. =20

Can I do anything about this behavior? =20

Thanks

- Greg Scott
