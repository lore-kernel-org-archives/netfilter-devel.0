From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: [ANNOUNCE] iptables-1.2.8 feature freeze
Date: Mon, 31 Mar 2003 13:53:11 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0303311351520.14297@dns.toxicfilms.tv>
References: <20030330202322.GA7718@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-23717851-1193720516-1049111591=:14297"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030330202322.GA7718@sunbeam.de.gnumonks.org>
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

---23717851-1193720516-1049111591=:14297
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hi Harald,

> Please test the CVS snapshot of today (will be published in 2 hours,
> just before midnight german time). The snapshot will be available at
> ftp://ftp.netfilter.org/pub/iptables/snapshot/iptables-1.2.7a-20030330.tar.bz2
Ok, it is a typo here, look:

diff -ru iptables.orig/iptables.c iptables/iptables.c
--- iptables.orig/iptables.c	2003-03-03 09:08:37.000000000 +0100
+++ iptables/iptables.c	2003-03-31 13:46:11.000000000 +0200
@@ -336,7 +336,7 @@
 void
 exit_tryhelp(int status)
 {
-	if (line =! -1)
+	if (line != -1)
 		fprintf(stderr, "Error occured at line: %d\n", line);
 	fprintf(stderr, "Try `%s -h' or '%s --help' for more information.\n",
 			program_name, program_name );
---23717851-1193720516-1049111591=:14297
Content-Type: TEXT/plain; name="iptables.c.diff"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.51.0303311353110.14297@dns.toxicfilms.tv>
Content-Description: iptables.c.diff
Content-Disposition: attachment; filename="iptables.c.diff"

ZGlmZiAtcnUgaXB0YWJsZXMub3JpZy9pcHRhYmxlcy5jIGlwdGFibGVzL2lw
dGFibGVzLmMNCi0tLSBpcHRhYmxlcy5vcmlnL2lwdGFibGVzLmMJMjAwMy0w
My0wMyAwOTowODozNy4wMDAwMDAwMDAgKzAxMDANCisrKyBpcHRhYmxlcy9p
cHRhYmxlcy5jCTIwMDMtMDMtMzEgMTM6NDY6MTEuMDAwMDAwMDAwICswMjAw
DQpAQCAtMzM2LDcgKzMzNiw3IEBADQogdm9pZA0KIGV4aXRfdHJ5aGVscChp
bnQgc3RhdHVzKQ0KIHsNCi0JaWYgKGxpbmUgPSEgLTEpDQorCWlmIChsaW5l
ICE9IC0xKQ0KIAkJZnByaW50ZihzdGRlcnIsICJFcnJvciBvY2N1cmVkIGF0
IGxpbmU6ICVkXG4iLCBsaW5lKTsNCiAJZnByaW50ZihzdGRlcnIsICJUcnkg
YCVzIC1oJyBvciAnJXMgLS1oZWxwJyBmb3IgbW9yZSBpbmZvcm1hdGlvbi5c
biIsDQogCQkJcHJvZ3JhbV9uYW1lLCBwcm9ncmFtX25hbWUgKTsNCg==

---23717851-1193720516-1049111591=:14297--
