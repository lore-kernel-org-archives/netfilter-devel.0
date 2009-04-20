From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: Compiling ebtables statically or dynamically results in different
 	behaviour
Date: Mon, 20 Apr 2009 19:43:03 +0200
Message-ID: <49ECB427.7030303@pandora.be>
References: <W8403423488155181239184148@nocme1bl6.telenet-ops.be>	 <2a7fce340904080257r4164cd63hcd5f07b036489aae@mail.gmail.com> <2a7fce340904200227j42e07fd3gbf507539809a4e08@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Tim Verhoeven <tim.verhoeven.be@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:39371 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbZDTRnP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Apr 2009 13:43:15 -0400
In-Reply-To: <2a7fce340904200227j42e07fd3gbf507539809a4e08@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm currently lacking the time, but if you have some programming 
experience, a dump of the data sent to the kernel for the static and 
dynamic version of the code would be great. See ebt_deliver_table() in 
communication.c: the data pointed to by repl and repl->entries 
specifically. Please use a simple table: start with an empty one before 
issuing the command.

cheers,
Bart

Tim Verhoeven schreef:
> On Wed, Apr 8, 2009 at 11:57 AM, Tim Verhoeven
> <tim.verhoeven.be@gmail.com> wrote:
>   
>> On Wed, Apr 8, 2009 at 11:49 AM, bdschuym@pandora.be
>> <bdschuym@telenet.be> wrote:
>>     
>>> What is your exact command and what type of processor are you using?
>>>
>>>       
>> The command run is "ebtables -N 1000"
>>
>> This is /proc/cpuinfo :
>> processor       : 0
>> vendor_id       : GenuineIntel
>> cpu family      : 6
>> model           : 23
>> model name      : Intel(R) Xeon(R) CPU           E5430  @ 2.66GHz
>>     
> ...snip...
>
> Hi again,
>
> Is there any update about this issue ? Can I do anything to help debug
>  the problem ? I have test machines available.
>
> Thanks,
> Tim
>
>   

