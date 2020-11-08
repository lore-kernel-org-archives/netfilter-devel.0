Return-Path: <SRS0=tTqd=EO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC5E9C388F9
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Nov 2020 21:27:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D139206DC
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Nov 2020 21:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgKHV1U (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 8 Nov 2020 16:27:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbgKHV1T (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 8 Nov 2020 16:27:19 -0500
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD203C0613CF
        for <netfilter-devel@vger.kernel.org>; Sun,  8 Nov 2020 13:27:19 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 7417F67400E5;
        Sun,  8 Nov 2020 22:27:15 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Sun,  8 Nov 2020 22:27:11 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp0.kfki.hu (Postfix) with ESMTP id 6D1AA67400DC;
        Sun,  8 Nov 2020 22:27:11 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 5F8C8340D5C; Sun,  8 Nov 2020 22:27:11 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 5AE8A340D5B;
        Sun,  8 Nov 2020 22:27:11 +0100 (CET)
Date:   Sun, 8 Nov 2020 22:27:11 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@blackhole.kfki.hu
To:     Oskar Berggren <oskar.berggren@gmail.com>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: ipset 7.7 modules fail to build on kernel 4.19.152
In-Reply-To: <CAHOuc7Ou_=rXSGCweVtN8QhMx8XaA9DPvBZBPHTe2SS05C0GsQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.23.453.2011082203260.26301@blackhole.kfki.hu>
References: <CAHOuc7N4gWZQmGaHdZ3oMt6S2PA-8JXTEabaybsH2bM9zHcBfA@mail.gmail.com> <alpine.DEB.2.23.453.2011020953550.16514@localhost> <CAHOuc7Ou_=rXSGCweVtN8QhMx8XaA9DPvBZBPHTe2SS05C0GsQ@mail.gmail.com>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Oskar,

On Sun, 8 Nov 2020, Oskar Berggren wrote:

> > > ip_set_core.c:90:40 macro list_for_each_entry_rcu passed 4 arguments 
> > > but takes just 3 ip_set_core.c:89:2 list_for_each_entry_rcu 
> > > undeclared
> It fixes the problems listed for jhash.h, but unfortunately not for 
> ip_set_core.c.
> 
> There don't seem to be any compat layer for list_for_each_entry_rcu in
> ipset sources.
> 
> The fourth parameter to list_for_each_entry_rcu seems to appear in
> 5.4-rc1 by this commit:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=28875945ba98d1b47a8a706812b6494d165bb0a0

The backward compatibility for list_for_each_entry_rcu() with three args 
only was missing indeed, the patch below should fix it:

diff --git a/configure.ac b/configure.ac
index 1058315..7388cdd 100644
--- a/configure.ac
+++ b/configure.ac
@@ -746,6 +746,16 @@ else
 	AC_SUBST(HAVE_SYNCHRONIZE_RCU_BH, undef)
 fi
 
+AC_MSG_CHECKING([kernel source for the fourth arg of list_for_each_entry_rcu() in rculist.h])
+if test -f $ksourcedir/include/linux/rculist.h && \
+   $GREP -q 'define list_for_each_entry_rcu(pos, head, member, cond' $ksourcedir/include/linux/rculist.h; then
+	AC_MSG_RESULT(yes)
+	AC_SUBST(HAVE_LIST_FOR_EACH_ENTRY_RCU_FOUR_ARGS, define)
+else
+	AC_MSG_RESULT(no)
+	AC_SUBST(HAVE_LIST_FOR_EACH_ENTRY_RCU_FOUR_ARGS, undef)
+fi
+
 AC_MSG_CHECKING([kernel source for struct net_generic])
 if test -f $ksourcedir/include/net/netns/generic.h && \
    $GREP -q 'struct net_generic' $ksourcedir/include/net/netns/generic.h; then
diff --git a/kernel/include/linux/netfilter/ipset/ip_set_compat.h.in b/kernel/include/linux/netfilter/ipset/ip_set_compat.h.in
index 87e0641..0bcff2c 100644
--- a/kernel/include/linux/netfilter/ipset/ip_set_compat.h.in
+++ b/kernel/include/linux/netfilter/ipset/ip_set_compat.h.in
@@ -56,6 +56,7 @@
 #@HAVE_LOCKDEP_NFNL_IS_HELD@ HAVE_LOCKDEP_NFNL_IS_HELD
 #@HAVE_COND_RESCHED_RCU@ HAVE_COND_RESCHED_RCU
 #@HAVE_SKB_IIF@ HAVE_SKB_IIF
+#@HAVE_LIST_FOR_EACH_ENTRY_RCU_FOUR_ARGS@ HAVE_LIST_FOR_EACH_ENTRY_RCU_FOUR_ARGS
 
 #ifdef HAVE_EXPORT_SYMBOL_GPL_IN_MODULE_H
 #include <linux/module.h>
@@ -469,6 +470,14 @@ static inline u16 nfnl_msg_type(u8 subsys, u8 msg_type)
 #define dev_get_by_index_rcu __dev_get_by_index
 #endif
 
+#ifdef HAVE_LIST_FOR_EACH_ENTRY_RCU_FOUR_ARGS
+#define list_for_each_entry_rcu_compat(pos, head, member, cond) \
+	list_for_each_entry_rcu(pos, head, member, cond)
+#else
+#define list_for_each_entry_rcu_compat(pos, head, member, cond) \
+	list_for_each_entry_rcu(pos, head, member)
+#endif
+
 /* Compiler attributes */
 #ifndef __has_attribute
 # define __has_attribute(x) __GCC4_has_attribute_##x
diff --git a/kernel/net/netfilter/ipset/ip_set_core.c b/kernel/net/netfilter/ipset/ip_set_core.c
index fb35e23..9de8289 100644
--- a/kernel/net/netfilter/ipset/ip_set_core.c
+++ b/kernel/net/netfilter/ipset/ip_set_core.c
@@ -86,8 +86,8 @@ find_set_type(const char *name, u8 family, u8 revision)
 {
 	struct ip_set_type *type;
 
-	list_for_each_entry_rcu(type, &ip_set_type_list, list,
-				lockdep_is_held(&ip_set_type_mutex))
+	list_for_each_entry_rcu_compat(type, &ip_set_type_list, list,
+				       lockdep_is_held(&ip_set_type_mutex))
 		if (STRNCMP(type->name, name) &&
 		    (type->family == family ||
 		     type->family == NFPROTO_UNSPEC) &&

I'm going to release ipset 7.8 in the next days - 7.7 was actually not 
announced yet :-).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
