From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: AW: Add new target in mangle table
Date: Mon, 14 Apr 2008 12:20:35 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804140921290.9651@fbirervta.pbzchgretzou.qr>
References: <20080414071710.C0E061802C4D8@sovereign.computergmbh.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Manuel Scheub <manuprivat@gmx.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33045 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbYDNKUg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:20:36 -0400
In-Reply-To: <20080414071710.C0E061802C4D8@sovereign.computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-04-14 09:10, Manuel Scheub wrote:
>
>>>Hi developers,
>>>
>>>I encountered difficulties during integrating a new target in mangle
>>>table (iptables-1.4.0 (from www.netfilter.org), kernel-2.6.23 (from
>>>www.kernel.org)). 
>>>I have a master from iptables-1.2.9 and kernel-2.6.3. But there were too
>>>many differences and changes be made.
>>>The idea behind to add the target is, that a user who has a fix-ip entry
>>>in his network settings can be handled from a gateway, for which the new
>>>targets should be implemented. for example:
>>>
>>># iptables -t mangle -I PREROUTING -i eth2 -s 192.168.0.168 -j SADDR
>>>--to-source 10.0.19.2
>>
>>This looks pretty much like RAWNAT, as posted in 
>>http://marc.info/?l=netfilter-devel&m=120024054521550&w=2 .
>>
>Excuse me, but I didn?t get the solution for the RAWNAT issue.
>Maybe it refers to that I'm not so familiar with the netfilter stuff.
>
>Is it possible to realize my issue, or do I have problems with the
>conntrack?

Could you describe the target a bit closer? I did not quite get what you 
mean by "user who has a fixed IP address can be handled(?) from [by?] a 
gateway". Because your code (SADDR) does seem to only change the source 
address, I guessed it is equivalent to RAWSNAT.



>Where can I find the source code for the RAWNAT target.

It is in a git repository at 
http://dev.computergmbh.de/gitweb.cgi?p=xtables-addons (there is also 
the git:// URL for cloning), and http://tinyurl.com/4qoylk would give 
you a snapshot in tar format.
