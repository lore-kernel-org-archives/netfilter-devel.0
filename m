From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH] RST packet handling in TCP window tracking
Date: Tue, 25 Jan 2005 11:20:58 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0501250948120.9430@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391808-947935033-1106642959=:9430"
Cc: Tim Burress <tim@variosecure.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-ID: <Pine.LNX.4.58.0501250949250.9430@blackhole.kfki.hu>
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
  Send mail to mime@docserver.cac.washington.edu for more info.

--110391808-947935033-1106642959=:9430
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <Pine.LNX.4.58.0501250949251.9430@blackhole.kfki.hu>

Hi,

Tim Burres discovered that RST packets were validated only by their ACK
fields: the SEQ fields were ignored, being the RST packets dataless. The
attached patch fixes the problem.

As it is a critical path, I'd be glad to see some independent verification
that there are no evil side effects.

Signed-off-by: Tim Burress <tim@variosecure.net>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110391808-947935033-1106642959=:9430
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; NAME="tcp-win-rst.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.58.0501250949190.9430@blackhole.kfki.hu>
Content-Description: tcp-win-rst.patch
Content-Disposition: ATTACHMENT; FILENAME="tcp-win-rst.patch"

ZGlmZiAtdXJOIC0tZXhjbHVkZS1mcm9tPS91c3Ivc3JjL2RpZmYuZXhjbHVk


ZSBsaW51eC0yLjYuOS10Y3Atd2luL25ldC9pcHY0L25ldGZpbHRlci9pcF9j


b25udHJhY2tfcHJvdG9fdGNwLmMgbGludXgtMi42LjktdGNwLXdpbi1yc3Qv


bmV0L2lwdjQvbmV0ZmlsdGVyL2lwX2Nvbm50cmFja19wcm90b190Y3AuYw0K


LS0tIGxpbnV4LTIuNi45LXRjcC13aW4vbmV0L2lwdjQvbmV0ZmlsdGVyL2lw


X2Nvbm50cmFja19wcm90b190Y3AuYwkyMDA0LTEyLTEwIDA4OjUyOjU1LjAw


MDAwMDAwMCArMDEwMA0KKysrIGxpbnV4LTIuNi45LXRjcC13aW4tcnN0L25l


dC9pcHY0L25ldGZpbHRlci9pcF9jb25udHJhY2tfcHJvdG9fdGNwLmMJMjAw


NS0wMS0yNCAxNjozNzoxMC4wMDAwMDAwMDAgKzAxMDANCkBAIC01OTgsMTAg


KzU5OCwxNCBAQA0KIAkJYWNrID0gc2FjayA9IHJlY2VpdmVyLT50ZF9lbmQ7


DQogCX0NCiANCi0JaWYgKHNlcSA9PSBlbmQpDQorCWlmIChzZXEgPT0gZW5k


IA0KKwkgICAgJiYgKCF0Y3BoLT5yc3QgfHwgc3RhdGUtPnN0YXRlID09IFRD


UF9DT05OVFJBQ0tfU1lOX1NFTlQpKQ0KIAkJLyoNCiAJCSAqIFBhY2tldHMg


Y29udGFpbnMgbm8gZGF0YTogd2UgYXNzdW1lIGl0IGlzIHZhbGlkDQogCQkg


KiBhbmQgY2hlY2sgdGhlIGFjayB2YWx1ZSBvbmx5Lg0KKwkJICogSG93ZXZl


ciBSU1Qgc2VnbWVudHMgYXJlIGFsd2F5cyB2YWxpZGF0ZWQgYnkgdGhlaXIN


CisJCSAqIFNFUSBudW1iZXIsIGV4Y2VwdCB3aGVuIHNlcSA9PSAwIChyZXNl


dCBzZW50IGFuc3dlcmluZw0KKwkJICogU1lOLg0KIAkJICovDQogCQlzZXEg


PSBlbmQgPSBzZW5kZXItPnRkX2VuZDsNCiAJCQ0K



--110391808-947935033-1106642959=:9430--
