From: Patrick McHardy <kaber@trash.net>
Subject: Re: nat drop the icmp redirect packet
Date: Wed, 30 Nov 2011 19:53:37 +0100
Message-ID: <4ED67BB1.8020808@trash.net>
References: <4ED2E00B.3000006@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56184 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab1K3Sxk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Nov 2011 13:53:40 -0500
In-Reply-To: <4ED2E00B.3000006@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11/28/2011 02:12 AM, Gao feng wrote:
> Hi
>
> In func nf_nat_icmp_reply_translation,the icmp packet will be droped when the nat is not finished.
> pc A(whose gateway is C) send a icmp request to pc B.
> When gw C receive this packet,it may return a icmp redirect packet to A.
> BUT now,the icmp request packet has not go to POSTROUTING,So the nat is not finished.
> Finally,the icmp redirect packet will be droped no matter the conn has nat or not.
>
> of course,the icmp redirect packet will be correct handled when nat is finished.
>
> Can somebody will give me some suggestion,
> or should I just add a sysctl to let the user decide drop or receive this icmp redirect packet when nat is not finished?

It doesn't matter whether the ICMP packet has gone through
POST_ROUTING, the conntrack associated with the packet is
that of the original packet causing the ICMP REDIRECT (or
any other kind of ICMP error).

Basically, we don't want hosts talking directly to each other
*if* NAT has been set up since that would obviously break
things. In the case you describe (only destination NAT setup
completed, but null mapping) instead of dropping the packet,
we could set up a null source mapping and let the packet
through under the assumption that the hosts will then start
communicating directly.

This will break if the host receiving the ICMP REDIRECT ignores
it though. What is the specific problem you're trying to solve?
