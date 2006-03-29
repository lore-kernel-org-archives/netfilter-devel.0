From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: Problems With Geoip and linux-2.6.16 .....
Date: Wed, 29 Mar 2006 19:49:40 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0603291946120.1705@bizon.gios.gov.pl>
References: <20060329151830.GA4313@69.17.112.251>
	<Pine.LNX.4.64.0603291745050.724@bizon.gios.gov.pl>
	<20060329160633.GA20866@69.17.112.251>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-564313910-1143654580=:1705"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Nick Pasich <NewsLetters@NickAndBarb.net>
In-Reply-To: <20060329160633.GA20866@69.17.112.251>
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

---187430788-564313910-1143654580=:1705
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 29 Mar 2006, Nick Pasich wrote:

> Krzysztof,
>
> Your's is the only reply I've received.
>
> Because Email doesn't get through to either Samuel Jean or
> Nickolas Boulain at <nib@cookinglinux.org> or <sjean@cookinglinux.org>,
> I'm wondering if anyone is maintaining "geoip" anymore.
>
> If not, I'll give it a whirl.....

Please test attached file. I don't use this extension so all I can tell=20
that the patch allows kernel to be modified with patched pom-ng and=20
then successufully compiled.

Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-564313910-1143654580=:1705
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=geoip.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0603291949400.1705@bizon.gios.gov.pl>
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

---187430788-564313910-1143654580=:1705--
