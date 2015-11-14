From: Philip Whineray <phil@firehol.org>
Subject: [PATCH v2] Root in namespace owns x_tables /proc entries
Date: Sat, 14 Nov 2015 09:12:14 +0000
Message-ID: <20151114091214.GA486@compaq.slightly-cracked.com>
References: <20151111165026.GA20549@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@inai.de>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:37595 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbbKNJMU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Nov 2015 04:12:20 -0500
Received: by wmww144 with SMTP id w144so59752685wmw.0
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Nov 2015 01:12:18 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20151111165026.GA20549@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Reading these files is impossible in an unprivileged user namespace,
interfering with various firewall tools. For instance, iptables-save
relies on reading /proc/net/ip_tables_names to dump only loaded tables.
---

Please don't apply in current form - it doesn't work. The namespace is
only set up after the /proc entry is created so it keeps the original
owner (an unshare within an unshare can work... mapping root to root).

Since it's in danger of getting quite complicate, would one or more of
the following be acceptable?

- Choose permission in a module parameter

- Allow setting with sysctl e.g. net.netfilter.conf.xtable_proc_perms

- Match permissions of /proc/modules (grsec restricts these so we will
  gain the same policy).

I also worked on a capabilities patch but that made userspace much more
complicated in a namespace than outside one. It would be simpler
to patch programs to read /proc/modules or assume the contents if they
can't read /proc/net/ip_tables_names.

 net/netfilter/x_tables.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 9b42b5e..671654d 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1227,6 +1227,8 @@ int xt_proto_init(struct net *net, u_int8_t af)
 #ifdef CONFIG_PROC_FS
 	char buf[XT_FUNCTION_MAXNAMELEN];
 	struct proc_dir_entry *proc;
+	kuid_t root_uid;
+	kgid_t root_gid;
 #endif
 
 	if (af >= ARRAY_SIZE(xt_prefix))
@@ -1234,12 +1236,16 @@ int xt_proto_init(struct net *net, u_int8_t af)
 
 
 #ifdef CONFIG_PROC_FS
+	root_uid = make_kuid(current_user_ns(), 1000);
+	root_gid = make_kgid(current_user_ns(), 1000);
+
 	strlcpy(buf, xt_prefix[af], sizeof(buf));
 	strlcat(buf, FORMAT_TABLES, sizeof(buf));
 	proc = proc_create_data(buf, 0440, net->proc_net, &xt_table_ops,
 				(void *)(unsigned long)af);
 	if (!proc)
 		goto out;
+	proc_set_user(proc, root_uid, root_gid);
 
 	strlcpy(buf, xt_prefix[af], sizeof(buf));
 	strlcat(buf, FORMAT_MATCHES, sizeof(buf));
-- 
2.1.4

