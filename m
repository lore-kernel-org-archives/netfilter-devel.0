From: Rick Jones <rick.jones2@hp.com>
Subject: Re: [Fwd: Re: Shortcuts to counting rules?]
Date: Wed, 05 Nov 2008 10:55:50 -0800
Message-ID: <4911EC36.3040701@hp.com>
References: <490B46F0.4010100@hp.com>	<alpine.LNX.1.10.0810311906120.29079@fbirervta.pbzchgretzou.qr>	<490B544B.50903@hp.com>	<alpine.LNX.1.10.0811010209040.23833@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0811051922050.6949@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Jesper Dangaard Brouer <hawk@diku.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:18063 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbYKESzy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Nov 2008 13:55:54 -0500
In-Reply-To: <Pine.LNX.4.64.0811051922050.6949@ask.diku.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jesper Dangaard Brouer wrote:
> On Sat, 1 Nov 2008, Jan Engelhardt wrote:
> 
>> On Friday 2008-10-31 19:54, Rick Jones wrote:
>>
>>>>
>>>> iptables-save | grep ^- | wc -l
>>>
>>>
>>> Here is where I cop to being a luddite who prefers straight C to calling
>>> system() :)
>>
>>
>> But there is no C library. And libiptc is so strongly internal that
>> it does not fall under libraries-to-use.
> 
> 
> I don't see why not to use libiptc.  Its been one of the most stable / 
> less-changed through the years...

I wouldn't mind using libiptc, but it seems to be something the 
maintainers don't want mere mortals using.  Also, and perhaps as a 
result, it isn't entirely clear that even installing an iptables-dev 
package (on which I'd rather not have netperf rely if I can avoid it) 
actually gives a libiptc everywhere.

That leaves deciphering at least some of what the existing libiptc code 
does and mimmicing it in netperf :(

rick jones

> 
> I'm using libiptc quite extensivly in IPTables::libiptc Perl CPAN module.
> 
> Hilsen
>   Jesper Brouer
> 
> -- 
> -------------------------------------------------------------------
> MSc. Master of Computer Science
> Dept. of Computer Science, University of Copenhagen
> Author of http://www.adsl-optimizer.dk
> -------------------------------------------------------------------
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

