From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Fix for -m osf to work with -m recent (and probably other matches)
Date: Sun, 21 Sep 2003 21:01:26 +0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030921210126.65e336d0.johnpol@2ka.mipt.ru>
References: <20030921162151.GA16472@moon.ondraszek.ds.polsl.gliwice.pl>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart_Sun__21_Sep_2003_21:01:26_+0400_084f2250"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Piotr =?KOI8-R?Q?Gasid=B3o?= <quaker@ondraszek.eu.org>
In-Reply-To: <20030921162151.GA16472@moon.ondraszek.ds.polsl.gliwice.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

--Multipart_Sun__21_Sep_2003_21:01:26_+0400_084f2250
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by ffke-campus-gw.mipt.ru id h8LGx4Jx005316

On Sun, 21 Sep 2003 18:21:51 +0200
Piotr Gasid=B3o <quaker@ondraszek.eu.org> wrote:

> Hello,
>=20
> I tried to do OS accounting on my router. I entered below rule:
>=20
> # iptables -I FORWARD -p tcp --syn \
> -m osf --genre Linux \
> -m recent --set --name os-linux
>=20
> And I got following error:
>=20
> Can't specify multiple strings.
>=20
> When I switch -m recent with -m osf (and of couse rule looses it
> sense) everything it's fine. I figured out, that above error is caused
> by wrong check for --genre option in parse() function in libipt_osf.c.
> I attach patch, that fix this.

Hello.

Yes, you are right. The userland code is not correct.
I'm cc'ing this message to netfilter-devel@lists.netfilter.org.

Thank you.

> --=20
> Piotr 'QuakeR' Gasid=B3o, just another user @ ondraszek.eu.org
> ##################### sending lusers to /dev/null since 1998
> ############ Waiting for tomorrow, for a little ray of light
> ########## Waiting for tomorrow just to see your smile again

	Evgeniy Polyakov ( s0mbre )

--Multipart_Sun__21_Sep_2003_21:01:26_+0400_084f2250
Content-Type: application/octet-stream;
 name="libipt_osf.c.patch"
Content-Disposition: attachment;
 filename="libipt_osf.c.patch"
Content-Transfer-Encoding: base64

LS0tIGxpYmlwdF9vc2YuYy5vcmlnCVN1biBTZXAgMjEgMTg6MzU6MjMgMjAwMworKysgbGliaXB0
X29zZi5jCVN1biBTZXAgMjEgMjA6MDY6MTcgMjAwMwpAQCAtNzEsMTcgKzcxLDIwIEBACiB7CiAJ
c3RydWN0IGlwdF9vc2ZfaW5mbyAqaW5mbyA9IChzdHJ1Y3QgaXB0X29zZl9pbmZvICopKCptYXRj
aCktPmRhdGE7CiAKLQlzd2l0Y2gKLQlpZiAoKmZsYWdzKQotCQlleGl0X2Vycm9yKFBBUkFNRVRF
Ul9QUk9CTEVNLCAiQ2FuJ3Qgc3BlY2lmeSBtdWx0aXBsZSBzdHJpbmdzIik7Ci0KLQljaGVja19p
bnZlcnNlKG9wdGFyZywgJmludmVydCwgJm9wdGluZCwgMCk7Ci0JcGFyc2Vfc3RyaW5nKG9wdGFy
ZywgaW5mbyk7Ci0JaWYgKGludmVydCkKLQkJaW5mby0+aW52ZXJ0ID0gMTsKLQlpbmZvLT5sZW49
c3RybGVuKChjaGFyICopaW5mby0+Z2VucmUpOwotCSpmbGFncyA9IDE7Ci0KKwlzd2l0Y2goYykg
eworCQljYXNlICcxJzoKKwkJCWlmICgqZmxhZ3MpCisJCQkJZXhpdF9lcnJvcihQQVJBTUVURVJf
UFJPQkxFTSwgIkNhbid0IHNwZWNpZnkgbXVsdGlwbGUgc3RyaW5ncyIpOworCQkJY2hlY2tfaW52
ZXJzZShvcHRhcmcsICZpbnZlcnQsICZvcHRpbmQsIDApOworCQkJcGFyc2Vfc3RyaW5nKGFyZ3Zb
b3B0aW5kLTFdLCBpbmZvKTsKKwkJCWlmIChpbnZlcnQpCisJCQkJaW5mby0+aW52ZXJ0ID0gMTsK
KwkJCWluZm8tPmxlbj1zdHJsZW4oKGNoYXIgKilpbmZvLT5nZW5yZSk7CisJCQkqZmxhZ3MgPSAx
OworCQkJYnJlYWs7CisJCWRlZmF1bHQ6CisJCQlyZXR1cm4gMDsKKwl9CiAJcmV0dXJuIDE7CiB9
CiAKCg==

--Multipart_Sun__21_Sep_2003_21:01:26_+0400_084f2250--
