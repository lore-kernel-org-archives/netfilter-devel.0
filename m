From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2 1/3] netfilter: af_info: add network namespace
 parameter to route hook
Date: Thu, 24 Mar 2011 16:15:10 -0700 (PDT)
Message-ID: <20110324.161510.57488462.davem@davemloft.net>
References: <1300998597-2018-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: fw@strlen.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54030
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934201Ab1CXXOb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Mar 2011 19:14:31 -0400
In-Reply-To: <1300998597-2018-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>
Date: Thu, 24 Mar 2011 21:29:55 +0100

> This is required to eventually replace the rt6_lookup call in xt_addrtype.c
> with nf_afinfo->route().
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: David S. Miller <davem@davemloft.net>
