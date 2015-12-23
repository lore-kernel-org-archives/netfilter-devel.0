From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] extensions: libxt_MARK: Add translation to nft
Date: Wed, 23 Dec 2015 17:15:06 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1512231714490.9969@nerf40.vanv.qr>
References: <20151223153353.GA17748@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:59534 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058AbbLWQPH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Dec 2015 11:15:07 -0500
In-Reply-To: <20151223153353.GA17748@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2015-12-23 16:33, Shivani Bhardwaj wrote:
>+++ b/extensions/libxt_MARK.c
>@@ -242,7 +242,24 @@ static void mark_tg_save(const void *ip, const struct xt_entry_target *target)
> {
> 	const struct xt_mark_tginfo2 *info = (const void *)target->data;
> 
>-	printf(" --set-xmark 0x%x/0x%x", info->mark, info->mask);
>+	printf(" --set mark 0x%x/0x%x", info->mark, info->mask);
>+}

This looks like it will break regular iptables.
