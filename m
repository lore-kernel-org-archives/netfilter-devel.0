Return-Path: <SRS0=E6gp=UJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1789C282DD
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jun 2019 12:24:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9711C20820
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jun 2019 12:24:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="kXGoVX4y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389746AbfFJMY1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jun 2019 08:24:27 -0400
Received: from smtp-out.kfki.hu ([148.6.0.45]:53467 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389899AbfFJMY1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jun 2019 08:24:27 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 6CE9867400D9;
        Mon, 10 Jun 2019 14:24:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:references:in-reply-to
        :x-mailer:message-id:date:date:from:from:received:received
        :received; s=20151130; t=1560169459; x=1561983860; bh=w+WzSGNNMD
        2IXtK/X3ZImFpAeDLJbtEUism+eMXTIAI=; b=kXGoVX4yR4kC9bctfxzb7LYQ3o
        MDzJqQURh+SBLNxwznAy55H1R8P9DyJnz0V44dX3MsZ/42hcFkb7fm7m7/Sxjun2
        iKT3P+WtLR+LjP/y/D2oDBjm5Wjqe/PWF2gLkiHTT1HXiHObZBRgFdVYMlGzOm+p
        hk7+9oKV3ZyNkh0PY=
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Mon, 10 Jun 2019 14:24:19 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp0.kfki.hu (Postfix) with ESMTP id 4785067400E9;
        Mon, 10 Jun 2019 14:24:17 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 3B299229CA; Mon, 10 Jun 2019 14:24:17 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7/7] Update my email address
Date:   Mon, 10 Jun 2019 14:24:16 +0200
Message-Id: <20190610122416.22708-8-kadlec@blackhole.kfki.hu>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190610122416.22708-1-kadlec@blackhole.kfki.hu>
References: <20190610122416.22708-1-kadlec@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It's better to use my kadlec@netfilter.org email address in
the source code. I might not be able to use
kadlec@blackhole.kfki.hu in the future.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 CREDITS                                        | 2 +-
 MAINTAINERS                                    | 2 +-
 include/linux/jhash.h                          | 2 +-
 include/linux/netfilter/ipset/ip_set.h         | 2 +-
 include/linux/netfilter/ipset/ip_set_counter.h | 2 +-
 include/linux/netfilter/ipset/ip_set_skbinfo.h | 2 +-
 include/linux/netfilter/ipset/ip_set_timeout.h | 2 +-
 include/uapi/linux/netfilter/ipset/ip_set.h    | 2 +-
 net/ipv4/netfilter/iptable_raw.c               | 2 +-
 net/ipv4/netfilter/nf_nat_h323.c               | 2 +-
 net/ipv6/netfilter/ip6table_raw.c              | 2 +-
 net/netfilter/ipset/ip_set_bitmap_gen.h        | 2 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c         | 4 ++--
 net/netfilter/ipset/ip_set_bitmap_ipmac.c      | 4 ++--
 net/netfilter/ipset/ip_set_bitmap_port.c       | 4 ++--
 net/netfilter/ipset/ip_set_core.c              | 4 ++--
 net/netfilter/ipset/ip_set_getport.c           | 2 +-
 net/netfilter/ipset/ip_set_hash_gen.h          | 2 +-
 net/netfilter/ipset/ip_set_hash_ip.c           | 4 ++--
 net/netfilter/ipset/ip_set_hash_ipmark.c       | 2 +-
 net/netfilter/ipset/ip_set_hash_ipport.c       | 4 ++--
 net/netfilter/ipset/ip_set_hash_ipportip.c     | 4 ++--
 net/netfilter/ipset/ip_set_hash_ipportnet.c    | 4 ++--
 net/netfilter/ipset/ip_set_hash_mac.c          | 4 ++--
 net/netfilter/ipset/ip_set_hash_net.c          | 4 ++--
 net/netfilter/ipset/ip_set_hash_netiface.c     | 4 ++--
 net/netfilter/ipset/ip_set_hash_netnet.c       | 2 +-
 net/netfilter/ipset/ip_set_hash_netport.c      | 4 ++--
 net/netfilter/ipset/ip_set_hash_netportnet.c   | 2 +-
 net/netfilter/ipset/ip_set_list_set.c          | 4 ++--
 net/netfilter/nf_conntrack_h323_main.c         | 2 +-
 net/netfilter/nf_conntrack_proto_tcp.c         | 2 +-
 net/netfilter/xt_iprange.c                     | 4 ++--
 net/netfilter/xt_set.c                         | 4 ++--
 34 files changed, 49 insertions(+), 49 deletions(-)

