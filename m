From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [IPTABLES] the same options for different kinds of matches don't
 work
Date: Fri, 15 Aug 2008 16:38:38 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808151633500.10478@fbirervta.pbzchgretzou.qr>
References: <412e6f7f0808150951u2f2d58afn8340c64fed9de2a2@mail.gmail.com> <48A5CEFE.5090407@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Changli Gao <xiaosuo@gmail.com>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51607 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbYHOUij (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Aug 2008 16:38:39 -0400
In-Reply-To: <48A5CEFE.5090407@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-08-15 14:46, Pablo Neira Ayuso wrote:
>Changli Gao wrote:
>> When using iptables to extent the firewall of Linux, I found that: if
>> there are more than one kinds of iptables matches, only the former
>> options are parsed correctly, but the later options will be treated
>> wrongly.
>> 
>> For example:
>> 
>> iptables -t mangle -A PREROUTING -m a --mac-source 00:11:22:33:44:55
>> -m b --mac-source 00:11:22:33:44:55 -j ACCEPT
>> 
>> the above command will fail due to the later match.
>> 
>> Then I checked the source code of iptables. It seems that the extra
>> options for each match are global for each individual command. It is
>> out of my exception. I used to think that options are only available
>> for that match. So I "fixed" this issues quickly. After patching, the
>> command options contain the default global options and the last match
>> or the target extra options.
>
>I see, it's worth to know this issue. However, my main objection with
>this patch is: is there any match in iptables mainline that actually
>uses two options with clashing names?

- mark, connmark, realm
- ecn and ECN
- multiport and tcp/udp/sctp/dccp.

(There was a reason to my post after all ;-)
