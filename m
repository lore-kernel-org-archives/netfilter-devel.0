From: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
Subject: Re: ipt_time fixes (resend, sorry)
Date: Fri, 14 Jan 2005 09:37:22 -0500
Message-ID: <20050114143722.GA10088@ti64.telemetry-investments.com>
References: <Pine.LNX.4.61.0501141503220.9908@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Fabrice MARIE <fabrice@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0501141503220.9908@bizon.gios.gov.pl>
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

On Fri, Jan 14, 2005 at 03:04:38PM +0100, Krzysztof Oledzki wrote:
> Hello,
> 
> My two patches fixes two problem I have just found. I tried to 
> migrate from 2.4.x to the 2.6.11-rc1 kernel. Patches are against 
> patch-o-matic-ng-20050105 but can be cleanly applied to the latest 
> patch-o-matic-ng (20050113).
> 
> 1. Fix compilation, without this patch I got:

Yes, I also sent a patch for this.

> 
> 2. Fix time match when skb->stamp.tv_sec is 0. I don't know why but on 
> 2.6.11-rc1 (and probably others 2.6.x kernels) skb->stamp.tv_sec seems to 
> be allways 0, even on PRE_ROUTING and LOCAL_IN. So I fixed it by allways 
> use kernel time byt only if skb->stamp.tv_sec is 0 (like in ULOG). With 
> such modification we no longer needs kerneltime in the "struct 
> ipt_time_info"
> but I'm afraid we should keep it for binary compability, shouldn't we?

This is most likely due to Andi Kleen's net timestamp optimization, which
avoids calling gettimeofday in the network fastpath unless it is needed.

net/core/dev.c:1003:

/* When > 0 there are consumers of rx skb time stamps */
static atomic_t netstamp_needed = ATOMIC_INIT(0);

void net_enable_timestamp(void)
{
        atomic_inc(&netstamp_needed);
}

void net_disable_timestamp(void)
{
        atomic_dec(&netstamp_needed);
}

static inline void net_timestamp(struct timeval *stamp)
{
        if (atomic_read(&netstamp_needed))
                do_gettimeofday(stamp);
        else {
                stamp->tv_sec = 0;
                stamp->tv_usec = 0;
        }
}


Regards,

	Bill Rugolsky
 
