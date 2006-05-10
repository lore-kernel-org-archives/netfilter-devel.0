From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: Maintaining the geoip patchlet
Date: Thu, 11 May 2006 01:17:55 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0605110115580.9942@bizon.gios.gov.pl>
References: <twig.1146828937.80906@bugmachine.ca>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-580028132-1147303075=:9942"
Cc: netfilter-devel@lists.netfilter.org, NewsLetters@NickAndBarb.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Samuel Jean <jix@bugmachine.ca>
In-Reply-To: <twig.1146828937.80906@bugmachine.ca>
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

---187430788-580028132-1147303075=:9942
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 5 May 2006, Samuel Jean wrote:

> Hi,
>
> I've been quite busy past months and couldn't track the geoip status in
> current Linux kernels. I've dropped registration of cookinglinux.org and
> this is why our email addresses don't work anymore. Sorry for that.
>
> Nicolas and I will continue to maintain the geoip match. I am gonna setup
> the repository tonight, after work.
>
> I think this apt-like pom is a great idea.
>
> Keep up the good work.

I attached patch for geoip that makes it usable with 2.6.16.x kernels. It=
=20
also kills warnings about incompatible types. Thanks.

Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-580028132-1147303075=:9942
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=geoip.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0605110117550.9942@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=geoip.patch

ZGlmZiAtTnVyIHBhdGNoLW8tbWF0aWMtbmctMjAwNjAzMjgtb3JpZy9wYXRj
aGxldHMvZ2VvaXAvbGludXgtMi42L25ldC9pcHY0L25ldGZpbHRlci9NYWtl
ZmlsZS5sYWRkIHBhdGNoLW8tbWF0aWMtbmctMjAwNjAzMjgvcGF0Y2hsZXRz
L2dlb2lwL2xpbnV4LTIuNi9uZXQvaXB2NC9uZXRmaWx0ZXIvTWFrZWZpbGUu
bGFkZA0KLS0tIHBhdGNoLW8tbWF0aWMtbmctMjAwNjAzMjgtb3JpZy9wYXRj
aGxldHMvZ2VvaXAvbGludXgtMi42L25ldC9pcHY0L25ldGZpbHRlci9NYWtl
ZmlsZS5sYWRkCTIwMDUtMDEtMjMgMTY6NTM6MTQuMDAwMDAwMDAwICswMTAw
DQorKysgcGF0Y2gtby1tYXRpYy1uZy0yMDA2MDMyOC9wYXRjaGxldHMvZ2Vv
aXAvbGludXgtMi42L25ldC9pcHY0L25ldGZpbHRlci9NYWtlZmlsZS5sYWRk
CTIwMDYtMDMtMjkgMTk6MTc6MDkuMDAwMDAwMDAwICswMjAwDQpAQCAtMSwz
ICsxLDMgQEANCi1vYmotJChDT05GSUdfSVBfTkZfTUFUQ0hfTElNSVQpICs9
IGlwdF9saW1pdC5vDQorb2JqLSQoQ09ORklHX0lQX05GX01BVENIX1JFQ0VO
VCkgKz0gaXB0X3JlY2VudC5vDQogb2JqLSQoQ09ORklHX0lQX05GX01BVENI
X0dFT0lQKSArPSBpcHRfZ2VvaXAubw0KIA0KZGlmZiAtTnVyIHBhdGNoLW8t
bWF0aWMtbmctMjAwNjAzMjgtb3JpZy9wYXRjaGxldHMvZ2VvaXAvbGludXgt
Mi42L25ldC9pcHY0L25ldGZpbHRlci9pcHRfZ2VvaXAuYyBwYXRjaC1vLW1h
dGljLW5nLTIwMDYwMzI4L3BhdGNobGV0cy9nZW9pcC9saW51eC0yLjYvbmV0
L2lwdjQvbmV0ZmlsdGVyL2lwdF9nZW9pcC5jDQotLS0gcGF0Y2gtby1tYXRp
Yy1uZy0yMDA2MDMyOC1vcmlnL3BhdGNobGV0cy9nZW9pcC9saW51eC0yLjYv
bmV0L2lwdjQvbmV0ZmlsdGVyL2lwdF9nZW9pcC5jCTIwMDUtMDEtMjMgMTY6
NTM6MTQuMDAwMDAwMDAwICswMTAwDQorKysgcGF0Y2gtby1tYXRpYy1uZy0y
MDA2MDMyOC9wYXRjaGxldHMvZ2VvaXAvbGludXgtMi42L25ldC9pcHY0L25l
dGZpbHRlci9pcHRfZ2VvaXAuYwkyMDA2LTAzLTI5IDE5OjE2OjQ1LjAwMDAw
MDAwMCArMDIwMA0KQEAgLTk5LDYgKzk5LDcgQEANCiAgICAgICAgICAgICAg
ICAgIGNvbnN0IHN0cnVjdCBuZXRfZGV2aWNlICpvdXQsDQogICAgICAgICAg
ICAgICAgICBjb25zdCB2b2lkICptYXRjaGluZm8sDQogICAgICAgICAgICAg
ICAgICBpbnQgb2Zmc2V0LA0KKwkJIHVuc2lnbmVkIGludCBwcm90b2ZmLA0K
ICAgICAgICAgICAgICAgICAgaW50ICpob3Rkcm9wKQ0KIHsNCiAgICBjb25z
dCBzdHJ1Y3QgaXB0X2dlb2lwX2luZm8gKmluZm8gPSBtYXRjaGluZm87DQpA
QCAtMTMzLDcgKzEzNCw3IEBADQogfQ0KIA0KIHN0YXRpYyBpbnQgZ2VvaXBf
Y2hlY2tlbnRyeShjb25zdCBjaGFyICp0YWJsZW5hbWUsDQotICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBjb25zdCBzdHJ1Y3QgaXB0X2lwICppcCwN
CisgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnN0IHZvaWQgKmlw
LA0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdm9pZCAqbWF0Y2hp
bmZvLA0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdW5zaWduZWQg
aW50IG1hdGNoc2l6ZSwNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IHVuc2lnbmVkIGludCBob29rX21hc2spDQo=

---187430788-580028132-1147303075=:9942--
