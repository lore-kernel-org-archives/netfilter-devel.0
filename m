From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Merging iptables-nftables into iptables
Date: Tue, 31 Dec 2013 10:40:51 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1312311038320.22184@nerf08.vanv.qr>
References: <20131204114834.GA13280@localhost> <20131230230731.GA4849@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:33044 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170Ab3LaJkw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 Dec 2013 04:40:52 -0500
In-Reply-To: <20131230230731.GA4849@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2013-12-31 00:07, Pablo Neira Ayuso wrote:
>I plan to give it another review tomorrow to see if I left something
>behind in the rebase, if no troubles I'll merge it into master.
>
>[1] http://git.netfilter.org/iptables/log/?h=nft-compat

You left:

+PKG_CHECK_MODULES([libnfables], [libnftables >= 1.0],

and this seems to have mixed nft and xt:

+AC_ARG_ENABLE([nftables],
+       AS_HELP_STRING([--disable-xtables], [Do not build xtables]),


+AM_PROG_LEX

=> AC_PROG_LEX

+if test "$flex_major" -eq "2" && test "$flex_minor" -eq "5" && test
"$flex_rev" -ge "33"; then
+       AC_MSG_RESULT([$flex_version. OK])
+else
+       AC_MSG_WARN([flex version $flex_version found.
+       Version 2.5.33 or greater is required. You may experience problems
+       while compilating the conntrack-tools. Please, consider to upgrade
+       flex.])
+fi

conntrack-tools?!

