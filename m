From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Something like a bug
Date: Tue, 15 Apr 2008 17:47:19 +0200
Message-ID: <4804CE07.3060507@netfilter.org>
References: <dbdd0cc00804140027y54a00ca7pdef3b091dde33bf6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050900090701040409050207"
Cc: netfilter-devel@vger.kernel.org
To: Rick Xu <rickxbx@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47558 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752029AbYDOPrg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2008 11:47:36 -0400
In-Reply-To: <dbdd0cc00804140027y54a00ca7pdef3b091dde33bf6@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050900090701040409050207
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Rick Xu wrote:
> int nfnl_nfa_addattr_l(struct nfattr *nfa, int maxlen, int type,
>                const void *data, int alen)
> {
>  ......
> 
>     if ((NFA_OK(nfa, nfa->nfa_len) + len) > maxlen) {
>         errno = ENOSPC;
>         return -1;
>     }
> 
>     subnfa = (struct nfattr *)(((char *)nfa) + NFA_OK(nfa, nfa->nfa_len));
> 
> .....
> }
> 
> NFA_OK looks so weird here. I think it should be:
> int nfnl_nfa_addattr_l(struct nfattr *nfa, int maxlen, int type,
>                const void *data, int alen)
> {
>  ......
> 
>     if ( NFA_ALIGN(nfa->nfa_len) + NFA_LENGTH(len) > maxlen) {
>         errno = ENOSPC;
>         return -1;
>     }
> 
>     subnfa = (struct nfattr *)(((char *)nfa) + NFA_ALIGN( nfa->nfa_len));
> 
> .....
> }
> 
> Please kindly correct me if I made a mistake.


Indeed, that function is completely broken but it does not have any
known client.

It seems a leftover of the days when we didn't have anything better to
nest attributes, so that it's completely useless these days. I have
fixed in SVN anyway. Patch attached.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------050900090701040409050207
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="x"

Index: configure.in
===================================================================
--- configure.in	(revisión: 7400)
+++ configure.in	(copia de trabajo)
@@ -4,7 +4,7 @@
 
 AC_CANONICAL_SYSTEM
 
-AM_INIT_AUTOMAKE(libnfnetlink, 0.0.33)
+AM_INIT_AUTOMAKE(libnfnetlink, 0.0.34)
 
 AC_PROG_CC
 AC_EXEEXT
Index: src/libnfnetlink.c
===================================================================
--- src/libnfnetlink.c	(revisión: 7400)
+++ src/libnfnetlink.c	(copia de trabajo)
@@ -799,16 +799,16 @@
 	assert(maxlen > 0);
 	assert(type >= 0);
 
-	if ((NFA_OK(nfa, nfa->nfa_len) + len) > maxlen) {
+	if (NFA_ALIGN(nfa->nfa_len) + len > maxlen) {
 		errno = ENOSPC;
 		return -1;
 	}
 
-	subnfa = (struct nfattr *)(((char *)nfa) + NFA_OK(nfa, nfa->nfa_len));
+	subnfa = (struct nfattr *)(((char *)nfa) + NFA_ALIGN(nfa->nfa_len));
 	subnfa->nfa_type = type;
 	subnfa->nfa_len = len;
 	memcpy(NFA_DATA(subnfa), data, alen);
-	nfa->nfa_len = (NLMSG_ALIGN(nfa->nfa_len) + len);
+	nfa->nfa_len = NFA_ALIGN(nfa->nfa_len) + len;
 
 	return 0;
 }

--------------050900090701040409050207--
