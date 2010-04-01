From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/5] netfilter: ipv6: move POSTROUTING invocation before
 fragmentation
Date: Thu, 01 Apr 2010 12:23:55 +0200
Message-ID: <4BB4743B.3080604@trash.net>
References: <1270031934-15940-1-git-send-email-jengelh@medozas.de> <1270031934-15940-2-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49286 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab0DAKX5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Apr 2010 06:23:57 -0400
In-Reply-To: <1270031934-15940-2-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Patrick McHardy notes: "We used to invoke IPv4 POST_ROUTING after
> fragmentation as well just to defragment the packets in conntrack
> immediately afterwards, but that got changed during the
> netfilter-ipsec integration. Ideally IPv6 would behave like IPv4."
> 
> This patch makes it so. Sending an oversized frame (e.g. `ping6
> -s64000 -c1 ::1`) will now show up in POSTROUTING as a single skb
> rather than multiple ones.

Looks good to me. I'll wait until next week in case anyone
else has comments on this patch.

