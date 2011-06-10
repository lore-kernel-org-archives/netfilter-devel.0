From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 7/8] iptables: Coverity: OVERRUN_STATIC
Date: Fri, 10 Jun 2011 23:10:54 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1106102308300.28383@frira.zrqbmnf.qr>
References: <1307712362-17727-1-git-send-email-jpopelka@redhat.com> <1307712362-17727-8-git-send-email-jpopelka@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jiri Popelka <jpopelka@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:54785 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477Ab1FJVK5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jun 2011 17:10:57 -0400
In-Reply-To: <1307712362-17727-8-git-send-email-jpopelka@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2011-06-10 15:26, Jiri Popelka wrote:
>
>libiptc/libiptc.c:1690: overrun-buffer-arg: Overrunning static array "t->target.u.user.name"
>                        of size 29 bytes by passing it to a function which indexes it
>                        with argument "30UL" at byte position 29.
>
>libiptc/libiptc.c:1127: overrun-buffer-arg: Overrunning static array "t->target.u.user.name"
>                        of size 29 bytes by passing it to a function which indexes it
>                        with argument "30UL" at byte position 29.

>diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
>index c2cb0bc..1a99047 100644
>--- a/libiptc/libiptc.c
>+++ b/libiptc/libiptc.c
>@@ -1121,7 +1121,7 @@ static inline int iptcc_compile_rule (struct xtc_handle *h, STRUCT_REPLACE *repl
> 		STRUCT_STANDARD_TARGET *t;
> 		t = (STRUCT_STANDARD_TARGET *)GET_TARGET(r->entry);
> 		/* memset for memcmp convenience on delete/replace */
>-		memset(t->target.u.user.name, 0, FUNCTION_MAXNAMELEN);
>+		memset(t->target.u.user.name, 0, XT_EXTENSION_MAXNAMELEN);
> 		strcpy(t->target.u.user.name, STANDARD_TARGET);
> 		/* Jumps can only happen to builtin chains, so we
> 		 * can safely assume that they always have a header */

I have a feeling that there was something... namely implicitly
setting t->target.u.user.revision too.

So this might need  a +t->target.u.user.revision = 0;
unless you want t->target.u.user.revision to contain.. something,
probably undefined value.