diff --git a/CREDITS b/CREDITS
index 8e0342620a06..4200f4f91a16 100644
--- a/CREDITS
+++ b/CREDITS
@@ -1800,7 +1800,7 @@ S: 2300 Copenhagen S.
 S: Denmark
=20
 N: Jozsef Kadlecsik
-E: kadlec@blackhole.kfki.hu
+E: kadlec@netfilter.org
 P: 1024D/470DB964 4CB3 1A05 713E 9BF7 FAC5  5809 DD8C B7B1 470D B964
 D: netfilter: TCP window tracking code
 D: netfilter: raw table
diff --git a/MAINTAINERS b/MAINTAINERS
index fcbd648b960e..4c65ce86fc9e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10858,7 +10858,7 @@ F:	drivers/net/ethernet/neterion/
=20
 NETFILTER
 M:	Pablo Neira Ayuso <pablo@netfilter.org>
-M:	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+M:	Jozsef Kadlecsik <kadlec@netfilter.org>
 M:	Florian Westphal <fw@strlen.de>
 L:	netfilter-devel@vger.kernel.org
 L:	coreteam@netfilter.org
diff --git a/include/linux/jhash.h b/include/linux/jhash.h
index 8037850f3104..ba2f6a9776b6 100644
--- a/include/linux/jhash.h
+++ b/include/linux/jhash.h
@@ -17,7 +17,7 @@
  * if SELF_TEST is defined.  You can use this free for any purpose.  It'=
s in
  * the public domain.  It has no warranty.
  *
- * Copyright (C) 2009-2010 Jozsef Kadlecsik (kadlec@blackhole.kfki.hu)
+ * Copyright (C) 2009-2010 Jozsef Kadlecsik (kadlec@netfilter.org)
  *
  * I've modified Bob's hash to be useful in the Linux kernel, and
  * any bugs present are my fault.
diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfi=
lter/ipset/ip_set.h
index e499d170f12d..f5c6e7cd6469 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -1,7 +1,7 @@
 /* Copyright (C) 2000-2002 Joakim Axelsson <gozem@linux.nu>
  *                         Patrick Schaaf <bof@bof.de>
  *                         Martin Josefsson <gandalf@wlug.westbo.se>
- * Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ * Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/include/linux/netfilter/ipset/ip_set_counter.h b/include/lin=
ux/netfilter/ipset/ip_set_counter.h
index 3d33a2c3f39f..305aeda2a899 100644
--- a/include/linux/netfilter/ipset/ip_set_counter.h
+++ b/include/linux/netfilter/ipset/ip_set_counter.h
@@ -1,7 +1,7 @@
 #ifndef _IP_SET_COUNTER_H
 #define _IP_SET_COUNTER_H
=20
-/* Copyright (C) 2015 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+/* Copyright (C) 2015 Jozsef Kadlecsik <kadlec@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/include/linux/netfilter/ipset/ip_set_skbinfo.h b/include/lin=
ux/netfilter/ipset/ip_set_skbinfo.h
index 29d7ef2bc3fa..fac57ef854c2 100644
--- a/include/linux/netfilter/ipset/ip_set_skbinfo.h
+++ b/include/linux/netfilter/ipset/ip_set_skbinfo.h
@@ -1,7 +1,7 @@
 #ifndef _IP_SET_SKBINFO_H
 #define _IP_SET_SKBINFO_H
=20
-/* Copyright (C) 2015 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+/* Copyright (C) 2015 Jozsef Kadlecsik <kadlec@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/include/linux/netfilter/ipset/ip_set_timeout.h b/include/lin=
ux/netfilter/ipset/ip_set_timeout.h
index 8ce271e187b6..dc74150f3432 100644
--- a/include/linux/netfilter/ipset/ip_set_timeout.h
+++ b/include/linux/netfilter/ipset/ip_set_timeout.h
@@ -1,7 +1,7 @@
 #ifndef _IP_SET_TIMEOUT_H
 #define _IP_SET_TIMEOUT_H
=20
-/* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+/* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/include/uapi/linux/netfilter/ipset/ip_set.h b/include/uapi/l=
inux/netfilter/ipset/ip_set.h
index ea69ca21ff23..eea166c52c36 100644
--- a/include/uapi/linux/netfilter/ipset/ip_set.h
+++ b/include/uapi/linux/netfilter/ipset/ip_set.h
@@ -2,7 +2,7 @@
 /* Copyright (C) 2000-2002 Joakim Axelsson <gozem@linux.nu>
  *                         Patrick Schaaf <bof@bof.de>
  *                         Martin Josefsson <gandalf@wlug.westbo.se>
- * Copyright (C) 2003-2011 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ * Copyright (C) 2003-2011 Jozsef Kadlecsik <kadlec@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptabl=
e_raw.c
index 6eefde5bc468..69697eb4bfc6 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -2,7 +2,7 @@
 /*
  * 'raw' table, which is the very first hooked in at PRE_ROUTING and LOC=
AL_OUT .
  *
- * Copyright (C) 2003 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ * Copyright (C) 2003 Jozsef Kadlecsik <kadlec@netfilter.org>
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/module.h>
diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat=
_h323.c
index 15f2b2604890..076b6b29d66d 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -7,7 +7,7 @@
  * This source code is licensed under General Public License version 2.
  *
  * Based on the 'brute force' H.323 NAT module by
- * Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ * Jozsef Kadlecsik <kadlec@netfilter.org>
  */
