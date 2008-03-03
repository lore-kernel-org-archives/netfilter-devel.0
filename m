From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: tarball target
Date: Mon, 3 Mar 2008 13:08:38 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803031305540.7660@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0802211633500.26109@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0802291946560.24056@fbirervta.pbzchgretzou.qr>
 <47CB67DB.1060800@netfilter.org> <Pine.LNX.4.64.0803031226430.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47879 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbYCCMIj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Mar 2008 07:08:39 -0500
In-Reply-To: <Pine.LNX.4.64.0803031226430.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mar 3 2008 12:34, Jan Engelhardt wrote:
>>
>>Attention, I'm about to release iptables-1.4.1 which includes the
>>userspace part for this. I can still delay it a couple of days and
>>rework the release tarball if you pass me the userspace part asap.

(Hmm... releases always seem to be at the wrong time)

Another thing you will need is:

commit b381f81cca8c1a49c318fde97a2ef69054055995
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Mon Mar 3 13:04:07 2008 +0100

    Makefile: add a "tarball" target

diff --git a/Makefile.am b/Makefile.am
index a0f33c6..7c3f131 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -93,3 +93,11 @@ ip6tables.8: ${srcdir}/ip6tables.8.in extensions/matches6.man extensions/targets
 
 extensions/%:
 	${MAKE} ${AM_MAKEFLAGS} -C $(@D) $(@F)
+
+.PHONY: tarball
+tarball:
+	rm -Rf /tmp/xtables;
+	pushd ${top_srcdir} && git-archive --prefix=xtables/ HEAD | tar -C /tmp -x && popd;
+	pushd /tmp/xtables && ./autogen.sh && popd;
+	tar -C /tmp -cf xtables-${PACKAGE_VERSION}.tar.bz2 xtables/;
+	rm -Rf /tmp/xtables;
