From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: use autoconf to process .in man pages
Date: Wed, 29 May 2013 19:40:44 +0200
Message-ID: <20130529174044.GA7556@localhost>
References: <20130520030106.GA15853@pileus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Andy Spencer <andy753421@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53009 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614Ab3E2Rky (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 May 2013 13:40:54 -0400
Content-Disposition: inline
In-Reply-To: <20130520030106.GA15853@pileus.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 20, 2013 at 03:01:06AM +0000, Andy Spencer wrote:
> This fixes a bug in iptables.8 and ip6tables.8 where @PACKAGE_VERSION@
> was not processed in the VERSION section. It also simplifies the
> Makefile by avoiding some sed commands.

Applied, thanks Andy.

> ---
> Yea, I don't know how I feel about having a .in.in, but it seems to work
> well enough.

I renamed the .in.in to .tmpl.in. After the the package version is
set, we got a template file which is later on populated with the
extensions. Just comestic change to avoid that.
