From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [net-next] socket: Added 'transparent' option
Date: Thu, 4 Jun 2009 14:45:02 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0906041443050.6111@fbirervta.pbzchgretzou.qr>
References: <1244119045-10614-1-git-send-email-panther@balabit.hu> <1244119045-10614-2-git-send-email-panther@balabit.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Laszlo Attila Toth <panther@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58573 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388AbZFDMpB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jun 2009 08:45:01 -0400
In-Reply-To: <1244119045-10614-2-git-send-email-panther@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-06-04 14:37, Laszlo Attila Toth wrote:

>Added new revision of the 'socket' match. If its new option is set,
>enabled 'transparent' socket option is required for the socket to be m=
atched.
>
>Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>

>+++ b/include/linux/netfilter/xt_socket.h
>@@ -0,0 +1,8 @@
>+#ifndef _XT_SOCKET_H_match
>+#define _XT_SOCKET_H_match
>+
>+struct xt_socket_match_info1 {
>+	__u8 transparent:1;
>+};
>+
>+#endif /* _XT_SOCKET_H_match */

Compiler-level bitfields are not portable, so let's not use them.

>@@ -142,10 +145,22 @@ socket_mt(const struct sk_buff *skb, const struc=
t xt_match_param *par)
> 				   saddr, daddr, sport, dport, par->in, false);
> 	if (sk !=3D NULL) {
> 		bool wildcard =3D (sk->sk_state !=3D TCP_TIME_WAIT && inet_sk(sk)->=
rcv_saddr =3D=3D 0);
>+		bool transparent =3D (sk->sk_state !=3D TCP_TIME_WAIT &&
>+					inet_sk(sk)->transparent) ||
>+				   (sk->sk_state =3D=3D TCP_TIME_WAIT &&
>+					inet_twsk(sk)->tw_transparent);
>+		const struct xt_socket_match_info1 *info =3D NULL;
>+
>+		if (check_transparent);
>+			info =3D par->matchinfo;

That's a definite =E2=80=9Cwhoops in coding=E2=80=9D there with that tr=
ailing ;.
Wanna buy a `make C=3D1`? :-)

>+static struct xt_match socket_mt_reg[] __read_mostly =3D {
>+	{
>+		.name		=3D "socket",
>+		.revision	=3D 0,
>+		.family		=3D AF_INET,

NFPROTO_IPV4

>+		.match		=3D socket_mt_v0,
>+		.hooks		=3D 1 << NF_INET_PRE_ROUTING,
>+		.me		=3D THIS_MODULE,
>+	},
>+	{
>+		.name		=3D "socket",
>+		.revision	=3D 1,
>+		.family		=3D AF_INET,

^
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
