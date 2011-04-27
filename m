From: Ulrich Weber <ulrich.weber@googlemail.com>
Subject: Re: ip6tables breaks dnssec?
Date: Wed, 27 Apr 2011 12:43:19 +0200
Message-ID: <4DB7F347.1080107@gmail.com>
References: <20110427085755.GD2418@omroep.nl> <alpine.LNX.2.01.1104271200480.12004@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Leo Baltus <Leo.Baltus@omroep.nl>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33624 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756743Ab1D0KnX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:43:23 -0400
Received: by wya21 with SMTP id 21so1134727wya.19
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2011 03:43:22 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1104271200480.12004@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Each fragmented IPv6 packets will traverse netfilter separately,
in contrast to IPv4, where its only one refragmented packet.

"ip6tables -A INPUT -j ACCEPT -p udp --dport 53" will only match the
first fragment, where the UDP header can be found. To match the
additional fragments, you have to insert these rules:

ip6tables -I INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
ip6tables -I OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

Cheers
 Ulrich

On 04/27/2011 12:08 PM, Jan Engelhardt wrote:
> On Wednesday 2011-04-27 10:57, Leo Baltus wrote:
> 
>> Hi,
>>
>> When doing recusive dns queries to dnssec-enbled servers it looks like
>> ip6tables does not assemble udp packets before filtering takes place.
>> This results in fragments being dropped.
> 
> You need to have nf_defrag_ipv6 loaded for automatic defragmentation. 
> There are only a few components that depend on it - nf_conntrack and 
> TPROXY, so it may not be autoloaded if you do not use either.
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