=20
 #include <linux/module.h>
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6ta=
ble_raw.c
index 3f7d4691c423..a22100b1cf2c 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -2,7 +2,7 @@
 /*
  * IPv6 raw table, a port of the IPv4 raw table to IPv6
  *
- * Copyright (C) 2003 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ * Copyright (C) 2003 Jozsef Kadlecsik <kadlec@netfilter.org>
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/module.h>
diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipse=
t/ip_set_bitmap_gen.h
index 38ef2ea838cb..29c1e9a50601 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -1,4 +1,4 @@
-/* Copyright (C) 2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+/* Copyright (C) 2013 Jozsef Kadlecsik <kadlec@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset=
/ip_set_bitmap_ip.c
index 488d6d05c65c..5a66c5499700 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -1,6 +1,6 @@
 /* Copyright (C) 2000-2002 Joakim Axelsson <gozem@linux.nu>
  *                         Patrick Schaaf <bof@bof.de>
- * Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ * Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -31,7 +31,7 @@
 #define IPSET_TYPE_REV_MAX	3	/* skbinfo support added */
=20
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
+MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
 IP_SET_MODULE_DESC("bitmap:ip", IPSET_TYPE_REV_MIN, IPSET_TYPE_REV_MAX);
 MODULE_ALIAS("ip_set_bitmap:ip");
=20
diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ip=
set/ip_set_bitmap_ipmac.c
index 980000fc3b50..ec7a8b12642c 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -1,7 +1,7 @@
 /* Copyright (C) 2000-2002 Joakim Axelsson <gozem@linux.nu>
  *                         Patrick Schaaf <bof@bof.de>
  *			   Martin Josefsson <gandalf@wlug.westbo.se>
- * Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ * Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -31,7 +31,7 @@
 #define IPSET_TYPE_REV_MAX	3	/* skbinfo support added */
=20
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
+MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
 IP_SET_MODULE_DESC("bitmap:ip,mac", IPSET_TYPE_REV_MIN, IPSET_TYPE_REV_M=
AX);
 MODULE_ALIAS("ip_set_bitmap:ip,mac");
=20
diff --git a/net/netfilter/ipset/ip_set_bitmap_port.c b/net/netfilter/ips=
et/ip_set_bitmap_port.c
index b561ca8b3659..18275ec4924c 100644
--- a/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -1,4 +1,4 @@
-/* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+/* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -26,7 +26,7 @@
 #define IPSET_TYPE_REV_MAX	3	/* skbinfo support added */
=20
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
+MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
 IP_SET_MODULE_DESC("bitmap:port", IPSET_TYPE_REV_MIN, IPSET_TYPE_REV_MAX=
);
 MODULE_ALIAS("ip_set_bitmap:port");
