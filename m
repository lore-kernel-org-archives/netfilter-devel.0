From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Use of Kernel Headers
Date: Wed, 18 Aug 2004 01:32:55 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0408180123380.7879@filer.marasystems.com>
References: <4122743A.7020309@jg555.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Developer <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jim Gifford <maillist@jg555.com>
In-Reply-To: <4122743A.7020309@jg555.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 17 Aug 2004, Jim Gifford wrote:

> It has been stated numerous times that userspace programs should not be 
> compiled against raw kernel headers, but iptables does compile against 
> userspace headers and breaks this rule. With the advent of the 
> linux-libc-headers package, should iptables be compiled against the 
> linux-libc-headers or the raw kernel headers since iptables is a user space 
> program?

This depends on if you build iptables for your custom patched kernel or a 
standard kernel.

For a standard kernel it should be sufficient with linux-libc-headers I 
think, but it is possible some required linux iptables headers is missing 
from the iptables package (include/linux/netfilter_ipv[46]/). If 
you find some missing please report here which files needs to be added 
from the kernel tree and maybe it can be cleaned up.

> Should patch-o-matic update the headers in the proper location, 
> /usr/include/linux/netfilter_ipv4 etc?

patch-o-matic should always update the kernel source tree and your 
iptables should then be built to this source tree. This to make sure 
the view of iptables and your kernel matches. But to be honest it should 
only be the include/linux/netfilter_ipv[46]/ directories which is required 
by iptables.

Regards
Henrik
