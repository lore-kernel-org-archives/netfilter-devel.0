From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] netfilter: conntrack: optional reliable conntrack
 event	delivery
Date: Mon, 04 May 2009 16:02:03 +0200
Message-ID: <49FEF55B.8020109@netfilter.org>
References: <20090504134740.8394.21789.stgit@Decadence> <20090504135355.8394.65706.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38510 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756037AbZEDOCP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 May 2009 10:02:15 -0400
In-Reply-To: <20090504135355.8394.65706.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch improves ctnetlink event reliability if one broadcast
> listener has set the NETLINK_BROADCAST_ERROR socket option.

I have just detected an inconsistency in the handling of
IPCT_DELIVERY_FAILED, I'll resend this patch alone again.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
