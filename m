From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [CTNETLINK] Rework conntrack fields dumping logic on events
Date: Tue, 14 Nov 2006 21:01:32 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0611142055130.1650@blackhole.kfki.hu>
References: <4553D3D5.40408@netfilter.org>
	<Pine.LNX.4.64.0611102151300.26087@blackhole.kfki.hu>
	<4557B157.6010205@netfilter.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391808-1916419613-1163534492=:1650"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <4557B157.6010205@netfilter.org>
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

--110391808-1916419613-1163534492=:1650
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hi Pablo,

On Mon, 13 Nov 2006, Pablo Neira Ayuso wrote:

> > Actually, how it is solved to pass the setting of dynamically assigned 
> > (i.e. currently not registered) helpers? What about registering such 
> > helpers with non-matching address/proto/port parameters?
> 
> I'm unsure that I understand the question. Currently ctnetlink cannot
> assign a helper that is not registered. Therefore, in order to register
> a helper with non-matching parameter, wouldn't we need a new parameter
> at modprobe stage? Perhaps some kind of userspace tool to manage helper
> matching parameters could be interesting.

The attached patch (on top of Patrick's nf_nat git tree and my patches 
sent to this list) implements what I suggested: *do* register the helpers 
which are actually assigned by an expectfn. Thus ctnetlink can find them 
by name and then fill conntrack with the helper. In order to make sure a 
bogus packet can't trigger such helpers, __nf_ct_helper_find had to be 
modified. What do you think?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110391808-1916419613-1163534492=:1650
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=netlink.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0611142101320.1650@blackhole.kfki.hu>
Content-Description: netlink.patch
Content-Disposition: attachment; filename=netlink.patch

