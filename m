From: Krzysztof Oledzki <olenf@ans.pl>
Subject: [PATCH] net/ipv6/netfilter/Kconfig cleanups
Date: Sat, 12 Nov 2005 02:13:40 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0511120207340.26844@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-31064403-1131758020=:26844"
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

---187430788-31064403-1131758020=:26844
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello,

Attached (and inlined) patch moves NF_CONNTRACK_IPV6 so both "IPv6:=20
Netfilter Configuration" and "IP: Netfilter Configuration" look similar.
It also removes unneeded CONFIG_IP6_NF_CONNTRACK.


[NETFILTER] net/ipv6/netfilter/Kconfig cleanups

This patch makes two cleanups in net/ipv6/netfilter/Kconfig:

  - Moves NF_CONNTRACK_IPV6 at bottom of the file.

  - Remove already commented CONFIG_IP6_NF_CONNTRACK.
    It is never going to be implemented since we have
    now Layer 3 independent connection tracking (NF_CONNTRACK)

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>

diff -Nur linux-2.6.14-git14-orig/net/ipv6/netfilter/Kconfig linux-2.6.14-g=
it14/net/ipv6/netfilter/Kconfig
--- linux-2.6.14-git14-orig/net/ipv6/netfilter/Kconfig=092005-11-11 15:10:4=
1.000000000 +0100
+++ linux-2.6.14-git14/net/ipv6/netfilter/Kconfig=092005-11-11 16:28:58.000=
000000 +0100
@@ -5,10 +5,20 @@
  menu "IPv6: Netfilter Configuration (EXPERIMENTAL)"
  =09depends on INET && IPV6 && NETFILTER && EXPERIMENTAL

-#tristate 'Connection tracking (required for masq/NAT)' CONFIG_IP6_NF_CONN=
TRACK
-#if [ "$CONFIG_IP6_NF_CONNTRACK" !=3D "n" ]; then
-#  dep_tristate '  FTP protocol support' CONFIG_IP6_NF_FTP $CONFIG_IP6_NF_=
CONNTRACK
-#fi
+config NF_CONNTRACK_IPV6
+=09tristate "IPv6 support for new connection tracking (EXPERIMENTAL)"
+=09depends on EXPERIMENTAL && NF_CONNTRACK
+=09---help---
+=09  Connection tracking keeps a record of what packets have passed
+=09  through your machine, in order to figure out how they are related
+=09  into connections.
+
+=09  This is IPv6 support on Layer 3 independent connection tracking.
+=09  Layer 3 independent connection tracking is experimental scheme
+=09  which generalize ip_conntrack to support other layer 3 protocols.
+
+=09  To compile it as a module, choose M here.  If unsure, say N.
+
  config IP6_NF_QUEUE
  =09tristate "IP6 Userspace queueing via NETLINK (OBSOLETE)"
  =09---help---
