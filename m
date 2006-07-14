From: Jesper Dangaard Brouer <hawk@diku.dk>
Subject: [PATCH] BUG: libiptc chain references bug
Date: Fri, 14 Jul 2006 14:29:57 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0607141427230.31153@tyr.diku.dk>
References: <Pine.LNX.4.61.0607121722360.13610@ask.diku.dk>
	<Pine.LNX.4.61.0607131303220.29013@tyr.diku.dk>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-511516064-1000784743-1152880197=:31153"
Cc: hawk@comx.dk
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.61.0607131303220.29013@tyr.diku.dk>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---511516064-1000784743-1152880197=:31153
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed


Correcting a chain references increment bug in libiptc.

The bug lies in function iptc_delete_entry() / TC_DELETE_ENTRY.  The
problem is the construction of "r" the rule entry, that is used for
comparison. The problem is that the function iptcc_map_target()
increase the target chains references count.

The fix is to use function iptcc_delete_rule() to delete the "r" rule
(as it decrement the counter again). To make it work a small NULL
pointer check is also added iptcc_delete_rule().

Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>

-- 
Best regards
   Jesper Brouer
   ComX Networks A/S
   Linux Network developer
   Cand. Scient Datalog / MSc.
   Author of http://adsl-optimizer.dk
---511516064-1000784743-1152880197=:31153
Content-Type: TEXT/PLAIN; charset=US-ASCII;
	name="iptables.references_bug01.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.61.0607141429570.31153@tyr.diku.dk>
Content-Description: 
Content-Disposition: attachment; filename="iptables.references_bug01.patch"

SW5kZXg6IGlwdGFibGVzL2xpYmlwdGMvbGliaXB0Yy5jDQo9PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09DQotLS0gaXB0YWJsZXMvbGliaXB0Yy9saWJpcHRjLmMJ
KHJldmlzaW9uIDY2NDQpDQorKysgaXB0YWJsZXMvbGliaXB0Yy9saWJpcHRj
LmMJKHdvcmtpbmcgY29weSkNCkBAIC0zNDcsNyArMzQ3LDggQEAgc3RhdGlj
IHZvaWQgaXB0Y2NfZGVsZXRlX3J1bGUoc3RydWN0IHJ1bA0KIAkgICAgJiYg
ci0+anVtcCkNCiAJCXItPmp1bXAtPnJlZmVyZW5jZXMtLTsNCiANCi0JbGlz
dF9kZWwoJnItPmxpc3QpOw0KKwlpZiAoci0+bGlzdC5uZXh0ICYmIHItPmxp
c3QucHJldikNCisJICBsaXN0X2RlbCgmci0+bGlzdCk7DQogCWZyZWUocik7
DQogfQ0KIA0KQEAgLTE1MTUsNiArMTUxNiw4IEBAIFRDX0RFTEVURV9FTlRS
WShjb25zdCBJUFRfQ0hBSU5MQUJFTCBjaGENCiANCiAJbWVtY3B5KHItPmVu
dHJ5LCBvcmlnZncsIG9yaWdmdy0+bmV4dF9vZmZzZXQpOw0KIAlyLT5jb3Vu
dGVyX21hcC5tYXB0eXBlID0gQ09VTlRFUl9NQVBfTk9NQVA7DQorDQorCS8q
IFJlbWVtYmVyIHRoYXQgaXB0Y2NfbWFwX3RhcmdldCBpbmNyZW1lbnQgdGFy
Z2V0IGNoYWluIHJlZmVyZW5jZXMgKi8NCiAJaWYgKCFpcHRjY19tYXBfdGFy
Z2V0KCpoYW5kbGUsIHIpKSB7DQogCQlERUJVR1AoInVuYWJsZSB0byBtYXAg
dGFyZ2V0IG9mIHJ1bGUgZm9yIGNoYWluIGAlcydcbiIsIGNoYWluKTsNCiAJ
CWZyZWUocik7DQpAQCAtMTU0MiwxMyArMTU0NSwxMyBAQCBUQ19ERUxFVEVf
RU5UUlkoY29uc3QgSVBUX0NIQUlOTEFCRUwgY2hhDQogDQogCQljLT5udW1f
cnVsZXMtLTsNCiAJCWlwdGNjX2RlbGV0ZV9ydWxlKGkpOw0KKwkJaXB0Y2Nf
ZGVsZXRlX3J1bGUocik7IC8qIGZyZWUgYW5kIGRlY3JlbWVudCByZWZlcmVu
Y2VzICovDQogDQogCQlzZXRfY2hhbmdlZCgqaGFuZGxlKTsNCi0JCWZyZWUo
cik7DQogCQlyZXR1cm4gMTsNCiAJfQ0KIA0KLQlmcmVlKHIpOw0KKwlpcHRj
Y19kZWxldGVfcnVsZShyKTsgLyogZnJlZSBhbmQgZGVjcmVtZW50IHJlZmVy
ZW5jZXMgKi8NCiAJZXJybm8gPSBFTk9FTlQ7DQogCXJldHVybiAwOw0KIH0N
Cg==

---511516064-1000784743-1152880197=:31153--
