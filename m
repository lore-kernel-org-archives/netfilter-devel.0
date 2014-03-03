From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH nft] parser: support reject unreach|reset
Date: Mon, 03 Mar 2014 22:41:32 +0100
Message-ID: <1393882892.19488.14.camel@ice-age2.regit.org>
References: <1393881146-12967-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:53909 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbaCCVlk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Mar 2014 16:41:40 -0500
In-Reply-To: <1393881146-12967-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Mon, 2014-03-03 at 22:12 +0100, Florian Westphal wrote:
> reject did not allow to use tcp reset instead of icmp unreach.

I'm currently working on a patchset to support this and also setting the
ICMP code. But I'm fighting on the ICMP code filtering.

> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  After this patch its possibe to do something like
> 
>  rule filter output reject reset

I found syntax a bit short ;) If we add ICMP code support
and follow the logic:

rule filter output reject administratively-prohibited

My plan was to do something like:

rule filter output reject with tcp reset
rule filter output reject with icmp|code administratively-prohibited

> 
>  Which makes kernel generate bogus tcp resets in repsonse
>  to non-tcp packets.
> 
>  In iptables this is avoided by making checkentry fail if -p tcp is not
>  specified when tcp-reset is requested.
>
>  How should this be handled in nft?

Good point. It looks a bit like what Patrick did mention in "Re:
[nftables RFC PATCH 0/1] implementing icmp code filterin"

"We do something similar in ct_expr_update_type() for ct expressions."

Idea is to update the entry and in this case to output an error if we
don't have tcp. But I'm not sure we can access to the other expressions
(and henve to the TCP or not info) in that point.

BR,
-- 
Eric Leblond <eric@regit.org>

