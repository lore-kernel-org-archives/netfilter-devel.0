From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: [PATCH] CTA_PROTO_NUM is u_int8_t not u_int16_t (was Re:
 CTA_PROTO_NUM u_int8_t or u_int16_t)
Date: Tue, 13 Dec 2005 10:56:08 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0512131041090.928@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0511231128510.9162@bizon.gios.gov.pl>
	<20051124200736.GW31478@sunbeam.de.gnumonks.org>
	<20051124202125.GX31478@sunbeam.de.gnumonks.org>
	<43864DC7.6060109@trash.net>
	<Pine.LNX.4.64.0511250040030.14092@bizon.gios.gov.pl>
	<20051125084427.GL31478@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.64.0511251019330.32144@bizon.gios.gov.pl>
	<438710E1.2000202@trash.net> <4387A946.3000005@eurodev.net>
	<Pine.LNX.4.64.0511272313570.28434@bizon.gios.gov.pl>
	<20051129040925.GC3544@rama.towersoft.de> <438CDF45.9040308@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1793095467-1134467768=:928"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira Ayuso <pablo@eurodev.net>, stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <438CDF45.9040308@trash.net>
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

---187430788-1793095467-1134467768=:928
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 30 Nov 2005, Patrick McHardy wrote:

> Harald Welte wrote:
>> No, I oppose any kind of kernel version number checking.  I'd rather
>> break 2.6.14 with new versions of the userspace.
>>=20
>
> The stable tree has a couple of patches pending, so I guess there
> will be another release. I'll ask them if they would take a patch
> to fix this issue.
>

The review cycle for the 2.6.14.4 was started. I can't find this fix in=20
listed patches and it seems 2.6.14 needs little different patch than=20
2.6.15: s/size_t/int/.

Patch attached, not sure what to do with Signed-off-by lines so please=20
feel free to correct it.

Any chances for submitting it into -stable for inclusion in 2.6.14.4?

Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-1793095467-1134467768=:928
Content-Type: TEXT/PLAIN; charset=US-ASCII;
	name=CTA_PROTO_NUM-u_int8_t-2.6.14.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0512131056080.928@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=CTA_PROTO_NUM-u_int8_t-2.6.14.patch

W05FVEZJTFRFUl06IEZpeCBDVEFfUFJPVE9fTlVNIGF0dHJpYnV0ZSBzaXpl
IGluIGN0bmV0bGluayAoMi42LjE0LnggdmVyc2lvbikNCg0KQ1RBX1BST1RP
X05VTSBpcyBhIHVfaW50OF90Lg0KDQpCYXNlZCBvbiBvcnlnaW5hbCBwYXRj
aCBieSBQYXRyaWNrIE1jSGFyZHkgPGthYmVyQHRyYXNoLm5ldD4NCg0KU2ln
bmVkLW9mZi1ieTogS3J6eXN6dG9mIFBpb3RyIE9sZWR6a2kgPG9sZUBhbnMu
cGw+DQoNCi0tLSBhL25ldC9pcHY0L25ldGZpbHRlci9pcF9jb25udHJhY2tf
bmV0bGluay5jDQorKysgYi9uZXQvaXB2NC9uZXRmaWx0ZXIvaXBfY29ubnRy
YWNrX25ldGxpbmsuYw0KQEAgLTUwMyw3ICs1MDMsNyBAQCBjdG5ldGxpbmtf
cGFyc2VfdHVwbGVfaXAoc3RydWN0IG5mYXR0ciAqDQogfQ0KIA0KIHN0YXRp
YyBjb25zdCBpbnQgY3RhX21pbl9wcm90b1tDVEFfUFJPVE9fTUFYXSA9IHsN
Ci0JW0NUQV9QUk9UT19OVU0tMV0JPSBzaXplb2YodV9pbnQxNl90KSwNCisJ
W0NUQV9QUk9UT19OVU0tMV0JPSBzaXplb2YodV9pbnQ4X3QpLA0KIAlbQ1RB
X1BST1RPX1NSQ19QT1JULTFdCT0gc2l6ZW9mKHVfaW50MTZfdCksDQogCVtD
VEFfUFJPVE9fRFNUX1BPUlQtMV0JPSBzaXplb2YodV9pbnQxNl90KSwNCiAJ
W0NUQV9QUk9UT19JQ01QX1RZUEUtMV0JPSBzaXplb2YodV9pbnQ4X3QpLA0K
QEAgLTUyOCw3ICs1MjgsNyBAQCBjdG5ldGxpbmtfcGFyc2VfdHVwbGVfcHJv
dG8oc3RydWN0IG5mYXR0DQogDQogCWlmICghdGJbQ1RBX1BST1RPX05VTS0x
XSkNCiAJCXJldHVybiAtRUlOVkFMOw0KLQl0dXBsZS0+ZHN0LnByb3RvbnVt
ID0gKih1X2ludDE2X3QgKilORkFfREFUQSh0YltDVEFfUFJPVE9fTlVNLTFd
KTsNCisJdHVwbGUtPmRzdC5wcm90b251bSA9ICoodV9pbnQ4X3QgKilORkFf
REFUQSh0YltDVEFfUFJPVE9fTlVNLTFdKTsNCiANCiAJcHJvdG8gPSBpcF9j
b25udHJhY2tfcHJvdG9fZmluZF9nZXQodHVwbGUtPmRzdC5wcm90b251bSk7
DQogDQo=

---187430788-1793095467-1134467768=:928--
