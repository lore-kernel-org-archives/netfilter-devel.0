From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] netfilter: fix export secctx error handling
Date: Thu, 06 Jan 2011 11:25:32 -0800 (PST)
Message-ID: <20110106.112532.48509766.davem@davemloft.net>
References: <20110106015633.10207.39405.stgit@decadence>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43239
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753275Ab1AFTZA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Jan 2011 14:25:00 -0500
In-Reply-To: <20110106015633.10207.39405.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 06 Jan 2011 02:56:33 +0100

> In 1ae4de0cdf855305765592647025bde55e85e451, the secctx was exported
> via the /proc/net/netfilter/nf_conntrack and ctnetlink interfaces
> instead of the secmark.
> 
> That patch introduced the use of security_secid_to_secctx() which may
> return a non-zero value on error.
> 
> In one of my setups, I have NF_CONNTRACK_SECMARK enabled but no
> security modules. Thus, security_secid_to_secctx() returns a negative
> value that results in the breakage of the /proc and `conntrack -L'
> outputs. To fix this, we skip the inclusion of secctx if the
> aforementioned function fails.
> 
> This patch also fixes the dynamic netlink message size calculation
> if security_secid_to_secctx() returns an error, since its logic is
> also wrong.
> 
> This problem exists in Linux kernel >= 2.6.37.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Applied, thanks Pablo.
