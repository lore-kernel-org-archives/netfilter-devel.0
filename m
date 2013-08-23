From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCHv2] iptables: link against libnetfilter_conntrack
Date: Fri, 23 Aug 2013 22:03:46 +0200
Message-ID: <20130823200346.GC5311@breakpoint.cc>
References: <1376411824-22311-1-git-send-email-gustavo@zacarias.com.ar>
 <alpine.LSU.2.10.9.1308132051420.22862@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Gustavo Zacarias <gustavo@zacarias.com.ar>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54290 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932215Ab3HWUDu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Aug 2013 16:03:50 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.10.9.1308132051420.22862@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@inai.de> wrote:
> On Tuesday 2013-08-13 18:37, Gustavo Zacarias wrote:
> >diff --git a/iptables/Makefile.am b/iptables/Makefile.am
> >index a4246eb..6390b7c 100644
> >--- a/iptables/Makefile.am
> >+++ b/iptables/Makefile.am
> >@@ -21,6 +21,9 @@ xtables_multi_SOURCES += ip6tables-save.c ip6tables-restore.c \
> > xtables_multi_CFLAGS  += -DENABLE_IPV6
> > xtables_multi_LDADD   += ../libiptc/libip6tc.la ../extensions/libext6.a
> > endif
> >+if HAVE_LIBNETFILTER_CONNTRACK
> >+xtables_multi_LDADD += @libnetfilter_conntrack_LIBS@
> >+endif
> > xtables_multi_SOURCES += xshared.c
> > xtables_multi_LDADD   += ../libxtables/libxtables.la -lm
> 
> The righteous patch would be something like the following.
[..]

Applied to stable-1.4.20, thanks everyone.