ZGlmZiAtdXJOIC0tZXhjbHVkZS1mcm9tPS91c3Ivc3JjL2RpZmYuZXhjbHVk
ZSBsaW51eC0yLjYuMjAtbmF0LWNvcmUvaW5jbHVkZS9uZXQvbmV0ZmlsdGVy
L25mX2Nvbm50cmFja19oZWxwZXIuaCBsaW51eC0yLjYuMjAtbmV0bGluay9p
bmNsdWRlL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2hlbHBlci5oDQot
LS0gbGludXgtMi42LjIwLW5hdC1jb3JlL2luY2x1ZGUvbmV0L25ldGZpbHRl
ci9uZl9jb25udHJhY2tfaGVscGVyLmgJMjAwNi0xMS0wNiAxNDowODoxNS4w
MDAwMDAwMDAgKzAxMDANCisrKyBsaW51eC0yLjYuMjAtbmV0bGluay9pbmNs
dWRlL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2hlbHBlci5oCTIwMDYt
MTEtMTQgMTc6MDI6NDAuMDAwMDAwMDAwICswMTAwDQpAQCAtMjMsNyArMjMs
OSBAQA0KIAkJCQkJICogZXhwZWN0ZWQgY29ubmVjdGlvbnMgKi8NCiAJdW5z
aWduZWQgaW50IHRpbWVvdXQ7CQkvKiB0aW1lb3V0IGZvciBleHBlY3RlZHMg
Ki8NCiANCi0JLyogTWFzayBvZiB0aGluZ3Mgd2Ugd2lsbCBoZWxwIChjb21w
YXJlZCBhZ2FpbnN0IHNlcnZlciByZXNwb25zZSkgKi8NCisJLyogTWFzayBv
ZiB0aGluZ3Mgd2Ugd2lsbCBoZWxwIChjb21wYXJlZCBhZ2FpbnN0IHNlcnZl
ciByZXNwb25zZSk6DQorCSAqIHR1cGxlLnNyYy51IG11c3QgYmUgc2V0IHRv
IHplcm8gZm9yIGR5bmFtaWMgaGVscGVycywgaS5lLiB3aGljaA0KKwkgKiBh
cmUgYXR0YWNoZWQgYnkgYW4gZXhwZWN0Zm4gdG8gdGhlIGNvbm50cmFjayBl
bnRyeSAqLyANCiAJc3RydWN0IG5mX2Nvbm50cmFja190dXBsZSB0dXBsZTsN
CiAJc3RydWN0IG5mX2Nvbm50cmFja190dXBsZSBtYXNrOw0KIAkNCmRpZmYg
LXVyTiAtLWV4Y2x1ZGUtZnJvbT0vdXNyL3NyYy9kaWZmLmV4Y2x1ZGUgbGlu
dXgtMi42LjIwLW5hdC1jb3JlL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNr
X2hlbHBlci5jIGxpbnV4LTIuNi4yMC1uZXRsaW5rL25ldC9uZXRmaWx0ZXIv
bmZfY29ubnRyYWNrX2hlbHBlci5jDQotLS0gbGludXgtMi42LjIwLW5hdC1j
b3JlL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2hlbHBlci5jCTIwMDYt
MTEtMDYgMTQ6MDg6MTUuMDAwMDAwMDAwICswMTAwDQorKysgbGludXgtMi42
LjIwLW5ldGxpbmsvbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfaGVscGVy
LmMJMjAwNi0xMS0xNCAxNjo0NDo0NS4wMDAwMDAwMDAgKzAxMDANCkBAIC0z
NSw4ICszNSwxMyBAQA0KIAlzdHJ1Y3QgbmZfY29ubnRyYWNrX2hlbHBlciAq
aDsNCiANCiAJbGlzdF9mb3JfZWFjaF9lbnRyeShoLCAmaGVscGVycywgbGlz
dCkgew0KLQkJaWYgKG5mX2N0X3R1cGxlX21hc2tfY21wKHR1cGxlLCAmaC0+
dHVwbGUsICZoLT5tYXNrKSkNCi0JCQlyZXR1cm4gaDsNCisJCWlmIChuZl9j
dF90dXBsZV9tYXNrX2NtcCh0dXBsZSwgJmgtPnR1cGxlLCAmaC0+bWFzaykp
IHsNCisJCQkvKiBJZ25vcmUgZHluYW1pYyBoZWxwZXJzOiB3ZSBzaG91bGQg
bG9nIGl0ICovDQorCQkJaWYgKGgtPnR1cGxlLnNyYy51KQ0KKwkJCQlyZXR1
cm4gaDsNCisJCQllbHNlDQorCQkJCXJldHVybiBOVUxMDQorCQl9DQogCX0N
CiAJcmV0dXJuIE5VTEw7DQogfQ0KZGlmZiAtdXJOIC0tZXhjbHVkZS1mcm9t
PS91c3Ivc3JjL2RpZmYuZXhjbHVkZSBsaW51eC0yLjYuMjAtbmF0LWNvcmUv
bmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfaGVscGVyX2gzMjMuYyBsaW51
eC0yLjYuMjAtbmV0bGluay9uZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19o
ZWxwZXJfaDMyMy5jDQotLS0gbGludXgtMi42LjIwLW5hdC1jb3JlL25ldC9u
ZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2hlbHBlcl9oMzIzLmMJMjAwNi0xMS0w
NiAxNDozOTowNC4wMDAwMDAwMDAgKzAxMDANCisrKyBsaW51eC0yLjYuMjAt
bmV0bGluay9uZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19oZWxwZXJfaDMy
My5jCTIwMDYtMTEtMTMgMTc6NTA6NDguMDAwMDAwMDAwICswMTAwDQpAQCAt
MTc3MCw2ICsxNzcwLDcgQEANCiAvKiBOb3QgX19leGl0IC0gY2FsbGVkIGZy
b20gaW5pdCgpICovDQogc3RhdGljIHZvaWQgZmluaSh2b2lkKQ0KIHsNCisJ
bmZfY29ubnRyYWNrX2hlbHBlcl91bnJlZ2lzdGVyKCZuZl9jb25udHJhY2tf
aGVscGVyX2gyNDUpOw0KIAluZl9jb25udHJhY2tfaGVscGVyX3VucmVnaXN0
ZXIoJm5mX2Nvbm50cmFja19oZWxwZXJfcmFzKTsNCiAJbmZfY29ubnRyYWNr
X2hlbHBlcl91bnJlZ2lzdGVyKCZuZl9jb25udHJhY2tfaGVscGVyX3E5MzEp
Ow0KIAlrZnJlZShoMzIzX2J1ZmZlcik7DQpAQCAtMTc4NSw3ICsxNzg2LDgg
QEANCiAJaWYgKCFoMzIzX2J1ZmZlcikNCiAJCXJldHVybiAtRU5PTUVNOw0K
IAlpZiAoKHJldCA9IG5mX2Nvbm50cmFja19oZWxwZXJfcmVnaXN0ZXIoJm5m
X2Nvbm50cmFja19oZWxwZXJfcTkzMSkpIHx8DQotCSAgICAocmV0ID0gbmZf
Y29ubnRyYWNrX2hlbHBlcl9yZWdpc3RlcigmbmZfY29ubnRyYWNrX2hlbHBl
cl9yYXMpKSkgew0KKwkgICAgKHJldCA9IG5mX2Nvbm50cmFja19oZWxwZXJf
cmVnaXN0ZXIoJm5mX2Nvbm50cmFja19oZWxwZXJfcmFzKSkgfHwNCisJICAg
IChyZXQgPSBuZl9jb25udHJhY2tfaGVscGVyX3JlZ2lzdGVyKCZuZl9jb25u
dHJhY2tfaGVscGVyX2gyNDUpKSkgew0KIAkJZmluaSgpOw0KIAkJcmV0dXJu
IHJldDsNCiAJfQ0K

--110391808-1916419613-1163534492=:1650--
