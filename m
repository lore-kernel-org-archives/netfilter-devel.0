From: Patrick McHardy <kaber@trash.net>
Subject: Re: Linux 2.6.12 REDIRECT bug?
Date: Thu, 23 Jun 2005 14:29:09 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0506231428220.3964@kaber.coreworks.de>
References: <42B956F7.8080704@freesurf.fr>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="279739137-478399739-1119529749=:3964"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Bradley King <bking@freesurf.fr>
In-Reply-To: <42B956F7.8080704@freesurf.fr>
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

--279739137-478399739-1119529749=:3964
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

On Wed, 22 Jun 2005, Bradley King wrote:

> [1.] One line summary of the problem:
> the iptables REDIRECT kernel module seems to fail with kernel 2.6.12
>
> [2.] Full description of the problem/report:
> Have been running previous 2.6.x versions w/o problems A command like:
> iptables -t nat -A PREROUTING -i br0  -p tcp --dport 80 -j REDIRECT --to-port 
> 8080
> (used to redirect intranet traffic through a NAT/MASQUERADE firewall short 
> circuits traffic (port 8080 see's no activity at all)
> I tried DNAT with the same results
> Note that the inferface is a bridge interface with an Ethernet and Wifi 
> interface bridged togeter

Does this patch help?

Regards
Patrick

--279739137-478399739-1119529749=:3964
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=diff
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.62.0506231429090.3964@kaber.coreworks.de>
Content-Description: 
Content-Disposition: attachment; filename=diff

ZGlmZiAtLWdpdCBhL25ldC9pcHY0L2lwX291dHB1dC5jIGIvbmV0L2lwdjQv
aXBfb3V0cHV0LmMNCi0tLSBhL25ldC9pcHY0L2lwX291dHB1dC5jDQorKysg
Yi9uZXQvaXB2NC9pcF9vdXRwdXQuYw0KQEAgLTE4OCw3ICsxODgsMTIgQEAg
c3RhdGljIGlubGluZSBpbnQgaXBfZmluaXNoX291dHB1dDIoc3RydQ0KIAkJ
c2tiID0gc2tiMjsNCiAJfQ0KIA0KLQluZl9yZXNldChza2IpOw0KKyNpZmRl
ZiBDT05GSUdfQlJJREdFX05FVEZJTFRFUg0KKwkvKiBicmlkZ2UtbmV0Zmls
dGVyIGRlZmVycyBjYWxsaW5nIHNvbWUgSVAgaG9va3MgdG8gdGhlIGJyaWRn
ZSBsYXllciBhbmQNCisJICogc3RpbGwgbmVlZHMgdGhlIGNvbm50cmFjayBy
ZWZlcmVuY2UgKi8NCisJaWYgKHNrYi0+bmZfYnJpZGdlID09IE5VTEwpDQor
I2VuZGlmDQorCQluZl9yZXNldChza2IpOw0KIA0KIAlpZiAoaGgpIHsNCiAJ
CWludCBoaF9hbGVuOw0K

--279739137-478399739-1119529749=:3964--
