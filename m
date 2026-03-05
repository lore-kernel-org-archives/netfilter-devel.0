Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4404B2B9B7
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Mar 2026 00:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772671675; cv=none; b=PYH+nwOra9mJuEbqmHDlYLAbTOfR8jjelv/cQ5jiYgJgZjMYAU5LwDCZy5geRJJWPViq2/i2lsH825Ak40fo332BtvagRBtzVZqSuTPOJhoNNcFp12e7nrpAdgjcD2MSeJYsKtO1ZuzS8WboP0EsfgKn0E/UT4blGa5kJ49cjqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772671675; c=relaxed/simple;
	bh=seD+juHBFQ8ZcewZJhwsfMFcSDGnYqkGphUYzEp1lEk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=C82doT5etioITQ3ZjPw3Q5+IBgD2uuQQQ8B7NiBdW3zyeXJapw19AEjovvc8E+yoQ4/MV8iP/VhWtS+HvLCZ+n9DTFnXbSvCXZ+pzZhTWzVd6jDqBXfr9tYzDg2S0L1yNdO2Iq060FqeOlHstSoxV0K6GDYqmrVtxTRL6ypbKyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=sony.com; spf=fail smtp.mailfrom=sony.com; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=sony.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=sony.com
Received: from eig-obgw-6003b.ext.cloudfilter.net ([10.0.30.175])
	by cmsmtp with ESMTPS
	id xsYEvKvpPKjfoxwsVvhbuf; Thu, 05 Mar 2026 00:47:47 +0000
Received: from host2044.hostmonster.com ([67.20.76.238])
	by cmsmtp with ESMTPS
	id xwsUvzWRihoT4xwsUvRRGb; Thu, 05 Mar 2026 00:47:47 +0000
X-Authority-Analysis: v=2.4 cv=XZyJzJ55 c=1 sm=1 tr=0 ts=69a8d2b3
 a=O1AQXT3IpLm5MaED65xONQ==:117 a=uc9KWs4yn0V/JYYSH7YHpg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=mDV3o1hIAAAA:8 a=RT0onXadAAAA:8
 a=Aziwk6T4AAAA:8 a=z6gsHLkEAAAA:8 a=VnNF1IyMAAAA:8 a=pGLkceISAAAA:8
 a=20KFwNOVAAAA:8 a=tOO0nKmCAAAA:8 a=BXCyXuAxAAAA:8 a=Tty9oNO6AAAA:8
 a=joG0BDkuKpNYsG9LMrcA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=RVmHIydaz68A:10 a=mYB3vj3COWURRnkzEGRi:22 a=mtcElmGe8wx6H7Xd9tIj:22
 a=Gz67Kf0DkuxJ4rqyVRET:22 a=PwRmQJGe9grQJPGacnFL:22 a=Bts-Es6F1CBXvF7u4C_G:22
 a=iekntanDnrheIxGr1pkv:22
Received: from [66.118.46.62] (port=42014 helo=timdesk..)
	by host2044.hostmonster.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <tim.bird@sony.com>)
	id 1vxwsS-00000001qOB-0b4H;
	Wed, 04 Mar 2026 17:47:44 -0700
From: Tim Bird <tim.bird@sony.com>
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.kernel.org,
	kuniyu@google.com,
	mubashirq@google.com,
	willemb@google.com,
	dsahern@kernel.org,
	pablo@netfilter.org,
	laforge@netfilter.org,
	fw@strlen.de,
	ncardwell@google.com,
	ycheng@google.com,
	xemul@parallels.com,
	idosch@mellanox.com
Cc: tim.bird@sony.com,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-spdx@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] net: Add SPDX ids to some source files
Date: Wed,  4 Mar 2026 17:47:22 -0700
Message-ID: <20260305004724.87469-1-tim.bird@sony.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host2044.hostmonster.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - sony.com
X-BWhitelist: no
X-Source-IP: 66.118.46.62
X-Source-L: No
X-Exim-ID: 1vxwsS-00000001qOB-0b4H
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (timdesk..) [66.118.46.62]:42014
X-Source-Auth: tim@bird.org
X-Email-Count: 4
X-Org: HG=bhshared_hm;ORG=bluehost;
X-Source-Cap: YmlyZG9yZztiaXJkb3JnO2hvc3QyMDQ0Lmhvc3Rtb25zdGVyLmNvbQ==
X-Local-Domain: no
X-CMAE-Envelope: MS4xfBVHOrGuQ8EKhGOGgpAcJzyxxXi1NUu2GLbr/tOhsiqChkDLXt5p5If6Jdp4T8swNdYIwFMbBcQBcqs71hJ8W7z0oEv0Sy16WcmV699KmJYCbOcmNmo6
 rz0e2XQ7LVaRyMCQscgU9mvEOpGNXGSX7HPKQbJ9tZVkzBL3RzE78ky2O2NQ4PdfKr4SjbPRoBxkaQqtXw0msygYAcK7Do/s/n0=

