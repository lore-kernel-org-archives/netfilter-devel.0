From: Holger Freyther <zecke@selfish.org>
Subject: [PATCH] netfilter: Fix typo in nf_queue.c
Date: Sat, 26 Dec 2009 04:22:51 +0100
Message-ID: <200912260422.52186.zecke@selfish.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_MGYNLpD+fA6Jl7N"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gandharva.secretlabs.de ([78.46.147.237]:59921 "EHLO
	gandharva.secretlabs.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757548AbZLZDcu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Dec 2009 22:32:50 -0500
Received: from tamarin.localnet (123-192-180-176.dynamic.kbronet.com.tw [123.192.180.176])
	by gandharva.secretlabs.de (Postfix) with ESMTPSA id 198661B10C04
	for <netfilter-devel@vger.kernel.org>; Sat, 26 Dec 2009 03:19:29 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--Boundary-00=_MGYNLpD+fA6Jl7N
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi all,

LaF0rge pointed me to libnetfilter_queue earlier this week and today I
started to read the kernel code of it. I stumbled across a small typo in
the code. I'm sorry that I take your attention away from a real issue for
this but maybe it is still worth applying.

regards
	holger




--Boundary-00=_MGYNLpD+fA6Jl7N
Content-Type: text/x-patch;
  charset="UTF-8";
  name="0001-netfilter-Fix-typo-in-nf_queue.c.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-netfilter-Fix-typo-in-nf_queue.c.patch"

=46rom e2046abf4c9d09dff4e2e45135b1feac4086f2b7 Mon Sep 17 00:00:00 2001
=46rom: Holger Hans Peter Freyther <zecke@selfish.org>
Date: Sat, 26 Dec 2009 04:10:41 +0100
Subject: [PATCH] netfilter: Fix typo in nf_queue.c

Signed-of-by: Holger Hans Peter Freyther <zecke@selfish.org>
=2D--
 net/netfilter/nf_queue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 3a6fd77..b3f76f9 100644
=2D-- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -239,7 +239,7 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned=
 int verdict)
=20
 	nf_queue_entry_release_refs(entry);
=20
=2D	/* Continue traversal iff userspace said ok... */
+	/* Continue traversal if userspace said ok... */
 	if (verdict =3D=3D NF_REPEAT) {
 		elem =3D elem->prev;
 		verdict =3D NF_ACCEPT;
=2D-=20
1.6.3.3


--Boundary-00=_MGYNLpD+fA6Jl7N--
