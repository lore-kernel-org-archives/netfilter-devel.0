From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: compiling ip_set_iptree.o
Date: Tue, 18 Oct 2005 15:20:31 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0510181516400.5575@blackhole.kfki.hu>
References: <00e501c5d395$0cb95eb0$0100a8c0@newlife>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391808-32441583-1129641631=:5575"
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Return-path: <netfilter-bounces@lists.netfilter.org>
To: Ming-Ching Tiew <mingching.tiew@redtone.com>
In-Reply-To: <00e501c5d395$0cb95eb0$0100a8c0@newlife>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

--110391808-32441583-1129641631=:5575
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Tue, 18 Oct 2005, Ming-Ching Tiew wrote:

> Compiling ip_set_iptree.o as module get this error :-
>
>  CC [M]  net/ipv4/netfilter/ip_set_iptree.o
> net/ipv4/netfilter/ip_set_iptree.c:123: error: parse error before "flags"
> net/ipv4/netfilter/ip_set_iptree.c:124: warning: function declaration isn't a prototype
> net/ipv4/netfilter/ip_set_iptree.c: In function `__addip':

That's due to a backward compatibility issue - I tested the code on
2.6.12.x and - as you wrote - you try to use ipset on 2.6.11.x. Please use
the attached patch which takes care of it.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110391808-32441583-1129641631=:5575
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="ipset-iptree.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.58.0510181520310.5575@blackhole.kfki.hu>
Content-Description: ipset-iptree.patch
Content-Disposition: attachment; filename="ipset-iptree.patch"

ZGlmZiAtdXJOIC0tZXhjbHVkZS1mcm9tPS91c3Ivc3JjL2RpZmYuZXhjbHVk
ZSBsaW51eC0yLjYuMTIuMy1pcHNldC1pcHBvcnQvbmV0L2lwdjQvbmV0Zmls
dGVyL2lwX3NldF9pcHRyZWUuYyBsaW51eC0yLjYuMTIuMy1pcHNldC1pcHBv
cnQyL25ldC9pcHY0L25ldGZpbHRlci9pcF9zZXRfaXB0cmVlLmMNCi0tLSBs
aW51eC0yLjYuMTIuMy1pcHNldC1pcHBvcnQvbmV0L2lwdjQvbmV0ZmlsdGVy
L2lwX3NldF9pcHRyZWUuYwkyMDA1LTEwLTEyIDE3OjA5OjA2LjAwMDAwMDAw
MCArMDIwMA0KKysrIGxpbnV4LTIuNi4xMi4zLWlwc2V0LWlwcG9ydDIvbmV0
L2lwdjQvbmV0ZmlsdGVyL2lwX3NldF9pcHRyZWUuYwkyMDA1LTEwLTE4IDEz
OjAxOjI1LjAwMDAwMDAwMCArMDIwMA0KQEAgLTE5LDYgKzE5LDExIEBADQog
I2luY2x1ZGUgPGFzbS9iaXRvcHMuaD4NCiAjaW5jbHVkZSA8bGludXgvc3Bp
bmxvY2suaD4NCiANCisvKiBCYWNrd2FyZCBjb21wYXRpYmlsaXR5ICovDQor
I2lmbmRlZiBfX25vY2FzdA0KKyNkZWZpbmUgX19ub2Nhc3QNCisjZW5kaWYN
CisNCiAjaW5jbHVkZSA8bGludXgvbmV0ZmlsdGVyX2lwdjQvaXBfc2V0X2lw
dHJlZS5oPg0KIA0KIC8qIEdhcmJhZ2UgY29sbGVjdGlvbiBpbnRlcnZhbCBp
biBzZWNvbmRzOiAqLw0K

--110391808-32441583-1129641631=:5575--
