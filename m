From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] netfilter: nft: select NFNETLINK
Date: Mon, 30 Dec 2013 18:18:50 +0100
Message-ID: <20131230171850.GC21208@localhost>
References: <1388311290-18366-1-git-send-email-eric@regit.org>
 <1388311290-18366-2-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36841 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756051Ab3L3RSz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Dec 2013 12:18:55 -0500
Content-Disposition: inline
In-Reply-To: <1388311290-18366-2-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Dec 29, 2013 at 11:01:29AM +0100, Eric Leblond wrote:
> In Kconfig, nft is set as depending on NFNETLINK so building nft as a
> module or inside kernel is depending of the state of NFNETLINK inside
> the kernel config. If someone wants to build nftables inside the
> kernel, it is necessary to also build NFNETLINK inside the kernel.
> But NFNETLINK can not be set in the menu so it is necessary to toggle
> an external value such as logging or nfacct to have a switch of
> NFNETLINK to kernel build.
> This patch change the dependency to a select inside Kconfig to be able
> to set the build of nftables as modules or inside kernel independently.

Applied, thanks Eric.
