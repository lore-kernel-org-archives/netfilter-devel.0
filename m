From: Unit Zero <onyx@zero.fdns.net>
Subject: Re: Activating IPTables rules with external files (containing flag
 va lues).
Date: Tue, 24 Feb 2004 08:14:26 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.56L0.0402240755160.882@zero.fdns.net>
References: <019BE2AC0F67D51198C000508B69393F0C1DDCE0@esf-exchange1a.brevard.k12.fl.us>
 <20040216103033.I90371@tempest.prismnet.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Ziemba, Jason@Viera" <jason.ziemba@brevard.k12.fl.us>,
	"'netfilter-devel@lists.netfilter.org'" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Allen Francom <aef@prismnet.com>
In-Reply-To: <20040216103033.I90371@tempest.prismnet.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



On Mon, 16 Feb 2004, Allen Francom wrote:

> Most likely what you are referring to are some settings
> you can change in the /proc file system.
> 
> Files under /proc are actually little windows into
> the live running kernel.
> 
> Some of these deal with networking parameters.
> 
> There are quite a few.  Mostly things work well by
> default, but there are a number of things you might
> want to change.
> 
> I do not know of a single comprehensive resource
> on this topic and I would also like to see a pointer
> to something on it.
> 

Actually, the kernel sources (and in particular the ip/tcp/udp/icmp and 
routing/forwarding and netfilter code, which I have come to know quite 
well, which live in net/ipv4/) are quite extensively commented and it's 
relatively easy to find the code that handles each sysctl and other 
kernel<->userspace communication.

I was able to learn netfilter quite well in just a month or two of 
experimenting with stuff by writing short kernel modules to test out 
various things I was curious about, and now I know enough to have begun 
development of some pretty complicated extensions to the IP networking 
architecture...

A few kernel panics every once in a while aren't so bad :) 

> Good question.
> 
> Sinc,
> -AEF
> 
