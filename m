Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 280FFC7EE23
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 May 2023 16:11:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233382AbjE3QL5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 May 2023 12:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbjE3QLx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 May 2023 12:11:53 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D525E48
        for <netfilter-devel@vger.kernel.org>; Tue, 30 May 2023 09:11:37 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 2CDDC58740D43; Tue, 30 May 2023 18:11:09 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 2B57860DEA078;
        Tue, 30 May 2023 18:11:09 +0200 (CEST)
Date:   Tue, 30 May 2023 18:11:09 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Phil Sutter <phil@nwl.cc>
cc:     Netfilter Developer Mailing List 
        <netfilter-devel@vger.kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>
Subject: Re: [iptables PATCH] xshared: fix memory leak in should_load_proto
In-Reply-To: <20230529171846.10616-1-ansuelsmth@gmail.com>
Message-ID: <rpro25oo-2036-33rr-4258-o15rn7665o73@vanv.qr>
References: <20230529171846.10616-1-ansuelsmth@gmail.com>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Monday 2023-05-29 19:18, Christian Marangi wrote:

>With the help of a Coverity Scan, it was pointed out that it's present a
>memory leak in the corner case where find_proto is not NULL in the
>function should_load_proto. find_proto return a struct xtables_match
>pointer from xtables_find_match that is allocated but never freed.
>
>Correctly free the found proto in the corner case where find_proto
>succeed.
>
>@@ -113,11 +113,16 @@ find_proto(const char *pname, enum xtables_tryload tryload,
>  */
> static bool should_load_proto(struct iptables_command_state *cs)
> {
>+	struct xtables_match *proto;
>+
> 	if (cs->protocol == NULL)
> 		return false;
>-	if (find_proto(cs->protocol, XTF_DONT_LOAD,
>-	    cs->options & OPT_NUMERIC, NULL) == NULL)
>+	proto = find_proto(cs->protocol, XTF_DONT_LOAD,
>+			   cs->options & OPT_NUMERIC, NULL);
>+	if (proto == NULL)
> 		return true;
>+
>+	free(proto);
> 	return !cs->proto_used;
> }

After 13 years, the code I once wrote feels weird. In essence, find_proto is
called twice, but that should not be necessary because cs->proto_used already
tracks whether this was done.
[e.g. use `iptables -A INPUT -p tcp --dport 25 --unrecognized` to trigger]

Could someone cross check my alternative proposal I have below?


>From de6b99bbb29c148831ad072d1764012ee79a7883 Mon Sep 17 00:00:00 2001
From: Jan Engelhardt <jengelh@inai.de>
Date: Tue, 30 May 2023 14:59:30 +0200
Subject: [PATCH] iptables: dissolve should_load_proto

cs->proto_used already tells whether -p foo was turned into an
implicit -m foo once, so I do not think should_load_proto() has a
reason to exist.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 iptables/xshared.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index ac51fac5..55fe8961 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -111,22 +111,15 @@ find_proto(const char *pname, enum xtables_tryload tryload,
  *   [think of ip6tables-restore!]
  * - the protocol extension can be successively loaded
  */
-static bool should_load_proto(struct iptables_command_state *cs)
-{
-	if (cs->protocol == NULL)
-		return false;
-	if (find_proto(cs->protocol, XTF_DONT_LOAD,
-	    cs->options & OPT_NUMERIC, NULL) == NULL)
-		return true;
-	return !cs->proto_used;
-}
-
 static struct xtables_match *load_proto(struct iptables_command_state *cs)
 {
-	if (!should_load_proto(cs))
+	if (cs->protocol == NULL)
 		return NULL;
+	if (cs->proto_used)
+		return NULL;
+	cs->proto_used = true;
 	return find_proto(cs->protocol, XTF_TRY_LOAD,
-			  cs->options & OPT_NUMERIC, &cs->matches);
+	       cs->options & OPT_NUMERIC, &cs->matches);
 }
 
 static int command_default(struct iptables_command_state *cs,
@@ -157,13 +150,10 @@ static int command_default(struct iptables_command_state *cs,
 		return 0;
 	}
 
-	/* Try loading protocol */
 	m = load_proto(cs);
 	if (m != NULL) {
 		size_t size;
 
-		cs->proto_used = 1;
-
 		size = XT_ALIGN(sizeof(struct xt_entry_match)) + m->size;
 
 		m->m = xtables_calloc(1, size);
-- 
2.40.1

