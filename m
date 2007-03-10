From: Greg KH <greg@kroah.com>
Subject: Re: [stable] [patch 12/20] nfnetlink_log: fix reference counting
Date: Sat, 10 Mar 2007 01:14:45 -0800
Message-ID: <20070310091445.GA26611@kroah.com>
References: <20070310061234.465093436@mini.kroah.org> <20070310061803.GM31412@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
	"Theodore Ts'o" <tytso@mit.edu>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	netfilter-devel@lists.netfilter.org,
	Justin Forbes <jmforbes@linuxtx.org>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>, davem@davemloft.net,
	Randy Dunlap <rdunlap@xenotime.net>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	akpm@linux-foundation.org,
	Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
	torvalds@linux-foundation.org, Patrick McHardy <kaber@trash.net>,
	alan@lxorguk.ukuu.org.uk
To: Greg KH <gregkh@suse.de>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1161022AbXCJJPb@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070310061803.GM31412@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Mar 09, 2007 at 10:18:03PM -0800, Greg KH wrote:
> -stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> From: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
> 
> [NETFILTER]: nfnetlink_log: fix reference counting
> 
> Fix reference counting (memory leak) problem in __nfulnl_send() and callers
> related to packet queueing.
> 
> Signed-off-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
> Signed-off-by: Patrick McHardy <kaber@trash.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  net/netfilter/nfnetlink_log.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- a/net/netfilter/nfnetlink_log.c
> +++ b/net/netfilter/nfnetlink_log.c
> @@ -220,7 +220,8 @@ _instance_destroy2(struct nfulnl_instanc
>  		/* timer "holds" one reference (we have one more) */
>  		if (timer_pending(&inst->timer)) {
>  			del_timer(&inst->timer);
> -			instance_put(inst);
> +
> +instance_put(inst);
>  		}
>  		if (inst->qlen)
>  			__nfulnl_send(inst);
> 

As this patch does nothing, it's now dropped.  It was my fault as the
original patch didn't apply and I messed up using quilt here.

thanks,

greg k-h
