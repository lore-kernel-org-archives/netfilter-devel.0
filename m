From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH] Passive OS fingerprint matching module update. Dynamic
 fingerprint loading.
Date: Tue, 23 Sep 2003 11:22:52 +0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030923112252.4b4cef7c.johnpol@2ka.mipt.ru>
References: <20030922171921.009b2133.johnpol@2ka.mipt.ru>
	<20030922173231.5bd6a7ae.johnpol@2ka.mipt.ru>
	<20030922135151.GM31401@sunbeam.de.gnumonks.org>
	<20030922190325.3c4b19f8.johnpol@2ka.mipt.ru>
	<20030923112131.47ac5552.johnpol@2ka.mipt.ru>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart_Tue__23_Sep_2003_11:22:52_+0400_08336698"
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
   quaker@ondraszek.eu.org, solt@dns.toxicfilms.tv
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: johnpol@2ka.mipt.ru
In-Reply-To: <20030923112131.47ac5552.johnpol@2ka.mipt.ru>
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

--Multipart_Tue__23_Sep_2003_11:22:52_+0400_08336698
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 23 Sep 2003 11:21:31 +0400
Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> Attached patch contains bits of documentation for passive OS
> fingerprint matching module.
> Patch is against CVS-patch-o-matic 
> osf.patch.configure.help and osf.patch.help.
> 
> Please apply.
> 

Forgot attach.


	Evgeniy Polyakov

--Multipart_Tue__23_Sep_2003_11:22:52_+0400_08336698
Content-Type: application/octet-stream;
 name="help.diff"
Content-Disposition: attachment;
 filename="help.diff"
Content-Transfer-Encoding: base64

LS0tIHBhdGNoLW8tbWF0aWMvYmFzZS9vc2YucGF0Y2guaGVscC5vcmlnCTIwMDMtMDktMjMgMTE6
MDg6NTIuMDAwMDAwMDAwICswNDAwCisrKyBwYXRjaC1vLW1hdGljL2Jhc2Uvb3NmLnBhdGNoLmhl
bHAJMjAwMy0wOS0yMyAxMToxMzoyNS4wMDAwMDAwMDAgKzA0MDAKQEAgLTIzLDcgKzIzLDIxIEBA
CiAKICAgTk9URTogLXAgdGNwIGlzIG9idmlvdXNseSByZXF1aXJlZCBhcyBpdCBpcyBhIFRDUCBt
YXRjaC4KIAotICBUaGUgYXZhaWxhYmxlIGdlbnJlcyBhcmU6IExpbnV4LCBGcmVlQlNELCBOZXRC
U0QsIE9wZW5CU0QsIFdpbmRvd3MKKyAgSXQgaXMgcG9zc2libGUgdG8gZHluYW1pY2FsbHkgbG9h
ZC9mbHVzaCBmaW5nZXJwcmludHMgdGhyb3VnaCAvcHJvYyBmcy4KKyAgRm9yIGNvbXBsZXRlIGxp
c3Qgb2Ygc3VwcG9ydGVkIGZpbmdlcnByaW50cyBwbGVhc2UgdmlzaXQKKyAgaHR0cDovL3d3dy5v
cGVuYnNkLm9yZy9jZ2ktYmluL2N2c3dlYi9zcmMvZXRjL3BmLm9zIGFuZAorICBodHRwOi8vbGNh
bXR1Zi5jb3JlZHVtcC5jeC9wMGYuc2h0bWwuCisKKyAgRXhhbXBsZXM6CisJbG9hZGluZyBuZXcg
cnVsZToKKwllY2hvICIxNjM4NDo2NDowOjQ0Ok01MTI6LjpBSVg6NC4zLjIgYW5kIGVhcmxpZXIi
Pi9wcm9jL3N5cy9uZXQvaXB2NC9vc2YKKworCXJlYWRpbmcgbG9hZGVkIHJ1bGVzKAorCW5vdCBp
biBsb2FkaW5nIGZvcm1hdCwgYnV0IGZvciBpbmZvIGFib3V0IGdlbnJpZXMvZGV0YWlscyBvbmx5
KTogCisJY2F0IC9wcm9jL3N5cy9uZXQvaXB2NC9vc2YKKworCWRyb3BwaW5nIHdob2xlIGZpbmdl
cnByaW50IHRhYmxlIHdpdGggdGhlIGZvbGxvd2luZyBjb21tYW5kOgorCWVjaG8gLWVuIEZMVVNI
ID4gL3Byb2Mvc3lzL25ldC9pcHY0L29zZgogCiAgIElmIHlvdSBzYXkgWSBoZXJlLCB0cnkgaXB0
YWJsZXMgLW0gb3NmIC0taGVscCBmb3IgbW9yZSBpbmZvcm1hdGlvbi4KIAotLS0gcGF0Y2gtby1t
YXRpYy9iYXNlL29zZi5wYXRjaC5jb25maWd1cmUuaGVscC5vcmlnCTIwMDMtMDktMjMgMTE6MTY6
NTAuMDAwMDAwMDAwICswNDAwCisrKyBwYXRjaC1vLW1hdGljL2Jhc2Uvb3NmLnBhdGNoLmNvbmZp
Z3VyZS5oZWxwCTIwMDMtMDktMjMgMTE6MTc6MTcuMDAwMDAwMDAwICswNDAwCkBAIC0xNSw2ICsx
NSw4IEBACiAgIGJpdCBzZXQpIHdpdGggaGFyZGNvZGVkIGluIGZpbmdlcnNbXSB0YWJsZSBvbmVz
LgogCiAgIElmIHlvdSBzYXkgWSBoZXJlLCB0cnkgaXB0YWJsZXMgLW0gb3NmIC0taGVscCBmb3Ig
bW9yZSBpbmZvcm1hdGlvbi4KLSAKKworICBZb3UgbmVlZCB0byBlbmFibGUgcHJvY2ZzIGZvciBj
b3JyZWN0IGxvYWRpbmcvZmx1c2hpbmcgZmluZ2VycHJpbnRzLgorCiAgIElmIHlvdSB3YW50IHRv
IGNvbXBpbGUgaXQgYXMgYSBtb2R1bGUsIHNheSBNIGhlcmUgYW5kIHJlYWQKICAgRG9jdW1lbnRh
dGlvbi9tb2R1bGVzLnR4dC4gIElmIHVuc3VyZSwgc2F5IGBOJy4K

--Multipart_Tue__23_Sep_2003_11:22:52_+0400_08336698--
