From: Samuel Jean <sj-netfilter@cookinglinux.org>
Subject: Re: [testsuite] ipt_iprange
Date: Thu, 16 Dec 2004 20:26:02 -0500
Message-ID: <41C235AA.9030006@cookinglinux.org>
References: <41C213FB.2000101@cookinglinux.org>
	<1103246257.29545.39.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <1103246257.29545.39.camel@localhost.localdomain>
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

> 1) I like all the tests to only test one thing, and be as orthogonal and
> simple as possible.  So I always try to use the same rule over and over,
> with very simply changes.

It is very interesting.

> 
> 2) The default setup is eth0: 192.168.0.*, and eth1: 192.168.1.*, so
> unless there's a good reason you should probably stick with those
> address ranges.
> 

This is noted.

> 4) The opposite case is always the exact opposite, making it simple to
> write the test and ensure it's correct.
> 

So far, this is the best way to do. I appreciate this come back and will 
stick to your way.

Thanks a bunch,

--peejix
