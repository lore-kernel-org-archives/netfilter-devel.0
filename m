From: Grzegorz Janoszka <Grzegorz@Janoszka.pl>
Subject: Trivial connlimit and IPMARK patch for 2.6.16
Date: Tue, 4 Apr 2006 00:09:52 +0200 (CEST)
Message-ID: <Pine.GSO.4.63.0604040002220.15645@galaxy.agh.edu.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-559023410-959030623-1144102083=:15645"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-ID: <Pine.GSO.4.63.0604040008190.15645@galaxy.agh.edu.pl>
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

---559023410-959030623-1144102083=:15645
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; FORMAT=flowed
Content-ID: <Pine.GSO.4.63.0604040008191.15645@galaxy.agh.edu.pl>


Hello,

Due to move of some targets from iptables to xtables, some 
patches turned to "not applyable", becouse their Makefile.ladd files
tried to add iptables entries just after a target, that had been moved 
from iptables to xtables.

Attached patch solves this problem, it only modifies Makefile.ladd files 
of connlimit and IPMARK. The patch is to patch-o-matic-ng-20060401 but it 
should apply clearly on any latest pom-ng.

Please apply it.

-- 
Grzegorz Janoszka
---559023410-959030623-1144102083=:15645
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; NAME=pom-connlimit-IPMARK.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.GSO.4.63.0604040008030.15645@galaxy.agh.edu.pl>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME=pom-connlimit-IPMARK.patch

ZGlmZiAtdXJOIHBhdGNoLW8tbWF0aWMtbmctMjAwNjA0MDEtb2xkL3BhdGNo
bGV0cy9jb25ubGltaXQvbGludXgtMi42LjExL25ldC9pcHY0L25ldGZpbHRl
ci9NYWtlZmlsZS5sYWRkIHBhdGNoLW8tbWF0aWMtbmctMjAwNjA0MDEvcGF0
Y2hsZXRzL2Nvbm5saW1pdC9saW51eC0yLjYuMTEvbmV0L2lwdjQvbmV0Zmls
dGVyL01ha2VmaWxlLmxhZGQNCi0tLSBwYXRjaC1vLW1hdGljLW5nLTIwMDYw
NDAxLW9sZC9wYXRjaGxldHMvY29ubmxpbWl0L2xpbnV4LTIuNi4xMS9uZXQv
aXB2NC9uZXRmaWx0ZXIvTWFrZWZpbGUubGFkZAkyMDA0LTA1LTA2IDE0OjUy
OjM3LjAwMDAwMDAwMCArMDIwMA0KKysrIHBhdGNoLW8tbWF0aWMtbmctMjAw
NjA0MDEvcGF0Y2hsZXRzL2Nvbm5saW1pdC9saW51eC0yLjYuMTEvbmV0L2lw
djQvbmV0ZmlsdGVyL01ha2VmaWxlLmxhZGQJMjAwNi0wNC0wMyAyMzoxNDoy
MC4wMDAwMDAwMDAgKzAyMDANCkBAIC0xLDIgKzEsMiBAQA0KLW9iai0kKENP
TkZJR19JUF9ORl9NQVRDSF9TVEFURSkgKz0gaXB0X3N0YXRlLm8NCitvYmot
JChDT05GSUdfSVBfTkZfTUFUQ0hfVE9TKSArPSBpcHRfdG9zLm8NCiBvYmot
JChDT05GSUdfSVBfTkZfTUFUQ0hfQ09OTkxJTUlUKSArPSBpcHRfY29ubmxp
bWl0Lm8NCmRpZmYgLXVyTiBwYXRjaC1vLW1hdGljLW5nLTIwMDYwNDAxLW9s
ZC9wYXRjaGxldHMvSVBNQVJLL2xpbnV4LTIuNi9uZXQvaXB2NC9uZXRmaWx0
ZXIvTWFrZWZpbGUubGFkZCBwYXRjaC1vLW1hdGljLW5nLTIwMDYwNDAxL3Bh
dGNobGV0cy9JUE1BUksvbGludXgtMi42L25ldC9pcHY0L25ldGZpbHRlci9N
YWtlZmlsZS5sYWRkDQotLS0gcGF0Y2gtby1tYXRpYy1uZy0yMDA2MDQwMS1v
bGQvcGF0Y2hsZXRzL0lQTUFSSy9saW51eC0yLjYvbmV0L2lwdjQvbmV0Zmls
dGVyL01ha2VmaWxlLmxhZGQJMjAwNC0wNS0wNiAxNDoyMzo1NC4wMDAwMDAw
MDAgKzAyMDANCisrKyBwYXRjaC1vLW1hdGljLW5nLTIwMDYwNDAxL3BhdGNo
bGV0cy9JUE1BUksvbGludXgtMi42L25ldC9pcHY0L25ldGZpbHRlci9NYWtl
ZmlsZS5sYWRkCTIwMDYtMDQtMDMgMjM6MTE6NTcuMDAwMDAwMDAwICswMjAw
DQpAQCAtMSwyICsxLDIgQEANCi1vYmotJChDT05GSUdfSVBfTkZfVEFSR0VU
X01BUkspICs9IGlwdF9NQVJLLm8NCitvYmotJChDT05GSUdfSVBfTkZfVEFS
R0VUX1RUTCkgKz0gaXB0X1RUTC5vDQogb2JqLSQoQ09ORklHX0lQX05GX1RB
UkdFVF9JUE1BUkspICs9IGlwdF9JUE1BUksubw0K

---559023410-959030623-1144102083=:15645--
