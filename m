From: Roman Hoog Antink <rha@open.ch>
Subject: Re: xt_recent compat code supposedly broken
Date: Fri, 24 Apr 2009 13:32:50 +0200
Message-ID: <49F1A362.6020109@open.ch>
References: <alpine.LSU.2.00.0904241032310.20106@fbirervta.pbzchgretzou.qr> <alpine.LSU.2.00.0904241050030.22023@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050201050705020808000901"
Cc: kaber@trash.net, Josef Drexler <joe-lk@ttdpatch.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail6.open.ch ([213.156.224.131]:22244 "EHLO mail6.open.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444AbZDXLyi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Apr 2009 07:54:38 -0400
In-Reply-To: <alpine.LSU.2.00.0904241050030.22023@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050201050705020808000901
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Thank you!

Find attached the slightly adapted patch (nf_inet_addr is a union, not 
struct). I tested it successfully with kernel 2.6.29 and it fixed the 
compat path issue.

Cheers
Roman


--------------050201050705020808000901
Content-Type: text/x-patch;
 name="xt_recent-compat-2.6.29.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xt_recent-compat-2.6.29.patch"

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 791e030..fcc2d7b 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -474,7 +474,7 @@ static ssize_t recent_old_proc_write(struct file *file,
 	struct recent_table *t = pde->data;
 	struct recent_entry *e;
 	char buf[sizeof("+255.255.255.255")], *c = buf;
-	__be32 addr;
+	union nf_inet_addr addr = {};
 	int add;
 
 	if (size > sizeof(buf))
@@ -506,14 +506,13 @@ static ssize_t recent_old_proc_write(struct file *file,
 		add = 1;
 		break;
 	}
-	addr = in_aton(c);
+	addr.ip = in_aton(c);
 
 	spin_lock_bh(&recent_lock);
-	e = recent_entry_lookup(t, (const void *)&addr, NFPROTO_IPV4, 0);
+	e = recent_entry_lookup(t, &addr, NFPROTO_IPV4, 0);
 	if (e == NULL) {
 		if (add)
-			recent_entry_init(t, (const void *)&addr,
-					  NFPROTO_IPV4, 0);
+			recent_entry_init(t, &addr, NFPROTO_IPV4, 0);
 	} else {
 		if (add)
 			recent_entry_update(t, e);
-- # Created with git-export-patch 

--------------050201050705020808000901--
