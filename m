From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/4] netfilter: xt_connlimit: use hlist instead
Date: Tue, 15 Mar 2011 13:26:05 +0100
Message-ID: <4D7F5ADD.4030709@trash.net>
References: <1300085414-27275-1-git-send-email-xiaosuo@gmail.com> <1300085414-27275-3-git-send-email-xiaosuo@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42115 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552Ab1COM0L (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Mar 2011 08:26:11 -0400
In-Reply-To: <1300085414-27275-3-git-send-email-xiaosuo@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 14.03.2011 07:50, Changli Gao wrote:
> The header of hlist is smaller than list.

Applied.
