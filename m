From: Jesper Dangaard Brouer <hawk@diku.dk>
Subject: Re: [Fwd: Re: Shortcuts to counting rules?]
Date: Sat, 8 Nov 2008 11:28:20 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0811081124080.25065@ask.diku.dk>
References: <490B46F0.4010100@hp.com> <alpine.LNX.1.10.0810311906120.29079@fbirervta.pbzchgretzou.qr>
 <490B544B.50903@hp.com> <alpine.LNX.1.10.0811010209040.23833@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0811051922050.6949@ask.diku.dk>
 <alpine.LNX.1.10.0811070405070.27330@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Rick Jones <rick.jones2@hp.com>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mgw1.diku.dk ([130.225.96.91]:40773 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbYKHK2Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Nov 2008 05:28:24 -0500
In-Reply-To: <alpine.LNX.1.10.0811070405070.27330@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 7 Nov 2008, Jan Engelhardt wrote:

> On Wednesday 2008-11-05 19:25, Jesper Dangaard Brouer wrote:
>> On Sat, 1 Nov 2008, Jan Engelhardt wrote:
>>> On Friday 2008-10-31 19:54, Rick Jones wrote:
>>>>>
>>>>> iptables-save | grep ^- | wc -l
>>>>
>>>> Here is where I cop to being a luddite who prefers straight C to calling
>>>> system() :)
>>>
>>> But there is no C library. And libiptc is so strongly internal that
>>> it does not fall under libraries-to-use.
>>
>> I don't see why not to use libiptc.  Its been one of the most stable /
>> less-changed through the years...
>>
>> I'm using libiptc quite extensivly in IPTables::libiptc Perl CPAN module.
>
> Hm yeah. The API might be ok, but the source is ugly. Hence
> the recent slew of patches. I'm still thinking how to pull
> this off so that it gets even less ugly, less big (it is
> essentially compiled twice), and then make it available
> as a standard library.

I would really like if we could make it available as a standard library, 
preferably a dynamic .so lib.  Just like you have recently done with 
libxtables.so.

That would make it easier to make libraries like my IPTables::libiptc Perl 
CPAN module.

Hilsen
   Jesper Brouer

--
-------------------------------------------------------------------
MSc. Master of Computer Science
Dept. of Computer Science, University of Copenhagen
Author of http://www.adsl-optimizer.dk
-------------------------------------------------------------------