=20
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_s=
et_core.c
index 039892cd2b7d..18430ad2fdf2 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1,6 +1,6 @@
 /* Copyright (C) 2000-2002 Joakim Axelsson <gozem@linux.nu>
  *                         Patrick Schaaf <bof@bof.de>
- * Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ * Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -51,7 +51,7 @@ static unsigned int max_sets;
 module_param(max_sets, int, 0600);
 MODULE_PARM_DESC(max_sets, "maximal number of sets");
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
+MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
 MODULE_DESCRIPTION("core IP set support");
 MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_IPSET);
=20
diff --git a/net/netfilter/ipset/ip_set_getport.c b/net/netfilter/ipset/i=
p_set_getport.c
index 3f09cdb42562..dc7b46b41354 100644
--- a/net/netfilter/ipset/ip_set_getport.c
+++ b/net/netfilter/ipset/ip_set_getport.c
@@ -1,4 +1,4 @@
-/* Copyright (C) 2003-2011 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+/* Copyright (C) 2003-2011 Jozsef Kadlecsik <kadlec@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index 623e0d675725..07ef941130a6 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1,4 +1,4 @@
-/* Copyright (C) 2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+/* Copyright (C) 2013 Jozsef Kadlecsik <kadlec@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/i=
p_set_hash_ip.c
index 613eb212cb48..7b82bf1104ce 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -1,4 +1,4 @@
-/* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+/* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -30,7 +30,7 @@
 #define IPSET_TYPE_REV_MAX	4	/* skbinfo support  */
=20
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
+MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
 IP_SET_MODULE_DESC("hash:ip", IPSET_TYPE_REV_MIN, IPSET_TYPE_REV_MAX);
 MODULE_ALIAS("ip_set_hash:ip");
=20
diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ips=
et/ip_set_hash_ipmark.c
index f3ba8348cf9d..7d468f98a252 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -1,4 +1,4 @@
-/* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+/* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
  * Copyright (C) 2013 Smoothwall Ltd. <vytas.dauksa@smoothwall.net>
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ips=
et/ip_set_hash_ipport.c
index ddb8039ec1d2..d358ee69d04b 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -1,4 +1,4 @@
-/* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+/* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -32,7 +32,7 @@
 #define IPSET_TYPE_REV_MAX	5 /* skbinfo support added */
=20
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
+MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
 IP_SET_MODULE_DESC("hash:ip,port", IPSET_TYPE_REV_MIN, IPSET_TYPE_REV_MA=
X);
 MODULE_ALIAS("ip_set_hash:ip,port");
=20
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/i=
pset/ip_set_hash_ipportip.c
index a7f4d7a85420..0a304785f912 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -1,4 +1,4 @@
-/* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+/* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -32,7 +32,7 @@
 #define IPSET_TYPE_REV_MAX	5 /* skbinfo support added */
=20
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
+MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
 IP_SET_MODULE_DESC("hash:ip,port,ip", IPSET_TYPE_REV_MIN, IPSET_TYPE_REV=
_MAX);
 MODULE_ALIAS("ip_set_hash:ip,port,ip");
=20
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/=
ipset/ip_set_hash_ipportnet.c
index 88b83d6d3084..245f7d714870 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -1,4 +1,4 @@
-/* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+/* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -34,7 +34,7 @@
 #define IPSET_TYPE_REV_MAX	7 /* skbinfo support added */
=20
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
+MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
 IP_SET_MODULE_DESC("hash:ip,port,net", IPSET_TYPE_REV_MIN, IPSET_TYPE_RE=
V_MAX);
 MODULE_ALIAS("ip_set_hash:ip,port,net");
=20
diff --git a/net/netfilter/ipset/ip_set_hash_mac.c b/net/netfilter/ipset/=
ip_set_hash_mac.c
index 4fe5f243d0a3..3d1fc71dac38 100644
--- a/net/netfilter/ipset/ip_set_hash_mac.c
+++ b/net/netfilter/ipset/ip_set_hash_mac.c
@@ -1,4 +1,4 @@
-/* Copyright (C) 2014 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+/* Copyright (C) 2014 Jozsef Kadlecsik <kadlec@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -23,7 +23,7 @@
 #define IPSET_TYPE_REV_MAX	0
=20
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
+MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
 IP_SET_MODULE_DESC("hash:mac", IPSET_TYPE_REV_MIN, IPSET_TYPE_REV_MAX);
 MODULE_ALIAS("ip_set_hash:mac");
=20
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/=
ip_set_hash_net.c
index 5449e23af13a..470701fda231 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -1,4 +1,4 @@
-/* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+/* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -31,7 +31,7 @@
 #define IPSET_TYPE_REV_MAX	6 /* skbinfo mapping support added */
=20
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
+MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
 IP_SET_MODULE_DESC("hash:net", IPSET_TYPE_REV_MIN, IPSET_TYPE_REV_MAX);
 MODULE_ALIAS("ip_set_hash:net");
