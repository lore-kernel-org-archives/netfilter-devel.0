From: Patrick McHardy <kaber@trash.net>
Subject: Re: Automatically load modules in iptables-save
Date: Thu, 19 Mar 2009 14:58:18 +0100
Message-ID: <49C24F7A.4030700@trash.net>
References: <20090316171014.GG31952@ralph.linux2go.dk> <20090319125532.GC20472@ralph.linux2go.dk> <49C24332.2020107@trash.net> <20090319135006.GD20472@ralph.linux2go.dk> <alpine.LSU.2.00.0903191452550.27642@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Soren Hansen <soren@ubuntu.com>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35968 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630AbZCSN6Y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Mar 2009 09:58:24 -0400
In-Reply-To: <alpine.LSU.2.00.0903191452550.27642@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2009-03-19 14:50, Soren Hansen wrote:
>   
>> On Thu, Mar 19, 2009 at 02:05:54PM +0100, Patrick McHardy wrote:
>>     
>>>>> If the iptables modules are not loaded when iptables-save is run,
>>>>> iptables-save will fail, because it can't open the relevant files in
>>>>> /proc.  This patch makes iptables-save attempt to load the modules,
>>>>> and then retries.
>>>>>           
>> Right. I thought about just silently bailing out, but decided to go this
>> route instead. Explanation follows.
>>
>> $ sudo iptables-save
>> iptables-save v1.4.1.1: Unable to open /proc/net/ip_tables_names: No such file or directory
>> $ echo $?
>> 1
>>
>> I decided to try to load the modules instead of just silently returning,
>>     
>
> IMHO, it should not fail, not even silently, but return success.
> If x_tables.ko is not loaded, there cannot be any tables active
> anyway, and thus would be equal to a loaded x_tables.ko with
> no table modules (iptable_filter, etc.) loaded.
>   

That's my opinion as well. I've never understood why so many things are
silently
activated by "list" or "dump" commands.

>> so that if iptables-save succeeds, you can reasonably expect
>> iptables-restore to work as well.
>>     
>
> `echo '' | iptables-restore` does work. One more reason to
> make iptables-save not outputting anything returning 0.
>   

Agreed.
