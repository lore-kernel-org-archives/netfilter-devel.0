From: Chris Wilson <chris@netservers.co.uk>
Subject: ROUTE target
Date: Wed, 19 May 2004 17:39:25 +0100 (BST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0405191735500.16679@chris.camcom.co.uk>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463779581-449564920-1084984765=:16679"
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: =?ISO-8859-1?Q?C=E9dric_de_Launois?= <delaunois@info.ucl.ac.be>
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

---1463779581-449564920-1084984765=:16679
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hi all,

I spotted a small problem with the ROUTE target in POM-ng. It doesn't 
include <net/checksum.h>, and therefore gets an unresolved symbol 
ip_fast_csum. Patch is attached.

Cheers, Chris.
-- 
_  __ __     _
 / __/ / ,__(_)_  | Chris Wilson -- UNIX Firewall Lead Developer |
/ (_  ,\/ _/ /_ \ | NetServers.co.uk http://www.netservers.co.uk |
\__/_/_/_//_/___/ | 21 Signet Court, Cambridge, UK. 01223 576516 |
---1463779581-449564920-1084984765=:16679
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="ipt_ROUTE-unresolved-symbols.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.58.0405191739250.16679@chris.camcom.co.uk>
Content-Description: 
Content-Disposition: attachment; filename="ipt_ROUTE-unresolved-symbols.patch"

SW5kZXg6IFJPVVRFL2xpbnV4L25ldC9pcHY0L25ldGZpbHRlci9pcHRfUk9V
VEUuYw0KPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KUkNTIGZpbGU6IC9jdnNw
dWJsaWMvcGF0Y2gtby1tYXRpYy1uZy9ST1VURS9saW51eC9uZXQvaXB2NC9u
ZXRmaWx0ZXIvaXB0X1JPVVRFLmMsdg0KcmV0cmlldmluZyByZXZpc2lvbiAx
LjQNCmRpZmYgLXUgLWIgLUIgLXcgLXAgLXIxLjQgaXB0X1JPVVRFLmMNCi0t
LSBST1VURS9saW51eC9uZXQvaXB2NC9uZXRmaWx0ZXIvaXB0X1JPVVRFLmMJ
MTEgTWF5IDIwMDQgMDk6MDc6MTcgLTAwMDAJMS40DQorKysgUk9VVEUvbGlu
dXgvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwdF9ST1VURS5jCTE5IE1heSAyMDA0
IDE2OjM5OjE0IC0wMDAwDQpAQCAtMTksNiArMTksNyBAQA0KICNpbmNsdWRl
IDxuZXQvaXAuaD4NCiAjaW5jbHVkZSA8bmV0L3JvdXRlLmg+DQogI2luY2x1
ZGUgPG5ldC9pY21wLmg+DQorI2luY2x1ZGUgPG5ldC9jaGVja3N1bS5oPg0K
IA0KICNpZiAwDQogI2RlZmluZSBERUJVR1AgcHJpbnRrDQo=

---1463779581-449564920-1084984765=:16679--
