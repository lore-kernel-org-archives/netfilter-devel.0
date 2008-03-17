From: Patrick McHardy <kaber@trash.net>
Subject: Re: [stable-patch 2/2] Fix computation of netlink skb size.
Date: Mon, 17 Mar 2008 15:10:43 +0100
Message-ID: <47DE7BE3.9030302@trash.net>
References: <1204623659-9507-1-git-send-email-eric@inl.fr> <1204623659-9507-3-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:11284 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753569AbYCQOTU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Mar 2008 10:19:20 -0400
In-Reply-To: <1204623659-9507-3-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch is similar to nfnetlink_queue fixes. It fixes the computation
> of skb size by using NLMSG_SPACE instead of NLMSG_ALIGN.

Also applied, thanks.
