From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Use of Kernel Headers
Date: Sat, 21 Aug 2004 11:30:36 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0408211114310.16646@filer.marasystems.com>
References: <4122743A.7020309@jg555.com> <Pine.LNX.4.61.0408180123380.7879@filer.marasystems.com>
 <Pine.LNX.4.58.0408182356030.5432@blackhole.kfki.hu> <4126F018.207@jg555.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Developer <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jim Gifford <maillist@jg555.com>
In-Reply-To: <4126F018.207@jg555.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 20 Aug 2004, Jim Gifford wrote:

> This all goes back to having true separation between the kernel and 
> userspace, I'm starting to think iptables is different in it's situation and 
> true separation will never be possible

Separation is possible, it is mainly a matter of how the userspace headers 
should be maintained and how to ensure kernel compatibility to a 
reasonable manner (i.e. mostly an adminstrative issue). Today a lot of the 
kernel release compatibility depends on using the kernel headers. There is 
also a one or two extensions which have more complex dependencies but I 
think all of these is in pom extra.

Have you tried what I requested before? Copying the kernel netfilter_ipvX 
headers to the userspace include directory and testing how much 
of it compiles? Just specify the iptables userspace directory as kernel 
source after doing this to avoid having to fiddle with the makefiles etc..

Regards
Henrik
