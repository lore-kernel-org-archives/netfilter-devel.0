From: Henrik Nordstrom <hno@marasystems.com>
Subject: [pomng patch] correctly break linked sources in ladd
Date: Sat, 28 Feb 2004 15:46:36 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402281531190.9609-200000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-1286759099-1077979596=:9609"
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

---1463811839-1286759099-1077979596=:9609
Content-Type: TEXT/PLAIN; charset=US-ASCII

The beaklink function did not always succeed or even notice it needed to
breaking links, most notably symlinks failed miserably.

The attached patch changes the code to simply do what patch and most other
programs does when replacing a file, write the new contents to a new temp
file and then replace the original file with rename.

With this (and all patches rebuilt from pom as per earlier mail) pom-ng
seems to apply fine to 2.4.25.

Regards
Henrik

---1463811839-1286759099-1077979596=:9609
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="pomng-breaklinks.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44.0402281546360.9609@filer.marasystems.com>
Content-Description: 
Content-Disposition: attachment; filename="pomng-breaklinks.patch"

SW5kZXg6IE5ldGZpbHRlcl9QT00ucG0NCj09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT0NClJDUyBmaWxlOiAvY3ZzcHVibGljL3BhdGNoLW8tbWF0aWMtbmcvTmV0
ZmlsdGVyX1BPTS5wbSx2DQpyZXRyaWV2aW5nIHJldmlzaW9uIDEuMTgNCmRp
ZmYgLXUgLXAgLXIxLjE4IE5ldGZpbHRlcl9QT00ucG0NCi0tLSBOZXRmaWx0
ZXJfUE9NLnBtCTI3IEZlYiAyMDA0IDIxOjQwOjIwIC0wMDAwCTEuMTgNCisr
KyBOZXRmaWx0ZXJfUE9NLnBtCTI4IEZlYiAyMDA0IDE0OjQwOjIxIC0wMDAw
DQpAQCAtMzUsMzAgKzM1LDYgQEAgbXkgJXZlcnNpb247DQogbXkgJWxhc3Rf
d29yZHM7DQogb3VyICVzcmNwYXRoOw0KIA0KLXN1YiBicmVha2xpbmsoJCkN
Ci17DQotCW15ICgkZmlsZSkgPSBAXzsNCi0JbXkgJG5saW5rcyA9IChzdGF0
KCRmaWxlKSlbM107DQotCWlmICgkbmxpbmtzID09IDEpIHsNCi0JCXJldHVy
biAxOw0KLQl9DQotCW15ICR0bXBuYW0gPSBGaWxlOjpUZW1wOjp0bXBuYW0o
KTsNCi0JaWYgKCFGaWxlOjpDb3B5Ojpjb3B5KCRmaWxlLCAkdG1wbmFtKSkg
ew0KLQkJJEVSUk1TRyA9ICJicmVha2xpbms6IHVuYWJsZSB0byBjb3B5IGZp
bGUgJGZpbGUgdG8gJHRtcG5hbTogJCEiOw0KLQkJcmV0dXJuIDA7DQotCX0N
Ci0JaWYgKCF1bmxpbmsoJGZpbGUpKSB7DQotCQkkRVJSTVNHID0gImJyZWFr
bGluazogdW5hYmxlIHRvIHVubGluayAkZmlsZSI7DQotCQlyZXR1cm4gMDsN
Ci0JfQ0KLQlpZiAoIUZpbGU6OkNvcHk6Om1vdmUoJHRtcG5hbSwgJGZpbGUp
KSB7DQotCQkkRVJSTVNHID0gImJyZWFrbGluazogdW5hYmxlIHRvIG1vdmUg
JHRtcG5hbSB0byAkZmlsZTogJCEiOw0KLQkJcmV0dXJuIDA7DQotCX0NCi0J
cmV0dXJuIDE7DQotfQ0KLQkNCi0NCiAjIHByaW50IHRoZSBsYXN0IGVycm9y
IG1lc3NhZ2UNCiAjDQogc3ViIHBlcnJvcigpDQpAQCAtNjE4LDE4ICs1OTQs
MTkgQEAgc3ViIGFwcGx5X2xpbmVhZGQoJCQkJCQpDQogCX0NCiANCiAJaWYg
KCR0ZXN0ID09IDApIHsNCi0JCW15ICRmaWxlbmFtID0gIiRzcmNmaWxlIjsN
Ci0JCWlmICghYnJlYWtsaW5rKCRmaWxlbmFtKSkgew0KLQkJCXJldHVybiAw
Ow0KLQkJfQ0KLQkJaWYgKCFvcGVuKFNSQywgJz4nLiRmaWxlbmFtKSkgew0K
LQkJCSRFUlJNU0cgPSAidW5hYmxlIHRvIHdyaXRlIHRvIGxhZCBzcmMgJHNy
Y2ZpbGUiOw0KKwkJbXkgJG5ld2ZpbGUgPSAiJHtzcmNmaWxlfS4kJCI7DQor
CQlpZiAoIW9wZW4oU1JDLCAiPiR7bmV3ZmlsZX0iKSkgew0KKwkJCSRFUlJN
U0cgPSAidW5hYmxlIHRvIHdyaXRlIHRvIGZpbGUgJHtuZXdmaWxlfSI7DQog
CQkJcmV0dXJuIDA7DQogCQl9DQogCQlmb3JlYWNoIG15ICRsaW5lIChAbmV3
bGluZXMpIHsNCiAJCQlwcmludChTUkMgJGxpbmUpOw0KIAkJfQ0KIAkJY2xv
c2UoU1JDKTsNCisJCWlmICghcmVuYW1lKCRuZXdmaWxlLCAkc3JjZmlsZSkp
IHsNCisJCQkkRVJSTVNHID0gInVuYWJsZSB0byByZXBsYWNlIGZpbGUgJHNy
Y2ZpbGUiOw0KKwkJCXJldHVybiAwOw0KKwkJfQ0KIAl9DQogDQogCXJldHVy
biAxOw0K
---1463811839-1286759099-1077979596=:9609--
