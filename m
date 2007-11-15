From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: fix compat_nf_sockopt typo
Date: Thu, 15 Nov 2007 22:58:37 +0100
Message-ID: <473CC10D.2010305@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050806040701090409050900"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: "David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57353 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761574AbXKOV6o (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2007 16:58:44 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------050806040701090409050900
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit


--------------050806040701090409050900
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: fix compat_nf_sockopt typo

It should pass opt to the ->get/->set functions, not ops.

Tested-by: Luca Tettamanti <kronos.it@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 65ad145a53233f4ddd3021ad23e8407137c9207c
tree a6633e33307b5ec1e11fedc2d0e125ed6e2bd081
parent 99fee6d7e5748d96884667a4628118f7fc130ea0
author Patrick McHardy <kaber@trash.net> Thu, 15 Nov 2007 22:57:57 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 15 Nov 2007 22:57:57 +0100

 net/netfilter/nf_sockopt.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_sockopt.c b/net/netfilter/nf_sockopt.c
index 87bc144..3dd4b3c 100644
--- a/net/netfilter/nf_sockopt.c
+++ b/net/netfilter/nf_sockopt.c
@@ -143,12 +143,12 @@ static int compat_nf_sockopt(struct sock *sk, int pf, int val,
 		if (ops->compat_get)
 			ret = ops->compat_get(sk, val, opt, len);
 		else
-			ret = ops->get(sk, val, ops, len);
+			ret = ops->get(sk, val, opt, len);
 	} else {
 		if (ops->compat_set)
-			ret = ops->compat_set(sk, val, ops, *len);
+			ret = ops->compat_set(sk, val, opt, *len);
 		else
-			ret = ops->set(sk, val, ops, *len);
+			ret = ops->set(sk, val, opt, *len);
 	}
 
 	module_put(ops->owner);

--------------050806040701090409050900--
