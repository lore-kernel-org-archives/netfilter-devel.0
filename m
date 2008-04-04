From: Bhaskar <vbhaskar@rocsys.com>
Subject: Re: What does SPI firewall Mean?
Date: Fri, 04 Apr 2008 14:53:04 +0530
Message-ID: <47F5F378.3010304@rocsys.com>
References: <47F5D9A7.4000403@rocsys.com> <alpine.LNX.1.10.0804041035350.1301@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp102.biz.mail.mud.yahoo.com ([68.142.200.237]:33993 "HELO
	smtp102.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752768AbYDDJ15 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Apr 2008 05:27:57 -0400
In-Reply-To: <alpine.LNX.1.10.0804041035350.1301@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

SPI  - Stateful Packet Inspection Firewall
NW - Network

"That is because -- despite the connection "association" being active --
you only allow http from eth0->eth1 but not the reverse direction. "

How do I make sure that the associate be used?
Jan Engelhardt wrote:
>
> On Friday 2008-04-04 09:32, Bhaskar wrote:
>
>> I have been thinking about this questions.  The obvious answer I got is
>> SPI firewall understands the states of the packet flow
>
> Security Parameter Index
> Single Packet Inspection
> Stateless Packet Inspection
> Stateful Packet Inspection
> ...
> FWIW PCMCIA!</sarcasm>
>
> (I have no joy figuring out what all your acronyms, SPI and NW mean.)
>
>>   1. iptables -A FORWARD -i eth0 -o eth1 -p tcp -m state --state
>>      NEW,ESTABLISHED --dport 80 -j ACCEPT
>>   2. iptabgles -A FORWARD -i eth0 -o eth1 -p udp -m udp --dport 53 -j
>>      ACCEPT
>>   3. iptables -A FORWARD -j LOG --log-prefix "Dropping Other Packets:"
>>   4. iptables -A FORWARD -j DROP
>>
>>   1. iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
>>
>> The intension is to allow HTTP Traffic to the internal network.  With
>> the above setup I am not able to browse from PC connected in Protected
>> NW.
>
> That is because -- despite the connection "association" being active --
> you only allow http from eth0->eth1 but not the reverse direction.
>
>> After analyzing the Logs and added another 2 policies above Policy
>> Number 3:
>> iptables -A FORWARD -i eth1 -o eth0 -p tcp -m state --state
>> NEW,ESTABLISHED --sport 80 -j ACCEPT
>> iptables -A FORWARD -i eth1 -o eth0 -p udp -m udp --sport 53 -j ACCEPT
>>
>> After adding these policies I am able to browse.  AFAIK, once an
>> association is created (first time when packet is passing through
>> netfilter), the associated traffic would flow and Policies are not
>> parsed for the verdict.
> -- 
> To unsubscribe from this list: send the line "unsubscribe
> netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

