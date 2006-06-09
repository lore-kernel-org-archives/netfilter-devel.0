From: "Jing Min Zhao" <zhaojingmin@hotmail.com>
Subject: [H.323 Helper 4/5]: Put expect after use
Date: Fri, 9 Jun 2006 00:26:49 -0400
Message-ID: <BAY109-DAV1B781CFA865124D88270EB3880@phx.gbl>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0084_01C68B5B.65EB92E0"
Cc: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Netfilter Development Mailinglist" <netfilter-devel@lists.netfilter.org>
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

This is a multi-part message in MIME format.

------=_NextPart_000_0084_01C68B5B.65EB92E0
Content-Type: text/plain;
	charset="GB18030"
Content-Transfer-Encoding: base64

QnVnZml4OiBQdXQgZXhwZWN0IGFmdGVyIHVzZS4NCg0KU2lnbmVkLW9mZi1ieTogSmluZyBNaW4g
WmhhbyA8emhhb2ppbmdtaW5AdXNlcnMuc291cmNlZm9yZ2UubmV0Pg==

------=_NextPart_000_0084_01C68B5B.65EB92E0
Content-Type: application/octet-stream;
	name="patch4-put-expect"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch4-put-expect"

diff -pruN =
linux-2.6.17.orig/net/ipv4/netfilter/ip_conntrack_helper_h323.c =
linux-2.6.17/net/ipv4/netfilter/ip_conntrack_helper_h323.c=0A=
--- linux-2.6.17.orig/net/ipv4/netfilter/ip_conntrack_helper_h323.c	=
2006-06-08 20:59:43.000000000 -0400=0A=
+++ linux-2.6.17/net/ipv4/netfilter/ip_conntrack_helper_h323.c	=
2006-06-08 21:02:37.000000000 -0400=0A=
@@ -1323,7 +1323,7 @@ static int process_rcf(struct sk_buff **=0A=
 		ip_ct_refresh_acct(ct, ctinfo, NULL, info->timeout * HZ);=0A=
 =0A=
 		/* Set expect timeout */=0A=
-		read_lock_bh(&ip_conntrack_lock);=0A=
+		write_lock_bh(&ip_conntrack_lock);=0A=
 		exp =3D find_expect(ct, ct->tuplehash[dir].tuple.dst.ip,=0A=
 				  info->sig_port[!dir]);=0A=
 		if (exp) {=0A=
@@ -1336,8 +1336,9 @@ static int process_rcf(struct sk_buff **=0A=
 			       ntohs(exp->tuple.dst.u.tcp.port),=0A=
 			       info->timeout);=0A=
 			set_expect_timeout(exp, info->timeout);=0A=
+			ip_conntrack_expect_put(exp);=0A=
 		}=0A=
-		read_unlock_bh(&ip_conntrack_lock);=0A=
+		write_unlock_bh(&ip_conntrack_lock);=0A=
 	}=0A=
 =0A=
 	return 0;=0A=

------=_NextPart_000_0084_01C68B5B.65EB92E0--
