From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: nf_conntrack_count versus '/proc/net/nf_conntrack | wc -l'
 count
Date: Fri, 19 Feb 2010 15:12:41 +0100
Message-ID: <1266588761.3136.12.camel@edumazet-laptop>
References: <48ceaa831002150927q166b5955gfa0e1e465903d29d@mail.gmail.com>
	 <1266271377.2859.28.camel@edumazet-laptop>
	 <48ceaa831002151410j1dbdfce3tcbdb5ceaa86b0e2b@mail.gmail.com>
	 <48ceaa831002180940y65af65b4p5d887f2f1a50b4b@mail.gmail.com>
	 <1266515463.2877.10.camel@edumazet-laptop>
	 <48ceaa831002180955v4fd87e20o4e116c87f4f4b259@mail.gmail.com>
	 <1266516452.2877.12.camel@edumazet-laptop>
	 <48ceaa831002181013q46d4d623xcd88f6164a088729@mail.gmail.com>
	 <4B7D84C6.2040102@trash.net>
	 <48ceaa831002181139k134dadbp2bc65857eac6af59@mail.gmail.com>
	 <48ceaa831002181653o549964c3w76bc27dd66864f8b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Afi Gjermund <afigjermund@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:39344 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab0BSOMv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Feb 2010 09:12:51 -0500
Received: by bwz1 with SMTP id 1so77100bwz.21
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Feb 2010 06:12:49 -0800 (PST)
In-Reply-To: <48ceaa831002181653o549964c3w76bc27dd66864f8b@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le jeudi 18 f=C3=A9vrier 2010 =C3=A0 16:53 -0800, Afi Gjermund a =C3=A9=
crit :

> I have found the issue that was causing this problem.  A userspace
> application that was using the NFQueue mechanism to queue data to
> userspace was returning a verdict of STOLEN on the first UDP packet
> seen.  This appears to have been leaving entries in the connection
> table that could not be flushed via nf_conntrack_flush().  When
> changing the verdict to DROP, the problem no longer existed.
>=20
> This was found as I noticed the Timer value of the connections within
> the table remained at 3000 (30 in nf_conntrack_udp_timeout x 100).
>=20
> Feb 18 22:56:31 titan user.info kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Table Dump =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> Feb 18 22:56:31 titan user.info kernel:  ---- Set ----
> Feb 18 22:56:31 titan user.info kernel: Timer is : 3000
> Feb 18 22:56:31 titan user.info kernel:  tuple dump: IP_CT_DIR_ORIGIN=
AL
> Feb 18 22:56:31 titan user.info kernel:
> Feb 18 22:56:31 titan user.warn kernel:  tuple c321cc70: l3num 2
> protonum 17  srcIP 172.16.8.45 srcPort 4858  -> dstIP 172.16.8.7
> dstPort 45001
> Feb 18 22:56:31 titan user.info kernel:  tuple dump: IP_CT_DIR_REPLY
> Feb 18 22:56:31 titan user.info kernel:
> Feb 18 22:56:31 titan user.warn kernel:  tuple c321cca8: l3num 2
> protonum 17  srcIP 172.16.8.7 srcPort 45001  -> dstIP 172.16.8.45
> dstPort 4858
> Feb 18 22:56:31 titan user.info kernel:  ---- End Set ----
> Feb 18 22:56:31 titan user.info kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> End Table Dump =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> Feb 18 22:57:03 titan user.info kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Table Dump =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> Feb 18 22:57:03 titan user.info kernel:  ---- Set ----
> Feb 18 22:57:03 titan user.info kernel: Timer is : 3000
> Feb 18 22:57:03 titan user.info kernel:  tuple dump: IP_CT_DIR_ORIGIN=
AL
> Feb 18 22:57:03 titan user.info kernel:
> Feb 18 22:57:03 titan user.warn kernel:  tuple c321cc70: l3num 2
> protonum 17  srcIP 172.16.8.45 srcPort 4858  -> dstIP 172.16.8.7
> dstPort 45001
> Feb 18 22:57:03 titan user.info kernel:  tuple dump: IP_CT_DIR_REPLY
> Feb 18 22:57:03 titan user.info kernel:
> Feb 18 22:57:03 titan user.warn kernel:  tuple c321cca8: l3num 2
> protonum 17  srcIP 172.16.8.7 srcPort 45001  -> dstIP 172.16.8.45
> dstPort 4858
> Feb 18 22:57:03 titan user.info kernel:  ---- End Set ----
> Feb 18 22:57:03 titan user.info kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> End Table Dump =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
>=20
> Thank you all for your help!  Hopefully this may help other people as=
 well.
>=20
> Afi

Thanks Afi for providing us more info :)

Patrick, If a user application asks NF_STOLEN, we leak the skb.
As the entry is freed, there is no way this skb can be found again.

What do you think of following patch ?
Or should we ignore NF_STOLEN status from user, to let packet still
queued ?

Thanks

[PATCH] nf_queue: fix NF_STOLEN skb leak

commit 3bc38712e3a6e059 (handle NF_STOP and unknown verdicts in
nf_reinject) was a partial fix to packet leaks.

If user asks NF_STOLEN status, we must free the skb as well.

Reported-by: Afi Gjermund <afigjermund@gmail.com>
Signed-off-by: Eric DUmazet <eric.dumazet@gmail.com>
---
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 3a6fd77..ba095fd 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -265,7 +265,6 @@ void nf_reinject(struct nf_queue_entry *entry, unsi=
gned int verdict)
 		local_bh_disable();
 		entry->okfn(skb);
 		local_bh_enable();
-	case NF_STOLEN:
 		break;
 	case NF_QUEUE:
 		if (!__nf_queue(skb, elem, entry->pf, entry->hook,
@@ -273,6 +272,7 @@ void nf_reinject(struct nf_queue_entry *entry, unsi=
gned int verdict)
 				verdict >> NF_VERDICT_BITS))
 			goto next_hook;
 		break;
+	case NF_STOLEN:
 	default:
 		kfree_skb(skb);
 	}


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