=20
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/i=
pset/ip_set_hash_netiface.c
index f5164c1efce2..1df8656ad84d 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -1,4 +1,4 @@
-/* Copyright (C) 2011-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+/* Copyright (C) 2011-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -32,7 +32,7 @@
 #define IPSET_TYPE_REV_MAX	6 /* skbinfo support added */
=20
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
+MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
 IP_SET_MODULE_DESC("hash:net,iface", IPSET_TYPE_REV_MIN, IPSET_TYPE_REV_=
MAX);
 MODULE_ALIAS("ip_set_hash:net,iface");
=20
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ips=
et/ip_set_hash_netnet.c
index 5a2b923bd81f..e0553be89600 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -1,4 +1,4 @@
-/* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+/* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
  * Copyright (C) 2013 Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.a=
rpa>
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ip=
set/ip_set_hash_netport.c
index 1a187be9ebc8..943d55d76fcf 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -1,4 +1,4 @@
-/* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+/* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -33,7 +33,7 @@
 #define IPSET_TYPE_REV_MAX	7 /* skbinfo support added */
=20
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
+MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
 IP_SET_MODULE_DESC("hash:net,port", IPSET_TYPE_REV_MIN, IPSET_TYPE_REV_M=
AX);
 MODULE_ALIAS("ip_set_hash:net,port");
=20
diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter=
/ipset/ip_set_hash_netportnet.c
index 613e18e720a4..afaff99e578c 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -1,4 +1,4 @@
-/* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+/* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/=
ip_set_list_set.c
index 4f894165cdcd..ed4360072f64 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -1,4 +1,4 @@
-/* Copyright (C) 2008-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+/* Copyright (C) 2008-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -22,7 +22,7 @@
 #define IPSET_TYPE_REV_MAX	3 /* skbinfo support added */
=20
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
+MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
 IP_SET_MODULE_DESC("list:set", IPSET_TYPE_REV_MIN, IPSET_TYPE_REV_MAX);
 MODULE_ALIAS("ip_set_list:set");
=20
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_co=
nntrack_h323_main.c
index 12de40390e97..1ff66e070cb2 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -7,7 +7,7 @@
  * This source code is licensed under General Public License version 2.
  *
  * Based on the 'brute force' H.323 connection tracking module by
- * Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ * Jozsef Kadlecsik <kadlec@netfilter.org>
  *
  * For more information, please see http://nath323.sourceforge.net/
  */
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_co=
nntrack_proto_tcp.c
index 7ba01d8ee165..60b68400435d 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1,6 +1,6 @@
 /* (C) 1999-2001 Paul `Rusty' Russell
  * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
- * (C) 2002-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ * (C) 2002-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
  * (C) 2006-2012 Patrick McHardy <kaber@trash.net>
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/net/netfilter/xt_iprange.c b/net/netfilter/xt_iprange.c
index b46626cddd93..4ab4155706d7 100644
--- a/net/netfilter/xt_iprange.c
+++ b/net/netfilter/xt_iprange.c
@@ -1,7 +1,7 @@
 /*
  *	xt_iprange - Netfilter module to match IP address ranges
  *
- *	(C) 2003 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ *	(C) 2003 Jozsef Kadlecsik <kadlec@netfilter.org>
  *	(C) CC Computer Consultants GmbH, 2008
  *
  *	This program is free software; you can redistribute it and/or modify
@@ -133,7 +133,7 @@ static void __exit iprange_mt_exit(void)
 module_init(iprange_mt_init);
 module_exit(iprange_mt_exit);
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
+MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
 MODULE_AUTHOR("Jan Engelhardt <jengelh@medozas.de>");
 MODULE_DESCRIPTION("Xtables: arbitrary IPv4 range matching");
 MODULE_ALIAS("ipt_iprange");
diff --git a/net/netfilter/xt_set.c b/net/netfilter/xt_set.c
index cf67bbe07dc2..f025c51ba375 100644
--- a/net/netfilter/xt_set.c
+++ b/net/netfilter/xt_set.c
@@ -1,7 +1,7 @@
 /* Copyright (C) 2000-2002 Joakim Axelsson <gozem@linux.nu>
  *                         Patrick Schaaf <bof@bof.de>
  *                         Martin Josefsson <gandalf@wlug.westbo.se>
- * Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ * Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -21,7 +21,7 @@
 #include <uapi/linux/netfilter/xt_set.h>
=20
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
+MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
 MODULE_DESCRIPTION("Xtables: IP set match and target module");
 MODULE_ALIAS("xt_SET");
 MODULE_ALIAS("ipt_set");
--=20
2.20.1

