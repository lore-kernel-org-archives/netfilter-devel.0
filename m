From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [IPTABLES] the same options for different kinds of matches don't
 work
Date: Fri, 15 Aug 2008 20:46:22 +0200
Message-ID: <48A5CEFE.5090407@netfilter.org>
References: <412e6f7f0808150951u2f2d58afn8340c64fed9de2a2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60070 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751352AbYHOUWq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Aug 2008 16:22:46 -0400
In-Reply-To: <412e6f7f0808150951u2f2d58afn8340c64fed9de2a2@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Changli Gao wrote:
> When using iptables to extent the firewall of Linux, I found that: if
> there are more than one kinds of iptables matches, only the former
> options are parsed correctly, but the later options will be treated
> wrongly.
> 
> For example:
> 
> iptables -t mangle -A PREROUTING -m a --mac-source 00:11:22:33:44:55
> -m b --mac-source 00:11:22:33:44:55 -j ACCEPT
> 
> the above command will fail due to the later match.
> 
> Then I checked the source code of iptables. It seems that the extra
> options for each match are global for each individual command. It is
> out of my exception. I used to think that options are only available
> for that match. So I "fixed" this issues quickly. After patching, the
> command options contain the default global options and the last match
> or the target extra options.

I see, it's worth to know this issue. However, my main objection with
this patch is: is there any match in iptables mainline that actually
uses two options with clashing names?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
