From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ctnetlink: fix loop in ctnetlink_get_conntrack()
Date: Thu, 13 Jan 2011 17:00:20 +0100
Message-ID: <4D2F2194.4000601@netfilter.org>
References: <1294924795-20816-1-git-send-email-fwestphal@astaro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net
To: Florian Westphal <fwestphal@astaro.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49562 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757007Ab1AMQAZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Jan 2011 11:00:25 -0500
In-Reply-To: <1294924795-20816-1-git-send-email-fwestphal@astaro.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 13/01/11 14:19, Florian Westphal wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> This patch fixes a loop in ctnetlink_get_conntrack() that can be
> triggered if you use the same socket to receive events and to
> perform a GET operation. Under heavy load, netlink_unicast()
> may return -EAGAIN, this error code is reserved in nfnetlink for
> the module load-on-demand. Instead, we return -ENOBUFS which is
> the appropriate error code that has to be propagated to
> user-space.

Indeed, it's in Patrick's tree but it didn't get the patch to reach the
kernel. I'll pass it to davem.
