From: Patrick McHardy <kaber@trash.net>
Subject: Re: NetFlow / sFlow / IPFIX network probe proposal
Date: Tue, 30 Mar 2010 18:39:46 +0200
Message-ID: <4BB22952.2050305@trash.net>
References: <faefb3f11003300706x16b73a2coefe5079284583db2@mail.gmail.com> <alpine.LSU.2.01.1003301647320.19967@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Roman Tsisyk <roman@tsisyk.com>, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org, linux-net@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42268 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab0C3Qju (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Mar 2010 12:39:50 -0400
In-Reply-To: <alpine.LSU.2.01.1003301647320.19967@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2010-03-30 16:06, Roman Tsisyk wrote:
> 
>> # Probe one network to first server
>> iptables -A FORWARD -s 192.168.0.0/24 -j PROBE --target 0
>> iptables -A FORWARD -d 192.168.0.0/24 -j PROBE --target 0
>>
>> # Probe another network to second server
>> iptables -A FORWARD -s 192.168.5.0/24 -j PROBE --target 1
>> iptables -A FORWARD -d 192.168.5.0/24 -j PROBE --target 1
>>
>> # Probe outgoing email flow to third server
>> iptables -A FORWARD -s 192.168.5.0/24 --dport 25 -j PROBE --target 2
>> ---
>>
>> 4. Support for exporting statistics via /proc
>> Traffic and packet rate, udp socket information and everything what
>> can be useful.
> 
> Should probably be using netlink or sysfs instead.

We already have conntrack and ctnetlink to gather per-connection
statistics, which should decrease the overhead for doing this in
userspace a lot. There also exists a netflow plugin for ulogd2,
but I'm not sure it was already submitted and merged.
