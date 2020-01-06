Return-Path: <SRS0=Xvwf=23=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55F4CC33C9B
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 18:55:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BCC22070E
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 18:55:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YQTXH2uQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgAFSzF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 13:55:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44418 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726820AbgAFSzE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 13:55:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578336903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:in-reply-to:
         references:references:references;
        bh=wy0TndcXT1skUXZqvb8tuxri02CbQdJn6TND9F2D5Lc=;
        b=YQTXH2uQ/7lOzChJ12ok15JhxvXdq/QZLZVF/T/P5WmVbYPf1k8ulGIZSxzXi+a84wnKPZ
        WeMRkj69czUgAcLLG0tag0oph11pIYZzCoCJ+YBDGBjrNfkymiNqdqCUk/a9VUhN3UhDs1
        s50vI2Kt7VOdNWghTZJaFt3ApbpzFQ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-sFa9Qx8dPmuPesHmWNhDjA-1; Mon, 06 Jan 2020 13:55:02 -0500
X-MC-Unique: sFa9Qx8dPmuPesHmWNhDjA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DDF4DBA5;
        Mon,  6 Jan 2020 18:54:59 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-34.phx2.redhat.com [10.3.112.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 862AD5D9E5;
        Mon,  6 Jan 2020 18:54:56 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, fw@strlen.de, twoerner@redhat.com,
        eparis@parisplace.org, ebiederm@xmission.com, tgraf@infradead.org,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak25 v2 3/9] netfilter: normalize ebtables function declarations II
Date:   Mon,  6 Jan 2020 13:54:04 -0500
Message-Id: <7df83e229cff2518e73425cdc712505fb773a9c2.1577830902.git.rgb@redhat.com>
In-Reply-To: <cover.1577830902.git.rgb@redhat.com>
References: <cover.1577830902.git.rgb@redhat.com>
In-Reply-To: <cover.1577830902.git.rgb@redhat.com>
References: <cover.1577830902.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Align all function declaration parameters with open parenthesis.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 net/bridge/netfilter/ebtables.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index c9dff9e11ddb..b3c784ae33a0 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1248,9 +1248,9 @@ void ebt_unregister_table(struct net *net, struct ebt_table *table,
 
 /* userspace just supplied us with counters */
 static int do_update_counters(struct net *net, const char *name,
-				struct ebt_counter __user *counters,
-				unsigned int num_counters,
-				const void __user *user, unsigned int len)
+			      struct ebt_counter __user *counters,
+			      unsigned int num_counters,
+			      const void __user *user, unsigned int len)
 {
 	int i, ret;
 	struct ebt_counter *tmp;
@@ -1294,7 +1294,7 @@ static int do_update_counters(struct net *net, const char *name,
 }
 
 static int update_counters(struct net *net, const void __user *user,
-			    unsigned int len)
+			   unsigned int len)
 {
 	struct ebt_replace hlp;
 
@@ -1457,8 +1457,8 @@ static int copy_everything_to_user(struct ebt_table *t, void __user *user,
 	   ebt_entry_to_user, entries, tmp.entries);
 }
 
-static int do_ebt_set_ctl(struct sock *sk,
-	int cmd, void __user *user, unsigned int len)
+static int do_ebt_set_ctl(struct sock *sk, int cmd, void __user *user,
+			  unsigned int len)
 {
 	int ret;
 	struct net *net = sock_net(sk);
@@ -1660,7 +1660,7 @@ static int compat_watcher_to_user(struct ebt_entry_watcher *w,
 }
 
 static int compat_copy_entry_to_user(struct ebt_entry *e, void __user **dstptr,
-				unsigned int *size)
+				     unsigned int *size)
 {
 	struct ebt_entry_target *t;
 	struct ebt_entry __user *ce;
@@ -2149,7 +2149,7 @@ static int size_entry_mwt(struct ebt_entry *entry, const unsigned char *base,
  * Called before validation is performed.
  */
 static int compat_copy_entries(unsigned char *data, unsigned int size_user,
-				struct ebt_entries_buf_state *state)
+			       struct ebt_entries_buf_state *state)
 {
 	unsigned int size_remaining = size_user;
 	int ret;
@@ -2167,7 +2167,8 @@ static int compat_copy_entries(unsigned char *data, unsigned int size_user,
 
 
 static int compat_copy_ebt_replace_from_user(struct ebt_replace *repl,
-					    void __user *user, unsigned int len)
+					     void __user *user,
+					     unsigned int len)
 {
 	struct compat_ebt_replace tmp;
 	int i;
@@ -2321,8 +2322,8 @@ static int compat_update_counters(struct net *net, void __user *user,
 					hlp.num_counters, user, len);
 }
 
-static int compat_do_ebt_set_ctl(struct sock *sk,
-		int cmd, void __user *user, unsigned int len)
+static int compat_do_ebt_set_ctl(struct sock *sk, int cmd, void __user *user,
+				 unsigned int len)
 {
 	int ret;
 	struct net *net = sock_net(sk);
@@ -2343,8 +2344,8 @@ static int compat_do_ebt_set_ctl(struct sock *sk,
 	return ret;
 }
 
-static int compat_do_ebt_get_ctl(struct sock *sk, int cmd,
-		void __user *user, int *len)
+static int compat_do_ebt_get_ctl(struct sock *sk, int cmd, void __user *user,
+				 int *len)
 {
 	int ret;
 	struct compat_ebt_replace tmp;
-- 
1.8.3.1

