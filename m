From: Max Laverse <max@laverse.net>
Subject: [PATCH] iptables: masquerade: add randomize-full support
Date: Sun, 3 Dec 2017 22:29:51 +0100
Message-ID: <57F31E92-B3B7-470A-A4CD-FCD3D95D9F84@laverse.net>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 9.mo179.mail-out.ovh.net ([46.105.76.148]:60955 "EHLO
        9.mo179.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752233AbdLCV35 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Dec 2017 16:29:57 -0500
Received: from player716.ha.ovh.net (b6.ovh.net [213.186.33.56])
        by mo179.mail-out.ovh.net (Postfix) with ESMTP id 57E5B81F23
        for <netfilter-devel@vger.kernel.org>; Sun,  3 Dec 2017 22:29:55 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

It seems that the email I sent on Friday never made it to the mailing list.
That’s why I'm sending this new one to you. I hope you don’t mind and 
could forward it, if it still can't reach the mailing list. If the old one is
blocked somewhere, it can be deleted.

Thanks

--

There is a known race condition when allocating a port for masquerading that
can lead to insertion in the conntrack table to fail under heavy load, with an
increment of the insert_failed counter. The kernel supports the 
NF_NAT_RANGE_PROTO_RANDOM_FULLY flag since [1] which uses prandom_u32() to
choose the first port to try when looking for a free tuple. Using this flag
significantly reduces the number of insertion collision. This patch provides
the user space part to make randomize-full support available in iptables on the
MASQUERADE target as it was done for SNAT [2].

 [1] https://patchwork.ozlabs.org/patch/304306/
 [2] https://patchwork.ozlabs.org/patch/304447/


7d1ec25 iptables: masquerade: add randomize-full support
diff --git a/extensions/libip6t_MASQUERADE.c b/extensions/libip6t_MASQUERADE.c
index 3b59e43..f92760f 100644
--- a/extensions/libip6t_MASQUERADE.c
+++ b/extensions/libip6t_MASQUERADE.c
@@ -18,6 +18,7 @@
 enum {
 	O_TO_PORTS = 0,
 	O_RANDOM,
+	O_RANDOM_FULLY,
 };
 
 static void MASQUERADE_help(void)
@@ -27,12 +28,15 @@ static void MASQUERADE_help(void)
 " --to-ports <port>[-<port>]\n"
 "				Port (range) to map to.\n"
 " --random\n"
-"				Randomize source port.\n");
+"				Randomize source port.\n"
+" --random-fully\n"
+"				Fully randomize source port.\n");
 }
 
 static const struct xt_option_entry MASQUERADE_opts[] = {
 	{.name = "to-ports", .id = O_TO_PORTS, .type = XTTYPE_STRING},
 	{.name = "random", .id = O_RANDOM, .type = XTTYPE_NONE},
+	{.name = "random-fully", .id = O_RANDOM_FULLY, .type = XTTYPE_NONE},
 	XTOPT_TABLEEND,
 };
 
@@ -96,6 +100,9 @@ static void MASQUERADE_parse(struct xt_option_call *cb)
 	case O_RANDOM:
 		r->flags |=  NF_NAT_RANGE_PROTO_RANDOM;
 		break;
+	case O_RANDOM_FULLY:
+		r->flags |=  NF_NAT_RANGE_PROTO_RANDOM_FULLY;
+		break;
 	}
 }
 
@@ -114,6 +121,9 @@ MASQUERADE_print(const void *ip, const struct xt_entry_target *target,
 
 	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM)
 		printf(" random");
+
+	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY)
+		printf(" random-fully");
 }
 
 static void
@@ -129,6 +139,9 @@ MASQUERADE_save(const void *ip, const struct xt_entry_target *target)
 
 	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM)
 		printf(" --random");
+
+	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY)
+		printf(" --random-fully");
 }
 
 static int MASQUERADE_xlate(struct xt_xlate *xl,
@@ -148,6 +161,10 @@ static int MASQUERADE_xlate(struct xt_xlate *xl,
 	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM)
 		xt_xlate_add(xl, "random ");
 
+	xt_xlate_add(xl, " ");
+	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY)
+		xt_xlate_add(xl, "random-fully ");
+
 	return 1;
 }
 
