From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: iptables: build updates and fixes
Date: Fri, 30 Dec 2011 12:58:49 +0100
Message-ID: <20111230115849.GC12204@1984>
References: <1325208902-2014-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50407 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063Ab1L3L6w (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Dec 2011 06:58:52 -0500
Content-Disposition: inline
In-Reply-To: <1325208902-2014-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 30, 2011 at 02:34:55AM +0100, Jan Engelhardt wrote:
> 
> The following changes since commit b8c42eca0f224a00bf55b60ded81af14a1e07da1:
>   libiptc: provide separate pkgconfig files (2011-12-18 02:52:32 +0100)
> 
> are available FOR REVIEW in the git repository at:
>   git://dev.medozas.de/iptables stable
> 
> Jan Engelhardt (6):
>       Update .gitignore
>       build: use AC_CONFIG_AUX_DIR and stash away tools
>       Update .gitignore
>       build: use delayed expansion on the user-settable variables
>       extensions: link on libxtables and check symbols
>       nfnl_osf: add missing libnfnetlink_CFLAGS to compile process

No objections regarding this patchset.

Only thing is that I'd like to reduce the changes on the -stable branch
to the strictly neccessary.

This is the only way to reduce the chances that someone comes and say
that we have broken something in -stable.

Would you be OK if this goes to master instead?
