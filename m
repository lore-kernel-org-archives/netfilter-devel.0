From: Leo Baltus <Leo.Baltus@omroep.nl>
Subject: Re: ip6tables breaks dnssec?
Date: Wed, 27 Apr 2011 12:56:44 +0200
Message-ID: <20110427105644.GA9859@omroep.nl>
References: <20110427085755.GD2418@omroep.nl>
 <alpine.LNX.2.01.1104271200480.12004@obet.zrqbmnf.qr>
 <4DB7F347.1080107@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Ulrich Weber <ulrich.weber@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from out1a.mail.omroep.nl ([145.58.30.184]:59514 "EHLO
	out1a.mail.omroep.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760Ab1D0K4m (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:56:42 -0400
Content-Disposition: inline
In-Reply-To: <4DB7F347.1080107@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Op 27/04/2011 om 12:43:19 +0200, schreef Ulrich Weber:
> Each fragmented IPv6 packets will traverse netfilter separately,
> in contrast to IPv4, where its only one refragmented packet.
> 

I seem to have missed that.

> "ip6tables -A INPUT -j ACCEPT -p udp --dport 53" will only match the
> first fragment, where the UDP header can be found. To match the
> additional fragments, you have to insert these rules:
> 
> ip6tables -I INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
> ip6tables -I OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
> 

Thanks. That was it.

> On 04/27/2011 12:08 PM, Jan Engelhardt wrote:
> > On Wednesday 2011-04-27 10:57, Leo Baltus wrote:
> > 
> >> Hi,
> >>
> >> When doing recusive dns queries to dnssec-enbled servers it looks like
> >> ip6tables does not assemble udp packets before filtering takes place.
> >> This results in fragments being dropped.
> > 
> > You need to have nf_defrag_ipv6 loaded for automatic defragmentation. 
> > There are only a few components that depend on it - nf_conntrack and 
> > TPROXY, so it may not be autoloaded if you do not use either.
> > --
> > To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Leo Baltus, internetbeheerder                         /\
NPO ICT Internet Services                            /NPO/\
Sumatralaan 45, 1217 GP Hilversum, Filmcentrum, west \  /\/
beheer@omroep.nl, 035-6773555                         \/
