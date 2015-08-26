From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] build: add finer module blacklisting
Date: Wed, 26 Aug 2015 21:09:14 +0200
Message-ID: <20150826190914.GA23435@salvia>
References: <1439938134-1930-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51184 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840AbbHZTCx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Aug 2015 15:02:53 -0400
Content-Disposition: inline
In-Reply-To: <1439938134-1930-1-git-send-email-vapier@gentoo.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 18, 2015 at 06:48:54PM -0400, Mike Frysinger wrote:
> Newer extensions require libnftnl in order to build, but there are no
> configure or build checks for it, which leads to a bunch of modules
> failing when libnftnl isn't installed.  Add finer grained blacklisting
> so we can disable modules for specific parts rather than all of them.
> e.g. We want to blacklist libebt_limit, but not libxt_limit.

Applied, thanks for fixing this.

