From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [FUN] New target: passive OS fingerprinting.
Date: Thu, 27 Nov 2003 17:41:07 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031127174107.424fc0b1.johnpol@2ka.mipt.ru>
References: <20031124101806.GI4888@obroa-skai.de.gnumonks.org>
	<20031124230108.752aab76.johnpol@2ka.mipt.ru>
	<20031126194454.GC3740@obroa-skai.de.gnumonks.org>
	<20031127173310.56eeb5f8.johnpol@2ka.mipt.ru>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Thu__27_Nov_2003_17_41_07_+0300_EXX6n2kFmdOXwx=Q"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031127173310.56eeb5f8.johnpol@2ka.mipt.ru>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Thu__27_Nov_2003_17_41_07_+0300_EXX6n2kFmdOXwx=Q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

> On Wed, 26 Nov 2003 20:44:54 +0100
> Harald Welte <laforge@netfilter.org> wrote:
> 
> > 
> > Ok, I'll apply it to CVS.
> 
> Thank you.
> 
> Here is third patchset on top of previous two.

Attached.
 
> Please test and apply.
> 


	Evgeniy Polyakov ( s0mbre )

--Multipart=_Thu__27_Nov_2003_17_41_07_+0300_EXX6n2kFmdOXwx=Q
Content-Type: application/octet-stream;
 name="pom-ipt_osf.patch"
Content-Disposition: attachment;
 filename="pom-ipt_osf.patch"
Content-Transfer-Encoding: base64

LS0tIG5ldGZpbHRlci9wYXRjaC1vLW1hdGljL2Jhc2Uvb3NmLnBhdGNoCVRodSBOb3YgMjcgMTc6
MjY6MTkgMjAwMworKysgbmV0ZmlsdGVyL3BhdGNoLW8tbWF0aWMvYmFzZS9vc2YucGF0Y2gJVGh1
IE5vdiAyNyAxNzoyMDo1OCAyMDAzCkBAIC0xLDYgKzEsNiBAQAogLS0tIGxpbnV4L25ldC9pcHY0
L25ldGZpbHRlci9pcHRfb3NmLmMJVGh1IE9jdCAzMCAyMTozMToyMyAyMDAzCi0rKysgbGludXgv
bmV0L2lwdjQvbmV0ZmlsdGVyL2lwdF9vc2YuYwlXZWQgTm92IDI2IDA0OjAzOjQ5IDIwMDMKLUBA
IC0wLDAgKzEsNzY4IEBACisrKysgbGludXgvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwdF9vc2YuYwlU
aHUgTm92IDI3IDA0OjE0OjExIDIwMDMKK0BAIC0wLDAgKzEsNzg3IEBACiArLyoKICsgKiBpcHRf
b3NmLmMKICsgKgpAQCAtMTEwLDcgKzExMCw3IEBACiArCQllbmRmb3JfaWZhKGluX2Rldik7CiAr
CQkKICsJCWluX2Rldl9wdXQoaW5fZGV2KTsKLSsJCXJldHVybiAxOworKwkJcmV0dXJuIChpcC0+
dHRsIDw9IGZfdHRsKTsKICsJfQogKwllbHNlCiArCQlyZXR1cm4gKGlwLT50dGwgPT0gZl90dGwp
OwpAQCAtMjE5LDE1ICsyMTksMzAgQEAKICsKICsJCQlmb3IgKG9wdG51bT0wOyBvcHRudW08Zi0+
b3B0X251bTsgKytvcHRudW0pCiArCQkJewotKwkJCQlpZiAoZi0+b3B0W29wdG51bV0ua2luZCA9
PSAoKm9wdHApKQorKwkJCQlpZiAoZi0+b3B0W29wdG51bV0ua2luZCA9PSAoKm9wdHApKSAKICsJ
CQkJewogKwkJCQkJdW5zaWduZWQgY2hhciBsZW4gPSBmLT5vcHRbb3B0bnVtXS5sZW5ndGg7CiAr
CQkJCQl1bnNpZ25lZCBjaGFyICpvcHRlbmQgPSBvcHRwICsgbGVuOworKwkJCQkJaW50IGxvb3Bf
Y29udCA9IDA7CiArCiArCQkJCQlmbWF0Y2ggPSBGTUFUQ0hfT0s7CiArCi0rCQkJCQlpZiAoKm9w
dHAgPT0gT1NGT1BUX01TUykgLyogTVNTICovCi0rCQkJCQkJbXNzID0gbnRvaHMoKih1bnNpZ25l
ZCBzaG9ydCAqKShvcHRwKzIpKTsKKysKKysJCQkJCXN3aXRjaCAoKm9wdHApCisrCQkJCQl7Cisr
CQkJCQkJY2FzZSBPU0ZPUFRfTVNTOgorKwkJCQkJCQltc3MgPSBudG9ocygqKHVuc2lnbmVkIHNo
b3J0ICopKG9wdHArMikpOworKwkJCQkJCQlicmVhazsKKysJCQkJCQljYXNlIE9TRk9QVF9UUzoK
KysJCQkJCQkJbG9vcF9jb250ID0gMTsKKysJCQkJCQkJYnJlYWs7CisrCQkJCQl9CisrCQkJCQkK
KysJCQkJCWlmIChsb29wX2NvbnQpCisrCQkJCQl7CisrCQkJCQkJb3B0cCA9IG9wdGVuZDsKKysJ
CQkJCQljb250aW51ZTsKKysJCQkJCX0KICsJCQkJCQogKwkJCQkJaWYgKGxlbiAhPSAxKQogKwkJ
CQkJewpAQCAtMjc5LDExICsyOTQsMTUgQEAKICsJCQkJCQkJZm1hdGNoID0gRk1BVENIX09LOwog
KwkJCQkJCWJyZWFrOwogKwkJCQkJY2FzZSAxOiAvKiBNU1MgKi8KLSsJCQkJCQlpZiAod2luZG93
ID09IGYtPndzcy52YWwqbXNzKQorKy8qIEx1cmtlZCBpbiBPcGVuQlNEICovCisrI2RlZmluZSBT
TUFSVF9NU1MJMTQ2MAorKwkJCQkJCWlmICh3aW5kb3cgPT0gZi0+d3NzLnZhbCptc3MgfHwgCisr
CQkJCQkJCXdpbmRvdyA9PSBmLT53c3MudmFsKlNNQVJUX01TUykKICsJCQkJCQkJZm1hdGNoID0g
Rk1BVENIX09LOwogKwkJCQkJCWJyZWFrOwogKwkJCQkJY2FzZSAyOiAvKiBNVFUgKi8KLSsJCQkJ
CWlmICh3aW5kb3cgPT0gZi0+d3NzLnZhbCoobXNzKzQwKSkKKysJCQkJCQlpZiAod2luZG93ID09
IGYtPndzcy52YWwqKG1zcys0MCkgfHwKKysJCQkJCQkJd2luZG93ID09IGYtPndzcy52YWwqKFNN
QVJUX01TUys0MCkpCiArCQkJCQkJCWZtYXRjaCA9IEZNQVRDSF9PSzsKICsJCQkJCQlicmVhazsK
ICsJCQkJCWNhc2UgMzogLyogTU9EICovCg==

--Multipart=_Thu__27_Nov_2003_17_41_07_+0300_EXX6n2kFmdOXwx=Q--
