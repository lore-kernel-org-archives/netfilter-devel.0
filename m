From: "Craig Box" <craig@itpartners.co.nz>
Subject: RE: PPTP conntracking saga continued
Date: Thu, 18 Sep 2003 09:58:05 +1200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <44AD3126A8CE26439BBD21AB2F9CC1D81286E4@commsserver.itpartners.co.nz>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
To: "Philip Craig" <philipc@snapgear.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> I have had success with the following:
>=20
> 1. Start with Linux 2.4.22
> 2. Apply patch-o-matic/pending/63_getorigdst-tuple-zero.patch
> 3. Apply patch-o-matic/extra/pptp-conntrack-nat.patch
> 4. Copy in the files from netfilter-extensions/helpers/pptp
> 5. Apply the patches from:
>
http://lists.netfilter.org/pipermail/netfilter-devel/2003-September/0123
62.html

Well, the kernel compiled cleanly (which is a first!), even with IPSEC
and MPPE patches.

However, something about NAT and forwarding doesn't go.  The problem
isn't the firewalling ruleset; the machine still forwards (I can ping
between networks that the machine routes between) but it doesn't let me
ping from an internal machine to an internet machine.  I can access the
internet from the machine locally however.

The (two) internet connections are to ADSL routers via PPTP; could this
be part of the problem?

I didn't spend as much time as I'd have wanted to tcpdumping, as in
order to test everything works I really need to run it on a real world
connected machine instead of a proper test environment, and people
needed their internet connection back. I'll experiment again without the
other patches, but is there any known fault here, or is there anything
in the way of debugging information I should post to try and solve this
one?

Craig
