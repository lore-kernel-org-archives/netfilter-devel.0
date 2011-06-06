From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 6/7] netfilter: nf_conntrack: fix ct refcount leak in
 l4proto->error()
Date: Tue, 07 Jun 2011 01:17:55 +0200
Message-ID: <4DED6023.6080702@netfilter.org>
References: <1307319100-21827-1-git-send-email-pablo@netfilter.org> <1307319100-21827-7-git-send-email-pablo@netfilter.org> <402391307326240@web153.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net
To: "Oleg A. Arkhangelsky" <sysoleg@yandex.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32971 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180Ab1FFXSU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jun 2011 19:18:20 -0400
In-Reply-To: <402391307326240@web153.yandex.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 06/06/11 04:10, "Oleg A. Arkhangelsky" wrote:
> Hello,
> 
> 06.06.2011, 04:11, pablo@netfilter.org:
> 
>> With this patch, we can also fix wrong return values (-NF_ACCEPT)
>> for special cases in ICMP[v6] that should not bump the invalid/error
>> statistic counters.
> 
> Are you sure? Please, look here:
> 
> http://www.spinics.net/lists/netfilter-devel/msg15520.html

We now check if we have one skb->nfct after l4proto->error(), so that
affirmation doesn't apply anymore.
