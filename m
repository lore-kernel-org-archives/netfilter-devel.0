From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix NAT TCP sequence adjustment
Date: Tue, 31 May 2005 16:35:21 +0200
Message-ID: <429C7629.4010602@trash.net>
References: <20050402202438.GA2968@linuxace.com>	
	<1117531044.7878.18.camel@localhost.localdomain>	
	<429C6077.3060503@trash.net>
	<1117547304.7878.42.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <1117547304.7878.42.camel@localhost.localdomain>
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

Rusty Russell wrote:
> On Tue, 2005-05-31 at 15:02 +0200, Patrick McHardy wrote:
> 
>> Second of all, I spent like 10 hours to verify the
>>proposed fixes, and I am still convinced that it is correct.
> 
> Which shows exactly *why* we have a testsuite.  Dammit, I didn't spend
> all those hours on it for fun.
> 
> You spent *10* hours, and the testsuite runs in 5 seconds (60 seconds
> counting build time the first time).

I don't get your point - I know why we have a testsuite. You're
complaining that I had more important things to do than add tests to a
testsuite that didn't even run on my system until perhaps 4 hours ago,
after spending considerable time fixing the fallout from your patches?

In any case, without identifying the problems, you can't test for them.
It looks like your tests won't even trigger the original problem, let
alone the problem case I identified in Phil's proposed patch. So if I
had relied on it, we would now have an incorrect fix. And no, the 10
hours won't be wasted, as I already said before, I'll add proper tests
when nfsim runs on my system and I have time.

> <sigh>

Sigh indeed.

> I fixed the testsuite, so now when I get bored I can come up with a
> patch which removes those horrible hooks you added (sure, I may have to
> rewrite everything to do it).

Feel free to do so. Its not hard to replace them, the alternative just
felt a bit unsafe for -rc3.
