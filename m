Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2893C4321E
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Nov 2022 19:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbiK3TN4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Nov 2022 14:13:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiK3TNz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2022 14:13:55 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E24785803C
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2022 11:13:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4PAdxYaL4c9mIgfzDnntIUsSu4Xaoz277RfRCAcKvLM=; b=EHg0WYprmNi66mizTsz+hpaLZF
        hDjPkNMLukTNjgLdNGmVC8gB+HNI06Z9fvFCyOOnD5F2/WzsjgxWyHE5PZEgMtRdAAm4Hg8U5TQzl
        aExChkt24CmCyaf8Nsf5CyGZ5UZq2tMCHtyamNF/qPtId1cTlyyhB8fPE7y/PVyOM3YL9hViadTuR
        tLWOvCFGygARS1/uKTQQPjoTJtDE+pn1jxEgWiANBsxF2YKDMh9DPBp0Heeo6uVnHY/IetZ2T63uM
        OpAXs6L2HsuXe9Rw/72xa8xIA0GMVV7JFgstuENFQH2dPUczlWk5CnI5Q4NLVkcjVbZo9onZyDWKA
        sishQcsA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p0SWm-00019E-Ry
        for netfilter-devel@vger.kernel.org; Wed, 30 Nov 2022 20:13:53 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 5/9] iptables: Plug memleaks in print_firewall()
Date:   Wed, 30 Nov 2022 20:13:41 +0100
Message-Id: <20221130191345.14543-6-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221130191345.14543-1-phil@nwl.cc>
References: <20221130191345.14543-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When adding a rule in verbose mode, valgrind prints:

192 bytes in 1 blocks are definitely lost in loss record 1 of 2
   at 0x48417E5: malloc (vg_replace_malloc.c:381)
   by 0x486B158: xtables_malloc (xtables.c:446)
   by 0x486C1F6: xtables_find_match (xtables.c:826)
   by 0x10E684: print_match (iptables.c:115)
   by 0x10E684: print_firewall (iptables.c:169)
   by 0x10FC0C: print_firewall_line (iptables.c:196)
   by 0x10FC0C: append_entry (iptables.c:221)
   by 0x10FC0C: do_command4 (iptables.c:776)
   by 0x10E45B: iptables_main (iptables-standalone.c:59)
   by 0x49A2349: (below main) (in /lib64/libc.so.6)

200 bytes in 1 blocks are definitely lost in loss record 2 of 2
   at 0x48417E5: malloc (vg_replace_malloc.c:381)
   by 0x486B158: xtables_malloc (xtables.c:446)
   by 0x486BBD6: xtables_find_target (xtables.c:956)
   by 0x10E579: print_firewall (iptables.c:145)
   by 0x10FC0C: print_firewall_line (iptables.c:196)
   by 0x10FC0C: append_entry (iptables.c:221)
   by 0x10FC0C: do_command4 (iptables.c:776)
   by 0x10E45B: iptables_main (iptables-standalone.c:59)
   by 0x49A2349: (below main) (in /lib64/libc.so.6)

If the match/target was cloned, it needs to be freed. Basically a bug since
day 1.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ip6tables.c | 6 ++++++
 iptables/iptables.c  | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 062b2b152d554..1d2326570a71d 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -122,6 +122,9 @@ print_match(const struct xt_entry_match *m,
 			printf("%s%s ", match->name, unsupported_rev);
 		else
 			printf("%s ", match->name);
+
+		if (match->next == match)
+			free(match);
 	} else {
 		if (name[0])
 			printf("UNKNOWN match `%s' ", name);
@@ -179,6 +182,9 @@ print_firewall(const struct ip6t_entry *fw,
 			tg->print(&fw->ipv6, t, format & FMT_NUMERIC);
 		else if (target->print)
 			printf(" %s%s", target->name, unsupported_rev);
+
+		if (target->next == target)
+			free(target);
 	} else if (t->u.target_size != sizeof(*t))
 		printf("[%u bytes of unknown target data] ",
 		       (unsigned int)(t->u.target_size - sizeof(*t)));
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 0351b39fb7e3e..d246198f49d27 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -122,6 +122,9 @@ print_match(const struct xt_entry_match *m,
 			printf("%s%s ", match->name, unsupported_rev);
 		else
 			printf("%s ", match->name);
+
+		if (match->next == match)
+			free(match);
 	} else {
 		if (name[0])
 			printf("UNKNOWN match `%s' ", name);
@@ -178,6 +181,9 @@ print_firewall(const struct ipt_entry *fw,
 			tg->print(&fw->ip, t, format & FMT_NUMERIC);
 		else if (target->print)
 			printf(" %s%s", target->name, unsupported_rev);
+
+		if (target->next == target)
+			free(target);
 	} else if (t->u.target_size != sizeof(*t))
 		printf("[%u bytes of unknown target data] ",
 		       (unsigned int)(t->u.target_size - sizeof(*t)));
-- 
2.38.0

