From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Compiling IPTables-1.2.9 with Linux Kernel 2.4.6
Date: Fri, 23 Jan 2004 11:20:25 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401231119000.12080-100000@filer.marasystems.com>
References: <400FCD11.2A953624@multitech.co.in>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Brindha M P <brindha@multitech.co.in>
In-Reply-To: <400FCD11.2A953624@multitech.co.in>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 22 Jan 2004, Brindha M P wrote:

>     We face errors while compiling IPTables - 1.2.9 with Linux Kernel
> 2.4.6.
> 
> Kernel is compiled with Network packet filtering as inbuilt, IPTables
> support
> as inbuilt (other sub-options included as module)
> 
> Looks like the user-space iptables source code is referencing header
> files which is not present in the Kernel code.

According to the Changelog mostly any version should work, but if in doubt 
try using a release not too far from the date of the Linux kernel release.

Regards
Henrik
