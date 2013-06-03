From: Chen Gang <gang.chen@asianux.com>
Subject: Re: [PATCH net-next v3] netfilter: Correct calculation using skb->tail
 and skb-network_header
Date: Mon, 03 Jun 2013 17:06:53 +0800
Message-ID: <51AC5CAD.6040204@asianux.com>
References: <1369967969-32375-1-git-send-email-horms@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Simon Horman <horms@verge.net.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:1134 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687Ab3FCJHy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:07:54 -0400
In-Reply-To: <1369967969-32375-1-git-send-email-horms@verge.net.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 05/31/2013 10:39 AM, Simon Horman wrote:
> This corrects an regression introduced by "net: Use 16bits for *_headers
> fields of struct skbuff" when NET_SKBUFF_DATA_USES_OFFSET is not set. In
> that case skb->tail will be a pointer whereas skb->network_header
> will be an offset from head. This is corrected by using wrappers that
> ensure that calculations are always made using pointers.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Reported-by: Chen Gang <gang.chen@asianux.com>
> Signed-off-by: Simon Horman <horms@verge.net.au>
> 
> --
> v3
> * Add net-next to subject prefix
> 
> v2
> * Use skb_tail_pointer() to ensure the tail portion of the calculation is
>   always a pointer - it is not if NET_SKBUFF_DATA_USES_OFFSET is not set.

Thanks.

-- 
Chen Gang

Asianux Corporation
