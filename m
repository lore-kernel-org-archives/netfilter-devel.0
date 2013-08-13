From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] iptables: link libxtables against libnetfilter_conntrack
Date: Tue, 13 Aug 2013 15:59:32 +0200
Message-ID: <20130813135932.GJ29345@breakpoint.cc>
References: <1376399723-9967-1-git-send-email-gustavo@zacarias.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gustavo Zacarias <gustavo@zacarias.com.ar>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:6672 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757014Ab3HMN7d (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:59:33 -0400
Content-Disposition: inline
In-Reply-To: <1376399723-9967-1-git-send-email-gustavo@zacarias.com.ar>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Gustavo Zacarias <gustavo@zacarias.com.ar> wrote:
> When libnetfilter_conntrack is available libxtables needs to link
> against it otherwise we get build failures.

Only with --enable-static, right?
Can you make it conditional on ENABLE_STATIC, like this?

diff --git a/libxtables/Makefile.am b/libxtables/Makefile.am
index c5795fe..3de2e15 100644
--- a/libxtables/Makefile.am
+++ b/libxtables/Makefile.am
@@ -11,6 +11,9 @@ if ENABLE_STATIC
 # With --enable-static, shipped extensions are linked into the main executable,
 # so we need all the LIBADDs here too
 libxtables_la_LIBADD += -lm
+if HAVE_LIBNETFILTER_CONNTRACK
+libxtables_la_LIBADD += @libnetfilter_conntrack_LIBS@
+endif
 endif
 if ENABLE_SHARED
 libxtables_la_CFLAGS  = ${AM_CFLAGS}
