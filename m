From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH 1/5] netfilter: ipv6: move POSTROUTING invocation before
 fragmentation
Date: Thu, 01 Apr 2010 19:50:06 +0900
Message-ID: <4BB47A5E.6090205@linux-ipv6.org>
References: <1270031487-15094-1-git-send-email-jengelh@medozas.de> <1270031487-15094-2-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
	YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 94.43.138.210.xn.2iij.net ([210.138.43.94]:55486 "EHLO
	mail.st-paulia.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755186Ab0DAKul (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Apr 2010 06:50:41 -0400
In-Reply-To: <1270031487-15094-2-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello.

(2010/03/31 19:31), Jan Engelhardt wrote:
> Patrick McHardy notes: "We used to invoke IPv4 POST_ROUTING after
> fragmentation as well just to defragment the packets in conntrack
> immediately afterwards, but that got changed during the
> netfilter-ipsec integration. Ideally IPv6 would behave like IPv4."
> 
> This patch makes it so. Sending an oversized frame (e.g. `ping6
> -s64000 -c1 ::1`) will now show up in POSTROUTING as a single skb
> rather than multiple ones.

I am not in favor doing this
because we theoretically make fragments __before__ routing
in output path (as we reassemble __after__ routing in input path).

IMHO, FORWARDING and POSTROUTING share similar semantics
from routing POV.
As we see "fragments" in FORWARDING, we should see
fragments in POST_ROUTING, at least in IPv6.

--yoshfuji
