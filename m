From: Krzysztof Oledzki <olenf@ans.pl>
Subject: [CONNTRACKD]: Fix segfault
Date: Tue, 20 Jun 2006 15:21:50 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0606201514360.8549@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-123978349-1150809710=:8549"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
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

---187430788-123978349-1150809710=:8549
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello,

Attached (trivial) patch fixes segfault in conntrackd caused by wrong=20
"usage" calls.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-123978349-1150809710=:8549
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=conntrackd-segfault-fix.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0606201521500.8549@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=conntrackd-segfault-fix.patch

ZGlmZiAtTnVyIGNvbm50cmFja2QtMC44LjEtb3JpZy9zcmMvbWFpbi5jIGNv
bm50cmFja2QtMC44LjEvc3JjL21haW4uYw0KLS0tIGNvbm50cmFja2QtMC44
LjEtb3JpZy9zcmMvbWFpbi5jCTIwMDYtMDYtMjAgMTQ6MDQ6MDYuMDAwMDAw
MDAwICswMjAwDQorKysgY29ubnRyYWNrZC0wLjguMS9zcmMvbWFpbi5jCTIw
MDYtMDYtMjAgMTQ6MDY6MTQuMDAwMDAwMDAwICswMjAwDQpAQCAtMTExLDcg
KzExMSw3IEBADQogCQkJCWNvbmZpZ19zZXQgPSAxOw0KIAkJCQlicmVhazsN
CiAJCQl9DQotCQkJZnByaW50ZihzdGRvdXQsIHVzYWdlLCBWRVJTSU9OKTsN
CisJCQlmcHJpbnRmKHN0ZG91dCwgdXNhZ2UsIFZFUlNJT04sIGFyZ3ZbMF0p
Ow0KIAkJCWZwcmludGYoc3Rkb3V0LCAiTWlzc2luZyBjb25maWcgZmlsZW5h
bWVcbiIpOw0KIAkJCWJyZWFrOw0KIAkJY2FzZSAnRic6DQpAQCAtMTM2LDcg
KzEzNiw3IEBADQogCQkJc2V0X29wZXJhdGlvbl9tb2RlKCZtb2RlLCBTVEFU
U19NT0RFLCBhcmd2KTsNCiAJCQlicmVhazsNCiAJCWRlZmF1bHQ6DQotCQkJ
ZnByaW50ZihzdGRvdXQsIHVzYWdlLCBWRVJTSU9OKTsNCisJCQlmcHJpbnRm
KHN0ZG91dCwgdXNhZ2UsIFZFUlNJT04sIGFyZ3ZbMF0pOw0KIAkJCWZwcmlu
dGYoc3Rkb3V0LCAiVW5rbm93biBvcHRpb246ICVzXG4iLCBhcmd2W2ldKTsN
CiAJCQlyZXR1cm4gMDsNCiAJCQlicmVhazsNCg==

---187430788-123978349-1150809710=:8549--
