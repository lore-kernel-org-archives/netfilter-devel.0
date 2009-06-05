From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3] netfilter: MASQUERADE: remove redundant rwlock
Date: Fri, 05 Jun 2009 13:27:50 +0200
Message-ID: <4A290136.4040204@trash.net>
References: <1244164542-10739-1-git-send-email-fw@strlen.de> <1244164542-10739-4-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55329 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbZFEL1v (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2009 07:27:51 -0400
In-Reply-To: <1244164542-10739-4-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal wrote:
> The lock "protects" an assignment and a comparision of an integer.
> When the caller of device_cmp() evaluates the result, nat->masq_index
> may already have been changed (regardless if the lock is there or not).
> 
> So, the lock either has to be held during nf_ct_iterate_cleanup(),
> or can be removed.
> 
> This does the latter.

Agreed, its useless. Applied, thanks.
