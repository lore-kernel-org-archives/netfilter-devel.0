From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: Older version of PPTP patch drops
Date: Fri, 17 Mar 2006 13:47:51 -0600
Message-ID: <925A849792280C4E80C5461017A4B8A2032246@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
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

Hi all -=20

This goes back a while.  I have a couple of reports about PPTP servers
dropping connections after about 2 1/2 minutes.  I don't recall anything
in the archives about this so maybe the problem is still happening with
the latest version.  Anyway, the firewalls at both problem sites are
using iptables 1.2.11, POM 20040621, and kernel 2.4.27.  When I changed
one site from an even older version of the PPTP patch to the one I am
using now, I started getting reports of some remote clients dropping the
connections.  That was last summer and I didn't put much effort into
troubleshooting it.  But just a few minutes ago, I ran across another
one acting the same way. =20

Here is a tcpdump trace from the problem site a few minutes ago.  I
gathered as much data as I could before he got impatient with me.  You
can see the packets flying while he was trying a download - and then
suddenly everything stopped except for a couple of control messages. =20

The layout at both sites looks like this:

Remote (home)              Central site (at the office)

WinXP------Internet------Firewall--------Win2000 or 2003
PC                       with PPTP       server with RRAS
                         patch

11:52:39.096399 66.173.74.67 > 24.245.30.139: gre [KSv1] ID:7887 S:4574
ppp:=20
11:52:39.096516 66.173.74.67 > 24.245.30.139: gre [KSv1] ID:7887 S:4575
ppp:=20
11:52:39.163505 24.245.30.139 > 66.173.74.67: gre [KSAv1] ID:c3e6 S:2941
A:4556 ppp:=20
11:52:39.164137 66.173.74.67 > 24.245.30.139: gre [KSAv1] ID:7887 S:4576
A:2941 ppp:=20
11:52:39.164309 66.173.74.67 > 24.245.30.139: gre [KSv1] ID:7887 S:4577
ppp:=20
11:52:39.177507 24.245.30.139 > 66.173.74.67: gre [KSAv1] ID:c3e6 S:2942
A:4558 ppp:=20
11:52:39.178083 66.173.74.67 > 24.245.30.139: gre [KSAv1] ID:7887 S:4578
A:2942 ppp:=20
11:52:39.178100 66.173.74.67 > 24.245.30.139: gre [KSv1] ID:7887 S:4579
ppp:=20
11:52:39.193473 24.245.30.139 > 66.173.74.67: gre [KSAv1] ID:c3e6 S:2943
A:4560 ppp:=20
11:52:39.267376 66.173.74.67 > 24.245.30.139: gre [KAv1] ID:7887 A:2943
[|gre]
11:52:39.689669 66.173.74.67 > 24.245.30.139: gre [KSv1] ID:7887 S:4580
ppp:=20
11:52:40.783363 66.173.74.67 > 24.245.30.139: gre [KSv1] ID:7887 S:4581
ppp:=20
11:52:42.970808 66.173.74.67 > 24.245.30.139: gre [KSv1] ID:7887 S:4582
ppp:=20
11:52:47.345657 66.173.74.67 > 24.245.30.139: gre [KSv1] ID:7887 S:4583
ppp:=20

Connections to/from my place (2 Internet feeds - a DSL and a T1) both
work fine.  I can accept inbound and go outbound all over the place.  Of
course I'm also using a Linux firewall here.  One of my problem sites
has a Netgear appliance at her boundary at home.  When she skips the
Netgear and hooks up directly to her DSL then PPTP to her office works.
The other site has D-LInk appliance. =20

Should I be looking for some sort of timing issue?  Or has anyone heard
of this kind thing before and maybe its fixed with 2.6.16?

Thanks

- Greg Scott
