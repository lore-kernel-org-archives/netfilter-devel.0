From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: ip6_queue.o module missing in Red Hat linux 9 with 2.4.20-8
 kernel
Date: Fri, 16 Apr 2004 11:48:50 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404161146060.1981-100000@filer.marasystems.com>
References: <BAY14-DAV4QhExkiyPo00019965@hotmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Dev <devietf@hotmail.com>
In-Reply-To: <BAY14-DAV4QhExkiyPo00019965@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 15 Apr 2004, Dev wrote:

> I am using redhat linux 9 with 2.4.20-8 kernel.  I need the modules
> ip6_queue.o to run an aodv routing protocol. But i couldnt find the
> ip6_queue.o modules is /lib/modules/2.4.20/kernel/net/ipv6/netfilter. In
> that directory i have other netfilter modules like ip6_tables.o
> ip6table_filter.o etc.... Can any one please let me how i should make
> the modules ip6_queue.o

Build it from the kernel source. You most likely need to build your own 
custom kernel as building additional modules is not entirely trivial 
without first having built the kernel.. See RedHat documentation on how to 
build RedHat kernels.

Or bug RedHat about including the module in their kernel builds. Maybe 
they will listen..

Regards
Henrik