@@ -278,19 +288,5 @@
  =09  If you want to compile it as a module, say M here and read
  =09  <file:Documentation/modules.txt>.  If unsure, say `N'.

-config NF_CONNTRACK_IPV6
-=09tristate "IPv6 support for new connection tracking (EXPERIMENTAL)"
-=09depends on EXPERIMENTAL && NF_CONNTRACK
-=09---help---
-=09  Connection tracking keeps a record of what packets have passed
-=09  through your machine, in order to figure out how they are related
-=09  into connections.
-
-=09  This is IPv6 support on Layer 3 independent connection tracking.
-=09  Layer 3 independent connection tracking is experimental scheme
-=09  which generalize ip_conntrack to support other layer 3 protocols.
-
-=09  To compile it as a module, choose M here.  If unsure, say N.
-
  endmenu



Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-31064403-1131758020=:26844
Content-Type: TEXT/PLAIN; charset=US-ASCII;
	name=ipv6-netfilter-kconfig-cleanup.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0511120213400.26844@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=ipv6-netfilter-kconfig-cleanup.patch

DQpbTkVURklMVEVSXSBuZXQvaXB2Ni9uZXRmaWx0ZXIvS2NvbmZpZyBjbGVh
bnVwcw0KDQpUaGlzIHBhdGNoIG1ha2VzIHR3byBjbGVhbnVwcyBpbiBuZXQv
aXB2Ni9uZXRmaWx0ZXIvS2NvbmZpZzoNCg0KIC0gTW92ZXMgTkZfQ09OTlRS
QUNLX0lQVjYgYXQgYm90dG9tIG9mIHRoZSBmaWxlLg0KDQogLSBSZW1vdmUg
YWxyZWFkeSBjb21tZW50ZWQgQ09ORklHX0lQNl9ORl9DT05OVFJBQ0suDQog
ICBJdCBpcyBuZXZlciBnb2luZyB0byBiZSBpbXBsZW1lbnRlZCBzaW5jZSB3
ZSBoYXZlDQogICBub3cgTGF5ZXIgMyBpbmRlcGVuZGVudCBjb25uZWN0aW9u
IHRyYWNraW5nIChORl9DT05OVFJBQ0spDQoNClNpZ25lZC1vZmYtYnk6IEty
enlzenRvZiBQaW90ciBPbGVkemtpIDxvbGVAYW5zLnBsPg0KDQpkaWZmIC1O
dXIgbGludXgtMi42LjE0LWdpdDE0LW9yaWcvbmV0L2lwdjYvbmV0ZmlsdGVy
L0tjb25maWcgbGludXgtMi42LjE0LWdpdDE0L25ldC9pcHY2L25ldGZpbHRl
ci9LY29uZmlnDQotLS0gbGludXgtMi42LjE0LWdpdDE0LW9yaWcvbmV0L2lw
djYvbmV0ZmlsdGVyL0tjb25maWcJMjAwNS0xMS0xMSAxNToxMDo0MS4wMDAw
MDAwMDAgKzAxMDANCisrKyBsaW51eC0yLjYuMTQtZ2l0MTQvbmV0L2lwdjYv
bmV0ZmlsdGVyL0tjb25maWcJMjAwNS0xMS0xMSAxNjoyODo1OC4wMDAwMDAw
MDAgKzAxMDANCkBAIC01LDEwICs1LDIwIEBADQogbWVudSAiSVB2NjogTmV0
ZmlsdGVyIENvbmZpZ3VyYXRpb24gKEVYUEVSSU1FTlRBTCkiDQogCWRlcGVu
ZHMgb24gSU5FVCAmJiBJUFY2ICYmIE5FVEZJTFRFUiAmJiBFWFBFUklNRU5U
QUwNCiANCi0jdHJpc3RhdGUgJ0Nvbm5lY3Rpb24gdHJhY2tpbmcgKHJlcXVp
cmVkIGZvciBtYXNxL05BVCknIENPTkZJR19JUDZfTkZfQ09OTlRSQUNLDQot
I2lmIFsgIiRDT05GSUdfSVA2X05GX0NPTk5UUkFDSyIgIT0gIm4iIF07IHRo
ZW4NCi0jICBkZXBfdHJpc3RhdGUgJyAgRlRQIHByb3RvY29sIHN1cHBvcnQn
IENPTkZJR19JUDZfTkZfRlRQICRDT05GSUdfSVA2X05GX0NPTk5UUkFDSw0K
LSNmaQ0KK2NvbmZpZyBORl9DT05OVFJBQ0tfSVBWNg0KKwl0cmlzdGF0ZSAi
SVB2NiBzdXBwb3J0IGZvciBuZXcgY29ubmVjdGlvbiB0cmFja2luZyAoRVhQ
RVJJTUVOVEFMKSINCisJZGVwZW5kcyBvbiBFWFBFUklNRU5UQUwgJiYgTkZf
Q09OTlRSQUNLDQorCS0tLWhlbHAtLS0NCisJICBDb25uZWN0aW9uIHRyYWNr
aW5nIGtlZXBzIGEgcmVjb3JkIG9mIHdoYXQgcGFja2V0cyBoYXZlIHBhc3Nl
ZA0KKwkgIHRocm91Z2ggeW91ciBtYWNoaW5lLCBpbiBvcmRlciB0byBmaWd1
cmUgb3V0IGhvdyB0aGV5IGFyZSByZWxhdGVkDQorCSAgaW50byBjb25uZWN0
aW9ucy4NCisNCisJICBUaGlzIGlzIElQdjYgc3VwcG9ydCBvbiBMYXllciAz
IGluZGVwZW5kZW50IGNvbm5lY3Rpb24gdHJhY2tpbmcuDQorCSAgTGF5ZXIg
MyBpbmRlcGVuZGVudCBjb25uZWN0aW9uIHRyYWNraW5nIGlzIGV4cGVyaW1l
bnRhbCBzY2hlbWUNCisJICB3aGljaCBnZW5lcmFsaXplIGlwX2Nvbm50cmFj
ayB0byBzdXBwb3J0IG90aGVyIGxheWVyIDMgcHJvdG9jb2xzLg0KKw0KKwkg
IFRvIGNvbXBpbGUgaXQgYXMgYSBtb2R1bGUsIGNob29zZSBNIGhlcmUuICBJ
ZiB1bnN1cmUsIHNheSBOLg0KKw0KIGNvbmZpZyBJUDZfTkZfUVVFVUUNCiAJ
dHJpc3RhdGUgIklQNiBVc2Vyc3BhY2UgcXVldWVpbmcgdmlhIE5FVExJTksg
KE9CU09MRVRFKSINCiAJLS0taGVscC0tLQ0KQEAgLTI3OCwxOSArMjg4LDUg
QEANCiAJICBJZiB5b3Ugd2FudCB0byBjb21waWxlIGl0IGFzIGEgbW9kdWxl
LCBzYXkgTSBoZXJlIGFuZCByZWFkDQogCSAgPGZpbGU6RG9jdW1lbnRhdGlv
bi9tb2R1bGVzLnR4dD4uICBJZiB1bnN1cmUsIHNheSBgTicuDQogDQotY29u
ZmlnIE5GX0NPTk5UUkFDS19JUFY2DQotCXRyaXN0YXRlICJJUHY2IHN1cHBv
cnQgZm9yIG5ldyBjb25uZWN0aW9uIHRyYWNraW5nIChFWFBFUklNRU5UQUwp
Ig0KLQlkZXBlbmRzIG9uIEVYUEVSSU1FTlRBTCAmJiBORl9DT05OVFJBQ0sN
Ci0JLS0taGVscC0tLQ0KLQkgIENvbm5lY3Rpb24gdHJhY2tpbmcga2VlcHMg
YSByZWNvcmQgb2Ygd2hhdCBwYWNrZXRzIGhhdmUgcGFzc2VkDQotCSAgdGhy
b3VnaCB5b3VyIG1hY2hpbmUsIGluIG9yZGVyIHRvIGZpZ3VyZSBvdXQgaG93
IHRoZXkgYXJlIHJlbGF0ZWQNCi0JICBpbnRvIGNvbm5lY3Rpb25zLg0KLQ0K
LQkgIFRoaXMgaXMgSVB2NiBzdXBwb3J0IG9uIExheWVyIDMgaW5kZXBlbmRl
bnQgY29ubmVjdGlvbiB0cmFja2luZy4NCi0JICBMYXllciAzIGluZGVwZW5k
ZW50IGNvbm5lY3Rpb24gdHJhY2tpbmcgaXMgZXhwZXJpbWVudGFsIHNjaGVt
ZQ0KLQkgIHdoaWNoIGdlbmVyYWxpemUgaXBfY29ubnRyYWNrIHRvIHN1cHBv
cnQgb3RoZXIgbGF5ZXIgMyBwcm90b2NvbHMuDQotDQotCSAgVG8gY29tcGls
ZSBpdCBhcyBhIG1vZHVsZSwgY2hvb3NlIE0gaGVyZS4gIElmIHVuc3VyZSwg
c2F5IE4uDQotDQogZW5kbWVudQ0KIA0K

---187430788-31064403-1131758020=:26844--
