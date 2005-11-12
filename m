From: Krzysztof Oledzki <olenf@ans.pl>
Subject: [PATCH] Link netfilter before ipv4.
Date: Sat, 12 Nov 2005 02:07:24 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0511120202080.26844@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-453540461-1131757644=:26844"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
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

---187430788-453540461-1131757644=:26844
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello,

Attached (and inlined) patch moves netfilter before ipv4.
This is required for statically linked nf_conntrack_ipv4:

(...)
nf_conntrack_ipv4: can't register ipv4
TCP bic registered
TCP westwood registered
TCP highspeed registered
TCP hybla registered
TCP htcp registered
TCP vegas registered
TCP scalable registered
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.4.1 (4095 buckets, 32760 max)
(...)

[NETFILTER] Link netfilter before ipv4.

The netfilter code needs to be compiled&linked
before ipv4 because IPv4 support for NF_CONNTRACK
denends on it.

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>

diff -Nur linux-2.6.14-git14-orig/net/Makefile linux-2.6.14-git14/net/Makef=
ile
--- linux-2.6.14-git14-orig/net/Makefile=092005-10-28 02:02:08.000000000 +0=
200
+++ linux-2.6.14-git14/net/Makefile=092005-11-11 16:36:36.000000000 +0100
@@ -15,8 +15,8 @@
  # LLC has to be linked before the files in net/802/
  obj-$(CONFIG_LLC)=09=09+=3D llc/
  obj-$(CONFIG_NET)=09=09+=3D ethernet/ 802/ sched/ netlink/
-obj-$(CONFIG_INET)=09=09+=3D ipv4/
  obj-$(CONFIG_NETFILTER)=09=09+=3D netfilter/
+obj-$(CONFIG_INET)=09=09+=3D ipv4/
  obj-$(CONFIG_XFRM)=09=09+=3D xfrm/
  obj-$(CONFIG_UNIX)=09=09+=3D unix/
  ifneq ($(CONFIG_IPV6),)


Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-453540461-1131757644=:26844
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=netfilter-before-ipv4.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0511120207240.26844@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=netfilter-before-ipv4.patch

DQpbTkVURklMVEVSXSBMaW5rIG5ldGZpbHRlciBiZWZvcmUgaXB2NC4NCg0K
VGhlIG5ldGZpbHRlciBjb2RlIG5lZWRzIHRvIGJlIGNvbXBpbGVkJmxpbmtl
ZA0KYmVmb3JlIGlwdjQgYmVjYXVzZSBJUHY0IHN1cHBvcnQgZm9yIE5GX0NP
Tk5UUkFDSw0KZGVuZW5kcyBvbiBpdC4NCg0KU2lnbmVkLW9mZi1ieTogS3J6
eXN6dG9mIFBpb3RyIE9sZWR6a2kgPG9sZUBhbnMucGw+DQoNCmRpZmYgLU51
ciBsaW51eC0yLjYuMTQtZ2l0MTQtb3JpZy9uZXQvTWFrZWZpbGUgbGludXgt
Mi42LjE0LWdpdDE0L25ldC9NYWtlZmlsZQ0KLS0tIGxpbnV4LTIuNi4xNC1n
aXQxNC1vcmlnL25ldC9NYWtlZmlsZQkyMDA1LTEwLTI4IDAyOjAyOjA4LjAw
MDAwMDAwMCArMDIwMA0KKysrIGxpbnV4LTIuNi4xNC1naXQxNC9uZXQvTWFr
ZWZpbGUJMjAwNS0xMS0xMSAxNjozNjozNi4wMDAwMDAwMDAgKzAxMDANCkBA
IC0xNSw4ICsxNSw4IEBADQogIyBMTEMgaGFzIHRvIGJlIGxpbmtlZCBiZWZv
cmUgdGhlIGZpbGVzIGluIG5ldC84MDIvDQogb2JqLSQoQ09ORklHX0xMQykJ
CSs9IGxsYy8NCiBvYmotJChDT05GSUdfTkVUKQkJKz0gZXRoZXJuZXQvIDgw
Mi8gc2NoZWQvIG5ldGxpbmsvDQotb2JqLSQoQ09ORklHX0lORVQpCQkrPSBp
cHY0Lw0KIG9iai0kKENPTkZJR19ORVRGSUxURVIpCQkrPSBuZXRmaWx0ZXIv
DQorb2JqLSQoQ09ORklHX0lORVQpCQkrPSBpcHY0Lw0KIG9iai0kKENPTkZJ
R19YRlJNKQkJKz0geGZybS8NCiBvYmotJChDT05GSUdfVU5JWCkJCSs9IHVu
aXgvDQogaWZuZXEgKCQoQ09ORklHX0lQVjYpLCkNCg==

---187430788-453540461-1131757644=:26844--
