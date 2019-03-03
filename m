Return-Path: <SRS0=/MqZ=RG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 866C8C43381
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Mar 2019 14:03:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 453A620823
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Mar 2019 14:03:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=online.net header.i=@online.net header.b="i9hWakTw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbfCCODt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 3 Mar 2019 09:03:49 -0500
Received: from bounce-1.online.net ([62.210.16.43]:57954 "EHLO
        bounce-1.online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbfCCODs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Mar 2019 09:03:48 -0500
Received: from [62.210.16.40] (helo=smtpauth-dc2-1.online.net)
        by bounce-dc2-1.online.net with esmtpa (Exim 4.82)
        (envelope-from <alban.vidal@zordhak.fr>)
        id 1h0RDH-0006uX-63
        for netfilter-devel@vger.kernel.org; Sun, 03 Mar 2019 14:31:31 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=online.net; s=folays2;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:References:Cc:To:Subject:From; bh=v64qv8kF/HFPQvDKdayB/JKasNhFDOj1MYueeYLq4ao=;
        b=i9hWakTwmFDBZKseL+DaUup0xe33KaA7Wqvl8BpovLM9zGiMjjm1fIMe89dRUyPlJDlMwAzc6/m+cAFcZ242GzmFkm2Hs7b38LHF8UYPvPMRY8c+0O9SNQPFJWMMWcZOWboIQDcSuyeaHC+dRdKfpZPNTnPQpCFiI+lcZhD1dvY=;
Received: from [90.22.161.100] (helo=[192.168.0.157])
        by smtpauth-dc2-1.online.net with esmtpsa (TLS1.2:RSA_AES_128_CBC_SHA1:128)
        (Exim 4.82)
        (envelope-from <alban.vidal@zordhak.fr>)
        id 1h0RDG-0007lg-BH; Sun, 03 Mar 2019 14:31:30 +0100
From:   Alban Vidal <alban.vidal@zordhak.fr>
Subject: [PATCH v4 1/2] iptables-save: add option to show zeroed counters when
 saving rulesets
To:     netfilter-devel@vger.kernel.org
Cc:     ao2@ao2.it, Alban VIDAL <alban.vidal@zordhak.fr>
References: <20190217235554.4647-1-alban.vidal@zordhak.fr>
Openpgp: id=AE48C0F59B1998A06292A69996BD4FF64E709FDE
Autocrypt: addr=alban.vidal@zordhak.fr; prefer-encrypt=mutual; keydata=
 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 3XJT
Message-ID: <9179b69f-3253-97a8-2dd1-f88c745068d3@zordhak.fr>
Date:   Sun, 3 Mar 2019 14:31:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190217235554.4647-1-alban.vidal@zordhak.fr>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: fr-FR
X-auth-smtp-user: alban.vidal@zordhak.fr
X-online-auth-user: FLEX_bVN5SUc2b3VNNktrVWtDbQ==wrSfy7pF0ANK9pVsl1G+XhYfzw9Pfw==
X-online-auth-smtp: FLEX_bUVLU21NOEFDUXNtd1E2aw==aEHtJwly/jjHMqBEZkRle8lSpwgpZjfaaoRf7Ht5kA==
X-online-bounce-smtp: FLEX_T3VXb3drRVdtb0VzOGtVQw==5nJN+E5REci+LOXN0yEDO7KMqgv358dEJJLLkIQQGw==
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Alban VIDAL <alban.vidal@zordhak.fr>

Add a new '-Z' (or '--zero') option to iptables-save to show zeroed
counters for chains when saving rulesets.

This option is particularly useful when using a version control system
(like git) to track the saved iptables rules, to minimize the delta
between different ruleset versions.

The option is also added to xtables-save to keep compatibility on the
command line, however the functionality is not implemented yet.

Reviewed-by: Antonio Ospite <ao2@ao2.it>
Signed-off-by: Alban VIDAL <alban.vidal@zordhak.fr>
---
iptables/iptables-save.8.in | 7 +++++--
iptables/iptables-save.c | 12 ++++++++++--
iptables/xtables-save.c | 7 +++++--
3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/iptables/iptables-save.8.in b/iptables/iptables-save.8.in
index 51e11f3..76ea4ee 100644
--- a/iptables/iptables-save.8.in
+++ b/iptables/iptables-save.8.in
@@ -24,10 +24,10 @@ iptables-save \(em dump iptables rules
ip6tables-save \(em dump iptables rules
.SH SYNOPSIS
\fBiptables\-save\fP [\fB\-M\fP \fImodprobe\fP] [\fB\-c\fP]
-[\fB\-t\fP \fItable\fP] [\fB\-f\fP \fIfilename\fP]
+[\fB\-Z\fP] [\fB\-t\fP \fItable\fP] [\fB\-f\fP \fIfilename\fP]
.P
\fBip6tables\-save\fP [\fB\-M\fP \fImodprobe\fP] [\fB\-c\fP]
-[\fB\-t\fP \fItable\fP] [\fB\-f\fP \fIfilename\fP]
+[\fB\-Z\fP] [\fB\-t\fP \fItable\fP] [\fB\-f\fP \fIfilename\fP]
.SH DESCRIPTION
.PP
.B iptables-save
@@ -47,6 +47,9 @@ will log to STDOUT.
\fB\-c\fR, \fB\-\-counters\fR
include the current values of all packet and byte counters in the output
.TP
+\fB\-Z\fR, \fB\-\-zero\fR
+Display zero packet and byte chain counters when saving the ruleset.
+.TP
\fB\-t\fR, \fB\-\-table\fR \fItablename\fP
restrict output to only one table. If not specified, output includes all
available tables.
diff --git a/iptables/iptables-save.c b/iptables/iptables-save.c
index 826cb1e..d20bf85 100644
--- a/iptables/iptables-save.c
+++ b/iptables/iptables-save.c
@@ -23,10 +23,12 @@
#include "xshared.h"
static int show_counters;
+static bool display_zero_counters;
static const struct option options[] = {
{.name = "counters", .has_arg = false, .val = 'c'},
{.name = "dump", .has_arg = false, .val = 'd'},
+ {.name = "zero", .has_arg = false, .val = 'Z'},
{.name = "table", .has_arg = true, .val = 't'},
{.name = "modprobe", .has_arg = true, .val = 'M'},
{.name = "file", .has_arg = true, .val = 'f'},
@@ -104,6 +106,10 @@ static int do_output(struct iptables_save_cb *cb,
const char *tablename)
struct xt_counters count;
printf("%s ", cb->ops->get_policy(chain, &count, h));
+ if (display_zero_counters) {
+ count.pcnt = 0;
+ count.bcnt = 0;
+ }
printf("[%llu:%llu]\n",
(unsigned long long)count.pcnt,
(unsigned long long)count.bcnt);
@@ -137,7 +143,7 @@ do_iptables_save(struct iptables_save_cb *cb, int
argc, char *argv[])
FILE *file = NULL;
int ret, c;
- while ((c = getopt_long(argc, argv, "bcdt:M:f:V", options, NULL)) != -1) {
+ while ((c = getopt_long(argc, argv, "bcdZt:M:f:V", options, NULL)) !=
-1) {
switch (c) {
case 'b':
fprintf(stderr, "-b/--binary option is not implemented\n");
@@ -145,7 +151,9 @@ do_iptables_save(struct iptables_save_cb *cb, int
argc, char *argv[])
case 'c':
show_counters = 1;
break;
-
+ case 'Z':
+ display_zero_counters = true;
+ break;
case 't':
/* Select specific table. */
tablename = optarg;
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index 87ebb91..cee9137 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -35,6 +35,7 @@ static const struct option options[] = {
{.name = "counters", .has_arg = false, .val = 'c'},
{.name = "version", .has_arg = false, .val = 'V'},
{.name = "dump", .has_arg = false, .val = 'd'},
+ {.name = "zero", .has_arg = false, .val = 'Z'},
{.name = "table", .has_arg = true, .val = 't'},
{.name = "modprobe", .has_arg = true, .val = 'M'},
{.name = "file", .has_arg = true, .val = 'f'},
@@ -141,7 +142,7 @@ xtables_save_main(int family, const char *progname,
int argc, char *argv[])
exit(1);
}
- while ((c = getopt_long(argc, argv, "bcdt:M:f:46V", options, NULL)) !=
-1) {
+ while ((c = getopt_long(argc, argv, "bcdZt:M:f:46V", options, NULL))
!= -1) {
switch (c) {
case 'b':
fprintf(stderr, "-b/--binary option is not implemented\n");
@@ -149,7 +150,9 @@ xtables_save_main(int family, const char *progname,
int argc, char *argv[])
case 'c':
show_counters = true;
break;
-
+ case 'Z':
+ fprintf(stderr, "-Z/--zero option is not implemented yet\n");
+ break;
case 't':
/* Select specific table. */
tablename = optarg;

-- 
2.20.1

