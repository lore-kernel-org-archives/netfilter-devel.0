From: Rafael Buchbinder <shmulik@nsof.io>
Subject: [PATCH 2/2] extensions: xt_bpf: get the pinned ebpf object when match is initialized
Date: Sun, 17 Sep 2017 14:07:51 +0300
Message-ID: <20170917110751.7923-3-rafi@rbk.ms>
References: <20170917110751.7923-1-rafi@rbk.ms>
Cc: Willem de Bruijn <willemb@google.com>, rbk@nsof.io,
        shmulik@nsof.io, Rafael Buchbinder <rafi@rbk.ms>
To: netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:44987 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750793AbdIQLI2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 17 Sep 2017 07:08:28 -0400
Received: by mail-wr0-f177.google.com with SMTP id v109so4341975wrc.1
        for <netfilter-devel@vger.kernel.org>; Sun, 17 Sep 2017 04:08:27 -0700 (PDT)
In-Reply-To: <20170917110751.7923-1-rafi@rbk.ms>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

xt_bpf_info_v1 structure requires an open file descriptor to create an
eBPF match. This file descriptor is checked on every replace. However,
as this file descriptor is valid only for the iptables invocation which
loads the eBPF for the first time, all subsequent iptables invocations
fail in bpf_mt_check (kernel) function.

This commit fixes handling of pinned ebpf objects.

The file descriptor saved in xt_bpf_info_v1 structure is being re-open
in tc_init_fixup which is invoked immediately after tc_init.

Signed-off-by: Rafael Buchbinder <rafi@rbk.ms>
Signed-off-by: Shmulik Ladkani <shmulik@nsof.io>
---
 extensions/libxt_bpf.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/extensions/libxt_bpf.c b/extensions/libxt_bpf.c
index 9510c190..16d6bc25 100644
--- a/extensions/libxt_bpf.c
+++ b/extensions/libxt_bpf.c
@@ -247,6 +247,14 @@ static void bpf_print_v1(const void *ip, const struct xt_entry_match *match,
 		printf("unknown");
 }
 
+static void bpf_tc_init_fixup_v1(struct xt_entry_match *match)
+{
+	struct xt_bpf_info_v1 *info = (void *) match->data;
+
+	if (info->mode == XT_BPF_MODE_FD_PINNED)
+		bpf_parse_obj_pinned(info, info->path);
+}
+
 static struct xtables_match bpf_matches[] = {
 	{
 		.family		= NFPROTO_UNSPEC,
@@ -272,6 +280,7 @@ static struct xtables_match bpf_matches[] = {
 		.help		= bpf_help_v1,
 		.print		= bpf_print_v1,
 		.save		= bpf_save_v1,
+		.tc_init_fixup	= bpf_tc_init_fixup_v1,
 		.x6_parse	= bpf_parse_v1,
 		.x6_fcheck	= bpf_fcheck_v1,
 		.x6_options	= bpf_opts_v1,
-- 
2.14.1

