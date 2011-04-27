From: Leo Baltus <Leo.Baltus@omroep.nl>
Subject: Re: ip6tables breaks dnssec?
Date: Wed, 27 Apr 2011 13:41:39 +0200
Message-ID: <20110427114138.GC9859@omroep.nl>
References: <20110427085755.GD2418@omroep.nl>
 <alpine.LNX.2.01.1104271200480.12004@obet.zrqbmnf.qr>
 <4DB7F347.1080107@gmail.com>
 <alpine.LNX.2.01.1104271321060.10844@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ulrich Weber <ulrich.weber@googlemail.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from out1b.mail.omroep.nl ([145.58.30.185]:55495 "EHLO
	out1b.mail.omroep.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758316Ab1D0Llh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Apr 2011 07:41:37 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1104271321060.10844@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Op 27/04/2011 om 13:22:57 +0200, schreef Jan Engelhardt:
> On Wednesday 2011-04-27 12:43, Ulrich Weber wrote:
> 
> >Each fragmented IPv6 packets will traverse netfilter separately,
> >in contrast to IPv4, where its only one refragmented packet.
> 
> Not really. All fragments enter nf_hook_slow, be it IPv4 or IPv6.
> It's just that nf_defrag - which is a netfilter module - collects and 
> suppresses fragments before spitting out the unfragmented one.
> 
> >"ip6tables -A INPUT -j ACCEPT -p udp --dport 53" will only match the
> >first fragment, where the UDP header can be found. To match the
> >additional fragments, you have to insert these rules:
> >
> >ip6tables -I INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
> >ip6tables -I OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
> 
> That will load nf_conntrack_ipv6, and because conntrack depends on 
> nf_defrag_ipv6, will load that too. Once it is loaded, packets should 
> be defragmented independetly of whether you actually use -m conntrack 
> (or the obsolete -m state) or not.

my /proc/config.gs says:
CONFIG_NF_CONNTRACK_IPV6=y
so it is already loaded

But is does not defrag.

Also I am a bit worried about using conntrack because of the high
volume dns queries tend to be which would generate a very large
connectiontracking table and/or system load.

-- 
Leo Baltus, internetbeheerder                         /\
NPO ICT Internet Services                            /NPO/\
Sumatralaan 45, 1217 GP Hilversum, Filmcentrum, west \  /\/
beheer@omroep.nl, 035-6773555                         \/
