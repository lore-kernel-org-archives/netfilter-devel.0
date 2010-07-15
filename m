From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] nfnetlink_log: do not expose NFULNL_COPY_DISABLED to
 user-space
Date: Thu, 15 Jul 2010 11:30:06 +0200
Message-ID: <4C3ED51E.3060907@trash.net>
References: <20100714114914.4622.56919.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, eric.dumazet@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40212 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932874Ab0GOJaI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Jul 2010 05:30:08 -0400
In-Reply-To: <20100714114914.4622.56919.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 14.07.2010 13:49, schrieb Pablo Neira Ayuso:
> This patch moves NFULNL_COPY_PACKET definition from
> linux/netfilter/nfnetlink_log.h to net/netfilter/nfnetlink_log.h
> since this copy mode is only for internal use.
> 
> I have also changed the value from 0x03 to 0xff. Thus, we avoid
> a gap from user-space that may confuse users if we add new
> copy modes in the future.
> 
> This change was introduced in:
> http://www.spinics.net/lists/netfilter-devel/msg13535.html
> 
> Since this change is not included in any stable Linux kernel,
> I think it's safe to make this change now. Anyway, this copy
> mode does not make any sense from user-space, so this patch
> should not break any existing setup.
> 

Applied, thanks Pablo.
