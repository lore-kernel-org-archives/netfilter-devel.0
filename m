Return-Path: <SRS0=19L1=VX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7029C7618B
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Jul 2019 07:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C51D521873
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Jul 2019 07:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbfGZHYn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Jul 2019 03:24:43 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:7752 "EHLO smtp3-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbfGZHYn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Jul 2019 03:24:43 -0400
Received: from [IPv6:2a01:e34:ec0c:ae81:259a:5cf4:cd92:2659] (unknown [IPv6:2a01:e34:ec0c:ae80:259a:5cf4:cd92:2659])
        by smtp3-g21.free.fr (Postfix) with ESMTPS id CD00413F838
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Jul 2019 09:24:37 +0200 (CEST)
From:   Adel Belhouane <bugs.a.b@free.fr>
Subject: [PATCH iptables v2]: restore legacy behaviour of iptables-restore
 when rules start with -4/-6
To:     netfilter-devel@vger.kernel.org
Message-ID: <dcef34f2-7271-72e3-e0c3-60844305dd62@free.fr>
Date:   Fri, 26 Jul 2019 09:24:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


v2: moved examples to testcase files

Legacy implementation of iptables-restore / ip6tables-restore allowed
to insert a -4 or -6 option at start of a rule line to ignore it if not
matching the command's protocol. This allowed to mix specific ipv4 and
ipv6 rules in a single file, as still described in iptables 1.8.3's man
page in options -4 and -6. The implementation over nftables doesn't behave
correctly in this case: iptables-nft-restore accepts both -4 or -6 lines
and ip6tables-nft-restore throws an error on -4.

There's a distribution bug report mentioning this problem:
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=925343

Restore the legacy behaviour:
- let do_parse() return and thus not add a command in those restore
   special cases
- let do_commandx() ignore CMD_NONE instead of bailing out

I didn't attempt to fix all minor anomalies, but just to fix the
regression. For example in the line below, iptables should throw an error
instead of accepting -6 and then adding it as ipv4:

% iptables-nft -6 -A INPUT -p tcp -j ACCEPT

Signed-off-by: Adel Belhouane <bugs.a.b@free.fr>

diff --git a/iptables/tests/shell/testcases/ipt-restore/0005-ipt-6_0 b/iptables/tests/shell/testcases/ipt-restore/0005-ipt-6_0
new file mode 100755
index 000000000000..dd069771022c
--- /dev/null
+++ b/iptables/tests/shell/testcases/ipt-restore/0005-ipt-6_0
@@ -0,0 +1,26 @@
+#!/bin/bash
+
+# Make sure iptables-restore simply ignores
+# rules starting with -6
+
+set -e
+
+# show rules, drop uninteresting policy settings
+ipt_show() {
+	$XT_MULTI iptables -S | grep -v '^-P'
+}
+
+# issue reproducer for iptables-restore
+
+$XT_MULTI iptables-restore <<EOF
+*filter
+-A FORWARD -m comment --comment any -j ACCEPT
+-4 -A FORWARD -m comment --comment ipv4 -j ACCEPT
+-6 -A FORWARD -m comment --comment ipv6 -j ACCEPT
+COMMIT
+EOF
+
+EXPECT='-A FORWARD -m comment --comment any -j ACCEPT
+-A FORWARD -m comment --comment ipv4 -j ACCEPT'
+
+diff -u -Z <(echo -e "$EXPECT") <(ipt_show)
diff --git a/iptables/tests/shell/testcases/ipt-restore/0006-ip6t-4_0 b/iptables/tests/shell/testcases/ipt-restore/0006-ip6t-4_0
new file mode 100755
index 000000000000..a37253a9d78e
--- /dev/null
+++ b/iptables/tests/shell/testcases/ipt-restore/0006-ip6t-4_0
@@ -0,0 +1,26 @@
+#!/bin/bash
+
+# Make sure ip6tables-restore simply ignores
+# rules starting with -4
+
+set -e
+
+# show rules, drop uninteresting policy settings
+ipt_show() {
+	$XT_MULTI ip6tables -S | grep -v '^-P'
+}
+
+# issue reproducer for ip6tables-restore
+
+$XT_MULTI ip6tables-restore <<EOF
+*filter
+-A FORWARD -m comment --comment any -j ACCEPT
+-4 -A FORWARD -m comment --comment ipv4 -j ACCEPT
+-6 -A FORWARD -m comment --comment ipv6 -j ACCEPT
+COMMIT
+EOF
+
+EXPECT='-A FORWARD -m comment --comment any -j ACCEPT
+-A FORWARD -m comment --comment ipv6 -j ACCEPT'
+
+diff -u -Z <(echo -e "$EXPECT") <(ipt_show)
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 93d9dcba828b..0e0cb5f53d42 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -955,6 +955,9 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
  			break;
  
  		case '4':
+			if (p->restore && args->family == AF_INET6)
+				return;
+
  			if (args->family != AF_INET)
  				exit_tryhelp(2);
  
@@ -962,6 +965,9 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
  			break;
  
  		case '6':
+			if (p->restore && args->family == AF_INET)
+				return;
+
  			args->family = AF_INET6;
  			xtables_set_nfproto(AF_INET6);
  
@@ -1174,6 +1180,9 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
  	case CMD_SET_POLICY:
  		ret = nft_chain_set(h, p.table, p.chain, p.policy, NULL);
  		break;
+	case CMD_NONE:
+	/* do_parse ignored the line (eg: -4 with ip6tables-restore) */
+		break;
  	default:
  		/* We should never reach this... */
  		exit_tryhelp(2);
