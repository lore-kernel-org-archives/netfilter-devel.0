From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] Allowing non-root to get iptables info?
Date: Wed, 27 Feb 2008 12:52:52 +0100
Message-ID: <47C54F14.4010709@trash.net>
References: <20080225094951.5bd89c9c@extreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50833 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbYB0LxP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Feb 2008 06:53:15 -0500
In-Reply-To: <20080225094951.5bd89c9c@extreme>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Stephen Hemminger wrote:
> Is there any strong reason why checking the status of iptables is restricted?
>
> Vyatta makes a distribution for routers. In our case, we use a non-root account
> for operator commands, and some of the commands are about querying iptables status.
> It seems to be less risky to just fix the kernel to allow non-root user to query rules
> than the current script that uses sudo. Another alternative would be building a special
> restricted command that could be setuid root, but just changing the kernel seems easiest.
>   

I always thought of it as a privacy thing, similar to restricting
/proc/net/nf_conntrack. But since iptables rules usually don't
allow you to determine active connections just from the packet
counters that might be overkill. So I don't see any real harm
in allowing users to list the ruleset.

I'll queue this patch for 2.6.26 if nobody has any objections.


