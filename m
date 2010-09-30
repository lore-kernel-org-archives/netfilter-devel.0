From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/6] build: add debug configure flag
Date: Thu, 30 Sep 2010 11:50:22 +0200
Message-ID: <4CA45D5E.9010103@netfilter.org>
References: <1285116442-32490-1-git-send-email-eric@inl.fr> <1285116442-32490-4-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43933 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755410Ab0I3JuZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Sep 2010 05:50:25 -0400
In-Reply-To: <1285116442-32490-4-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 22/09/10 02:47, Eric Leblond wrote:
> --- a/src/Makefile.am
> +++ b/src/Makefile.am
> @@ -6,4 +6,8 @@ AM_CPPFLAGS = $(all_includes) -I$(top_srcdir)/include \
>  sbin_PROGRAMS = ulogd
>  
>  ulogd_SOURCES = ulogd.c select.c timer.c rbtree.c conffile.c hash.c
> +if HAVE_DEBUG
> +ulogd_LDFLAGS = -lpthread -export-dynamic

Do we still have the gdb pthread issue?
