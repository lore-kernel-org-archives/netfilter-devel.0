From: "George P Nychis" <gnychis@cmu.edu>
Subject: Re: changed 'random' patch for higher precision
Date: Tue, 2 May 2006 12:05:17 -0400 (EDT)
Message-ID: <32875.128.2.140.234.1146585917.squirrel@128.2.140.234>
References: <33328.128.2.140.234.1146369657.squirrel@128.2.140.234>
	<4457650F.7030901@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4457650F.7030901@trash.net>
To: "Patrick McHardy" <kaber@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


> George P Nychis wrote:
>> Hi,
>> 
>> I modified the "random" patch to support high precision averages ...
>> the original random only supports 1-99% in integer intervals
>> 
>> The original patch did this by having an 8 bit integer, reading random
>> bytes from the kernel into an 8 bit integer, and testing between 2 and
>> 252 (1*2.55 and 99*2.55 ... 2.55 coming from 255/100).
>> 
>> Regardless of how the original patch worked, I use a 32 bit integer to
>> support extremely high precision probabilities and changed the ranges
>> to UINT_MAX instead of 255, plus other changes.
>> 
>> I tested it pretty rigurously on the 2.4 kernel because i'm working on
>> a project right now which required high precision drop probabilities
>> 
>> My main question is, should i request changes to the random patch, or
>> completely create a new patch and argument?
> 
> I already have a version of random with higher precision queued for
> 2.6.18. You say you're using UINT_MAX .. can you represent a probability
> of both 0 and 1? :)
> 
> 
> 

Hey Patrick,

Well then this is perfect, because my implementation is for 2.4.32 ... i didn't touch the 2.6 stuff since my project is based on 2.4 kernel.

I can represent a probability of both 0 and 1, as soon as I finish up some work for the day, i'll send out my changes and patch and explain everything

- George
