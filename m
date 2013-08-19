From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] iptables: extensions/GNUMakefile.in use CPPFLAGS
Date: Tue, 20 Aug 2013 01:50:05 +0200 (CEST)
Message-ID: <alpine.LSU.2.10.9.1308200149450.1576@nerf07.vanv.qr>
References: <1376928139-10273-1-git-send-email-ljlane@debian.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: "Laurence J. Lane" <ljlane@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:57766 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab3HSXuH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Aug 2013 19:50:07 -0400
In-Reply-To: <1376928139-10273-1-git-send-email-ljlane@debian.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2013-08-19 18:02, Laurence J. Lane wrote:

>From: "Laurence J. Lane" <ljlane@debian.org>
>
>"All other Makefiles add CPPFLAGS to ${COMPILE} (automake), but GNUmakefile.in
> doesn't set it."

CPPFLAGS must come last because it's the uservariable that is supposed 
to override everything else.

>-AM_CPPFLAGS     = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_builddir} -I${top_srcdir}/include ${kinclude_CPPFLAGS}
>+AM_CPPFLAGS     = ${CPPFLAGS} ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_builddir} -I${top_srcdir}/include ${kinclude_CPPFLAGS}
