From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Again, HOPLIMIT inconsistency
Date: Fri, 5 Mar 2004 12:05:50 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403051150320.7448-200000@filer.marasystems.com>
References: <Pine.LNX.4.33.0403051034030.6328-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-1125921772-1078484750=:7448"
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0403051034030.6328-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---1463811839-1125921772-1078484750=:7448
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Fri, 5 Mar 2004, Jozsef Kadlecsik wrote:

> I have just committed your jumbo patch in cvs. Sorry for the delay and
> thank you the patience both of you.

Many thanks.

However, there is still some small issues

1. Part of the linux.patch for CONNMARK has been moved to a .ladd file,
and needs to be removed from linux.patch. Patch patch atteched.

2. ipv6 TRACE 2.4 .ladd files looks misplaced. From what I can tell these
belong in net/ipv6/netfilter/, not net/ipv6/

   cd TRACE/linux-2.4/net/ipv6
   mv Config.in.ladd Makefile.ladd netfilter/
   cvs add netfilter/*.ladd
   cvs delete Config.in.ladd Makefile.ladd


Regards
Henrik

---1463811839-1125921772-1078484750=:7448
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="CONNMARK_mark_ladd.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44.0403051205500.7448@filer.marasystems.com>
Content-Description: 
Content-Disposition: attachment; filename="CONNMARK_mark_ladd.patch"

SW5kZXg6IENPTk5NQVJLL2xpbnV4LnBhdGNoDQo9PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09DQpSQ1MgZmlsZTogL2N2c3B1YmxpYy9wYXRjaC1vLW1hdGljLW5n
L0NPTk5NQVJLL2xpbnV4LnBhdGNoLHYNCnJldHJpZXZpbmcgcmV2aXNpb24g
MS4zDQpkaWZmIC11IC1yMS4zIGxpbnV4LnBhdGNoDQotLS0gQ09OTk1BUksv
bGludXgucGF0Y2gJNSBNYXIgMjAwNCAwOTozMDoyNSAtMDAwMAkxLjMNCisr
KyBDT05OTUFSSy9saW51eC5wYXRjaAk1IE1hciAyMDA0IDEwOjU5OjA0IC0w
MDAwDQpAQCAtMSwxNiArMSwzIEBADQotZGlmZiAtdU4gbGludXgtMi40LjMt
cHJlMy9pbmNsdWRlL2xpbnV4L25ldGZpbHRlcl9pcHY0L2lwX2Nvbm50cmFj
ay5oIGxpbnV4LTIuNC4zLXByZTMtdW1sL2luY2x1ZGUvbGludXgvbmV0Zmls
dGVyX2lwdjQvaXBfY29ubnRyYWNrLmgNCi0tLS0gbGludXgtMi40LjMtcHJl
My9pbmNsdWRlL2xpbnV4L25ldGZpbHRlcl9pcHY0L2lwX2Nvbm50cmFjay5o
CUZyaSBNYXIgIDkgMjE6NDM6MjggMjAwMQ0KLSsrKyBsaW51eC0yLjQuMy1w
cmUzLXVtbC9pbmNsdWRlL2xpbnV4L25ldGZpbHRlcl9pcHY0L2lwX2Nvbm50
cmFjay5oCVdlZCBNYXIgMjEgMTM6MjA6MzcgMjAwMQ0KLUBAIC0xNDcsNiAr
MTQ3LDkgQEANCi0gCX0gbmF0Ow0KLSAjZW5kaWYgLyogQ09ORklHX0lQX05G
X05BVF9ORUVERUQgKi8NCi0gDQotKyNpZiBkZWZpbmVkKENPTkZJR19JUF9O
Rl9DT05OVFJBQ0tfTUFSSykNCi0rCXVuc2lnbmVkIGxvbmcgbWFyazsNCi0r
I2VuZGlmDQotIH07DQotIA0KLSAvKiBBbHRlciByZXBseSB0dXBsZSAobWF5
YmUgYWx0ZXIgaGVscGVyKS4gIElmIGl0J3MgYWxyZWFkeSB0YWtlbiwNCiBk
aWZmIC11TiAtLWV4Y2x1ZGUgLiogLS1leGNsdWRlICoubyBsaW51eC0yLjQu
My1wcmUzL25ldC9pcHY0L25ldGZpbHRlci9pcF9jb25udHJhY2tfc3RhbmRh
bG9uZS5jIGxpbnV4LTIuNC4zLXByZTMtdW1sL25ldC9pcHY0L25ldGZpbHRl
ci9pcF9jb25udHJhY2tfc3RhbmRhbG9uZS5jDQogLS0tIGxpbnV4LTIuNC4z
LXByZTMvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwX2Nvbm50cmFja19zdGFuZGFs
b25lLmMJVGh1IEF1ZyAxMCAyMTozNToxNSAyMDAwDQogKysrIGxpbnV4LTIu
NC4zLXByZTMtdW1sL25ldC9pcHY0L25ldGZpbHRlci9pcF9jb25udHJhY2tf
c3RhbmRhbG9uZS5jCVdlZCBNYXIgMjEgMTM6MDQ6MTkgMjAwMQ0K
---1463811839-1125921772-1078484750=:7448--