diff --git a/extensions/libip6t_MASQUERADE.t b/extensions/libip6t_MASQUERADE.t
index 4650204..e25d2a0 100644
--- a/extensions/libip6t_MASQUERADE.t
+++ b/extensions/libip6t_MASQUERADE.t
@@ -2,6 +2,7 @@
 *nat
 -j MASQUERADE;=;OK
 -j MASQUERADE --random;=;OK
+-j MASQUERADE --random-fully;=;OK
 -p tcp -j MASQUERADE --to-ports 1024;=;OK
 -p udp -j MASQUERADE --to-ports 1024-65535;=;OK
 -p udp -j MASQUERADE --to-ports 1024-65536;;FAIL
diff --git a/extensions/libipt_MASQUERADE.c b/extensions/libipt_MASQUERADE.c
index b7b5fc7..90bf606 100644
--- a/extensions/libipt_MASQUERADE.c
+++ b/extensions/libipt_MASQUERADE.c
@@ -11,6 +11,7 @@
 enum {
 	O_TO_PORTS = 0,
 	O_RANDOM,
+	O_RANDOM_FULLY,
 };
 
 static void MASQUERADE_help(void)
@@ -20,12 +21,15 @@ static void MASQUERADE_help(void)
 " --to-ports <port>[-<port>]\n"
 "				Port (range) to map to.\n"
 " --random\n"
-"				Randomize source port.\n");
+"				Randomize source port.\n"
+" --random-fully\n"
+"				Fully randomize source port.\n");
 }
 
 static const struct xt_option_entry MASQUERADE_opts[] = {
 	{.name = "to-ports", .id = O_TO_PORTS, .type = XTTYPE_STRING},
 	{.name = "random", .id = O_RANDOM, .type = XTTYPE_NONE},
+	{.name = "random-fully", .id = O_RANDOM_FULLY, .type = XTTYPE_NONE},
 	XTOPT_TABLEEND,
 };
 
@@ -97,6 +101,9 @@ static void MASQUERADE_parse(struct xt_option_call *cb)
 	case O_RANDOM:
 		mr->range[0].flags |=  NF_NAT_RANGE_PROTO_RANDOM;
 		break;
+	case O_RANDOM_FULLY:
+		mr->range[0].flags |=  NF_NAT_RANGE_PROTO_RANDOM_FULLY;
+		break;
 	}
 }
 
@@ -116,6 +123,9 @@ MASQUERADE_print(const void *ip, const struct xt_entry_target *target,
 
 	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM)
 		printf(" random");
+
+	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY)
+		printf(" random-fully");
 }
 
 static void
@@ -132,6 +142,9 @@ MASQUERADE_save(const void *ip, const struct xt_entry_target *target)
 
 	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM)
 		printf(" --random");
+
+	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY)
+		printf(" --random-fully");
 }
 
 static int MASQUERADE_xlate(struct xt_xlate *xl,
diff --git a/extensions/libipt_MASQUERADE.t b/extensions/libipt_MASQUERADE.t
index 4650204..e25d2a0 100644
--- a/extensions/libipt_MASQUERADE.t
+++ b/extensions/libipt_MASQUERADE.t
@@ -2,6 +2,7 @@
 *nat
 -j MASQUERADE;=;OK
 -j MASQUERADE --random;=;OK
+-j MASQUERADE --random-fully;=;OK
 -p tcp -j MASQUERADE --to-ports 1024;=;OK
 -p udp -j MASQUERADE --to-ports 1024-65535;=;OK
 -p udp -j MASQUERADE --to-ports 1024-65536;;FAIL
diff --git a/extensions/libxt_MASQUERADE.man b/extensions/libxt_MASQUERADE.man
index c9e3950..cc1e769 100644
--- a/extensions/libxt_MASQUERADE.man
+++ b/extensions/libxt_MASQUERADE.man
@@ -25,4 +25,10 @@ If option
 \fB\-\-random\fP
 is used then port mapping will be randomized (kernel >= 2.6.21).
 .TP
+\fB\-\-random-fully\fP
+Full randomize source port mapping
+If option
+\fB\-\-random-fully\fP
+is used then port mapping will be fully randomized (kernel >= 3.13).
+.TP
 IPv6 support available since Linux kernels >= 3.7.

