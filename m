From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: p-o-m-ng patch
Date: Thu, 26 Feb 2004 21:05:02 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402262059360.12492-100000@filer.marasystems.com>
References: <Pine.LNX.4.33.0402261140110.25110-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0402261140110.25110-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 26 Feb 2004, Jozsef Kadlecsik wrote:

> But linux-2.6.5 should match 2.6.5 and anything *above* 2.6.5 as well.

unless obviously if there is a closer match.

> I also suggest that let us tightly integrate netfilter and iptables
> into pom-ng. What I mean is that the feature patches have (always)
> got two parts: kernel module for netfilter and shared library for
> iptables. Let's start to store the shared libary part in pom-ng and not
> in the source of iptables:

This basically requires the module interface of iptables to be well
defined, allowing packaging of iptables development files to build
extension modules.  I like this idea btw, would make the development
process of an iptables extension much cleaner as it can then be written a 
trivial compile wrapper to compile iptables extensions from pom-ng without 
having to rebuild the whole of iptables.

People building static iptable binaries obviously would need to patch 
their iptables sources, but that is no problem either.

Regards
Henrik
