From: Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH v2 2/5] ipset: add "inner" flag implementation
Date: Sat, 29 Jun 2013 15:05:29 +0100
Message-ID: <51CEE9A9.4090109@googlemail.com>
References: <cover.1371423775.git.mr.dash.four@googlemail.com> <51BE49D4.1010901@googlemail.com> <alpine.DEB.2.00.1306262149560.17378@blackhole.kfki.hu> <51CCBE8A.3080305@googlemail.com> <alpine.DEB.2.00.1306291247010.25929@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:54101 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab3F2OFj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Jun 2013 10:05:39 -0400
Received: by mail-wg0-f47.google.com with SMTP id l18so2483995wgh.14
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Jun 2013 07:05:38 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1306291247010.25929@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Jozsef Kadlecsik wrote:
>> As you've probably guessed, I kept the old functions and their parameters in
>> order to preserve the existing interface API, since any changes I make to
>> these will break existing code using them. If there is no objection and there
>> is no such requirement, I'll get rid of them in the next release of the
>> patches - just let me know.
>>     
>
> Yes, there's no such requirement and remove the backward compatibility 
> part.
>   
OK, I'll remove it then.

> The return value of ip[6]_hdr was never checked in ipset code yet, because 
> it doesn't return NULL at the point where these code parts are called. 
> It's an unnecessary checking.
>   
Fair enough - I'll remove that check too.

>> I disagree. By having "return false" (or "return 0", "return -1" and so on)
>> instead of "goto err" it is not immediately apparent to someone who
>> studies/reviews/uses the code that this is an error condition/path. I have
>> been in that situation many times when I have to go back and look at a
>> particular function call to see what "return false" or "return 0" actually
>> means.
>>
>> By including "goto err" instead of multiple "return false" statement, that
>> makes it instantly obvious what the purpose of that statement is without
>> having to look elsewhere.
>>     
>
> I see the point, to self-document the code, with the price of more lines. 
> It's a little bit overdoing in my opinion: pretty apparent which is the 
> error path and which is not. But this is highly a personal taste, I won't 
> press it.
>   
In other words, you'll be happy for me to leave things as they are - 
with the "goto"?
