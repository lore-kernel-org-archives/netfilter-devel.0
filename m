From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [FUN] New target: passive OS fingerprinting.
Date: Thu, 27 Nov 2003 23:02:51 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031127230251.70eedce3.johnpol@2ka.mipt.ru>
References: <20031124101806.GI4888@obroa-skai.de.gnumonks.org>
	<20031124230108.752aab76.johnpol@2ka.mipt.ru>
	<20031126194454.GC3740@obroa-skai.de.gnumonks.org>
	<20031127173310.56eeb5f8.johnpol@2ka.mipt.ru>
	<20031127174107.424fc0b1.johnpol@2ka.mipt.ru>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Thu__27_Nov_2003_23_02_51_+0300_PtfBpfQTIHdS_+rQ"
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: johnpol@2ka.mipt.ru
In-Reply-To: <20031127174107.424fc0b1.johnpol@2ka.mipt.ru>
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

--Multipart=_Thu__27_Nov_2003_23_02_51_+0300_PtfBpfQTIHdS_+rQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

And the fourth patch on top of previous 3:
right comments.

Kudos to Michal Zalewski and Mike Frantzen about SMART_MSS idea.

	Evgeniy Polyakov ( s0mbre )

--Multipart=_Thu__27_Nov_2003_23_02_51_+0300_PtfBpfQTIHdS_+rQ
Content-Type: application/octet-stream;
 name="pom-ipt_osf.patch"
Content-Disposition: attachment;
 filename="pom-ipt_osf.patch"
Content-Transfer-Encoding: base64

LS0tIG5ldGZpbHRlci9wYXRjaC1vLW1hdGljL2Jhc2Uvb3NmLnBhdGNoCVRodSBOb3YgMjcgMTc6
MzI6NDUgMjAwMworKysgbmV0ZmlsdGVyL3BhdGNoLW8tbWF0aWMvYmFzZS9vc2YucGF0Y2gJVGh1
IE5vdiAyNyAyMjo1OTowOSAyMDAzCkBAIC0yOTQsNyArMjk0LDcgQEAKICsJCQkJCQkJZm1hdGNo
ID0gRk1BVENIX09LOwogKwkJCQkJCWJyZWFrOwogKwkJCQkJY2FzZSAxOiAvKiBNU1MgKi8KLSsv
KiBMdXJrZWQgaW4gT3BlbkJTRCAqLworKy8qIEx1cmtlZCBpbiBPcGVuQlNELiAgSWRlYSBvZiBN
aWNoYWwgWmFsZXdza2kgKi8KICsjZGVmaW5lIFNNQVJUX01TUwkxNDYwCiArCQkJCQkJaWYgKHdp
bmRvdyA9PSBmLT53c3MudmFsKm1zcyB8fCAKICsJCQkJCQkJd2luZG93ID09IGYtPndzcy52YWwq
U01BUlRfTVNTKQpAQCAtNzg4LDggKzc4OCw4IEBACiArTU9EVUxFX0xJQ0VOU0UoIkdQTCIpOwog
K01PRFVMRV9BVVRIT1IoIkV2Z2VuaXkgUG9seWFrb3YgPGpvaG5wb2xAMmthLm1pcHQucnU+Iik7
CiArTU9EVUxFX0RFU0NSSVBUSU9OKCJQYXNzaXZlIE9TIGZpbmdlcnByaW50IG1hdGNoaW5nLiIp
OwotLS0tIGxpbnV4L2lubHVkZS9saW51eC9uZXRmaWx0ZXJfaXB2NC9pcHRfb3NmLmgJVGh1IE9j
dCAzMCAyMTozMToyMyAyMDAzCi0rKysgbGludXgvaW5sdWRlL2xpbnV4L25ldGZpbHRlcl9pcHY0
L2lwdF9vc2YuaAlNb24gTm92IDI0IDE4OjMzOjQyIDIwMDMKKy0tLSBsaW51eC9pbmNsdWRlL2xp
bnV4L25ldGZpbHRlcl9pcHY0L2lwdF9vc2YuaAlUaHUgT2N0IDMwIDIxOjMxOjIzIDIwMDMKKysr
KyBsaW51eC9pbmNsdWRlL2xpbnV4L25ldGZpbHRlcl9pcHY0L2lwdF9vc2YuaAlNb24gTm92IDI0
IDE4OjMzOjQyIDIwMDMKIEBAIC0wLDAgKzEsMTMwIEBACiArLyoKICsgKiBpcHRfb3NmLmgK

--Multipart=_Thu__27_Nov_2003_23_02_51_+0300_PtfBpfQTIHdS_+rQ--
