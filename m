From: Patrick McHardy <kaber@stinky.trash.net>
Subject: [PATCH]: fix potential use after free in destroy_conntrack
Date: Fri, 20 Jun 2003 12:44:14 +0200 (MEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.GSO.4.42.0306201236020.20652-200000@stinky.trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-559023410-851401618-1056105854=:20652"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: harald.welte@gnumonks.org
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

---559023410-851401618-1056105854=:20652
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hi Harald,
i missed this in my last patch (remove ct->master double check),
the reference to the master conntrack should not be dropped
until the expectation has deleted itself from the list.
This makes the last patch obsolete.

Best regards,
Patrick

---559023410-851401618-1056105854=:20652
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="ip_conntrack-destroy.diff"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.GSO.4.42.0306201244140.20652@stinky.trash.net>
Content-Description: 
Content-Disposition: attachment; filename="ip_conntrack-destroy.diff"

PT09PT0gbmV0L2lwdjQvbmV0ZmlsdGVyL2lwX2Nvbm50cmFja19jb3JlLmMg
MS4yMSB2cyBlZGl0ZWQgPT09PT0NCi0tLSAxLjIxL25ldC9pcHY0L25ldGZp
bHRlci9pcF9jb25udHJhY2tfY29yZS5jCUZyaSBKdW4gMjAgMDU6Mzc6NTYg
MjAwMw0KKysrIGVkaXRlZC9uZXQvaXB2NC9uZXRmaWx0ZXIvaXBfY29ubnRy
YWNrX2NvcmUuYwlGcmkgSnVuIDIwIDEyOjMzOjIzIDIwMDMNCkBAIC0zMTMs
OSArMzEzLDYgQEANCiAJSVBfTkZfQVNTRVJUKGF0b21pY19yZWFkKCZuZmN0
LT51c2UpID09IDApOw0KIAlJUF9ORl9BU1NFUlQoIXRpbWVyX3BlbmRpbmco
JmN0LT50aW1lb3V0KSk7DQogDQotCWlmIChjdC0+bWFzdGVyICYmIG1hc3Rl
cl9jdChjdCkpDQotCQlpcF9jb25udHJhY2tfcHV0KG1hc3Rlcl9jdChjdCkp
Ow0KLQ0KIAkvKiBUbyBtYWtlIHN1cmUgd2UgZG9uJ3QgZ2V0IGFueSB3ZWly
ZCBsb2NraW5nIGlzc3VlcyBoZXJlOg0KIAkgKiBkZXN0cm95X2Nvbm50cmFj
aygpIE1VU1QgTk9UIGJlIGNhbGxlZCB3aXRoIGEgd3JpdGUgbG9jaw0KIAkg
KiB0byBpcF9jb25udHJhY2tfbG9jayEhISAtSFcgKi8NCkBAIC0zMzIsOSAr
MzI5LDEyIEBADQogDQogCS8qIERlbGV0ZSBvdXIgbWFzdGVyIGV4cGVjdGF0
aW9uICovDQogCWlmIChjdC0+bWFzdGVyKSB7DQotCQkvKiBjYW4ndCBjYWxs
IF9fdW5leHBlY3RfcmVsYXRlZCBoZXJlLA0KLQkJICogc2luY2UgaXQgd291
bGQgc2NyZXcgdXAgZXhwZWN0X2xpc3QgKi8NCi0JCWxpc3RfZGVsKCZjdC0+
bWFzdGVyLT5leHBlY3RlZF9saXN0KTsNCisJCWlmIChjdC0+bWFzdGVyLT5l
eHBlY3RhbnQpIHsNCisJCQkvKiBjYW4ndCBjYWxsIF9fdW5leHBlY3RfcmVs
YXRlZCBoZXJlLA0KKwkJCSAqIHNpbmNlIGl0IHdvdWxkIHNjcmV3IHVwIGV4
cGVjdF9saXN0ICovDQorCQkJbGlzdF9kZWwoJmN0LT5tYXN0ZXItPmV4cGVj
dGVkX2xpc3QpOw0KKwkJCWlwX2Nvbm50cmFja19wdXQoY3QtPm1hc3Rlci0+
ZXhwZWN0YW50KTsNCisJCX0NCiAJCWtmcmVlKGN0LT5tYXN0ZXIpOw0KIAl9
DQogCVdSSVRFX1VOTE9DSygmaXBfY29ubnRyYWNrX2xvY2spOw0K
---559023410-851401618-1056105854=:20652--
