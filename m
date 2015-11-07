From: Philip Whineray <phil@firehol.org>
Subject: [PATCH] Expose x_tables /proc entries as 0444 not 0440
Date: Sat, 7 Nov 2015 07:49:39 +0000
Message-ID: <20151107074939.GA4003@compaq.slightly-cracked.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:36520 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbbKGHtr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Nov 2015 02:49:47 -0500
Received: by wimw2 with SMTP id w2so42753295wim.1
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Nov 2015 23:49:46 -0800 (PST)
Received: from compaq.slightly-cracked.com (b.e.d.5.a.3.e.f.f.f.6.7.0.6.e.0.0.0.0.0.b.f.a.c.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:cafb:0:e60:76ff:fe3a:5deb])
        by smtp.gmail.com with ESMTPSA id e9sm3836691wjw.8.2015.11.06.23.49.45
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Nov 2015 23:49:45 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Reading these files is impossible in an unprivileged user namespace,
interfering with various firewall tools. For instance, iptables-save
relies on reading /proc/net/ip_tables_names to dump only loaded tables.

Hiding the contents from non-root users does not achieve anything
practical. Possible values are well-known and the specifics can
be inferred from a list of loaded modules on most systems.

Signed-off-by: Philip Whineray <phil@firehol.org>
---
An alternate might be to change the ownership of the files within the
namespace when it is created:

https://lists.linuxcontainers.org/pipermail/lxc-users/2014-November/008110.html

I do not see that there is much advantage to this, it just ties the
ability to read the files to the ability to create an unprivileged
namespace.

 net/netfilter/x_tables.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 9b42b5e..c05adde 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1236,21 +1236,21 @@ int xt_proto_init(struct net *net, u_int8_t af)
 #ifdef CONFIG_PROC_FS
 	strlcpy(buf, xt_prefix[af], sizeof(buf));
 	strlcat(buf, FORMAT_TABLES, sizeof(buf));
-	proc = proc_create_data(buf, 0440, net->proc_net, &xt_table_ops,
+	proc = proc_create_data(buf, 0444, net->proc_net, &xt_table_ops,
 				(void *)(unsigned long)af);
 	if (!proc)
 		goto out;
 
 	strlcpy(buf, xt_prefix[af], sizeof(buf));
 	strlcat(buf, FORMAT_MATCHES, sizeof(buf));
-	proc = proc_create_data(buf, 0440, net->proc_net, &xt_match_ops,
+	proc = proc_create_data(buf, 0444, net->proc_net, &xt_match_ops,
 				(void *)(unsigned long)af);
 	if (!proc)
 		goto out_remove_tables;
 
 	strlcpy(buf, xt_prefix[af], sizeof(buf));
 	strlcat(buf, FORMAT_TARGETS, sizeof(buf));
-	proc = proc_create_data(buf, 0440, net->proc_net, &xt_target_ops,
+	proc = proc_create_data(buf, 0444, net->proc_net, &xt_target_ops,
 				(void *)(unsigned long)af);
 	if (!proc)
 		goto out_remove_matches;
-- 
2.1.4
