From: Bryan Duff <bduff@astrocorp.com>
Subject: Re: Building the conntrack rule from scratch
Date: Wed, 26 Nov 2008 16:57:46 -0600
Message-ID: <492DD46A.7000209@astrocorp.com>
References: <492DC363.3040304@astrocorp.com> <alpine.LNX.1.10.0811262320120.21265@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.astrocorp.com ([75.160.64.129]:21669 "EHLO
	mail.astrocorp.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752260AbYKZW5g (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Nov 2008 17:57:36 -0500
In-Reply-To: <alpine.LNX.1.10.0811262320120.21265@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Here is the rule:

conntrack -I --orig-src 192.168.10.10 --orig-dst 192.168.2.206 
--reply-src 192.168.2.206 --reply-dst 192.168.2.204 -p udp 
--orig-port-src 5000 --orig-port-dst 7002 --reply-port-src 7002 
--reply-port-dst 7000 -u ASSURED -t 60

192.168.10.10 is the phone in my LAN.
192.168.2.204 is the local WAN address.
192.168.2.206 is the remote address.

If that above rule is inserted, and I send traffic (that matches the 
rule) out the WAN from the LAN, why would it not SNAT the rule on the 
way out  (from orig-src  192.168.10.10  to reply-dst 192.168.2.204)?

iptables -t nat -A POSTROUTING -o eth1 -s 192.168.10.1/24 -m realm 
--realm 1 -j SNAT --to 192.168.2.204

Thanks.

-Bryan

Jan Engelhardt wrote:
> On Wednesday 2008-11-26 22:45, Bryan Duff wrote:
>
>   
>> If I build a conntrack rule (before any traffic actually traverses), and then
>> send traffic through, the conntrack rule gets used, but no SNAT takes place.
>>     
>
> Elaborate?
>
>   
>> Tell me if I'm missing something, or if more information is needed.
>>     
>
> The actual "rule".
>   

