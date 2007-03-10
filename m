From: Greg KH <greg@kroah.com>
Subject: Re: [stable] [NETFILTER 09/13]: nfnetlink_log: fix reference
	counting
Date: Fri, 9 Mar 2007 21:15:53 -0800
Message-ID: <20070310051553.GA1398@kroah.com>
References: <20070307213347.22306.9248.sendpatchset@localhost.localdomain>
	<20070307213359.22306.49771.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, stable@kernel.org, davem@davemloft.net
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20070307213359.22306.49771.sendpatchset@localhost.localdomain>
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

On Wed, Mar 07, 2007 at 10:34:39PM +0100, Patrick McHardy wrote:
> [NETFILTER]: nfnetlink_log: fix reference counting
> 
> Fix reference counting (memory leak) problem in __nfulnl_send() and callers
> related to packet queueing.
> 
> Signed-off-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Does not apply to the -stable tree for some reason :(

thanks,

greg k-h
