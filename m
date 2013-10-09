From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 2/2] examples: nft-set-get: retrieve all sets
Date: Wed, 09 Oct 2013 12:18:12 +0200
Message-ID: <20131009101812.29759.71506.stgit@nfdev.cica.es>
References: <20131009101806.29759.55315.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:40130 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753111Ab3JIKSR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Oct 2013 06:18:17 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 30C3F51ED4E
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2013 10:18:16 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0bgkNQJwduHc for <netfilter-devel@vger.kernel.org>;
	Wed,  9 Oct 2013 12:18:16 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id F140051ED34
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2013 12:18:15 +0200 (CEST)
In-Reply-To: <20131009101806.29759.55315.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Other nftables objects are allowed to be dumped with NFPROTO_UNSPEC.
With sets is also possible since kernel patch [b63108a] (netfilter: nf_tables:
allow to dump sets with NFPROTO_UNSPEC).

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 examples/nft-set-get.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/examples/nft-set-get.c b/examples/nft-set-get.c
index 4bc585c..672026f 100644
--- a/examples/nft-set-get.c
+++ b/examples/nft-set-get.c
@@ -74,8 +74,10 @@ int main(int argc, char *argv[])
 		family = NFPROTO_BRIDGE;
 	else if (strcmp(argv[1], "arp") == 0)
 		family = NFPROTO_ARP;
+	else if (strcmp(argv[1], "any") == 0)
+		family = NFPROTO_UNSPEC;
 	else {
-		fprintf(stderr, "Unknown family: ip, ip6, bridge, arp\n");
+		fprintf(stderr, "Unknown family: ip, ip6, bridge, arp, any\n");
 		exit(EXIT_FAILURE);
 	}
 

