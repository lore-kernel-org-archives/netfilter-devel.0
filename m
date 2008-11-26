From: Bryan Duff <bduff@astrocorp.com>
Subject: Re: Building the conntrack rule from scratch
Date: Wed, 26 Nov 2008 17:24:39 -0600
Message-ID: <492DDAB7.3090209@astrocorp.com>
References: <492DC363.3040304@astrocorp.com> <alpine.LNX.1.10.0811262320120.21265@fbirervta.pbzchgretzou.qr> <492DD46A.7000209@astrocorp.com> <alpine.LNX.1.10.0811270003121.21265@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.astrocorp.com ([64.122.215.18]:21544 "EHLO
	mail.astrocorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbYKZXYI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Nov 2008 18:24:08 -0500
In-Reply-To: <alpine.LNX.1.10.0811270003121.21265@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2008-11-26 23:57, Bryan Duff wrote:
>
>   
>> Here is the rule:
>>
>> conntrack -I --orig-src 192.168.10.10 --orig-dst 192.168.2.206 --reply-src
>> 192.168.2.206 --reply-dst 192.168.2.204 -p udp --orig-port-src 5000
>> --orig-port-dst 7002 --reply-port-src 7002 --reply-port-dst 7000 -u ASSURED -t
>> 60
>>
>> 192.168.10.10 is the phone in my LAN.
>> 192.168.2.204 is the local WAN address.
>> 192.168.2.206 is the remote address.
>>
>> If that above rule is inserted, and I send traffic (that matches the rule) out
>> the WAN from the LAN, why would it not SNAT the rule on the way out  (from
>> orig-src  192.168.10.10  to reply-dst 192.168.2.204)?
>>     
>
> You just set up a NAT mapping and even marked it ASSURED,
> so no further mapping modifications are accepted.
>
>   
Wait.  So I don't need to do anything else?  It should work?  Or is 
there still something I'm not doing (like setting up --src-nat in the 
conntrack -I command)?  Because when the packet from 192.168.10.10 going 
out eth1, is still has a source IP of 192.168.10.10 (and not 192.168.2.204).

I also assume that the SNAT rule below is ignored (when the conntrack 
rule above is used).
>> iptables -t nat -A POSTROUTING -o eth1 -s 192.168.10.1/24 -m realm --realm 1 -j
>> SNAT --to 192.168.2.204
>>     

