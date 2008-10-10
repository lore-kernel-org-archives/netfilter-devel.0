From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/8] [PATCH] use EOPNOTSUPP instead of EINVAL if the conntrack
 has no helper
Date: Fri, 10 Oct 2008 15:03:18 +0200
Message-ID: <48EF5296.1000101@trash.net>
References: <20081009083339.9824.24056.stgit@Decadence> <20081009083444.9824.95893.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53919 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759565AbYJJNDV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Oct 2008 09:03:21 -0400
In-Reply-To: <20081009083444.9824.95893.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch changes the return value if the conntrack has no helper assigned.
> Instead of EINVAL, which is reserved for malformed messages, it returns
> EOPNOTSUPP.

Applied, thanks.
