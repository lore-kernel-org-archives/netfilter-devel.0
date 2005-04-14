From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: About matching (also was: Multiple Targets)
Date: Thu, 14 Apr 2005 03:14:31 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0504140311270.16405@filer.marasystems.com>
References: <20050413152307.0312.LARK@linux.net.cn> <425CEFE3.2010200@rtij.nl>
	<20050413182822.0317.LARK@linux.net.cn> <425CFFE0.1000803@rtij.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martijn Lievaart <m@rtij.nl>
In-Reply-To: <425CFFE0.1000803@rtij.nl>
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

On Wed, 13 Apr 2005, Martijn Lievaart wrote:

> The only real advantage I can think of is that using --previous makes it 
> easier to generate rules automatically.

In automatic rule generation it is just as easy to create a subchain as it 
is to remember to use --previous.

But as seen in another thread iptables (the userspace) do have some 
performance issues with large numbers of chains. But this in itself is not 
an argument for --previous (just a sign that the chain management could do 
with some improvement)

Regards
Henrik
