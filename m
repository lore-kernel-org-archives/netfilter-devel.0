From: Henrik Nordstrom <hno@marasystems.com>
Subject: [patch] pom-ng convert Configure.help
Date: Sat, 28 Feb 2004 13:02:50 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402281301040.9148-200000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-239917762-1077969770=:9148"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---1463811839-239917762-1077969770=:9148
Content-Type: TEXT/PLAIN; charset=US-ASCII

The attached patch corrects how configure2pomng.sh deals with 
Configure.help additions.

Regards
Henrik

---1463811839-239917762-1077969770=:9148
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="pomng-convert-help.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44.0402281302500.9148@filer.marasystems.com>
Content-Description: 
Content-Disposition: attachment; filename="pomng-convert-help.patch"

SW5kZXg6IGNvbnZlcnQycG9tbmcuc2gNCj09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT0NClJDUyBmaWxlOiAvY3ZzcHVibGljL3BhdGNoLW8tbWF0aWMtbmcvY29u
dmVydDJwb21uZy5zaCx2DQpyZXRyaWV2aW5nIHJldmlzaW9uIDEuNQ0KZGlm
ZiAtdSAtcCAtcjEuNSBjb252ZXJ0MnBvbW5nLnNoDQotLS0gY29udmVydDJw
b21uZy5zaAkyNyBGZWIgMjAwNCAyMTo0MDoyMCAtMDAwMAkxLjUNCisrKyBj
b252ZXJ0MnBvbW5nLnNoCTI4IEZlYiAyMDA0IDExOjU4OjQ2IC0wMDAwDQpA
QCAtNDksNyArNDksNyBAQCBmb3IgZiBpbiAkUFJFRklYLmlwX2Nvbm50cmFj
ay5oKjsgZG8NCiBkb25lDQogDQogZm9yIGQgaW4gJFRSWURJUlM7IGRvDQot
CXJtZGlyIC1wICRERVNURElSLyRkDQorCXJtZGlyIC1wICRERVNURElSLyRk
IDI+L2Rldi9udWxsDQogZG9uZQ0KIA0KIGNwICRQUkVGSVggJERFU1RESVIv
bGludXgucGF0Y2gNCkBAIC02Miw2ICs2Miw5IEBAIGZvciBmIGluICRORVdG
SUxFUzsgZG8NCiAJJENWUyBhZGQgJGYNCiBkb25lDQogDQotIyB3ZSBuZWVk
IHRvIGRlYWwgd2l0aCBwYXRjaCBhbmQgY29uZmlndXJlLmhlbHAgbWFudWFs
bHkNCi1jcCAkUFJFRklYLmNvbmZpZ3VyZS5oZWxwICRERVNURElSL2NvbmZp
Z3VyZS5oZWxwDQotDQoraWYgWyAtZiAkUFJFRklYLmNvbmZpZ3VyZS5oZWxw
IF07IHRoZW4NCisgICAgbWtkaXIgLXAgJERFU1RESVIvbGludXgvRG9jdW1l
bnRhdGlvbg0KKyAgICAkQ1ZTIGFkZCAkREVTVERJUi9saW51eC9Eb2N1bWVu
dGF0aW9uDQorICAgIGNwICRQUkVGSVguY29uZmlndXJlLmhlbHAgJERFU1RE
SVIvbGludXgvRG9jdW1lbnRhdGlvbi9Db25maWd1cmUuaGVscC5sYWRkDQor
ICAgICRDVlMgYWRkICRERVNURElSL2xpbnV4L0RvY3VtZW50YXRpb24vQ29u
ZmlndXJlLmhlbHAubGFkZA0KK2ZpDQo=
---1463811839-239917762-1077969770=:9148--
