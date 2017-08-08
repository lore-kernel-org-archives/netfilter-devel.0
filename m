From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH iptables 2/2] xtables-compat: fix memory leak when listing
Date: Tue,  8 Aug 2017 20:53:46 +0200
Message-ID: <20170808185346.3183-2-pablombg@gmail.com>
References: <20170808185346.3183-1-pablombg@gmail.com>
Cc: pablo@netfilter.org, "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34205 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752092AbdHHSyF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Aug 2017 14:54:05 -0400
Received: by mail-wm0-f66.google.com with SMTP id x64so4383080wmg.1
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Aug 2017 11:54:04 -0700 (PDT)
In-Reply-To: <20170808185346.3183-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following memory leaks are detected by valgrind when
ip[6]tables-compat is used for listing operations:

==1604== 1,064 (120 direct, 944 indirect) bytes in 5 blocks are definitely lost in loss record 21 of 27
==1604==    at 0x4C2BBEF: malloc (vg_replace_malloc.c:299)
==1604==    by 0x56ABB78: xtables_malloc (in /usr/local/lib/libxtables.so.12.0.0)
==1604==    by 0x56AC7D3: xtables_find_match (in /usr/local/lib/libxtables.so.12.0.0)
==1604==    by 0x11F502: nft_parse_match (in /usr/local/sbin/xtables-compat-multi)
==1604==    by 0x11FC7B: nft_rule_to_iptables_command_state (in /usr/local/sbin/xtables-compat-multi)
==1604==    by 0x1218C0: nft_ipv4_print_firewall (nft-ipv4.c:301)
==1604==    by 0x11CBEB: __nft_rule_list (nft.c:2042)
==1604==    by 0x11CEA4: nft_rule_list (nft.c:2126)
==1604==    by 0x116A7F: list_entries (xtables.c:592)
==1604==    by 0x118B26: do_commandx (xtables.c:1233)
==1604==    by 0x115AE8: xtables_main (in /usr/local/sbin/xtables-compat-multi)
==1604==    by 0x115BCB: xtables_ip4_main (in /usr/local/sbin/xtables-compat-multi)
==1604==
==1604== 135,168 bytes in 1 blocks are definitely lost in loss record 25 of 27
==1604==    at 0x4C2BBEF: malloc (vg_replace_malloc.c:299)
==1604==    by 0x119072: mnl_nftnl_batch_alloc (nft.c:102)
==1604==    by 0x11A311: nft_init (nft.c:777)
==1604==    by 0x115A71: xtables_main (in /usr/local/sbin/xtables-compat-multi)
==1604==    by 0x115BCB: xtables_ip4_main (in /usr/local/sbin/xtables-compat-multi)
==1604==    by 0x12F911: subcmd_main (in /usr/local/sbin/xtables-compat-multi)
==1604==    by 0x10F636: main (in /usr/local/sbin/xtables-compat-multi)
==1604==
==1604== 135,168 bytes in 1 blocks are definitely lost in loss record 26 of 27
==1604==    at 0x4C2BBEF: malloc (vg_replace_malloc.c:299)
==1604==    by 0x119072: mnl_nftnl_batch_alloc (nft.c:102)
==1604==    by 0x11910C: mnl_nftnl_batch_page_add (nft.c:122)
==1604==    by 0x11D8FE: nft_action (nft.c:2402)
==1604==    by 0x11D957: nft_commit (nft.c:2413)
==1604==    by 0x11CCB7: nft_rule_list (nft.c:2076)
==1604==    by 0x116A7F: list_entries (xtables.c:592)
==1604==    by 0x118B26: do_commandx (xtables.c:1233)
==1604==    by 0x115AE8: xtables_main (in /usr/local/sbin/xtables-compat-multi)
==1604==    by 0x115BCB: xtables_ip4_main (in /usr/local/sbin/xtables-compat-multi)
==1604==    by 0x12F911: subcmd_main (in /usr/local/sbin/xtables-compat-multi)
==1604==    by 0x10F636: main (in /usr/local/sbin/xtables-compat-multi)

Fix these memory leaks.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 iptables/nft-ipv4.c | 2 ++
 iptables/nft-ipv6.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index cf311513..00dd3e93 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -320,6 +320,8 @@ static void nft_ipv4_print_firewall(struct nftnl_rule *r, unsigned int num,
 
 	if (!(format & FMT_NONEWLINE))
 		fputc('\n', stdout);
+
+	xtables_rule_matches_free(&cs.matches);
 }
 
 static void save_ipv4_addr(char letter, const struct in_addr *addr,
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 53526369..9867d1ee 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -251,6 +251,8 @@ static void nft_ipv6_print_firewall(struct nftnl_rule *r, unsigned int num,
 
 	if (!(format & FMT_NONEWLINE))
 		fputc('\n', stdout);
+
+	xtables_rule_matches_free(&cs.matches);
 }
 
 static void save_ipv6_addr(char letter, const struct in6_addr *addr,
-- 
2.13.2

