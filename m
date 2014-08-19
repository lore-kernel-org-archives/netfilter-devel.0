From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: Re: [PATCH] netfilter: x_tables: allow to use default cgroup match
Date: Tue, 19 Aug 2014 15:26:46 +0400
Message-ID: <53F33476.8070904@samsung.com>
References: <1408369588-12363-1-git-send-email-dborkman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Daniel Borkmann <dborkman@redhat.com>, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:48337 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbaHSL0u (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Aug 2014 07:26:50 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NAJ004ELX4N90C0@mailout3.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Tue, 19 Aug 2014 12:26:47 +0100 (BST)
In-reply-to: <1408369588-12363-1-git-send-email-dborkman@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08/18/2014 05:46 PM, Daniel Borkmann wrote:
> There's actually no good reason why we cannot use cgroup id 0,
> so lets just remove this artificial barrier.
>
> Reported-by: Alexey Perevalov <a.perevalov@samsung.com>
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> ---
>   net/netfilter/xt_cgroup.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
>
Thank you, Daniel, I tested it on my environment, patch is fine.

Tested-by: Alexey Perevalov <a.perevalov@samsung.com>

-- 
Best regards,
Alexey Perevalov
