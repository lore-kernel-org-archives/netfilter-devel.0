From: Michael Schwendt <rh0209ms@arcor.de>
Subject: libipt_conntrack.c iptables-save bug [PATCH]
Date: Tue, 26 Nov 2002 03:30:32 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021126033032.45cb1c4b.rh0209ms@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart_Tue__26_Nov_2002_03:30:32_+0100_08256fc8"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Multipart_Tue__26_Nov_2002_03:30:32_+0100_08256fc8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

libipt_conntrack.c in several places also lacks a white-space
character after the '!' prefix of an invertable argument.

Since I don't know what the policy is with regard to the print() and
save() functions, a temporary fix would be to simply add the missing
spaces to the main print sub-function, although they would be
printed for iptables -L then, too, and not just for iptables-save. A
different solution would need bigger changes to libipt_conntrack.c.

Michael

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)

iD8DBQE94tzI0iMVcrivHFQRAjtaAJ0SxRseqfsne29+PTTepmyfmTcijgCggLi+
tdc6Fx2KCOSbWKFC7/ILwVI=
=TTzB
-----END PGP SIGNATURE-----

--Multipart_Tue__26_Nov_2002_03:30:32_+0100_08256fc8
Content-Type: application/octet-stream;
 name="iptables-1.2.7a-missingspace.patch"
Content-Disposition: attachment;
 filename="iptables-1.2.7a-missingspace.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtTmF1ciBpcHRhYmxlcy0xLjIuN2Etb3JpZy9leHRlbnNpb25zL2xpYmlwdF9jb25udHJh
Y2suYyBpcHRhYmxlcy0xLjIuN2EvZXh0ZW5zaW9ucy9saWJpcHRfY29ubnRyYWNrLmMKLS0tIGlw
dGFibGVzLTEuMi43YS1vcmlnL2V4dGVuc2lvbnMvbGliaXB0X2Nvbm50cmFjay5jCVdlZCBNYXkg
MjkgMTU6MDg6MTYgMjAwMgorKysgaXB0YWJsZXMtMS4yLjdhL2V4dGVuc2lvbnMvbGliaXB0X2Nv
bm50cmFjay5jCVR1ZSBOb3YgMjYgMDI6NTg6MDIgMjAwMgpAQCAtNDA5LDcgKzQwOSw3IEBACiAJ
aWYoc2luZm8tPmZsYWdzICYgSVBUX0NPTk5UUkFDS19TVEFURSkgewogCQlwcmludGYoIiVzY3Rz
dGF0ZSAiLCBvcHRwZngpOwogICAgICAgICAJaWYgKHNpbmZvLT5pbnZmbGFncyAmIElQVF9DT05O
VFJBQ0tfU1RBVEUpCi0gICAgICAgICAgICAgICAgCWZwdXRjKCchJywgc3Rkb3V0KTsKKyAgICAg
ICAgICAgICAgICAJcHJpbnRmKCIhICIpOwogCQlwcmludF9zdGF0ZShzaW5mby0+c3RhdGVtYXNr
KTsKIAl9CiAKQEAgLTQ1NiwxNCArNDU2LDE0IEBACiAJaWYoc2luZm8tPmZsYWdzICYgSVBUX0NP
Tk5UUkFDS19TVEFUVVMpIHsKIAkJcHJpbnRmKCIlc2N0c3RhdHVzICIsIG9wdHBmeCk7CiAgICAg
ICAgIAlpZiAoc2luZm8tPmludmZsYWdzICYgSVBUX0NPTk5UUkFDS19TVEFURSkKLSAgICAgICAg
ICAgICAgICAJZnB1dGMoJyEnLCBzdGRvdXQpOworICAgICAgICAgICAgICAgIAlwcmludGYoIiEg
Iik7CiAJCXByaW50X3N0YXR1cyhzaW5mby0+c3RhdHVzbWFzayk7CiAJfQogCiAJaWYoc2luZm8t
PmZsYWdzICYgSVBUX0NPTk5UUkFDS19FWFBJUkVTKSB7CiAJCXByaW50ZigiJXNjdGV4cGlyZSAi
LCBvcHRwZngpOwogICAgICAgICAJaWYgKHNpbmZvLT5pbnZmbGFncyAmIElQVF9DT05OVFJBQ0tf
RVhQSVJFUykKLSAgICAgICAgICAgICAgICAJZnB1dGMoJyEnLCBzdGRvdXQpOworICAgICAgICAg
ICAgICAgIAlwcmludGYoIiEgIik7CiAKICAgICAgICAgCWlmIChzaW5mby0+ZXhwaXJlc19tYXgg
PT0gc2luZm8tPmV4cGlyZXNfbWluKQogICAgICAgICAgICAgICAgIAlwcmludGYoIiVsdSAiLCBz
aW5mby0+ZXhwaXJlc19taW4pOwo=

--Multipart_Tue__26_Nov_2002_03:30:32_+0100_08256fc8--
