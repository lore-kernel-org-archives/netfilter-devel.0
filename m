From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/3] set SEEN_REPLY before destroying conntrack on TCP
 RST
Date: Tue, 27 May 2008 06:53:22 +0200
Message-ID: <483B93C2.1000905@trash.net>
References: <1211447601.6878.38.camel@pumper.lan.luxnet.ch> <1211826305.19222.8.camel@pumper.lan.luxnet.ch>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030906040104080608080807"
Cc: netfilter-devel@vger.kernel.org
To: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42232 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbYE0Ex0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 May 2008 00:53:26 -0400
In-Reply-To: <1211826305.19222.8.camel@pumper.lan.luxnet.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030906040104080608080807
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Fabian Hugelshofer wrote:
> On Thu, 2008-05-22 at 10:13 +0100, Fabian Hugelshofer wrote:
>> ﻿If a connection fails with a TCP reset, the conntrack is destroyed 
>> immediately. This patch sets the SEEN_REPLY bit before destroying the 
>> conntrack.
> 
> This updated version also increments the accounting counters.

Thanks, but this needs to be changed slightly.

> Do I see this right, that the commits should be observable in the
> patch-o-matic git, if they are done?

No, they go in my nf-next-2.6.git tree. I'm uploading it
to (takes about 15 minutes):

git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-next-2.6.git

