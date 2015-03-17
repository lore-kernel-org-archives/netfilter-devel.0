From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft 2/3] parser: allow to reorder chain options
Date: Tue, 17 Mar 2015 12:15:14 +0000
Message-ID: <20150317121514.GM21401@acer.localdomain>
References: <1426594385-24063-1-git-send-email-pablo@netfilter.org>
 <1426594385-24063-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41117 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbbCQMPT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2015 08:15:19 -0400
Content-Disposition: inline
In-Reply-To: <1426594385-24063-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 17.03, Pablo Neira Ayuso wrote:
> This allows all possible combinations to work:
> 
>  nft add chain filter input { type filter hook input priority 0 \; }
>  nft add chain filter input { priority 0 type filter hook input \; }


I don't object to being able to change the order of type and hook,
but priority logically belongs to the hook keyword, why change this?
