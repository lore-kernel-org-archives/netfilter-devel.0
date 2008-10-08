From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [iptables PATCH 2/2] [TPROXY] Add userspace component of the
 socket match
Date: Wed, 8 Oct 2008 08:12:19 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810080803330.27120@fbirervta.pbzchgretzou.qr>
References: <20081008071541.9224.66180.stgit@nessa.odu> <20081008071541.9224.68351.stgit@nessa.odu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37523 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbYJHMMU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 08:12:20 -0400
In-Reply-To: <20081008071541.9224.68351.stgit@nessa.odu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-10-08 03:15, KOVACS Krisztian wrote:
>@@ -0,0 +1,39 @@
>+/*
>+ * Shared library add-on to iptables to add early socket matching support.
>+ *
>+ * Copyright (C) 2007 BalaBit IT Ltd.
>+ */
>+#include <stdio.h>
>+#include <getopt.h>
>+#include <iptables.h>
>+
>+static void socket_help(void)
>+{
>+	printf("socket v%s has no options\n\n", XTABLES_VERSION);
>+}
>+
>+static int socket_parse(int c, char **argv, int invert, unsigned int *flags,
>+			const void *entry, struct xt_entry_match **match)
>+{
>+	return 0;
>+}
>+
>+static void socket_check(unsigned int flags)
>+{
>+}
>+
>+static struct xtables_match socket_reg = {
>+	.name	       = "socket",
>+	.version       = XTABLES_VERSION,
>+	.family	       = AF_INET,
>+	.size	       = XT_ALIGN(0),
>+	.userspacesize = XT_ALIGN(0),
>+	.parse	       = socket_parse,
>+	.final_check   = socket_check,
>+	.help	       = socket_help,
>+};
>+
>+void _init(void)
>+{
>+	xtables_register_match(&socket_reg);
>+}

I doubt this trivial code is anything you could copyright.

>--- /dev/null
>+++ b/extensions/libxt_socket.man
>@@ -0,0 +1,2 @@
>+This matches if an open socket can be found by doing a socket lookup on the
>+packet.

I think, while at it, this match should be extended by options to find 
only listening sockets. People sometimes want something like this 
because they cannot possibly know the used port numbers in advance and 
do not want to use port ranges that could possible be too broad (--dport 
x:y) that would accidentally match other connections.
