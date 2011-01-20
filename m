From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 0/3][RFC] Relationship between conntrack and firewall
 rules
Date: Thu, 20 Jan 2011 23:52:25 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1101202351050.26671@obet.zrqbmnf.qr>
References: <1295563629-14996-1-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:52005 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754625Ab1ATWw0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jan 2011 17:52:26 -0500
In-Reply-To: <1295563629-14996-1-git-send-email-richard@nod.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2011-01-20 23:47, Richard Weinberger wrote:

>Hi,
>
>as a firewall admin I would like to see which rules allow
>the connections through my firewall.
>A relationship between conntrack and firewall rules would be nice.
>The next five patches bring this feature to the Linux Netfilter.
>
>First a small example.
>Consider this iptables rules:
>-A INPUT -m state --state ESTABLISHED,RELATED -j APPROVE --rule-id 1
>-A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -j APPROVE --rule-id 2
>-A INPUT -p tcp --dport 22 -m state --state NEW -j APPROVE --rule-id 3
>-A INPUT -p icmp -m state --state NEW -j APPROVE --rule-id 4
>
>The APPROVE target is the same as ACCEPT but it stores also a rule id into 
>the connection tracking entry.


What about connmark? You could have used that. Perhaps combined with the 
use of -j TRACE that can show which rules were processed before a 
verdict was issued.

