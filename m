From: Patrick McHardy <kaber@trash.net>
Subject: Re: Plans for future iptables versions / jumpset feature
Date: Fri, 23 May 2008 15:28:37 +0200
Message-ID: <4836C685.90207@trash.net>
References: <1211482843.28066.40.camel@enterprise.ims-firmen.de>	 <4835C6F0.5080604@trash.net> <00d501c8bccb$d7922000$86b66000$@com>	 <4836B562.6000302@trash.net> <1211546846.32088.8.camel@enterprise.ims-firmen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jacob <jacob@internet24.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36367 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbYEWN2k (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 May 2008 09:28:40 -0400
In-Reply-To: <1211546846.32088.8.camel@enterprise.ims-firmen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thomas Jacob wrote:
> On Fri, 2008-05-23 at 14:15 +0200, Patrick McHardy wrote:
>> Basically, you'd change (in ipt_do_table):
>>
>>                                  int newpos = t->verdict; 
>>
>>
>> to get the new position from the target module. This probably
>> requires to change the target function signature. Alternatively
>> you could try to encode it in the verdict. Loop detection
>> needs some way to get all possible jumps from the target
>> and check each possible path. Maybe the easiest way is probably
>> a target built into ip_tables.c
> 
> Out of curiosity, if Nishit would actually do it (@Nishit: if you do,
> maybe we could work together on this?) but there are really major
> changes afoot for netfilter during the course of this year, wouldn't
> those changes make such an extension obsolete and/or pretty
> difficult to port to the new netfilter?

If its sanely designed, there shouldn't be much trouble porting
it, especially since this feature will be implemented anyways.

