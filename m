From: Bas van Sisseren <bas@quarantainenet.nl>
Subject: Re: [PATCH] ipt_REDIRECT: only change dest-ip if not local ip
Date: Fri, 16 Jul 2010 14:42:19 +0200
Message-ID: <4C4053AB.8050300@quarantainenet.nl>
References: <4C402DBD.3010007@quarantainenet.nl> <4C404EAC.7050509@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.quarantaine.net ([217.114.102.88]:59524 "EHLO
	main.qone.quarantainenet.nl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965326Ab0GPMm2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Jul 2010 08:42:28 -0400
In-Reply-To: <4C404EAC.7050509@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Patrick,

In most situations, all addresses are known in advance (although we have
some situations where we both have a static address and a dhcp'ed address on
the same interface).

The problem is that we can't tell the other end to use the first address on
the interface. Some systems use the first address, others use the second
address. When a connection is set up from the remote system to the second
address, the original REDIRECT redirects the connection to the configured
port-number on the first address.

It seems way more logical to me to keep the destination address the same and
only change the port number if the destination address is locally configured
on that interface.


Assume:
  eth0 has these addresses:
    10.1.0.1, netmask 255.255.255.0  (primary address)
    10.2.0.1, netmask 255.255.255.0
    10.3.0.1, netmask 255.255.255.0
    10.4.0.1, netmask 255.255.255.0

  and redirects from.. say.. port 80 to 8080

  Connections to 10.1.0.1:80 will be redirected to 10.1.0.1:8080
  But also all connections to 10.2.0.1:80, 10.3.0.1:80 and
  10.4.0.1:80 will be redirected to 10.1.0.1:8080


With the patch, the connection to 10.2.0.1:80 will be redirected to
10.2.0.1:8080, 10.3.0.1:80 to 10.3.0.1:8080, etc..



On 16/07/10 14:21, Patrick McHardy wrote:
> Am 16.07.2010 12:00, schrieb Bas van Sisseren:
>> Hello,
>>
>> When redirecting, the destination address is replaced by the first
>> ip-address on the receiving interface.
>>
>> If the packet originally was sent to the second ip-address (or third,
>> fourth, etc..), this patch doesn't change the destination ip.
> 
> So I guess you use statically configured address that are known
> in advance. So why don't you simply set up your ruleset to only
> redirect packets sent to the first address? That avoids iterating
> through the entire address list for each new connection, which
> can be quite large.
> 
>>
>> ============
>> --- linux.orig/net/ipv4/netfilter/ipt_REDIRECT.c
>> +++ linux/net/ipv4/netfilter/ipt_REDIRECT.c
>> @@ -78,7 +78,21 @@
>>         rcu_read_lock();
>>         indev = __in_dev_get_rcu((*pskb)->dev);
>>         if (indev && (ifa = indev->ifa_list))
>> +       {
>> +           struct in_ifaddr *ifa_cur; // interface ip-list cursor
>> +
>> +           // set current destination ip
>> +           newdst = ((struct iphdr*)skb_network_header(*pskb))->daddr;
>> +
>> +           // iterate through interface ip list
>> +           for (ifa_cur = ifa; ifa_cur; ifa_cur = ifa_cur->ifa_next)
>> +               if (newdst == ifa_cur->ifa_local)
>> +                   goto newdst_is_local;
>> +
>> +           // set new destination to first ip of this interface
>>             newdst = ifa->ifa_local;
>> +       }
>> +   newdst_is_local:
>>         rcu_read_unlock();
>>
>>         if (!newdst)
>> ============
>>
>> Kind regards,
>>
>> Bas van Sisseren

-- 
Bas van Sisseren <bas@quarantainenet.nl>
Quarantainenet
