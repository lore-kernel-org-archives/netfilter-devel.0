From: Changli Gao <xiaosuo@gmail.com>
Subject: ct: will ct be stalled in rcu read critical section?
Date: Wed, 10 Feb 2010 11:16:20 +0800
Message-ID: <412e6f7f1002091916h5663057bq56b81d6ceec478a7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:50365 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab0BJDQX convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Feb 2010 22:16:23 -0500
Received: by fxm20 with SMTP id 20so786833fxm.21
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Feb 2010 19:16:21 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

in http://git.kernel.org/?p=3Dlinux/kernel/git/next/linux-next.git;a=3D=
commitdiff;h=3Dea781f197d6a835cbb93a0bf88ee1696296ed8aa#patch6
, I don't understand the patch bellow.

@@ -275,11 +291,18 @@ nf_conntrack_find_get(struct net *net, const
struct nf_conntrack_tuple *tuple)
        struct nf_conn *ct;

        rcu_read_lock();
+begin:
        h =3D __nf_conntrack_find(net, tuple);
        if (h) {
                ct =3D nf_ct_tuplehash_to_ctrack(h);
                if (unlikely(!atomic_inc_not_zero(&ct->ct_general.use))=
)
                        h =3D NULL;
+               else {
+                       if (unlikely(!nf_ct_tuple_equal(tuple, &h->tupl=
e))) {
+                               nf_ct_put(ct);
+                               goto begin;
+                       }
+               }
        }
        rcu_read_unlock();

will ct be stalled in rcu read critical section?

Would you explain it for me? Thanks!

--=20
Regards=EF=BC=8C
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
