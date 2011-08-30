From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH RFC 2/3] netfilter: add ipv4 reverse path filter match
Date: Tue, 30 Aug 2011 14:34:34 +0200
Message-ID: <4E5CD8DA.1010204@trash.net>
References: <1314350465-19598-1-git-send-email-fw@strlen.de> <1314350465-19598-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54405 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab1H3Mem (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Aug 2011 08:34:42 -0400
In-Reply-To: <1314350465-19598-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26.08.2011 11:21, Florian Westphal wrote:
> This tries to mimic behaviour of fib_validate_source.
> 
> main drawback:
> - additional fib lookup to get oif (used as flow key in reverse lookup)

As discussed during the workshop, we could just perform input routing
in the module to get the oif for free. That would require to take care
of statistics as currently done in ip_rcv_finish() though.

> - no result caching so far
> 
> Other issues:
> - can't use FORWARD chain because by the time FORWARD is invoked
>   ipv4 forward path may have already sent icmp messages is response
>   to to-be-discarded-via-rpfilter packets
> - using it in PREROUTING may do the wrong thing (e.g. when using
>   policy routing via mangle PREROUTING)

Not if you're setting up policy routing keys (marks) before doing
rp_filter, right? Would require using it in the mangle table of
course.

