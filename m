From: Andy Whitcroft <apw@shadowen.org>
Subject: Re: Difference between match and target
Date: Fri, 27 Jun 2003 09:42:44 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4231865.1056706964@blackhawk>
References: <20030624170402.8564.54425.Mailman@kashyyyk>
 <005301c33ae3$141da460$010f430a@elitecore7>
 <20030625091005.GH2645@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>, Sumit Pandya <sumit@elitecore.com>
In-Reply-To: <20030625091005.GH2645@sunbeam.de.gnumonks.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--On 25 June 2003 11:10 +0200 Harald Welte <laforge@netfilter.org> wrote:

> btw: you can do this now (having match and target in one kernel module,
> registering as match and target - but this would break iptables
> module-on-demand-loading code).  Where should iptables  know from, that
> when the user specifies '-m foo' it should load a kernel module called
> 'ipt_BAR.o' ?

I guess we could say that this could be placed in the modules 
configuration.  Are not aliases in modules.conf used for exactly this kind 
of thing for instance when probing for eth0?  That said it would add a 
significant maintenance overhead to keep the netfilter specific aliases in 
sync with the kernel.  Given that if you care about 1 page you likely 
should not be using modules anyhow its likely not worth the effort.

Cheers.

-apw
