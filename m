From: BORBELY Zoltan <bozo@andrews.hu>
Subject: crash in death_by_timeout()
Date: Mon, 17 Nov 2008 23:18:55 +0100
Message-ID: <20081117221855.GD3271@zebra.home>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="NtwzykIc2mflq5ck"
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx8.datanet.hu ([194.149.13.161]:63791 "EHLO mx8.datanet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbYKQXBT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2008 18:01:19 -0500
Received: from dolphin (tng660dvmi.adsl.datanet.hu [195.56.206.203])
	by mx8.datanet.hu (DataNet) with ESMTP id ED893EC284
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Nov 2008 23:19:14 +0100 (CET)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--NtwzykIc2mflq5ck
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

There's a race in the nfct netlink code, the result is a crash in the
death_by_timeout() function. When a timer interrupt occures during a
new entry addition, the kernel will crash due to a NULL deref. The
attached patch has solved the problem for us. I haven't tested it on
the latest kernels, but the problem still seems to be there.

Bye,
Zoltan Borbely

--NtwzykIc2mflq5ck
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="nf_conntrack_netlink.patch"

--- /tmp/nf_conntrack_netlink.c-orig	2008-09-29 23:28:55.000000000 +0200
+++ /tmp/nf_conntrack_netlink.c	2008-09-29 23:29:11.000000000 +0200
@@ -1177,8 +1177,8 @@
 		ct->master = master_ct;
 	}
 
-	add_timer(&ct->timeout);
 	nf_conntrack_hash_insert(ct);
+	add_timer(&ct->timeout);
 	rcu_read_unlock();
 
 	return 0;

--NtwzykIc2mflq5ck--
