From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/4] netfilter: xt_connlimit: remove connlimit_rnd_inited
Date: Tue, 15 Mar 2011 13:26:54 +0100
Message-ID: <4D7F5B0E.2060000@trash.net>
References: <1300085414-27275-1-git-send-email-xiaosuo@gmail.com> <1300085414-27275-4-git-send-email-xiaosuo@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42141 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552Ab1COM0z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Mar 2011 08:26:55 -0400
In-Reply-To: <1300085414-27275-4-git-send-email-xiaosuo@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 14.03.2011 07:50, Changli Gao wrote:
> A potential race condition when generating connlimit_rnd is also fixed.

Also applied, thanks Changli.
