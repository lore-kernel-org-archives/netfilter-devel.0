From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH 0/3][RFC] Relationship between conntrack and firewall rules
Date: Fri, 21 Jan 2011 00:02:24 +0100
Message-ID: <201101210002.24922.richard@nod.at>
References: <1295563629-14996-1-git-send-email-richard@nod.at> <alpine.LNX.2.01.1101202351050.26671@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a.ns.miles-group.at ([95.130.255.143]:40351 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755731Ab1ATXC2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jan 2011 18:02:28 -0500
In-Reply-To: <alpine.LNX.2.01.1101202351050.26671@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am Donnerstag 20 Januar 2011, 23:52:25 schrieb Jan Engelhardt:
> On Thursday 2011-01-20 23:47, Richard Weinberger wrote:
> >Hi,
> >
> >as a firewall admin I would like to see which rules allow
> >the connections through my firewall.
> >A relationship between conntrack and firewall rules would be nice.
> >The next five patches bring this feature to the Linux Netfilter.
> >
> >First a small example.
> >Consider this iptables rules:
> >-A INPUT -m state --state ESTABLISHED,RELATED -j APPROVE --rule-id 1
> >-A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -j APPROVE --rule-id 2
> >-A INPUT -p tcp --dport 22 -m state --state NEW -j APPROVE --rule-id 3
> >-A INPUT -p icmp -m state --state NEW -j APPROVE --rule-id 4
> >
> >The APPROVE target is the same as ACCEPT but it stores also a rule id into
> >the connection tracking entry.
> 
> What about connmark? You could have used that. Perhaps combined with the
> use of -j TRACE that can show which rules were processed before a
> verdict was issued.

Yeah, I know commark and TRACE but they are quite clumsy to use for such a purpose.
Especially writing firewall rules becomes more complex.

//richard