Add SPDX-License-Identifier lines to several source
files under the network sub-directory.  Work on files
in the core, dns_resolver, ipv4, ipv6 and
netfilter sub-dirs.  Remove boilerplate
and license reference text to avoid ambiguity.

Rusty Russell has expressed that his contributions
were intended to be GPL-2.0-or-later.

Signed-off-by: Tim Bird <tim.bird@sony.com>
---
---
 net/core/fib_notifier.c               |  1 +
 net/core/sock_diag.c                  |  3 +--
 net/dns_resolver/dns_key.c            | 14 +-------------
 net/dns_resolver/dns_query.c          | 14 +-------------
 net/dns_resolver/internal.h           | 14 +-------------
 net/ipv4/inetpeer.c                   |  3 +--
 net/ipv4/ipmr_base.c                  |  1 +
 net/ipv4/netfilter.c                  |  3 ++-
 net/ipv4/tcp_bbr.c                    |  1 +
 net/ipv4/tcp_dctcp.h                  |  1 +
 net/ipv4/tcp_plb.c                    |  1 +
 net/ipv6/fib6_notifier.c              |  1 +
 net/ipv6/ila/ila_common.c             |  1 +
 net/ipv6/netfilter.c                  |  3 ++-
 net/netfilter/core.c                  |  3 +--
 net/netfilter/nf_conntrack_netlink.c  |  4 +---
 net/netfilter/nf_flow_table_offload.c |  1 +
 net/netfilter/nf_queue.c              |  1 +
 net/netfilter/nfnetlink.c             |  4 +---
 net/netfilter/nft_chain_filter.c      |  1 +
 net/netfilter/xt_connbytes.c          |  3 ++-
 net/netfilter/xt_connlimit.c          |  3 ++-
 net/netfilter/xt_time.c               |  3 +--
 23 files changed, 27 insertions(+), 57 deletions(-)

diff --git a/net/core/fib_notifier.c b/net/core/fib_notifier.c
index 5cdca49b1d7c..6bb2cc7e88ca 100644
--- a/net/core/fib_notifier.c
+++ b/net/core/fib_notifier.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 #include <linux/rtnetlink.h>
 #include <linux/notifier.h>
 #include <linux/rcupdate.h>
diff --git a/net/core/sock_diag.c b/net/core/sock_diag.c
index c83335c62360..f67accd60675 100644
--- a/net/core/sock_diag.c
+++ b/net/core/sock_diag.c
@@ -1,5 +1,4 @@
-/* License: GPL */
-
+// SPDX-License-Identifier: GPL-2.0
 #include <linux/filter.h>
 #include <linux/mutex.h>
 #include <linux/socket.h>
diff --git a/net/dns_resolver/dns_key.c b/net/dns_resolver/dns_key.c
index c42ddd85ff1f..9d998e267f5f 100644
--- a/net/dns_resolver/dns_key.c
+++ b/net/dns_resolver/dns_key.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: LGPL-2.1-or-later
 /* Key type used to cache DNS lookups made by the kernel
  *
  * See Documentation/networking/dns_resolver.rst
@@ -7,19 +8,6 @@
  *              Steve French (sfrench@us.ibm.com)
  *              Wang Lei (wang840925@gmail.com)
  *		David Howells (dhowells@redhat.com)
- *
- *   This library is free software; you can redistribute it and/or modify
- *   it under the terms of the GNU Lesser General Public License as published
- *   by the Free Software Foundation; either version 2.1 of the License, or
- *   (at your option) any later version.
- *
- *   This library is distributed in the hope that it will be useful,
- *   but WITHOUT ANY WARRANTY; without even the implied warranty of
- *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
- *   the GNU Lesser General Public License for more details.
- *
- *   You should have received a copy of the GNU Lesser General Public License
- *   along with this library; if not, see <http://www.gnu.org/licenses/>.
  */
 #include <linux/module.h>
 #include <linux/moduleparam.h>
