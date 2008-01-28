From: Eric Leblond <eric@inl.fr>
Subject: Transmit mark during connection destruction event
Date: Tue, 29 Jan 2008 00:13:24 +0100
Message-ID: <20080128231323.GA24226@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="17pEHd4RhPHOinZp"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:52639 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764261AbYA1XNa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:13:30 -0500
Received: from bayen.regit.org ([81.57.69.189] helo=localhost)
	by fydelkass.inl.fr with esmtpsa (TLS-1.0:RSA_AES_128_CBC_SHA1:16)
	(Exim 4.63)
	(envelope-from <eric@inl.fr>)
	id 1JJdAP-0005Xa-9w
	for netfilter-devel@vger.kernel.org; Tue, 29 Jan 2008 00:13:29 +0100
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

The following feature was submitted some months ago. It forces the dump
of mark during the connection destruction event. The induced load is
quiet small and the patch is usefull to provide an easy way to filter
event on user side without having to keep an hash in userspace.

This new version is against 2.6.24 git tree.

BR,
-- 
Eric Leblond <eric@inl.fr>
NuFW, Now User Filtering Works : http://www.nufw.org

--17pEHd4RhPHOinZp
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-Transmit-mark-during-all-events.patch"
Content-Transfer-Encoding: quoted-printable

=46rom a222a44fc10d6bd0a6fdb4b0f086d83f6347d529 Mon Sep 17 00:00:00 2001
=46rom: Eric Leblond <eric@inl.fr>
Date: Tue, 29 Jan 2008 00:00:46 +0100
Subject: [PATCH] Transmit mark during all events.


Signed-off-by: Eric Leblond <eric@inl.fr>
---
 net/netfilter/nf_conntrack_netlink.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntr=
ack_netlink.c
index 7d23124..d6ade4d 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -414,18 +414,18 @@ static int ctnetlink_conntrack_event(struct notifier_=
block *this,
 		    && ctnetlink_dump_helpinfo(skb, ct) < 0)
 			goto nla_put_failure;
=20
-#ifdef CONFIG_NF_CONNTRACK_MARK
-		if ((events & IPCT_MARK || ct->mark)
-		    && ctnetlink_dump_mark(skb, ct) < 0)
-			goto nla_put_failure;
-#endif
-
 		if (events & IPCT_COUNTER_FILLING &&
 		    (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
 		     ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0))
 			goto nla_put_failure;
 	}
=20
+#ifdef CONFIG_NF_CONNTRACK_MARK
+	if ((events & IPCT_MARK || ct->mark)
+			&& ctnetlink_dump_mark(skb, ct) < 0)
+		goto nla_put_failure;
+#endif
+
 	nlh->nlmsg_len =3D skb->tail - b;
 	nfnetlink_send(skb, 0, group, 0);
 	return NOTIFY_DONE;
--=20
1.5.2.5


--17pEHd4RhPHOinZp--
