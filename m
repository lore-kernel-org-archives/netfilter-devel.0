From: David Miller <davem@davemloft.net>
Subject: Re: [patch] fix nla_policy_len to actually _iterate_ over the
 policy
Date: Mon, 28 Feb 2011 12:38:35 -0800 (PST)
Message-ID: <20110228.123835.245399145.davem@davemloft.net>
References: <20110228203559.GD8906@barkeeper1-xen.linbit>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
	holger@eitzenberger.org, kaber@trash.net,
	netfilter-devel@vger.kernel.org, stable@kernel.org
To: lars.ellenberg@linbit.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56387
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751667Ab1B1Uh6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Feb 2011 15:37:58 -0500
In-Reply-To: <20110228203559.GD8906@barkeeper1-xen.linbit>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Lars Ellenberg <lars.ellenberg@linbit.com>
Date: Mon, 28 Feb 2011 21:35:59 +0100

> Currently nla_policy_len always returns n * NLA_HDRLEN:
> It loops, but does not advance it's iterator.
> NLA_UNSPEC == 0 does not contain a .len in any policy.
> 
> Trivially fixed by adding p++.
> 
> Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>

Applied, thanks.
