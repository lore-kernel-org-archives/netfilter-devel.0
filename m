From: Amin Azez <azez@ufomechanic.net>
Subject: Re: no ctstat? Re: building libctnetlink
Date: Wed, 06 Apr 2005 15:59:32 +0100
Message-ID: <d30tcp$tsc$1@sea.gmane.org>
References: <423BF227.8030502@outerspace.dyndns.org>		<423BF4DC.2070902@outerspace.dyndns.org>		<1111335091.2523.46.camel@lap-ufomechanic>		<1111335425.2523.49.camel@lap-ufomechanic>	<423DF940.100@eurodev.net>		<1111412190.2716.55.camel@lap-ufomechanic>	<423F007F.2060102@eurodev.net>	<1111667756.2526.19.camel@lap-ufomechanic>	<4242B977.1030607@eurodev.net>
	<d2rpmi$3n8$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <d2rpmi$3n8$1@sea.gmane.org>
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

Sam Liddicott wrote:
> Pablo Neira wrote:
> 
>> Just another UFO mechanic wrote:
>>
>>> I am still trying to compile libctnetlink and libnfnetlink I cannot find
>>> a whole lot of info on it. I have 2 questions
>>>
>>> When I try compile
>>> I get the error
>>> libctnetlink.c:32:39 linux/nfnetlink_conntrack.h: No such file or
>>> directory
>>
>>
>>
>> Have you applied `nfnetlink-ctnetlink-0.13' in pom-ng? Add 
>> -I/your/kernel/include/path to your compilation script.
> 
> 
> Thanks for the tip Pablo; probably a case of user error; but:
> 
> When I try to apply nfnetlink-ctnetlink-0.13 from the latest pom-ng 
> (20050403), I am told:
> 
> nfnetlink-ctnetlink-0.13 has dependency on ctstat, but ctstat is not known
> cannot apply (9 rejects out of 42 hunks)
> 
> As far as I can tell ctstats was added to pom-ng in around September 
> 2004 time. There is a ctstat folder in my un-tar'd pom-ng, but it is empty.
> 
> I'm running patch-o-matic against iptables 1.2.11 and kernel 2.6.10
> source.

So after much looking, for my part, according to section 6.2 of the 2004 
workshop summary at 
http://www.netfilter.org/documentation/conferences/nf-workshop-2004-summary.html
  ctstat has already been merged with... with....

and there you have it.

I can't tell if ctstat has been merged with any particular kernel 
version or any particular iptables version or both.

This file, 
http://people.netfilter.org/gandalf/old/ctstat/ctstat-040215-2.6, hints 
that ctstat may have been merged with kernel 2.6

So assuming that you do have ctstat merged somehow (and 
ct_cpu_seq_show() seems to be defined in ip_conntrack_standalone.c on 
2.6.10), edit nfnetlink-ctnetlink-0.13/info and remove the dependancy on 
ctstat and then apply with
   ... ... ./runme --batch nfnetlink-ctnetlink-0.13

You'll still get a failure to apply though, which I'm looking into. I'll 
post back when I find out more, I'm going to try it on 2.6.11 and then 
look at the rejects more closely if that doesn't work.

Amin
