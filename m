From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ipset-5: 8/9] Enforce handling IPv4 and IPv6 differently for hash:ip type.
Date: Tue,  2 Nov 2010 15:35:33 +0100
Message-ID: <1288708534-14510-9-git-send-email-kadlec@blackhole.kfki.hu>
References: <1288708534-14510-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-2-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-3-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-4-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-5-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-6-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-7-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-8-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.7.0.4"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:46741 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641Ab0KBOfg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Nov 2010 10:35:36 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 50422188157
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Nov 2010 15:35:35 +0100 (CET)
Received: from smtp1.kfki.hu ([127.0.0.1])
	by localhost (smtp1.kfki.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S8+gL3Uu1xaX for <netfilter-devel@vger.kernel.org>;
	Tue,  2 Nov 2010 15:35:35 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.0.114])
	by smtp1.kfki.hu (Postfix) with ESMTP id 392A8188161
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Nov 2010 15:35:35 +0100 (CET)
In-Reply-To: <1288708534-14510-8-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------1.7.0.4
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit


Use the newly added parser function ipset_parse_ip4_single6 instead
of the generic ipset_parse_ip.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 src/ipset_hash_ip.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


--------------1.7.0.4
Content-Type: text/x-patch; name="0008-Enforce-handling-IPv4-and-IPv6-differently-for-hash-.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline; filename="0008-Enforce-handling-IPv4-and-IPv6-differently-for-hash-.patch"

diff --git a/src/ipset_hash_ip.c b/src/ipset_hash_ip.c
index be64189..1d9a175 100644
--- a/src/ipset_hash_ip.c
+++ b/src/ipset_hash_ip.c
@@ -85,7 +85,7 @@ struct ipset_type ipset_hash_ip0 = {
 	.dimension = IPSET_DIM_ONE,
 	.elem = { 
 		[IPSET_DIM_ONE] = { 
-			.parse = ipset_parse_ip,
+			.parse = ipset_parse_ip4_single6,
 			.print = ipset_print_ip,
 			.opt = IPSET_OPT_IP
 		},

--------------1.7.0.4--


