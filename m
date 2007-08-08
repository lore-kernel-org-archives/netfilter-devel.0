From: Eric Leblond <eric@inl.fr>
Subject: [PATCH] fix handling of netlink packets containing multiple messages
Date: Wed, 8 Aug 2007 08:08:11 +0200
Message-ID: <34517.5317525447$1186553334@news.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_Wdpp2Ob5iwKeT6_=n49nnE3"
Cc: gryzor@inl.fr
To: netfilter-devel@lists.netfilter.org, pablo@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

--MP_Wdpp2Ob5iwKeT6_=n49nnE3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: base64
Content-Disposition: inline

LS0tLS1CRUdJTiBQR1AgU0lHTkVEIE1FU1NBR0UtLS0tLQ0KSGFzaDogU0hBMQ0KDQpIaSwNCg0K
SSd2ZSBmb3VuZCBhIGJ1ZyBpbiBsaWJuZm5ldGxpbmsgd2hpY2ggZG9lcyBub3QgaGFuZGxlIGNv
cnJlY3RseQ0KbmV0bGluayBwYWNrZXRzIG1hZGUgb2YgbW9yZSB0aGFuIG9uZSBtZXNzYWdlLg0K
DQpJIGF0dGFjaCBhIHRyaXZpYWwgcGF0Y2ggd2hpY2ggZml4IHRoZSBpc3N1ZS4NCg0KQlIsDQot
IC0tIA0KRXJpYyBMZWJsb25kIDxlcmljQHJlZ2l0Lm9yZz4NCk51RlcsIE5vdyBVc2VyIEZpbHRl
cmluZyBXb3JrcyA6IGh0dHA6Ly93d3cubnVmdy5vcmcNCi0tLS0tQkVHSU4gUEdQIFNJR05BVFVS
RS0tLS0tDQpWZXJzaW9uOiBHbnVQRyB2MS40LjYgKEdOVS9MaW51eCkNCg0KaUQ4REJRRkd1VjNS
bnhBN0NkTVdqeklSQWpPbUFKNDRVc2s5M2JwNmhQWFA4KzRESWcxVEVZVysyUUNna1dScg0KMXdy
d0UvU1l3SEtQVkZmYkhGekRGRkE9DQo9dDNTeA0KLS0tLS1FTkQgUEdQIFNJR05BVFVSRS0tLS0t
DQo=

--MP_Wdpp2Ob5iwKeT6_=n49nnE3
Content-Type: text/x-patch; name=libnfnetlink_packet_parsing.diff
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=libnfnetlink_packet_parsing.diff

Index: src/libnfnetlink.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- src/libnfnetlink.c	(r=C3=A9vision 7003)
+++ src/libnfnetlink.c	(copie de travail)
@@ -1190,6 +1190,7 @@
 			return -1;
=20
 		len -=3D rlen;
+		buf +=3D rlen;
 	}
 	return 0;
 }

--MP_Wdpp2Ob5iwKeT6_=n49nnE3--
