From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] netfilter: add __rcu annotations
Date: Mon, 15 Nov 2010 18:32:44 +0100
Message-ID: <1289842364.2607.107.camel@edumazet-laptop>
References: <1289841688.2607.102.camel@edumazet-laptop>
	 <4CE16D38.5030506@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48510 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932998Ab0KORct (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:32:49 -0500
Received: by ewy8 with SMTP id 8so823360ewy.19
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Nov 2010 09:32:47 -0800 (PST)
In-Reply-To: <4CE16D38.5030506@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le lundi 15 novembre 2010 =C3=A0 18:26 +0100, Patrick McHardy a =C3=A9c=
rit :
> On 15.11.2010 18:21, Eric Dumazet wrote:
> > Use helpers to reduce number of sparse warnings
> > (CONFIG_SPARSE_RCU_POINTER=3Dy)
> >=20
> > remove one variable in amanda, hiding a previous one.
>=20
> nf_ct_expect_related() returns negative errno codes. It still
> works, but I prefer the clarity of actually using a signed
> variable for this. Unless you have strong feelings about this,
> I'll remove that part from the patch.

No problem, maybe rename the 2nd variable to avoid a sparse warning ?

net/ipv4/netfilter/nf_nat_amanda.c:47:7: warning: symbol 'ret' shadows
an earlier one
net/ipv4/netfilter/nf_nat_amanda.c:35:15: originally declared here

[PATCH] netfilter/amanda: rename a variable

Avoid a sparse warning about 'ret' variable shadowing

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 net/ipv4/netfilter/nf_nat_amanda.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_amanda.c b/net/ipv4/netfilter/nf=
_nat_amanda.c
index 0f23b3f..703f366 100644
--- a/net/ipv4/netfilter/nf_nat_amanda.c
+++ b/net/ipv4/netfilter/nf_nat_amanda.c
@@ -44,13 +44,13 @@ static unsigned int help(struct sk_buff *skb,
=20
 	/* Try to get same port: if not, try to change it. */
 	for (port =3D ntohs(exp->saved_proto.tcp.port); port !=3D 0; port++) =
{
-		int ret;
+		int res;
=20
 		exp->tuple.dst.u.tcp.port =3D htons(port);
-		ret =3D nf_ct_expect_related(exp);
-		if (ret =3D=3D 0)
+		res =3D nf_ct_expect_related(exp);
+		if (res =3D=3D 0)
 			break;
-		else if (ret !=3D -EBUSY) {
+		else if (res !=3D -EBUSY) {
 			port =3D 0;
 			break;
 		}


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
