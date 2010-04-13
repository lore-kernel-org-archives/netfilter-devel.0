From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/8] netfilter: ipv6: move POSTROUTING invocation before
 fragmentation
Date: Tue, 13 Apr 2010 15:30:00 +0200
Message-ID: <4BC471D8.1040108@trash.net>
References: <1271162268-28131-1-git-send-email-jengelh@medozas.de> <1271162268-28131-2-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49571 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab0DMNaB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 09:30:01 -0400
In-Reply-To: <1271162268-28131-2-git-send-email-jengelh@medozas.de>
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

Applied, thanks. It seems you could now change the IPv6 conntrack
LOCAL_OUT hook to skip defragmentation.

