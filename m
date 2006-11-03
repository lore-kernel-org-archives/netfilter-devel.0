From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 11/11] Reduce timer updates in __nf_ct_refresh_acct()
Date: Fri, 03 Nov 2006 13:39:03 +0100
Message-ID: <454B3867.5070004@trash.net>
References: <20061101210845.337590368@wlug.westbo.se>
	<20061101210914.886519886@wlug.westbo.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <20061101210914.886519886@wlug.westbo.se>
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

Martin Josefsson wrote:
> Only update the conntrack timer if there's been at least HZ jiffies since the
> last update. Reduces the number of del_timer/add_timer cycles from one per
> packet to one per connection per second (plus once for each state change of a
> connection)
> Should handle timer wraparounds and connection timeout changes.
> 
> Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
> 
> ---
>  net/netfilter/nf_conntrack_core.c |   11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_core.c
> ===================================================================
> --- linux-2.6.19-rc3-git4.quilt.orig/net/netfilter/nf_conntrack_core.c	2006-11-01 21:40:13.000000000 +0100
> +++ linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_core.c	2006-11-01 21:40:21.000000000 +0100
> @@ -865,9 +865,14 @@ void __nf_ct_refresh_acct(struct nf_conn
>  		ct->timeout.expires = extra_jiffies;
>  		event = IPCT_REFRESH;
>  	} else {
> -		/* Need del_timer for race avoidance (may already be dying). */
> -		if (del_timer(&ct->timeout)) {
> -			ct->timeout.expires = jiffies + extra_jiffies;
> +		unsigned long newtime = jiffies + extra_jiffies;
> +
> +		/* Only update the timeout if the new timeout is at least
> +		   HZ jiffies from the old timeout. Need del_timer for race
> +		   avoidance (may already be dying). */
> +		if (newtime - ct->timeout.expires >= HZ
> +		    && del_timer(&ct->timeout)) {
> +			ct->timeout.expires = newtime;
>  			add_timer(&ct->timeout);
>  			event = IPCT_REFRESH;
>  		}

Applied, thanks. BTW, the "race avoidance" strikes me as racy,
there are multiple locations where we simply do

if (del_timer(...))
   ct->timeout.function(...)

and expect the conntrack to be either destroyed by the
ct->timeout.function call or by the expiring timer.
But without taking ip_conntrack_lock we could have:

CPU1 (refresh)			CPU2

if (del_timer) [success]
				if (del_timer) [no success]
	add_timer()

which means the conntrack won't be destroyed. Did I miss
something?
