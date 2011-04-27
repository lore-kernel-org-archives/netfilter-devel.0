From: Stephen Clark <sclark46@earthlink.net>
Subject: Re: ip6tables breaks dnssec?
Date: Wed, 27 Apr 2011 08:54:24 -0400
Message-ID: <4DB81200.8060909@earthlink.net>
References: <20110427085755.GD2418@omroep.nl> <alpine.LNX.2.01.1104271200480.12004@obet.zrqbmnf.qr> <4DB7F347.1080107@gmail.com> <alpine.LNX.2.01.1104271321060.10844@obet.zrqbmnf.qr>
Reply-To: sclark46@earthlink.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ulrich Weber <ulrich.weber@googlemail.com>,
	Leo Baltus <Leo.Baltus@omroep.nl>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from elasmtp-kukur.atl.sa.earthlink.net ([209.86.89.65]:45505 "EHLO
	elasmtp-kukur.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756327Ab1D0My3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Apr 2011 08:54:29 -0400
In-Reply-To: <alpine.LNX.2.01.1104271321060.10844@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 04/27/2011 07:22 AM, Jan Engelhardt wrote:
> On Wednesday 2011-04-27 12:43, Ulrich Weber wrote:
>
>    
>> Each fragmented IPv6 packets will traverse netfilter separately,
>> in contrast to IPv4, where its only one refragmented packet.
>>      
> Not really. All fragments enter nf_hook_slow, be it IPv4 or IPv6.
> It's just that nf_defrag - which is a netfilter module - collects and
> suppresses fragments before spitting out the unfragmented one.
>
>    
>> "ip6tables -A INPUT -j ACCEPT -p udp --dport 53" will only match the
>> first fragment, where the UDP header can be found. To match the
>> additional fragments, you have to insert these rules:
>>
>> ip6tables -I INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
>> ip6tables -I OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
>>      
> That will load nf_conntrack_ipv6, and because conntrack depends on
> nf_defrag_ipv6, will load that too. Once it is loaded, packets should
> be defragmented independetly of whether you actually use -m conntrack
> (or the obsolete -m state) or not.
>    
Jan,

are you saying we should be using -m conntrack now instead of -m state 
and that -m state is going away?

> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>    


-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