diff --git a/net/dns_resolver/dns_query.c b/net/dns_resolver/dns_query.c
index 53da62984447..e1c09d7b8200 100644
--- a/net/dns_resolver/dns_query.c
+++ b/net/dns_resolver/dns_query.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: LGPL-2.1-or-later
 /* Upcall routine, designed to work as a key type and working through
  * /sbin/request-key to contact userspace when handling DNS queries.
  *
@@ -20,19 +21,6 @@
  *   For example to use this module to query AFSDB RR:
  *
  *	create dns_resolver afsdb:* * /sbin/dns.afsdb %k
- *
- *   This library is free software; you can redistribute it and/or modify
- *   it under the terms of the GNU Lesser General Public License as published
- *   by the Free Software Foundation; either version 2.1 of the License, or
- *   (at your option) any later version.
- *
- *   This library is distributed in the hope that it will be useful,
- *   but WITHOUT ANY WARRANTY; without even the implied warranty of
- *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
- *   the GNU Lesser General Public License for more details.
- *
- *   You should have received a copy of the GNU Lesser General Public License
- *   along with this library; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #include <linux/module.h>
diff --git a/net/dns_resolver/internal.h b/net/dns_resolver/internal.h
index 0c570d40e4d6..d0d8edcea092 100644
--- a/net/dns_resolver/internal.h
+++ b/net/dns_resolver/internal.h
@@ -1,21 +1,9 @@
+/* SPDX-License-Identifier: LGPL-2.1-or-later */
 /*
  *   Copyright (c) 2010 Wang Lei
  *   Author(s): Wang Lei (wang840925@gmail.com). All Rights Reserved.
  *
  *   Internal DNS Rsolver stuff
- *
- *   This library is free software; you can redistribute it and/or modify
- *   it under the terms of the GNU Lesser General Public License as published
- *   by the Free Software Foundation; either version 2.1 of the License, or
- *   (at your option) any later version.
- *
- *   This library is distributed in the hope that it will be useful,
- *   but WITHOUT ANY WARRANTY; without even the implied warranty of
- *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
- *   the GNU Lesser General Public License for more details.
- *
- *   You should have received a copy of the GNU Lesser General Public License
- *   along with this library; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #include <linux/compiler.h>
diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
index 7b1e0a2d6906..9fa396d5f09f 100644
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -1,8 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  *		INETPEER - A storage for permanent information about peers
  *
- *  This source is covered by the GNU GPL, the same as all kernel sources.
- *
  *  Authors:	Andrey V. Savochkin <saw@msu.ru>
  */
 
diff --git a/net/ipv4/ipmr_base.c b/net/ipv4/ipmr_base.c
index 2d62526406ca..57721827a61a 100644
--- a/net/ipv4/ipmr_base.c
+++ b/net/ipv4/ipmr_base.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /* Linux multicast routing support
  * Common logic shared by IPv4 [ipmr] and IPv6 [ip6mr] implementation
  */
diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index ce310eb779e0..ce9e1bfa4259 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -1,7 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * IPv4 specific functions of netfilter core
  *
- * Rusty Russell (C) 2000 -- This code is GPL.
+ * Rusty Russell (C) 2000
  * Patrick McHardy (C) 2006-2012
  */
 #include <linux/kernel.h>
