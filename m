From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: ip6t_REJECT dst underflow
Date: Fri, 26 Mar 2004 16:25:32 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200403260726.QAA02087@toshiba.co.jp>
References: <20040325134340.GC8500@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-users@linux-ipv6.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: okir@suse.de
In-Reply-To: <20040325134340.GC8500@suse.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

I think this patch is for ip6t_REJECT in USAGI kernel (linux 2.6.x), right ?
I applied your patch to USAGI tree.

Thank you for your report.

From: Olaf Kirch <okir@suse.de>
Date: Thu, 25 Mar 2004 14:43:40 +0100

> Hi,
> 
> the ip6t_REJECT module currently produces dst underruns when used.
> The problem is that it assigns the dst pointer to the new skb without
> bumping its reference count. The attached patch fixes this.
> 
> A second issue I came across isn't really a bug but more of
> a minor nuisance.
> 
> When I configured ip6t_REJECT to reject packets to ::1 and then pinged
> ::1, I would get in my syslog
> 
> 	Mar 25 14:16:05 hammer kernel: printk: 2 messages suppressed.
> 
> without telling me what message got suppressed. The problem is that the
> code does the following in two locations:
> 
> 	if (net_ratelimit())
> 		DEBUGP(....)
> 
> So with debugging off, all you get is the above mentioned messages
> from net_ratelimit but nothing else. Either the DEBUGP needs to be
> converted to a printk, or the entire if() statement needs to be
> enclosed in an #if/#endif pair.
> 
> Olaf
> -- 
> Olaf Kirch     |  Stop wasting entropy - start using predictable
> okir@suse.de   |  tempfile names today!
> ---------------+ 

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
