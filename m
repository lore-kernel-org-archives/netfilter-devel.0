Return-Path: <SRS0=/MqZ=RG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C229C4360F
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Mar 2019 14:32:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4464020836
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Mar 2019 14:32:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=online.net header.i=@online.net header.b="Sr7WMwqs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfCCOcp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 3 Mar 2019 09:32:45 -0500
Received: from bounce-1.online.net ([62.210.16.43]:37542 "EHLO
        bounce-1.online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726241AbfCCOco (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Mar 2019 09:32:44 -0500
Received: from [62.210.16.40] (helo=smtpauth-dc2-1.online.net)
        by bounce-dc2-1.online.net with esmtpa (Exim 4.82)
        (envelope-from <alban.vidal@zordhak.fr>)
        id 1h0RDL-0006ub-QW
        for netfilter-devel@vger.kernel.org; Sun, 03 Mar 2019 14:31:35 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=online.net; s=folays2;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:References:Cc:To:Subject:From; bh=eXv4YJvkkgLLD/YU2qABM7u5pwceW0efe2XtdrtVSxE=;
        b=Sr7WMwqsq5oluPYPTsCPXwC1Sw2a9V9y5WQC6I7JQiaq9mWbuv+XABf1uNGUIx2n/PRGIV9JUIqYPvclzf8rroBQ1jTIoIQ6QjOHYwNacC3A2jaXitS26K03koPTp40VS+oyPAICeaT6UqTfVB/N0P9zDAnlDZlplKMV9UcVn9U=;
Received: from [90.22.161.100] (helo=[192.168.0.157])
        by smtpauth-dc2-1.online.net with esmtpsa (TLS1.2:RSA_AES_128_CBC_SHA1:128)
        (Exim 4.82)
        (envelope-from <alban.vidal@zordhak.fr>)
        id 1h0RDK-0007mn-CP; Sun, 03 Mar 2019 14:31:34 +0100
From:   Alban Vidal <alban.vidal@zordhak.fr>
Subject: [PATCH v4 2/2] xtables-save: implement showing zeroed chain counters
 when saving rulesets
To:     netfilter-devel@vger.kernel.org
Cc:     ao2@ao2.it, Alban VIDAL <alban.vidal@zordhak.fr>
References: <20190217235554.4647-1-alban.vidal@zordhak.fr>
Openpgp: id=AE48C0F59B1998A06292A69996BD4FF64E709FDE
Autocrypt: addr=alban.vidal@zordhak.fr; prefer-encrypt=mutual; keydata=
 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 3XJT
Message-ID: <7c14e91c-4b8b-a7f6-9c4a-9d668d508790@zordhak.fr>
Date:   Sun, 3 Mar 2019 14:31:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190217235554.4647-1-alban.vidal@zordhak.fr>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: fr-FR
X-auth-smtp-user: alban.vidal@zordhak.fr
X-online-auth-user: FLEX_SXc2cTZPbXFzV29rR01TQQ==Y4Z4l5EEb7XuIQFQSvYA+ECfzKyY3A==
X-online-auth-smtp: FLEX_S0dHTThFNndDVUcyb1VRSQ==baCPVkuM8TvY3gSPLvrK/2+1vqhmCAXxOtHce+Qx+A==
X-online-bounce-smtp: FLEX_U3lvVVFDMjhxVThzS0NJMA==LvXts+VP+BR0v+GcnMZ53fRhO0fjBmqPTkNJ0O/JEg==
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Antonio Ospite <ao2@ao2.it>

Add a new FMT_ZEROED_CHAIN_COUNTS and use it in the save_chain()
callbacks to implement the '-Z' option for xtables-save as well.

Having zeroed chain counters is particularly useful when using a version
control system (like git) to track the saved iptables rules, to minimize
the delta between different ruleset versions.

Signed-off-by: Antonio Ospite <ao2@ao2.it>
---
include/xtables.h | 1 +
iptables/nft-arp.c | 3 ++-
iptables/nft-bridge.c | 3 ++-
iptables/nft-shared.c | 8 +++++++-
iptables/nft-shared.h | 6 ++++--
iptables/nft.c | 4 ++--
iptables/nft.h | 2 +-
iptables/xtables-save.c | 9 +++++----
8 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/include/xtables.h b/include/xtables.h
index 4aa084a..0aaca74 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -550,6 +550,7 @@ extern void xtables_save_string(const char *value);
#define FMT_LINENUMBERS 0x0100
#define FMT_EBT_SAVE 0x0200
#define FMT_C_COUNTS 0x0400
+#define FMT_ZEROED_CHAIN_COUNTS 0x0800
#define FMT_PRINT_RULE (FMT_NOCOUNTS | FMT_OPTIONS | FMT_VIA \
| FMT_NUMERIC | FMT_NOTABLE)
diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 637da42..4ec2287 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -679,7 +679,8 @@ out:
return ret;
}
-static void nft_arp_save_chain(const struct nftnl_chain *c, const char
*policy)
+static void nft_arp_save_chain(const struct nftnl_chain *c, const char
*policy,
+ unsigned int format)
{
const char *chain = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index ddfbee1..10b1dda 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -502,7 +502,8 @@ static void nft_bridge_print_rule(struct nftnl_rule
*r, unsigned int num,
}
static void nft_bridge_save_chain(const struct nftnl_chain *c,
- const char *policy)
+ const char *policy,
+ unsigned int format)
{
const char *chain = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 1c09277..0b7d380 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -832,12 +832,18 @@ void save_counters(const void *data)
(unsigned long long)cs->counters.bcnt);
}
-void nft_ipv46_save_chain(const struct nftnl_chain *c, const char *policy)
+void nft_ipv46_save_chain(const struct nftnl_chain *c, const char *policy,
+ unsigned int format)
{
const char *chain = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
uint64_t pkts = nftnl_chain_get_u64(c, NFTNL_CHAIN_PACKETS);
uint64_t bytes = nftnl_chain_get_u64(c, NFTNL_CHAIN_BYTES);
+ if (format & FMT_ZEROED_CHAIN_COUNTS) {
+ pkts = 0;
+ bytes = 0;
+ }
+
printf(":%s %s [%"PRIu64":%"PRIu64"]\n",
chain, policy ?: "-", pkts, bytes);
}
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 019c1f2..0603c6b 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -93,7 +93,8 @@ struct nft_family_ops {
unsigned int format);
void (*save_rule)(const void *data, unsigned int format);
void (*save_counters)(const void *data);
- void (*save_chain)(const struct nftnl_chain *c, const char *policy);
+ void (*save_chain)(const struct nftnl_chain *c, const char *policy,
+ unsigned int format);
void (*proto_parse)(struct iptables_command_state *cs,
struct xtables_args *args);
void (*post_parse)(int command, struct iptables_command_state *cs,
@@ -156,7 +157,8 @@ void save_rule_details(const struct
iptables_command_state *cs,
const char *outiface,
unsigned const char *outiface_mask);
void save_counters(const void *data);
-void nft_ipv46_save_chain(const struct nftnl_chain *c, const char *policy);
+void nft_ipv46_save_chain(const struct nftnl_chain *c, const char *policy,
+ unsigned int format);
void save_matches_and_target(const struct iptables_command_state *cs,
bool goto_flag, const void *fw,
unsigned int format);
diff --git a/iptables/nft.c b/iptables/nft.c
index a297d98..e1fd802 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1507,7 +1507,7 @@ static const char *policy_name[NF_ACCEPT+1] = {
[NF_ACCEPT] = "ACCEPT",
};
-int nft_chain_save(struct nft_handle *h, struct nftnl_chain_list *list)
+int nft_chain_save(struct nft_handle *h, struct nftnl_chain_list *list,
unsigned int format)
{
struct nftnl_chain_list_iter *iter;
struct nft_family_ops *ops;
@@ -1541,7 +1541,7 @@ int nft_chain_save(struct nft_handle *h, struct
nftnl_chain_list *list)
}
if (ops->save_chain)
- ops->save_chain(c, policy);
+ ops->save_chain(c, policy, format);
c = nftnl_chain_list_iter_next(iter);
}
diff --git a/iptables/nft.h b/iptables/nft.h
index 56dc207..25f6dcf 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -84,7 +84,7 @@ struct nftnl_chain;
int nft_chain_set(struct nft_handle *h, const char *table, const char
*chain, const char *policy, const struct xt_counters *counters);
struct nftnl_chain_list *nft_chain_list_get(struct nft_handle *h,
const char *table);
-int nft_chain_save(struct nft_handle *h, struct nftnl_chain_list *list);
+int nft_chain_save(struct nft_handle *h, struct nftnl_chain_list *list,
unsigned int format);
int nft_chain_user_add(struct nft_handle *h, const char *chain, const
char *table);
int nft_chain_user_del(struct nft_handle *h, const char *chain, const
char *table, bool verbose);
int nft_chain_user_flush(struct nft_handle *h, struct nftnl_chain_list
*list,
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index cee9137..59ad89b 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -30,6 +30,7 @@
#define prog_vers xtables_globals.program_version
static bool show_counters = false;
+static bool display_zero_counters = false;
static const struct option options[] = {
{.name = "counters", .has_arg = false, .val = 'c'},
@@ -86,7 +87,7 @@ __do_output(struct nft_handle *h, const char
*tablename, bool counters)
/* Dump out chain names first,
* thereby preventing dependency conflicts */
- nft_chain_save(h, chain_list);
+ nft_chain_save(h, chain_list, display_zero_counters ?
FMT_ZEROED_CHAIN_COUNTS : 0);
nft_rule_save(h, tablename, counters ? 0 : FMT_NOCOUNTS);
now = time(NULL);
@@ -151,7 +152,7 @@ xtables_save_main(int family, const char *progname,
int argc, char *argv[])
show_counters = true;
break;
case 'Z':
- fprintf(stderr, "-Z/--zero option is not implemented yet\n");
+ display_zero_counters = true;
break;
case 't':
/* Select specific table. */
@@ -278,7 +279,7 @@ static int __ebt_save(struct nft_handle *h, const
char *tablename, bool counters
/* Dump out chain names first,
* thereby preventing dependency conflicts */
- nft_chain_save(h, chain_list);
+ nft_chain_save(h, chain_list, display_zero_counters ?
FMT_ZEROED_CHAIN_COUNTS : 0);
nft_rule_save(h, tablename, format);
printf("\n");
return 0;
@@ -405,7 +406,7 @@ int xtables_arp_save_main(int argc, char **argv)
}
printf("*filter\n");
- nft_chain_save(&h, nft_chain_list_get(&h, "filter"));
+ nft_chain_save(&h, nft_chain_list_get(&h, "filter"),
display_zero_counters ? FMT_ZEROED_CHAIN_COUNTS : 0);
nft_rule_save(&h, "filter", show_counters ? 0 : FMT_NOCOUNTS);
printf("\n");
nft_fini(&h);

-- 
2.20.1

