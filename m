From: Samuel Jean <sj-netfilter@cookinglinux.org>
Subject: Re: [PATCH] ipt_hashlimit.c: expire's type overflow when showing
 tuples at bad moment.
Date: Tue, 01 Feb 2005 16:47:53 -0500
Message-ID: <41FFF909.9050509@cookinglinux.org>
References: <41F2FE92.6020603@cookinglinux.org>	<20050201132915.GJ6878@sunbeam.de.gnumonks.org>	<41FF877D.4080309@trash.net>	<20050201135423.GS6878@sunbeam.de.gnumonks.org>	<41FF9024.3070101@trash.net>	<6732.142.169.215.10.1107269629.squirrel@142.169.215.10>
	<41FFC770.2090401@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <41FFC770.2090401@trash.net>
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

Patrick McHardy wrote:
> On my system (x86_64, gcc-3.3.5) va_arg returns 2^32-1 for -1, but it
> should return 2^64-1. Are you seeing this problem on a 32bit or a 64bit
> machine ?

It's on x86 32bits, gcc-3.3.4.
Here's an exemple of consecutive cat:

# cat /proc/net/ipt_hashlimit/moo
0 x.239.59.104:0->0.0.0.0:0 1600 1600 320
0 x.162.158.131:0->0.0.0.0:0 1600 1600 320

# cat /proc/net/ipt_hashlimit/moo
4294967 x.239.59.104:0->0.0.0.0:0 1600 1600 320
4294967 x.162.158.131:0->0.0.0.0:0 1600 1600 320

# cat /proc/net/ipt_hashlimit/moo
#

 From what I can think, it goes bad only when a third operation comes into.
Here's what happen without dividing by HZ.

# cat /proc/net/ipt_hashlimit/moo
6 206.162.158.131:0->0.0.0.0:0 1600 1600 320

# cat /proc/net/ipt_hashlimit/moo
-447 206.162.158.131:0->0.0.0.0:0 1600 1600 320


> 
> Regards
> Patrick
> 
Hope this can help,

Samuel
