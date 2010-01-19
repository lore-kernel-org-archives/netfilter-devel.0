From: Patrick McHardy <kaber@trash.net>
Subject: Re: Group consensus sought on nf_conntrack_sip behavior
Date: Tue, 19 Jan 2010 23:01:52 +0100
Message-ID: <4B562BD0.8020306@trash.net>
References: <20100116103640.GB11547@goonies.be> <4B541272.8040001@trash.net> <20100118174919.GD11547@goonies.be> <4B54A4E7.6020200@trash.net> <20100118193654.GE11547@goonies.be> <4B556C5D.3000006@trash.net> <20100119172306.GF11547@goonies.be> <4B55F54E.4020205@trash.net> <20100119182535.GG11547@goonies.be> <4B55FC78.80001@trash.net> <20100119193655.GI11547@goonies.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Greg Alexander <greqcs@galexander.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55502 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab0ASWB4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jan 2010 17:01:56 -0500
In-Reply-To: <20100119193655.GI11547@goonies.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Greg Alexander wrote:
> On Tue, Jan 19, 2010 at 07:39:52PM +0100, Patrick McHardy wrote:
>> Well, I'll add one final point. You mentioned the IRC helper
>> as precedent, without referring to anything concrete. You're
>> mistaken though, the destination address is fixed. But I see
>> where your misunderstanding might come from.
>>
>> What the SIP helper does is allow expectations between *arbitrary*
>> hosts when the direct_media option is off - the destination address
>> originates from the SDP payload, the source address is a wildcard.
> 
> *sigh*
> 
> I offered a DCC send from an internal host with nf_nat_irc:
>   # cat /proc/net/ip_conntrack_expect
>   289 proto=6 src=0.0.0.0 dst=98.223.156.20 sport=0 dport=4110
>                   ^^^^^^^                         ^
> 
> I offered an RTP stream from an internal host using SIP/SDP with
> nf_conntrack_sip sip_direct_media=0 (and nf_nat_sip of course):
>   # cat /proc/net/ip_conntrack_expect
>   179 proto=17 src=0.0.0.0 dst=98.223.156.20 sport=0 dport=7078
>   179 proto=17 src=0.0.0.0 dst=98.223.156.20 sport=0 dport=7079
>                    ^^^^^^^                         ^

You are obviously unable to read. Why don't you go troll somewhere else.

