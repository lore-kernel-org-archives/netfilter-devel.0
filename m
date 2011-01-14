From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH]: netfilter: nf_conntrack: use is_vmalloc_addr()
Date: Fri, 14 Jan 2011 15:33:43 +0100
Message-ID: <1295015623.3937.23.camel@edumazet-laptop>
References: <4D3052AA.40100@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47682 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab1ANOdr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:33:47 -0500
Received: by wwa36 with SMTP id 36so3045043wwa.1
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jan 2011 06:33:46 -0800 (PST)
In-Reply-To: <4D3052AA.40100@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le vendredi 14 janvier 2011 =C3=A0 14:42 +0100, Patrick McHardy a =C3=A9=
crit :
> I'll add this to my tree unless someone spots a bug.
>=20
> netfilter: nf_conntrack: use is_vmalloc_addr()
>=20
> Use is_vmalloc_addr() in nf_ct_free_hashtable() and get rid of
> the vmalloc flags to indicate that a hash table has been allocated
> using vmalloc().
>=20

Seems fine to me, you could shrink this chunk to one line :

@@ -1271,7 +1271,7 @@ static void nf_conntrack_cleanup_net(struct net *=
net)
 		goto i_see_dead_people;
 	}
=20
-	nf_ct_free_hashtable(net->ct.hash, net->ct.hash_vmalloc,
+	nf_ct_free_hashtable(net->ct.hash,=20
 			     net->ct.htable_size);
 	nf_conntrack_ecache_fini(net);
 	nf_conntrack_acct_fini(net);
@@ -1301,21 +1301,18 @@ void nf_conntrack_cleanup(struct net *net)





--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
