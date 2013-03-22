From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH] ulogd2: raw2packet_BASE changes
Date: Fri, 22 Mar 2013 18:40:45 +0000
Message-ID: <514CA5AD.1090707@googlemail.com>
References: <5135E98B.20409@googlemail.com>	 <1362643095.6485.24.camel@tiger2> <51447E4F.1020401@googlemail.com> <1363514765.10781.11.camel@tiger2>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:64668 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab3CVSk6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Mar 2013 14:40:58 -0400
Received: by mail-wi0-f169.google.com with SMTP id c10so97956wiw.0
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Mar 2013 11:40:56 -0700 (PDT)
In-Reply-To: <1363514765.10781.11.camel@tiger2>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Eric Leblond wrote:
> Hello,
>
> On Sat, 2013-03-16 at 14:14 +0000, Mr Dash Four wrote:
>   
>>> I'm wondering if it is not more convenient to simply pass a field with raw
>>> data to the stack and have it used as binary in output plugins.
>>> This way, we will treat all cases (I mean all protocols, ipsec or gre
>>> are not supported in your patch) and the impact on the rest of the
>>> plugins will be smaller.
>>>   
>>>       
>> I don't think so.
>>
>> The very nature of the information contained within strictly depends on 
>> the protocol used in the original connection. If that was udp for 
>> example, then the only "additional information" (in other words, what my 
>> patch can extract from the secondary header) available to the plugins 
>> would be the KEY_O_UDP_* keys and nothing else.
>>
>> Besides, if a binary data is passed to the plugins, that data also needs 
>> to be processed - by *all* plugins connected to the chain, so I don't 
>> see this as a benefit at all.
>>
>>     
>>> I really fear changes on all output plugins will be huge without
>>> handling all cases.
>>>   
>>>       
>> Have you done a performance analysis to make that assumption? If so, 
>> could you post the results for all of us to see what that impact really is?
>>     
>
> Do I ever use the word "performance" ? I'm talking about developing
> work 
>
>   
>>> This will put work on interface and maybe it is a bit too much for them.
>>>   
>>>       
>> Same question as above?
>>     
>
> And same answer, I'm talking here about user interface that use ulogd
> provided data to give information to user. They will have to decode all
> these fields.
>   
The way I read your response, it was clear to me that by "this will put 
work on interface and maybe it is a bit too much for them" you had some 
performance concerns with regards to my patch, hence why I asked the 
questions I did in the previous post. The clue for me was in the "too 
much for them" bit.

If I understood you now correctly, you've explained that you have 
concerns over the re-development of the rest of the plugins necessary to 
accommodate these changes, is that right?

If so, again, from experience, I know that at least 2 plugins will 
require light-to-no-work - the GPRINT (which works well without *any* 
modifications) and the PGSQL plugin. I suspect for the other db plugins 
the situation won't be any different.

Admittedly, I am using a heavily-modified version of the PGSQL plugin 
where it took me about 10 minutes to accommodate these changes, as the 
existing PGSQL plugin (and accompanying sql script) in the ulogd2 
repository is ... well, lets just say that I won't recommend this to my 
competitors, let alone use this myself.

I can't really vouch for the rest of the plugins though, but if I go 
ahead with your suggestion above and distribute the new properties I 
listed in my patch as a binary object, then there will be needed the 
same amount of effort required at the very least, if not more, to modify 
the existing plugins to accommodate these changes, as well as be able to 
process the binary data into something more meaningful, so I don't see 
how this would be any different from what is already done in my patch?

>> I have been using this addition for over 7 months now (mainly as an 
>> extension to the PGSQL and GPRINT plugins as they are most-widely 
>> deployed on my servers here) and from experience I can tell you that, at 
>> least for the TCP part of the original connection, I need the TCP flags 
>> (in addition to everything else), simply because a connection can be 
>> rejected with icmp unreachable because of illegal flags combination. So 
>> in that particular case, I need to have all TCP flags available as keys.
>>     
>
> This information is also available in the binary data I suggest to add.
> And you could get it from there if needed.
>   
Except that you didn't. You suggested that I just include the src/dst ip 
addresses and ports, protocol and nothing more.To quote your previous 
response:

> If we consider the problem from an admin point of view the most
> meaningful information is the tuple (IP src and dest, proto, src and dst
> port) the rest is a bit too much.
>   

Care to highlight where in the above you mention TCP flags?

>> [1] - http://www.spinics.net/lists/netfilter-devel/msg23982.html
>>     
>
> Can you rebase it to current tree and resubmit with white space fixed as
> discussed before ?
>   
Care to address the questions I asked you in that post?

>> [2] - http://www.spinics.net/lists/netfilter-devel/msg23120.html
>>     
>
> Do you have provided a patchset containing the Null dereference fix and
> the SSL feature as asked by Pablo Neira Ayuso ?
>   
I'll do that when I get some answers. Besides, the main purpose of this 
patch wasn't fixing the null dereference bug, but to introduce the SSL 
feature and I am yet to hear from you whether you are happy with that 
part of the patch I provided a couple of months ago.
