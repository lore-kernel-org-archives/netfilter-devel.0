From: Borislav Petkov <bp@alien8.de>
Subject: nfnetlink warnings
Date: Mon, 23 Nov 2015 10:36:07 +0100
Message-ID: <20151123093607.GA5134@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	lkml <linux-kernel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.skyhub.de ([78.46.96.112]:54318 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbbKWJgP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Nov 2015 04:36:15 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hey,

so I keep getting those since recently:

net/netfilter/nfnetlink_queue.c:519:19: warning: =E2=80=98nfnl_ct=E2=80=
=99 may be used uninitialized in this function [-Wmaybe-uninitialized]
  if (ct && nfnl_ct->build(skb, ct, ctinfo, NFQA_CT, NFQA_CT_INFO) < 0)
                   ^
net/netfilter/nfnetlink_queue.c:316:23: note: =E2=80=98nfnl_ct=E2=80=99=
 was declared here
  struct nfnl_ct_hook *nfnl_ct;
                       ^
net/netfilter/nfnetlink_queue.c: In function =E2=80=98nfqnl_recv_verdic=
t=E2=80=99:
net/netfilter/nfnetlink_queue.c:1083:11: warning: =E2=80=98nfnl_ct=E2=80=
=99 may be used uninitialized in this function [-Wmaybe-uninitialized]
    nfnl_ct->seq_adjust(entry->skb, ct, ctinfo, diff);
           ^

and was thinking can we shut them up like this? I know, it is ugly :-\

I mean, it is obvious in both cases that nfnl_ct won't be used if ct is
not set but apparently gcc can't see that far...

---
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_=
queue.c
index 7d81d280cb4f..cd61b0b5c413 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -372,6 +372,8 @@ nfqnl_build_packet_message(struct net *net, struct =
nfqnl_instance *queue,
 			if (ct !=3D NULL)
 				size +=3D nfnl_ct->build_size(ct);
 		}
+	} else {
+		nfnl_ct =3D NULL;
 	}
=20
 	if (queue->flags & NFQA_CFG_F_UID_GID) {
@@ -1069,6 +1071,8 @@ nfqnl_recv_verdict(struct sock *ctnl, struct sk_b=
uff *skb,
 		nfnl_ct =3D rcu_dereference(nfnl_ct_hook);
 		if (nfnl_ct !=3D NULL)
 			ct =3D nfqnl_ct_parse(nfnl_ct, nlh, nfqa, entry, &ctinfo);
+	} else {
+		nfnl_ct =3D NULL;
 	}
=20
 	if (nfqa[NFQA_PAYLOAD]) {

--=20
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