diff --git a/net/ipv4/tcp_bbr.c b/net/ipv4/tcp_bbr.c
index 760941e55153..05d52372ca8f 100644
--- a/net/ipv4/tcp_bbr.c
+++ b/net/ipv4/tcp_bbr.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /* Bottleneck Bandwidth and RTT (BBR) congestion control
  *
  * BBR congestion control computes the sending rate based on the delivery
diff --git a/net/ipv4/tcp_dctcp.h b/net/ipv4/tcp_dctcp.h
index 4b0259111d81..f13f8d770576 100644
--- a/net/ipv4/tcp_dctcp.h
+++ b/net/ipv4/tcp_dctcp.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _TCP_DCTCP_H
 #define _TCP_DCTCP_H
 
diff --git a/net/ipv4/tcp_plb.c b/net/ipv4/tcp_plb.c
index 4bcf7eff95e3..68ccdb9a5412 100644
--- a/net/ipv4/tcp_plb.c
+++ b/net/ipv4/tcp_plb.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /* Protective Load Balancing (PLB)
  *
  * PLB was designed to reduce link load imbalance across datacenter
diff --git a/net/ipv6/fib6_notifier.c b/net/ipv6/fib6_notifier.c
index 949b72610df7..64cd4ed8864c 100644
--- a/net/ipv6/fib6_notifier.c
+++ b/net/ipv6/fib6_notifier.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 #include <linux/notifier.h>
 #include <linux/socket.h>
 #include <linux/kernel.h>
diff --git a/net/ipv6/ila/ila_common.c b/net/ipv6/ila/ila_common.c
index b8d43ed4689d..e71571455c8a 100644
--- a/net/ipv6/ila/ila_common.c
+++ b/net/ipv6/ila/ila_common.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 #include <linux/errno.h>
 #include <linux/ip.h>
 #include <linux/kernel.h>
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 46540a5a4331..c3dc90dfab80 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -1,7 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * IPv6 specific functions of netfilter core
  *
- * Rusty Russell (C) 2000 -- This code is GPL.
+ * Rusty Russell (C) 2000
  * Patrick McHardy (C) 2006-2012
  */
 #include <linux/kernel.h>
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 11a702065bab..d5df44ea9e7b 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -1,10 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
 /* netfilter.c: look after the filters for various protocols.
  * Heavily influenced by the old firewall.c by David Bonn and Alan Cox.
  *
  * Thanks to Rob `CmdrTaco' Malda for not influencing this code in any
  * way.
- *
- * This code is GPL.
  */
 #include <linux/kernel.h>
 #include <linux/netfilter.h>
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index c9d725fc2d71..9b295867a105 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /* Connection tracking via netlink socket. Allows for user space
  * protocol helpers and general trouble making from userspace.
  *
@@ -10,9 +11,6 @@
  * generally made possible by Network Robots, Inc. (www.networkrobots.com)
  *
  * Further development of this code funded by Astaro AG (http://www.astaro.com)
- *
- * This software may be used and distributed according to the terms
- * of the GNU General Public License, incorporated herein by reference.
  */
 
 #include <linux/init.h>
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 9b677e116487..b2e4fb6fa011 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/module.h>
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 7f12e56e6e52..a6c81c04b3a5 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Rusty Russell (C)2000 -- This code is GPL.
  * Patrick McHardy (c) 2006-2012
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index e62a0dea24ea..47f3ed441f64 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /* Netfilter messages via netlink socket. Allows for user space
  * protocol helpers and general trouble making from userspace.
  *
@@ -9,9 +10,6 @@
  * generally made possible by Network Robots, Inc. (www.networkrobots.com)
  *
  * Further development of this code funded by Astaro AG (http://www.astaro.com)
- *
- * This software may be used and distributed according to the terms
- * of the GNU General Public License, incorporated herein by reference.
  */
 
 #include <linux/module.h>
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index b16185e9a6dd..14b14c46c314 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index 2aabdcea8707..1c6ffc7f1622 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -1,5 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0
 /* Kernel module to match connection tracking byte counter.
- * GPL (C) 2002 Martin Devera (devik@cdi.cz).
+ *  (C) 2002 Martin Devera (devik@cdi.cz).
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/module.h>
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 848287ab79cf..42df9e175aff 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * netfilter module to limit the number of parallel tcp
  * connections per IP address.
@@ -9,7 +10,7 @@
  * based on ...
  *
  * Kernel module to match connection tracking information.
- * GPL (C) 1999  Rusty Russell (rusty@rustcorp.com.au).
+ *   (C) 1999  Rusty Russell (rusty@rustcorp.com.au).
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index 00319d2a54da..9068cf88ec30 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  *	xt_time
  *	Copyright © CC Computer Consultants GmbH, 2007
@@ -6,8 +7,6 @@
  *	This is a module which is used for time matching
  *	It is using some modified code from dietlibc (localtime() function)
  *	that you can find at https://www.fefe.de/dietlibc/
- *	This file is distributed under the terms of the GNU General Public
- *	License (GPL). Copies of the GPL can be obtained from gnu.org/gpl.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-- 
2.43.0