> --- linux-2.6.25.4.orig/net/netfilter/nf_conntrack_proto_tcp.c	2008-05-26 17:43:01.000000000 +0100
> +++ linux-2.6.25.4/net/netfilter/nf_conntrack_proto_tcp.c	2008-05-26 17:32:17.000000000 +0100
> @@ -22,6 +22,7 @@
>  #include <linux/netfilter_ipv4.h>
>  #include <linux/netfilter_ipv6.h>
>  #include <net/netfilter/nf_conntrack.h>
> +#include <net/netfilter/nf_conntrack_core.h>
>  #include <net/netfilter/nf_conntrack_l4proto.h>
>  #include <net/netfilter/nf_conntrack_ecache.h>
>  #include <net/netfilter/nf_log.h>
> @@ -960,8 +961,19 @@
>  		/* If only reply is a RST, we can consider ourselves not to
>  		   have an established connection: this is a fairly common
>  		   problem case, so we can delete the conntrack
> -		   immediately.  --RR */
> +		   immediately.  --RR
> +		   The SEEN_REPLY bit and the accounting counters are updated
> +		   here to have the correct information in the ct event. */
>  		if (th->rst) {
> +			if (ctinfo >= IP_CT_IS_REPLY)
> +				set_bit(IPS_SEEN_REPLY_BIT, &ct->status);
> +#ifdef CONFIG_NF_CT_ACCT
> +			spin_lock_bh(&nf_conntrack_lock);
 > +			ct->counters[CTINFO2DIR(ctinfo)].packets++;
 > +			ct->counters[CTINFO2DIR(ctinfo)].bytes +=

I'm trying to get rid of nf_conntrack_lock uses outside of the
connection tracking core, so this is a move in the wrong direction.
Also the same needs to be done for ICMP, DCCP, ICMPv6 and possibly
more.

> +				skb->len - skb_network_offset(skb);
> +			spin_unlock_bh(&nf_conntrack_lock);
> +#endif
>  			if (del_timer(&ct->timeout))
>  				ct->timeout.function((unsigned long)ct);

I think a better way is to encapsulate the del_timer/timeout.function
calls in a nf_ct_kill() function and perform accounting there.
Since all manual invocations of timeout.function are/should be
performed only while handling packets (that are usually not
accounted), this seems like the right way.

The attached patch (also queued in the tree mentioned above) does
the encapsulation. Please split your patch into two parts
(SEEN_REPLY and accounting) and add a Signed-off-by: line.



--------------030906040104080608080807
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="x"

Y29tbWl0IGJiMmQzZGRiOGZlNDZmMzg3ZWViOTIyMjAwNTBkY2Q3NmU1YjYwNzEKQXV0aG9y
OiBQYXRyaWNrIE1jSGFyZHkgPGthYmVyQHRyYXNoLm5ldD4KRGF0ZTogICBUdWUgTWF5IDI3
IDA2OjQ2OjQwIDIwMDggKzAyMDAKCiAgICBbTkVURklMVEVSXTogbmZfY29ubnRyYWNrOiBh
ZGQgbmZfY3Rfa2lsbCgpCiAgICAKICAgIEVuY2Fwc3VsYXRlIHRoZSBjb21tb24KICAgIAog
ICAgCWlmIChkZWxfdGltZXIoJmN0LT50aW1lb3V0KSkKICAgIAkJY3QtPnRpbWVvdXQuZnVu
Y3Rpb24oKHVuc2lnbmVkIGxvbmcpY3QpCiAgICAKICAgIHNlcXVlbmNlIGluIGEgbmV3IGZ1
bmN0aW9uLgogICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBQYXRyaWNrIE1jSGFyZHkgPGthYmVy
QHRyYXNoLm5ldD4KCmRpZmYgLS1naXQgYS9pbmNsdWRlL25ldC9uZXRmaWx0ZXIvbmZfY29u
bnRyYWNrLmggYi9pbmNsdWRlL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrLmgKaW5kZXgg
MmRiZDZjMC4uZmMxOWFiMiAxMDA2NDQKLS0tIGEvaW5jbHVkZS9uZXQvbmV0ZmlsdGVyL25m
X2Nvbm50cmFjay5oCisrKyBiL2luY2x1ZGUvbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2su
aApAQCAtMjIzLDYgKzIyMyw4IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBuZl9jdF9yZWZyZXNo
KHN0cnVjdCBuZl9jb25uICpjdCwKIAlfX25mX2N0X3JlZnJlc2hfYWNjdChjdCwgMCwgc2ti
LCBleHRyYV9qaWZmaWVzLCAwKTsKIH0KIAorZXh0ZXJuIHZvaWQgbmZfY3Rfa2lsbChzdHJ1
Y3QgbmZfY29ubiAqY3QpOworCiAvKiBUaGVzZSBhcmUgZm9yIE5BVC4gIElja3kuICovCiAv
KiBVcGRhdGUgVENQIHdpbmRvdyB0cmFja2luZyBkYXRhIHdoZW4gTkFUIG1hbmdsZXMgdGhl
IHBhY2tldCAqLwogZXh0ZXJuIHZvaWQgbmZfY29ubnRyYWNrX3RjcF91cGRhdGUoY29uc3Qg
c3RydWN0IHNrX2J1ZmYgKnNrYiwKZGlmZiAtLWdpdCBhL25ldC9pcHY0L25ldGZpbHRlci9u
Zl9jb25udHJhY2tfcHJvdG9faWNtcC5jIGIvbmV0L2lwdjQvbmV0ZmlsdGVyL25mX2Nvbm50
cmFja19wcm90b19pY21wLmMKaW5kZXggNzhhYjE5YS4uMGUyMWE0NiAxMDA2NDQKLS0tIGEv
bmV0L2lwdjQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19wcm90b19pY21wLmMKKysrIGIvbmV0
L2lwdjQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19wcm90b19pY21wLmMKQEAgLTg3LDkgKzg3
LDggQEAgc3RhdGljIGludCBpY21wX3BhY2tldChzdHJ1Y3QgbmZfY29ubiAqY3QsCiAJICAg
bWVhbnMgdGhpcyB3aWxsIG9ubHkgcnVuIG9uY2UgZXZlbiBpZiBjb3VudCBoaXRzIHplcm8g
dHdpY2UKIAkgICAodGhlb3JldGljYWxseSBwb3NzaWJsZSB3aXRoIFNNUCkgKi8KIAlpZiAo
Q1RJTkZPMkRJUihjdGluZm8pID09IElQX0NUX0RJUl9SRVBMWSkgewotCQlpZiAoYXRvbWlj
X2RlY19hbmRfdGVzdCgmY3QtPnByb3RvLmljbXAuY291bnQpCi0JCSAgICAmJiBkZWxfdGlt
ZXIoJmN0LT50aW1lb3V0KSkKLQkJCWN0LT50aW1lb3V0LmZ1bmN0aW9uKCh1bnNpZ25lZCBs
b25nKWN0KTsKKwkJaWYgKGF0b21pY19kZWNfYW5kX3Rlc3QoJmN0LT5wcm90by5pY21wLmNv
dW50KSkKKwkJCW5mX2N0X2tpbGwoY3QpOwogCX0gZWxzZSB7CiAJCWF0b21pY19pbmMoJmN0
LT5wcm90by5pY21wLmNvdW50KTsKIAkJbmZfY29ubnRyYWNrX2V2ZW50X2NhY2hlKElQQ1Rf
UFJPVE9JTkZPX1ZPTEFUSUxFLCBza2IpOwpkaWZmIC0tZ2l0IGEvbmV0L2lwdjYvbmV0Zmls
dGVyL25mX2Nvbm50cmFja19wcm90b19pY21wdjYuYyBiL25ldC9pcHY2L25ldGZpbHRlci9u
Zl9jb25udHJhY2tfcHJvdG9faWNtcHY2LmMKaW5kZXggZWU3MTNiMC4uZmUwODFiOSAxMDA2
NDQKLS0tIGEvbmV0L2lwdjYvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19wcm90b19pY21wdjYu
YworKysgYi9uZXQvaXB2Ni9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX3Byb3RvX2ljbXB2Ni5j
CkBAIC04OSw5ICs4OSw4IEBAIHN0YXRpYyBpbnQgaWNtcHY2X3BhY2tldChzdHJ1Y3QgbmZf
Y29ubiAqY3QsCiAJICAgbWVhbnMgdGhpcyB3aWxsIG9ubHkgcnVuIG9uY2UgZXZlbiBpZiBj
b3VudCBoaXRzIHplcm8gdHdpY2UKIAkgICAodGhlb3JldGljYWxseSBwb3NzaWJsZSB3aXRo
IFNNUCkgKi8KIAlpZiAoQ1RJTkZPMkRJUihjdGluZm8pID09IElQX0NUX0RJUl9SRVBMWSkg
ewotCQlpZiAoYXRvbWljX2RlY19hbmRfdGVzdCgmY3QtPnByb3RvLmljbXAuY291bnQpCi0J
CSAgICAmJiBkZWxfdGltZXIoJmN0LT50aW1lb3V0KSkKLQkJCWN0LT50aW1lb3V0LmZ1bmN0
aW9uKCh1bnNpZ25lZCBsb25nKWN0KTsKKwkJaWYgKGF0b21pY19kZWNfYW5kX3Rlc3QoJmN0
LT5wcm90by5pY21wLmNvdW50KSkKKwkJCW5mX2N0X2tpbGwoY3QpOwogCX0gZWxzZSB7CiAJ
CWF0b21pY19pbmMoJmN0LT5wcm90by5pY21wLmNvdW50KTsKIAkJbmZfY29ubnRyYWNrX2V2
ZW50X2NhY2hlKElQQ1RfUFJPVE9JTkZPX1ZPTEFUSUxFLCBza2IpOwpkaWZmIC0tZ2l0IGEv
bmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfY29yZS5jIGIvbmV0L25ldGZpbHRlci9uZl9j
b25udHJhY2tfY29yZS5jCmluZGV4IGM0YjE3OTkuLjc5YjA3YzMgMTAwNjQ0Ci0tLSBhL25l
dC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2NvcmUuYworKysgYi9uZXQvbmV0ZmlsdGVyL25m
X2Nvbm50cmFja19jb3JlLmMKQEAgLTg0OCw2ICs4NDgsMTMgQEAgYWNjdDoKIH0KIEVYUE9S
VF9TWU1CT0xfR1BMKF9fbmZfY3RfcmVmcmVzaF9hY2N0KTsKIAordm9pZCBuZl9jdF9raWxs
KHN0cnVjdCBuZl9jb25uICpjdCkKK3sKKwlpZiAoZGVsX3RpbWVyKCZjdC0+dGltZW91dCkp
CisJCWN0LT50aW1lb3V0LmZ1bmN0aW9uKCh1bnNpZ25lZCBsb25nKWN0KTsKK30KK0VYUE9S
VF9TWU1CT0xfR1BMKG5mX2N0X2tpbGwpOworCiAjaWYgZGVmaW5lZChDT05GSUdfTkZfQ1Rf
TkVUTElOSykgfHwgZGVmaW5lZChDT05GSUdfTkZfQ1RfTkVUTElOS19NT0RVTEUpCiAKICNp
bmNsdWRlIDxsaW51eC9uZXRmaWx0ZXIvbmZuZXRsaW5rLmg+CmRpZmYgLS1naXQgYS9uZXQv
bmV0ZmlsdGVyL25mX2Nvbm50cmFja19uZXRsaW5rLmMgYi9uZXQvbmV0ZmlsdGVyL25mX2Nv
bm50cmFja19uZXRsaW5rLmMKaW5kZXggMTM5MThjMS4uYWI2NTVmNiAxMDA2NDQKLS0tIGEv
bmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfbmV0bGluay5jCisrKyBiL25ldC9uZXRmaWx0
ZXIvbmZfY29ubnRyYWNrX25ldGxpbmsuYwpAQCAtODEyLDkgKzgxMiw4IEBAIGN0bmV0bGlu
a19kZWxfY29ubnRyYWNrKHN0cnVjdCBzb2NrICpjdG5sLCBzdHJ1Y3Qgc2tfYnVmZiAqc2ti
LAogCQkJcmV0dXJuIC1FTk9FTlQ7CiAJCX0KIAl9Ci0JaWYgKGRlbF90aW1lcigmY3QtPnRp
bWVvdXQpKQotCQljdC0+dGltZW91dC5mdW5jdGlvbigodW5zaWduZWQgbG9uZyljdCk7CiAK
KwluZl9jdF9raWxsKGN0KTsKIAluZl9jdF9wdXQoY3QpOwogCiAJcmV0dXJuIDA7CmRpZmYg
LS1naXQgYS9uZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19wcm90b19kY2NwLmMgYi9uZXQv
bmV0ZmlsdGVyL25mX2Nvbm50cmFja19wcm90b19kY2NwLmMKaW5kZXggYWZiNGExOC4uMjIz
NzQyZiAxMDA2NDQKLS0tIGEvbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfcHJvdG9fZGNj
cC5jCisrKyBiL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX3Byb3RvX2RjY3AuYwpAQCAt
NDc1LDggKzQ3NSw3IEBAIHN0YXRpYyBpbnQgZGNjcF9wYWNrZXQoc3RydWN0IG5mX2Nvbm4g
KmN0LCBjb25zdCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiLAogCWlmICh0eXBlID09IERDQ1BfUEtU
X1JFU0VUICYmCiAJICAgICF0ZXN0X2JpdChJUFNfU0VFTl9SRVBMWV9CSVQsICZjdC0+c3Rh
dHVzKSkgewogCQkvKiBUZWFyIGRvd24gY29ubmVjdGlvbiBpbW1lZGlhdGVseSBpZiBvbmx5
IHJlcGx5IGlzIGEgUkVTRVQgKi8KLQkJaWYgKGRlbF90aW1lcigmY3QtPnRpbWVvdXQpKQot
CQkJY3QtPnRpbWVvdXQuZnVuY3Rpb24oKHVuc2lnbmVkIGxvbmcpY3QpOworCQluZl9jdF9r
aWxsKGN0KTsKIAkJcmV0dXJuIE5GX0FDQ0VQVDsKIAl9CiAKZGlmZiAtLWdpdCBhL25ldC9u
ZXRmaWx0ZXIvbmZfY29ubnRyYWNrX3Byb3RvX3RjcC5jIGIvbmV0L25ldGZpbHRlci9uZl9j
b25udHJhY2tfcHJvdG9fdGNwLmMKaW5kZXggYmE5NDAwNC4uYzRhYTExZSAxMDA2NDQKLS0t
IGEvbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfcHJvdG9fdGNwLmMKKysrIGIvbmV0L25l
dGZpbHRlci9uZl9jb25udHJhY2tfcHJvdG9fdGNwLmMKQEAgLTg0Myw4ICs4NDMsNyBAQCBz
dGF0aWMgaW50IHRjcF9wYWNrZXQoc3RydWN0IG5mX2Nvbm4gKmN0LAogCQkJLyogQXR0ZW1w
dCB0byByZW9wZW4gYSBjbG9zZWQvYWJvcnRlZCBjb25uZWN0aW9uLgogCQkJICogRGVsZXRl
IHRoaXMgY29ubmVjdGlvbiBhbmQgbG9vayB1cCBhZ2Fpbi4gKi8KIAkJCXdyaXRlX3VubG9j
a19iaCgmdGNwX2xvY2spOwotCQkJaWYgKGRlbF90aW1lcigmY3QtPnRpbWVvdXQpKQotCQkJ
CWN0LT50aW1lb3V0LmZ1bmN0aW9uKCh1bnNpZ25lZCBsb25nKWN0KTsKKwkJCW5mX2N0X2tp
bGwoY3QpOwogCQkJcmV0dXJuIC1ORl9SRVBFQVQ7CiAJCX0KIAkJLyogRmFsbCB0aHJvdWdo
ICovCkBAIC04NzcsOCArODc2LDcgQEAgc3RhdGljIGludCB0Y3BfcGFja2V0KHN0cnVjdCBu
Zl9jb25uICpjdCwKIAkJCWlmIChMT0dfSU5WQUxJRChJUFBST1RPX1RDUCkpCiAJCQkJbmZf
bG9nX3BhY2tldChwZiwgMCwgc2tiLCBOVUxMLCBOVUxMLCBOVUxMLAogCQkJCQkgICJuZl9j
dF90Y3A6IGtpbGxpbmcgb3V0IG9mIHN5bmMgc2Vzc2lvbiAiKTsKLQkJCWlmIChkZWxfdGlt
ZXIoJmN0LT50aW1lb3V0KSkKLQkJCQljdC0+dGltZW91dC5mdW5jdGlvbigodW5zaWduZWQg
bG9uZyljdCk7CisJCQluZl9jdF9raWxsKGN0KTsKIAkJCXJldHVybiAtTkZfRFJPUDsKIAkJ
fQogCQljdC0+cHJvdG8udGNwLmxhc3RfaW5kZXggPSBpbmRleDsKQEAgLTk2MSw4ICs5NTks
NyBAQCBzdGF0aWMgaW50IHRjcF9wYWNrZXQoc3RydWN0IG5mX2Nvbm4gKmN0LAogCQkgICBw
cm9ibGVtIGNhc2UsIHNvIHdlIGNhbiBkZWxldGUgdGhlIGNvbm50cmFjawogCQkgICBpbW1l
ZGlhdGVseS4gIC0tUlIgKi8KIAkJaWYgKHRoLT5yc3QpIHsKLQkJCWlmIChkZWxfdGltZXIo
JmN0LT50aW1lb3V0KSkKLQkJCQljdC0+dGltZW91dC5mdW5jdGlvbigodW5zaWduZWQgbG9u
ZyljdCk7CisJCQluZl9jdF9raWxsKGN0KTsKIAkJCXJldHVybiBORl9BQ0NFUFQ7CiAJCX0K
IAl9IGVsc2UgaWYgKCF0ZXN0X2JpdChJUFNfQVNTVVJFRF9CSVQsICZjdC0+c3RhdHVzKQo=
--------------030906040104080608080807--
