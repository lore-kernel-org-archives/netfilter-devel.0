From: Patrick McHardy <kaber@trash.net>
Subject: Re: hashsize in nf_conntrack_ipv4
Date: Wed, 19 Dec 2007 11:17:32 +0100
Message-ID: <4768EFBC.8070300@trash.net>
References: <BAY122-W8237C00B08D4A997705B6BE5C0@phx.gbl>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010402060204030902080807"
Cc: netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: =?UTF-8?B?5p2O5Lyf5Y2O?= <liweihuahot@hotmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <BAY122-W8237C00B08D4A997705B6BE5C0@phx.gbl>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------010402060204030902080807
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

李伟华 wrote:
> 
> kernel version 2.6.23.9
> 
> when i load nf_conntrack_ipv4 with cmdline "modprobe ip_conntrack hashsize=10000" , 
> i got a err msg 
>          "FATAL: Error inserting nf_conntrack_ipv4 (/lib/modules/2.6.23.9/kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko):    
>          Unknown symbol in module, or unknown parameter (see dmesg)"   , 
> and endline in dmesg output 
>          "nf_conntrack_ipv4: Unknown parameter `hashsize' "
> 
> so,how can i set the buckets number when i loading ip_conntrack ?


Its a parameter of nf_conntrack now. But this is actually a bug since
we wanted to stay compatible from a user perspective. Could you
try if this patch makes it work with modprobe ip_conntrack again?


--------------010402060204030902080807
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="x"

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2suaCBiL2lu
Y2x1ZGUvbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2suaAppbmRleCA5MGZiNjZkLi40YWM1
YWIxIDEwMDY0NAotLS0gYS9pbmNsdWRlL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrLmgK
KysrIGIvaW5jbHVkZS9uZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFjay5oCkBAIC0yNDksNiAr
MjQ5LDcgQEAgc3RhdGljIGlubGluZSBpbnQgbmZfY3RfaXNfdW50cmFja2VkKGNvbnN0IHN0
cnVjdCBza19idWZmICpza2IpCiAJcmV0dXJuIChza2ItPm5mY3QgPT0gJm5mX2Nvbm50cmFj
a191bnRyYWNrZWQuY3RfZ2VuZXJhbCk7CiB9CiAKK2V4dGVybiBpbnQgbmZfY29ubnRyYWNr
X3NldF9oYXNoc2l6ZShjb25zdCBjaGFyICp2YWwsIHN0cnVjdCBrZXJuZWxfcGFyYW0gKmtw
KTsKIGV4dGVybiB1bnNpZ25lZCBpbnQgbmZfY29ubnRyYWNrX2h0YWJsZV9zaXplOwogZXh0
ZXJuIGludCBuZl9jb25udHJhY2tfY2hlY2tzdW07CiBleHRlcm4gYXRvbWljX3QgbmZfY29u
bnRyYWNrX2NvdW50OwpkaWZmIC0tZ2l0IGEvbmV0L2lwdjQvbmV0ZmlsdGVyL25mX2Nvbm50
cmFja19sM3Byb3RvX2lwdjQuYyBiL25ldC9pcHY0L25ldGZpbHRlci9uZl9jb25udHJhY2tf
bDNwcm90b19pcHY0LmMKaW5kZXggODMxZTliMi4uOTEwZGFlNyAxMDA2NDQKLS0tIGEvbmV0
L2lwdjQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19sM3Byb3RvX2lwdjQuYworKysgYi9uZXQv
aXB2NC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2wzcHJvdG9faXB2NC5jCkBAIC00MTksNiAr
NDE5LDkgQEAgc3RydWN0IG5mX2Nvbm50cmFja19sM3Byb3RvIG5mX2Nvbm50cmFja19sM3By
b3RvX2lwdjQgX19yZWFkX21vc3RseSA9IHsKIAkubWUJCSA9IFRISVNfTU9EVUxFLAogfTsK
IAorbW9kdWxlX3BhcmFtX2NhbGwoaGFzaHNpemUsIG5mX2Nvbm50cmFja19zZXRfaGFzaHNp
emUsIHBhcmFtX2dldF91aW50LAorCQkgICZuZl9jb25udHJhY2tfaHRhYmxlX3NpemUsIDA2
MDApOworCiBNT0RVTEVfQUxJQVMoIm5mX2Nvbm50cmFjay0iIF9fc3RyaW5naWZ5KEFGX0lO
RVQpKTsKIE1PRFVMRV9BTElBUygiaXBfY29ubnRyYWNrIik7CiBNT0RVTEVfTElDRU5TRSgi
R1BMIik7CmRpZmYgLS1naXQgYS9uZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19jb3JlLmMg
Yi9uZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19jb3JlLmMKaW5kZXggMDAwYzJmYi4uOTFm
OGRiZCAxMDA2NDQKLS0tIGEvbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfY29yZS5jCisr
KyBiL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2NvcmUuYwpAQCAtMTAxNiw3ICsxMDE2
LDcgQEAgc3RydWN0IGhsaXN0X2hlYWQgKm5mX2N0X2FsbG9jX2hhc2h0YWJsZShpbnQgKnNp
emVwLCBpbnQgKnZtYWxsb2NlZCkKIH0KIEVYUE9SVF9TWU1CT0xfR1BMKG5mX2N0X2FsbG9j
X2hhc2h0YWJsZSk7CiAKLWludCBzZXRfaGFzaHNpemUoY29uc3QgY2hhciAqdmFsLCBzdHJ1
Y3Qga2VybmVsX3BhcmFtICprcCkKK2ludCBuZl9jb25udHJhY2tfc2V0X2hhc2hzaXplKGNv
bnN0IGNoYXIgKnZhbCwgc3RydWN0IGtlcm5lbF9wYXJhbSAqa3ApCiB7CiAJaW50IGksIGJ1
Y2tldCwgaGFzaHNpemUsIHZtYWxsb2NlZDsKIAlpbnQgb2xkX3ZtYWxsb2NlZCwgb2xkX3Np
emU7CkBAIC0xMDY0LDcgKzEwNjQsNyBAQCBpbnQgc2V0X2hhc2hzaXplKGNvbnN0IGNoYXIg
KnZhbCwgc3RydWN0IGtlcm5lbF9wYXJhbSAqa3ApCiAJcmV0dXJuIDA7CiB9CiAKLW1vZHVs
ZV9wYXJhbV9jYWxsKGhhc2hzaXplLCBzZXRfaGFzaHNpemUsIHBhcmFtX2dldF91aW50LAor
bW9kdWxlX3BhcmFtX2NhbGwoaGFzaHNpemUsIG5mX2Nvbm50cmFja19zZXRfaGFzaHNpemUs
IHBhcmFtX2dldF91aW50LAogCQkgICZuZl9jb25udHJhY2tfaHRhYmxlX3NpemUsIDA2MDAp
OwogCiBpbnQgX19pbml0IG5mX2Nvbm50cmFja19pbml0KHZvaWQpCg==
--------------010402060204030902080807--
