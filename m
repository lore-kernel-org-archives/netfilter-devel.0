From: Michael Schwendt <rh0209ms@arcor.de>
Subject: [PATCH] Re: bug in iptables-save/iptables-restore
Date: Sun, 24 Nov 2002 12:43:44 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021124124344.20640cb8.rh0209ms@arcor.de>
References: <3DD7B46F.3050006@attbi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart_Sun__24_Nov_2002_12:43:44_+0100_0826fd40"
Cc: Gerry Skerbitz <gsker@attbi.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <3DD7B46F.3050006@attbi.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Multipart_Sun__24_Nov_2002_12:43:44_+0100_0826fd40
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Sun, 17 Nov 2002 09:23:27 -0600, Gerry Skerbitz wrote:

> I installed narc to build some firewall rules for me, but to fit it in
> well with the RedHat8 installation,
> I wanted to put its rules in /etc/sysconfig/iptables.  I ran
> iptables-save > /etc/sysconfig/iptables
> Then I tried restoring it using
> iptables-restore /etc/sysconfig iptables and got these errors:
> #~>/sbin/iptables-restore /etc/sysconfig/iptables
> iptables-restore v1.2.7a: length invalid: `!40'
> 
> Try `iptables-restore -h' or 'iptables-restore --help' for more
> information.
> 
> here are the offending lines created by iptables-save:
> #~>iptables-save | grep length
> -A CUST_LOG -p tcp -m length --length !40:68 -j LOG --log-prefix 
> "PACKET_LENGTH_BAD: " --log-level 7 --log-tcp-options --log-ip-options
> -A CUST_LOG -p tcp -m length --length !40:68 -j DROP
> #~>
> 
> I just did some digging and figured out that the exclamation point 
> should go before the --length 40:68.  I guess that's
> what iptables-save should really do and clearly it's what narc does
> when it sets up the rule.

It should go before the 40:68, but separated with whitespace,
like: -m length --length ! 40:68

Try attached patch.

This is one of a series of similar "missing white-space" in
iptables-save bugs. At some point in time it seems something
important was changed in the iptables package which broke
several extensions like this.

Michael
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)

iD8DBQE94Ltw0iMVcrivHFQRAlrLAJ4yfISsZ08ADUYk4kdANahga6hGHACfZhbe
leMNpQUNxPage5pz1GLBzes=
=Xh+Z
-----END PGP SIGNATURE-----

--Multipart_Sun__24_Nov_2002_12:43:44_+0100_0826fd40
Content-Type: application/octet-stream;
 name="iptables-1.2.7a-length.patch"
Content-Disposition: attachment;
 filename="iptables-1.2.7a-length.patch"
Content-Transfer-Encoding: base64

QWRkIG1pc3Npbmcgc3BhY2UgYmV0d2VlbiAnIScgYW5kIGxlbmd0aHMgcGFyYW1ldGVyIHVwb24K
cHJpbnRpbmcvc2F2aW5nIGludmVydGVkIC1tIC0tbGVuZ3RoIHJ1bGUuCgpkaWZmIC1OYXVyIGlw
dGFibGVzLTEuMi43YS1vcmlnL2V4dGVuc2lvbnMvbGliaXA2dF9sZW5ndGguYyBpcHRhYmxlcy0x
LjIuN2EvZXh0ZW5zaW9ucy9saWJpcDZ0X2xlbmd0aC5jCi0tLSBpcHRhYmxlcy0xLjIuN2Etb3Jp
Zy9leHRlbnNpb25zL2xpYmlwNnRfbGVuZ3RoLmMJV2VkIE1heSAyOSAxNTowODoxNiAyMDAyCisr
KyBpcHRhYmxlcy0xLjIuN2EvZXh0ZW5zaW9ucy9saWJpcDZ0X2xlbmd0aC5jCVN1biBOb3YgMjQg
MTI6MzM6MzAgMjAwMgpAQCAtMTE0LDcgKzExNCw3IEBACiBwcmludF9sZW5ndGgoc3RydWN0IGlw
NnRfbGVuZ3RoX2luZm8gKmluZm8pCiB7CiAJaWYgKGluZm8tPmludmVydCkKLQkJZnB1dGMoJyEn
LCBzdGRvdXQpOworCQlwcmludGYoIiEgIik7CiAJCiAJaWYgKGluZm8tPm1heCA9PSBpbmZvLT5t
aW4pCiAJCXByaW50ZigiJXUgIiwgaW5mby0+bWluKTsKZGlmZiAtTmF1ciBpcHRhYmxlcy0xLjIu
N2Etb3JpZy9leHRlbnNpb25zL2xpYmlwdF9sZW5ndGguYyBpcHRhYmxlcy0xLjIuN2EvZXh0ZW5z
aW9ucy9saWJpcHRfbGVuZ3RoLmMKLS0tIGlwdGFibGVzLTEuMi43YS1vcmlnL2V4dGVuc2lvbnMv
bGliaXB0X2xlbmd0aC5jCVdlZCBNYXkgMjkgMTU6MDg6MTYgMjAwMgorKysgaXB0YWJsZXMtMS4y
LjdhL2V4dGVuc2lvbnMvbGliaXB0X2xlbmd0aC5jCVN1biBOb3YgMjQgMTI6MzM6NTkgMjAwMgpA
QCAtMTEyLDcgKzExMiw3IEBACiBwcmludF9sZW5ndGgoc3RydWN0IGlwdF9sZW5ndGhfaW5mbyAq
aW5mbykKIHsKIAlpZiAoaW5mby0+aW52ZXJ0KQotCQlmcHV0YygnIScsIHN0ZG91dCk7CisJCXBy
aW50ZigiISAiKTsKIAkKIAlpZiAoaW5mby0+bWF4ID09IGluZm8tPm1pbikKIAkJcHJpbnRmKCIl
dSAiLCBpbmZvLT5taW4pOwo=

--Multipart_Sun__24_Nov_2002_12:43:44_+0100_0826fd40--
