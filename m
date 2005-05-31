From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] Fix NAT TCP sequence adjustment
Date: Tue, 31 May 2005 23:48:24 +1000
Message-ID: <1117547304.7878.42.camel@localhost.localdomain>
References: <20050402202438.GA2968@linuxace.com>
	<1117531044.7878.18.camel@localhost.localdomain>
	<429C6077.3060503@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <429C6077.3060503@trash.net>
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

On Tue, 2005-05-31 at 15:02 +0200, Patrick McHardy wrote:
>  Second of all, I spent like 10 hours to verify the
> proposed fixes, and I am still convinced that it is correct.

Which shows exactly *why* we have a testsuite.  Dammit, I didn't spend
all those hours on it for fun.

You spent *10* hours, and the testsuite runs in 5 seconds (60 seconds
counting build time the first time).

<sigh>

I fixed the testsuite, so now when I get bored I can come up with a
patch which removes those horrible hooks you added (sure, I may have to
rewrite everything to do it).

Rusty.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
