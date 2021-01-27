Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3D97C433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Jan 2021 23:17:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80E9F61601
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Jan 2021 23:17:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235478AbhA0XQl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Jan 2021 18:16:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235323AbhA0XPB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Jan 2021 18:15:01 -0500
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B469BC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Jan 2021 15:14:20 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 275666740176;
        Thu, 28 Jan 2021 00:14:18 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Thu, 28 Jan 2021 00:14:15 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp0.kfki.hu (Postfix) with ESMTP id A15216740183;
        Thu, 28 Jan 2021 00:13:41 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 89FDD340D5D; Thu, 28 Jan 2021 00:13:41 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 85923340D5C;
        Thu, 28 Jan 2021 00:13:41 +0100 (CET)
Date:   Thu, 28 Jan 2021 00:13:41 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@blackhole.kfki.hu
To:     Reindl Harald <h.reindl@thelounge.net>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: https://bugzilla.kernel.org/show_bug.cgi?id=207773
In-Reply-To: <alpine.DEB.2.23.453.2101271435390.11052@blackhole.kfki.hu>
Message-ID: <alpine.DEB.2.23.453.2101280006200.11052@blackhole.kfki.hu>
References: <9ab32341-ca2f-22e2-0cb0-7ab55198ab80@thelounge.net> <alpine.DEB.2.23.453.2101271435390.11052@blackhole.kfki.hu>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Wed, 27 Jan 2021, Jozsef Kadlecsik wrote:

> On Wed, 27 Jan 2021, Reindl Harald wrote:
> 
> > for the sake of god may someone look at this?
> > https://bugzilla.kernel.org/show_bug.cgi?id=207773
> 
> Could you send your iptables rules and at least the set definitions 
> without the set contents? I need to reproduce the issue.

Checking your rules, you have got a recent match in which you use both the 
--reap and --update flags. However, as far as I see the code leaves the 
possibility open that the recent entry to be updated is reaped, which 
then leads to the crash.

The following patch should fix the issue - however, I could not test it:

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 606411869698..0446307516cd 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -152,7 +152,8 @@ static void recent_entry_remove(struct recent_table *t, struct recent_entry *e)
 /*
  * Drop entries with timestamps older then 'time'.
  */
-static void recent_entry_reap(struct recent_table *t, unsigned long time)
+static void recent_entry_reap(struct recent_table *t, unsigned long time,
+			      struct recent_entry *working, bool update)
 {
 	struct recent_entry *e;
 
@@ -161,6 +162,12 @@ static void recent_entry_reap(struct recent_table *t, unsigned long time)
 	 */
 	e = list_entry(t->lru_list.next, struct recent_entry, lru_list);
 
+	/*
+	 * Do not reap the entry which are going to be updated.
+	 */
+	if (e == working && update)
+		return;
+
 	/*
 	 * The last time stamp is the most recent.
 	 */
@@ -303,7 +310,8 @@ recent_mt(const struct sk_buff *skb, struct xt_action_param *par)
 
 		/* info->seconds must be non-zero */
 		if (info->check_set & XT_RECENT_REAP)
-			recent_entry_reap(t, time);
+			recent_entry_reap(t, time, e,
+				info->check_set & XT_RECENT_UPDATE && ret);
 	}
 
 	if (info->check_set & XT_RECENT_SET ||

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
