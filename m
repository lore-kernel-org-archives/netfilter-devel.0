From: Michael Schwendt <rh0209ms@arcor.de>
Subject: [PATCH] iptables-save match tos bug-fix
Date: Tue, 26 Nov 2002 03:28:27 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021126032827.0c755686.rh0209ms@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart_Tue__26_Nov_2002_03:28:27_+0100_081fe1c8"
Cc: Harald Welte <laforge@gnumonks.org>
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


--Multipart_Tue__26_Nov_2002_03:28:27_+0100_081fe1c8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi everyone!

Here's one more patch for another "missing space in save() function"
bug. This time it's the "tos match" userspace extension. An inverted
TOS match is not saved correctly, so that iptables-restore would
understand it.

The patch is a bit longer because it tidies up save() as used by
iptables-save without adding white-space in print() as used by
iptables -L.

Michael

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)

iD8DBQE94txL0iMVcrivHFQRArTjAJ48jzFMAOFDsHU+VIM+J2gF4eawBACghhPi
u7pLzmwY1GqFXcfcnxWwxo0=
=6m+o
-----END PGP SIGNATURE-----

--Multipart_Tue__26_Nov_2002_03:28:27_+0100_081fe1c8
Content-Type: application/octet-stream;
 name="iptables-1.2.7a-savetos.patch"
Content-Disposition: attachment;
 filename="iptables-1.2.7a-savetos.patch"
Content-Transfer-Encoding: base64

Rml4IHNhdmUgZnVuY3Rpb24gb2YgdG9zIG1hdGNoLgoKZGlmZiAtTmF1ciBpcHRhYmxlcy0xLjIu
N2Etb3JpZy9leHRlbnNpb25zL2xpYmlwdF90b3MuYyBpcHRhYmxlcy0xLjIuN2EvZXh0ZW5zaW9u
cy9saWJpcHRfdG9zLmMKLS0tIGlwdGFibGVzLTEuMi43YS1vcmlnL2V4dGVuc2lvbnMvbGliaXB0
X3Rvcy5jCVdlZCBNYXkgMjkgMTU6MDg6MTYgMjAwMgorKysgaXB0YWJsZXMtMS4yLjdhL2V4dGVu
c2lvbnMvbGliaXB0X3Rvcy5jCVR1ZSBOb3YgMjYgMDI6NTY6NDAgMjAwMgpAQCAtMTA1LDEzICsx
MDUsMTAgQEAKIH0KIAogc3RhdGljIHZvaWQKLXByaW50X3Rvcyh1X2ludDhfdCB0b3MsIGludCBp
bnZlcnQsIGludCBudW1lcmljKQorcHJpbnRfdG9zKHVfaW50OF90IHRvcywgaW50IG51bWVyaWMp
CiB7CiAJdW5zaWduZWQgaW50IGk7CiAKLQlpZiAoaW52ZXJ0KQotCQlmcHV0YygnIScsIHN0ZG91
dCk7Ci0KIAlpZiAoIW51bWVyaWMpIHsKIAkJZm9yIChpID0gMDsgaTxzaXplb2YoVE9TX3ZhbHVl
cykvc2l6ZW9mKHN0cnVjdCBUT1NfdmFsdWUpOyBpKyspCiAJCQlpZiAoVE9TX3ZhbHVlc1tpXS5U
T1MgPT0gdG9zKSB7CkBAIC0xMzcsMTggKzEzNCwyNCBAQAogICAgICAgY29uc3Qgc3RydWN0IGlw
dF9lbnRyeV9tYXRjaCAqbWF0Y2gsCiAgICAgICBpbnQgbnVtZXJpYykKIHsKKwljb25zdCBzdHJ1
Y3QgaXB0X3Rvc19pbmZvICppbmZvID0gKGNvbnN0IHN0cnVjdCBpcHRfdG9zX2luZm8gKiltYXRj
aC0+ZGF0YTsKKyAgICAKIAlwcmludGYoIlRPUyBtYXRjaCAiKTsKLQlwcmludF90b3MoKChzdHJ1
Y3QgaXB0X3Rvc19pbmZvICopbWF0Y2gtPmRhdGEpLT50b3MsCi0JCSAgKChzdHJ1Y3QgaXB0X3Rv
c19pbmZvICopbWF0Y2gtPmRhdGEpLT5pbnZlcnQsIG51bWVyaWMpOworCWlmIChpbmZvLT5pbnZl
cnQpCisJCXByaW50ZigiISIpOworCXByaW50X3RvcyhpbmZvLT50b3MsIG51bWVyaWMpOwogfQog
CiAvKiBTYXZlcyB0aGUgdW5pb24gaXB0X21hdGNoaW5mbyBpbiBwYXJzYWJsZSBmb3JtIHRvIHN0
ZG91dC4gKi8KIHN0YXRpYyB2b2lkCiBzYXZlKGNvbnN0IHN0cnVjdCBpcHRfaXAgKmlwLCBjb25z
dCBzdHJ1Y3QgaXB0X2VudHJ5X21hdGNoICptYXRjaCkKIHsKKwljb25zdCBzdHJ1Y3QgaXB0X3Rv
c19pbmZvICppbmZvID0gKGNvbnN0IHN0cnVjdCBpcHRfdG9zX2luZm8gKiltYXRjaC0+ZGF0YTsK
KyAgICAKKwlpZiAoaW5mby0+aW52ZXJ0KQorCQlwcmludGYoIiEgIik7CiAJcHJpbnRmKCItLXRv
cyAiKTsKLQlwcmludF90b3MoKChzdHJ1Y3QgaXB0X3Rvc19pbmZvICopbWF0Y2gtPmRhdGEpLT50
b3MsCi0JCSAgKChzdHJ1Y3QgaXB0X3Rvc19pbmZvICopbWF0Y2gtPmRhdGEpLT5pbnZlcnQsIDAp
OworCXByaW50X3RvcyhpbmZvLT50b3MsIDApOwogfQogCiBzdGF0aWMK

--Multipart_Tue__26_Nov_2002_03:28:27_+0100_081fe1c8--
