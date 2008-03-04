From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] Fix computation of netlink skb size.
Date: Tue, 04 Mar 2008 15:58:26 +0100
Message-ID: <47CD6392.70305@trash.net>
References: <1204623963-10600-1-git-send-email-eric@inl.fr> <1204623963-10600-3-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep32-int.chello.at ([62.179.121.50]:49017 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273AbYCDO6a (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 09:58:30 -0500
In-Reply-To: <1204623963-10600-3-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch is similar to nfnetlink_queue fixes. It fixes the computation
> of skb size by using NLMSG_SPACE instead of NLMSG_ALIGN.


Also applied. I'll push your -stable patches once these two hit
upstream.
