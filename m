From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: Dell PE2650 with integrated Broadcom NIC and NIC hardware TCP
	checksums messes up PPTP
Date: Tue, 26 Sep 2006 11:30:03 -0500
Message-ID: <925A849792280C4E80C5461017A4B8A206FBCB@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Cc: prossow@ScholarshipAmerica.org, Patrick McHardy <kaber@trash.net>,
	Mike McRae <Mike_McRae@schneidermans.com>
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

(Trying again, this time formatted with plain text)
=20
This is not an IP_NAT_PPTP problem, but the problem seems to effect
IP_NAT_PPTP the most.  I want to thank Patrick for helping track this
down.  I think this problem has been hitting me for years in one form or
another and I think I might  **finally**  understand it.  I'll bet
others in the community are seeing the same thing.  I havevn't seen this
written up anywhere - so maybe this writeup will help others learn from
my experience. =20
=20
I was able to reproduce the problem at will and I think we also have a
simple solution.=20
=20
Here is the problem:
=20
When I do a PPTP connection into a Dell PE server with the integrated
Broadcom NIC, and the NIC hardware does TCP checksums instead of the
CPU,  the first connection works.  Subsequent connections hang.  They
never connect.  The server is behind a Linux firewall with IP_NAT_PPTP.
The nasty part about this problem is, it only fails for some client
connections.  Others connect with no apparent problems.  All the
nay-sayers blamed the Linux box for the problem - it turns out the Linux
box led to the solution!
=20
Thanks to lots of help from Patrick, and lots of output from tcpdump, we
noticed the server is sending bad checksums.  The bad checksums happen
even with successful connections.  It seems that some client NAT
gateways enforce this checksum coming back from the server, while others
don't seem to care. =20
=20
We just tested a solution this morning.  On the Dell server - in this
case with Win2000 - go into the advavnced adapter properties and turn
off hardware checksumming.  With hardware checksumming turned off,
remote PPTP connections seem to work perfectly.  We are going to run
some more tests from more apparent problem client sites but I am
convinced we finally found the problem. =20
=20
Here are the relevant steps we took to lead us to this conclusion -
leaving out all the false starts and dead-ends:
=20
I have two independent Internet feeds coming into my place.  One is a
T1, the other is DSL.   My T1 gateway is a Linux box with kernel
2.6.17.2 and IP_NAT_PPTP.  My DSL gateway is an older Linux box with
2.4.27 compiled with an old POM-NG IP_NAT_PPTP.  The PPTP server is at a
customer site. =20
=20
In an attempt to reproduced the problem, I  tried some outbound PPTP
connections from my place to the customer site. =20
=20
>From a WinXP system behind my DSL gateway, I can connect to the customer
PPTP server at will.  When the customer PPTP server is freshly booted, I
can also connect from behind my T1 gateway.  But when I connect from
behind my DSL gateway, then disconnect, then try to connect from my
laptop behind the T1 gateway, the T1 connection hangs and never works
again until rebooting the customer PPTP server.  Connnections from
behind the T1 gateway also hang if the DSL gateway stays connected.  But
connections from behind the DSL gateway always seem to work. =20
=20
Running TCPDUMP on the firewall at the customer PPTP site with both
successful and unsuccessful connections show that the customer PPTP
server is sending invalid TCP checksums.  For some reason, the DSL
gateway at my place doesn't seem to care, while the newer T1 gateway at
my place does seem to care.  It also happens that the client I used
behind the DSL gateway was a WinXP SP1 workstation.  The client behind
the T1 gateway is a WinXP SP2 workstation.  This may also be
significant. =20
=20
Regardless, as soon as we turned off NIC hardware checksums on the Dell
PE server, the problem went away.  I can connect from behind both
gateways in any order I want, as often as I want, and it hasn't broken
yet. =20
=20
This leads me to a few thoughts about Dell servers that would be
politically unwise to share in a public forum.  :)
=20
I want to thank Patrick agian for helping us track this down, and
hopefully this writeup can help others in similar situations. =20
=20
thanks
=20
- Greg Scott
