From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Building ipset-6.24 on CentOS7 fails
Date: Wed, 17 Dec 2014 08:58:27 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1412170857070.12901@blackhole.kfki.hu>
References: <CADuigkUASKDzmaHZmiLWLXadS_u13rnXV8+ww+UygYVaiD=RYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Ricardo Klein <klein.rfk@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:44695 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbaLQH5Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Dec 2014 02:57:24 -0500
In-Reply-To: <CADuigkUASKDzmaHZmiLWLXadS_u13rnXV8+ww+UygYVaiD=RYw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 16 Dec 2014, Ricardo Klein wrote:

> Trying to build ipset 6.24 on CentOS7 fails... Here is the error:
> http://pastebin.com/LDMvs0rv

Please try the next patch: is it sufficient on CentOS7?

diff --git a/configure.ac b/configure.ac
index 4212274..74bc7de 100644
--- a/configure.ac
+++ b/configure.ac
@@ -376,6 +376,16 @@ else
 	AC_SUBST(HAVE_TCF_EMATCH_STRUCT_NET, undef)
 fi
 
+AC_MSG_CHECKING([kernel source for list_last_entry])
+if test -f $ksourcedir/include/linux/list.h && \
+   $GREP -q 'list_last_entry' $ksourcedir/include/linux/list.h; then
+	AC_MSG_RESULT(yes)
+	AC_SUBST(HAVE_LIST_LAST_ENTRY, define)
+else
+	AC_MSG_RESULT(no)
+	AC_SUBST(HAVE_LIST_LAST_ENTRY, undef)
+fi
+
 AC_MSG_CHECKING([kernel source for struct net_generic])
 if test -f $ksourcedir/include/net/netns/generic.h && \
    $GREP -q 'struct net_generic' $ksourcedir/include/net/netns/generic.h; then
diff --git a/kernel/include/linux/netfilter/ipset/ip_set_compat.h.in b/kernel/include/linux/netfilter/ipset/ip_set_compat.h.in
index 375a18a..c33de44 100644
--- a/kernel/include/linux/netfilter/ipset/ip_set_compat.h.in
+++ b/kernel/include/linux/netfilter/ipset/ip_set_compat.h.in
@@ -40,6 +40,7 @@
 #@HAVE_XT_MTCHK_PARAM_STRUCT_NET@ HAVE_XT_MTCHK_PARAM_STRUCT_NET
 #@HAVE_TCF_EMATCH_OPS_CHANGE_ARG_NET@ HAVE_TCF_EMATCH_OPS_CHANGE_ARG_NET
 #@HAVE_TCF_EMATCH_STRUCT_NET@ HAVE_TCF_EMATCH_STRUCT_NET
+#@HAVE_LIST_LAST_ENTRY@ HAVE_LIST_LAST_ENTRY
 
 /* Not everything could be moved here. Compatibility stuffs can be found in
  * xt_set.c, ip_set_core.c, ip_set_getport.c, pfxlen.c too.
@@ -164,4 +165,9 @@ static inline int nla_put_net32(struct sk_buff *skb, int attrtype, __be32 value)
 }
 #endif
 
+#ifndef HAVE_LIST_LAST_ENTRY
+#define list_last_entry(ptr, type, member) \
+	list_entry((ptr)->prev, type, member)
+#endif
+
 #endif /* __IP_SET_COMPAT_H */

Best regards,
Jozse
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
