From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: What does SPI firewall Mean?
Date: Fri, 4 Apr 2008 11:47:14 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804041144420.1301@fbirervta.pbzchgretzou.qr>
References: <47F5D9A7.4000403@rocsys.com> <alpine.LNX.1.10.0804041035350.1301@fbirervta.pbzchgretzou.qr> <47F5F378.3010304@rocsys.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@vger.kernel.org
To: Bhaskar <vbhaskar@rocsys.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51922 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbYDDJrP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Apr 2008 05:47:15 -0400
In-Reply-To: <47F5F378.3010304@rocsys.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-04-04 11:23, Bhaskar wrote:
>> That is because -- despite the connection "association" being active --
>> you only allow http from eth0->eth1 but not the reverse direction.
>
> How do I make sure that the associate be used?

They are used. But you do not allow them.
As you said, you need

>>> After analyzing the Logs and added another 2 policies above Policy
>>> Number 3:
>>> iptables -A FORWARD -i eth1 -o eth0 -p tcp -m state --state
>>> NEW,ESTABLISHED --sport 80 -j ACCEPT
>>> iptables -A FORWARD -i eth1 -o eth0 -p udp -m udp --sport 53 -j ACCEPT

or rewrite your existing rules...

>>>   1. iptables -A FORWARD -i eth0 -o eth1 -p tcp -m state --state
>>>      NEW,ESTABLISHED --dport 80 -j ACCEPT
>>>   2. iptabgles -A FORWARD -i eth0 -o eth1 -p udp -m udp --dport 53 -j
>>>      ACCEPT
>>>   3. iptables -A FORWARD -j LOG --log-prefix "Dropping Other Packets:"
>>>   4. iptables -A FORWARD -j DROP
>>>
>>>   1. iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE

...to be something like:
  iptables -A FORWARD -m conntrack --ctstate ESTABLISHED -j ACCEPT
  iptables -A FORWARD -i eth0 -o eth1 -p tcp -m conntrack --ctstate NEW
     --dport 80 -j ACCEPT
  iptables -A FORWARD -i eth0 -o eth1 -p tcpp --dport 53 -j ACCEPT
(DNS can also go over TCP!)
  iptables -A FORWARD -i eth0 -o eth1 -p udp --dport 53 -j ACCEPT
  iptables -A FORWARD -j LOG --log-prefix "dropping others"
  iptables -A FORWARD -P DROP
(no need for -j DROP at the end when you can do it with -P)
