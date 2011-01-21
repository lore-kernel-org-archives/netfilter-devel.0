From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH 0/3][RFC] Relationship between conntrack and firewall rules
Date: Fri, 21 Jan 2011 12:56:34 +0100
Message-ID: <201101211256.34778.richard@nod.at>
References: <1295563629-14996-1-git-send-email-richard@nod.at> <201101211213.57308.richard@nod.at> <4D396D51.3070903@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a.ns.miles-group.at ([95.130.255.143]:53525 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541Ab1AUL4j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Jan 2011 06:56:39 -0500
In-Reply-To: <4D396D51.3070903@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am Freitag 21 Januar 2011, 12:26:09 schrieb Pablo Neira Ayuso:
> On 21/01/11 12:13, Richard Weinberger wrote:
> > Am Freitag 21 Januar 2011, 11:00:48 schrieb Pablo Neira Ayuso:
> >> On 21/01/11 00:02, Richard Weinberger wrote:
> >>> Am Donnerstag 20 Januar 2011, 23:52:25 schrieb Jan Engelhardt:
> >>>> On Thursday 2011-01-20 23:47, Richard Weinberger wrote:
> >>>>> Hi,
> >>>>> 
> >>>>> as a firewall admin I would like to see which rules allow
> >>>>> the connections through my firewall.
> >>>>> A relationship between conntrack and firewall rules would be nice.
> >>>>> The next five patches bring this feature to the Linux Netfilter.
> >>>>> 
> >>>>> First a small example.
> >>>>> Consider this iptables rules:
> >>>>> -A INPUT -m state --state ESTABLISHED,RELATED -j APPROVE --rule-id 1
> >>>>> -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -j APPROVE
> >>>>> --rule-id 2 -A INPUT -p tcp --dport 22 -m state --state NEW -j
> >>>>> APPROVE --rule-id 3 -A INPUT -p icmp -m state --state NEW -j APPROVE
> >>>>> --rule-id 4
> >>>>> 
> >>>>> The APPROVE target is the same as ACCEPT but it stores also a rule id
> >>>>> into the connection tracking entry.
> >>>> 
> >>>> What about connmark? You could have used that. Perhaps combined with
> >>>> the use of -j TRACE that can show which rules were processed before a
> >>>> verdict was issued.
> >>> 
> >>> Yeah, I know commark and TRACE but they are quite clumsy to use for
> >>> such a purpose.
> >> 
> >> Why are the clumsy for this purpose?
> > 
> > Because I would need more than one iptables command to model a firewall
> > rule. Or can you show me a simple iptables configuration using connmark
> > which achieves the same as my APPROVE example above?
> 
> Just a couple of extra rules to restore and save the connmark. Right?

With my extension you can see which rule accepted the connection
in the states ESTABLISHED, RELATED, NEW and REPLY.
So we have 4 rule ids per connection.

Let's look again at this connection:
tcp      6 431999 ESTABLISHED src=192.168.1.1 dst=192.168.1.2 sport=51444 \
        dport=22 src=192.168.1.2 dst=192.168.1.1 sport=22 dport=51444 [ASSURED] \
        mark=0 established=1 related=0 new=3 reply=2 use=1

We can observe that the connection in state ESTABLISHED was allowed by rule 1, 
NEW by rule 3 and REPLY by rule 2.

To model this using conntrack we need more than a few more restore and save rules...
(Assuming all rule ids are 8bit, because connmark is 32bit)

This is why I've made this contribution.
It makes it very easy to model such tasks.

//richard
