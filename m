From: Patrick McHardy <kaber@trash.net>
Subject: Re: [stable-patch 1/2] Fix computation of allocated size for netlink
 skb.
Date: Mon, 17 Mar 2008 15:09:29 +0100
Message-ID: <47DE7B99.6070608@trash.net>
References: <1204623659-9507-1-git-send-email-eric@inl.fr> <1204623659-9507-2-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep20-int.chello.at ([62.179.121.40]:35303 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbYCQOSF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Mar 2008 10:18:05 -0400
In-Reply-To: <1204623659-9507-2-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Size of the netlink skb was wrongly computed because the formula was using
> NLMSG_ALIGN instead of NLMSG_SPACE. NLMSG_ALIGN does not add the room for
> netlink header as NLMSG_SPACE does. This was causing a failure of message
> building in some cases.
> 
> On my test system, all messages for packets in range [8*k+41, 8*k+48] where k
> is an integer were invalid and the corresponding packets were dropped.


Applied.
