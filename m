From: Jan Engelhardt <jengelh@medozas.de>
Subject: Xtables-addons 1.32/ipset-GENL 5.2
Date: Tue, 4 Jan 2011 05:14:13 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1101040456270.11091@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

'=E3=81=A1=E3=82=8F

So a few people had been asking on whether ipset 5.x will be bundled=20
along with Xtables-addons. Naturally this is a difficult question=20
because ipset-5 wants a kernel patch. But yes, it is included as of Xt-=
a=20
1.32 (just out).

It has been augmented to not require the patch anymore, by moving it=20
over from nfnetlink (booo) to genetlink which does not depend on static=
=20
numbers, though you will need at least Linux 2.6.35 for this GENL=20
variant in both compilation and at runtime.
(As such, ipset-5 is deactivated by default in Xt-a 1.32 and needs to b=
e=20
turned on in mconfig.)


Xt-a files at the usual place.

The plain genl patch to ipset-5 can be found as a commit at=20
git://dev.medozas.de/ipset in the "genl" branch. It has received a run=20
through the testsuite (as far as it went until ospf), and I take that a=
s=20
an indication that proxying the protocol onto genl was successful.
