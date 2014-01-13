From: Kevin Fenzi <kevin@scrye.com>
Subject: Re: nftables/libnftables packages for Fedora
Date: Mon, 13 Jan 2014 12:18:36 -0700
Message-ID: <20140113121836.0d4b1595@voldemort.scrye.com>
References: <20140112134024.2475a4f2@voldemort.scrye.com>
 <alpine.LSU.2.11.1401130953150.14789@nerf08.vanv.qr>
 <20140113090942.GA14601@macbook.localnet>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/i4ltqNgIbfc4GEuMJyEa.cC"; protocol="application/pgp-signature"
Cc: Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 75-148-32-185-Colorado.hfc.comcastbusiness.net ([75.148.32.185]:37159
	"EHLO mail.scrye.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbaAMTSj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Jan 2014 14:18:39 -0500
In-Reply-To: <20140113090942.GA14601@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--Sig_/i4ltqNgIbfc4GEuMJyEa.cC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Jan 2014 09:09:43 +0000
Patrick McHardy <kaber@trash.net> wrote:

> On Mon, Jan 13, 2014 at 09:54:22AM +0100, Jan Engelhardt wrote:
> >=20
> > On Sunday 2014-01-12 21:40, Kevin Fenzi wrote:
> > >
> > >1. Completely minor, but noted in review of both packages that the
> > >COPYING file has the old fsf address in it. Would be great if you
> > >could update to the new one.=20
> > >https://fedoraproject.org/wiki/Common_Rpmlint_issues#incorrect-fsf-add=
ress
> >=20
> > No, best remove the address, because you really don't want to be
> > updating all the time.
>=20
> "All the time" seems slightly exagerated. But the "updated" license
> linked in the wiki is exactly the same version we're using, the
> address hasn't been changed:
>=20
> http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt

It has:=20

- Copyright (C) 1989, 1991 Free Software Foundation, Inc.
-                          675 Mass Ave, Cambridge, MA 02139, USA
+ Copyright (C) 1989, 1991 Free Software Foundation, Inc.,
+ 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA

... and a few other diffs like saying <yeah> instead of 19xx and Lesser
GNU Public License instead of Library, etc.=20

FSF moved buildings a few years ago... as far as I know they don't plan
to move again, and it's only happened once. The GPLv3 COPYING file I
note doesn't have any physical address in it. ;)=20

kevin

--Sig_/i4ltqNgIbfc4GEuMJyEa.cC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCgAGBQJS1DwMAAoJEEs3sNgP+7teU0sP/1ChsCyGQjkrcKGgUBKs2Uyf
TyLhXIk92orbyfB8HZ/6Ov31xW63bwXGT0579Gt2lUrqMzU5XwxPDngKiRaLdT/h
K16FxVA9bSbNcU+xVbPqJP6DhR91o+7IO7g6OBZ4yEc2MaS5kW+qaRnnyNadyuPw
df9qExbGhWhxb0mQqU5uOA1o1RsZDboo9hBzhGL+G/7/BpXn/jywJV4bRcnOBjw1
Z6eTtUZFd+NKYeqX+SYbZhRQiQT/Xmmf7m6juwrMtnr6x0EEWntUuvyYbE0mAMzg
Y4l85JnMfsP/aMpSz2YJ+8VCy4ABroZtHhWF0qwAIk7IGc5qYncpL8rS9Vs2tQdA
ENyjrphvy0EzhoOq+FYjDCG747z4NoFh5Jc3yXtcZOOED04+NQVC5o5/QIu9E2p2
UO9F0syiZhUBugGtVacSxuQTuegeeLDqNuMIn8gPlJ8vM7rn1LKNBM/uAsjOlVSM
DgbW81cQ5SRAILoDu4EHTJE1YrJtUvlmfwmzYMwRxnzANJg5kzyVBL6GVMIBXcTT
q1wtgcey1tA3LugVyVQYSwWx+ZmENwsaqieasOmdvONE00JFH+9SGx4+QTDcZPS9
VLVYG6MYLuRuUvos0E49i06iE8Gpj8rp5YDsjot/1BPlTfOlufsDWUY7zMJrZEB5
9UaZt1zABy2P4yMeJTLn
=TNCj
-----END PGP SIGNATURE-----

--Sig_/i4ltqNgIbfc4GEuMJyEa.cC--
