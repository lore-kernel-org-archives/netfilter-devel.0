From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [PATCH][TYPO] random.patch.configure.help
Date: Sat, 3 May 2003 17:16:05 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0305031713380.24297@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-23717851-1966275125-1051974965=:24297"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

---23717851-1966275125-1051974965=:24297
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hello,

there is a typo in patch-o-matic/base/random.patch.configure.help.
random6.patch.ipv6.configure.help is OK though.

Regards,
Maciej

diff -Nru netfilter.orig/patch-o-matic/base/random.patch.configure.help netfilter/patch-o-matic/base/random.patch.configure.help
--- netfilter.orig/patch-o-matic/base/random.patch.configure.help	2003-05-03 14:31:54.000000000 +0200
+++ netfilter/patch-o-matic/base/random.patch.configure.help	2003-05-03 16:59:39.000000000 +0200
@@ -1,5 +1,5 @@
 CONFIG_IP_NF_MATCH_TOS
-Nth match support
+Random match support
 CONFIG_IP_NF_MATCH_RANDOM
   This option adds a `random' match,
   which allow you to match packets randomly
---23717851-1966275125-1051974965=:24297
Content-Type: TEXT/plain; name="typo.diff"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.51.0305031716050.24297@dns.toxicfilms.tv>
Content-Description: typo
Content-Disposition: attachment; filename="typo.diff"

ZGlmZiAtTnJ1IG5ldGZpbHRlci5vcmlnL3BhdGNoLW8tbWF0aWMvYmFzZS9y
YW5kb20ucGF0Y2guY29uZmlndXJlLmhlbHAgbmV0ZmlsdGVyL3BhdGNoLW8t
bWF0aWMvYmFzZS9yYW5kb20ucGF0Y2guY29uZmlndXJlLmhlbHANCi0tLSBu
ZXRmaWx0ZXIub3JpZy9wYXRjaC1vLW1hdGljL2Jhc2UvcmFuZG9tLnBhdGNo
LmNvbmZpZ3VyZS5oZWxwCTIwMDMtMDUtMDMgMTQ6MzE6NTQuMDAwMDAwMDAw
ICswMjAwDQorKysgbmV0ZmlsdGVyL3BhdGNoLW8tbWF0aWMvYmFzZS9yYW5k
b20ucGF0Y2guY29uZmlndXJlLmhlbHAJMjAwMy0wNS0wMyAxNjo1OTozOS4w
MDAwMDAwMDAgKzAyMDANCkBAIC0xLDUgKzEsNSBAQA0KIENPTkZJR19JUF9O
Rl9NQVRDSF9UT1MNCi1OdGggbWF0Y2ggc3VwcG9ydA0KK1JhbmRvbSBtYXRj
aCBzdXBwb3J0DQogQ09ORklHX0lQX05GX01BVENIX1JBTkRPTQ0KICAgVGhp
cyBvcHRpb24gYWRkcyBhIGByYW5kb20nIG1hdGNoLA0KICAgd2hpY2ggYWxs
b3cgeW91IHRvIG1hdGNoIHBhY2tldHMgcmFuZG9tbHkNCg==

---23717851-1966275125-1051974965=:24297--
