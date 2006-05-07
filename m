From: Willy Tarreau <willy@w.ods.org>
Subject: Re: [PATCH] fix mem-leak in netfilter
Date: Sun, 7 May 2006 11:36:40 +0200
Message-ID: <20060507093640.GF11191@w.ods.org>
References: <200605070426.10405.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: laforge@netfilter.org, Stephen Frost <sfrost@snowman.net>,
	marcelo@kvack.org, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jesper Juhl <jesper.juhl@gmail.com>
Content-Disposition: inline
In-Reply-To: <200605070426.10405.jesper.juhl@gmail.com>
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

On Sun, May 07, 2006 at 04:26:10AM +0200, Jesper Juhl wrote:
> The Coverity checker spotted that we may leak 'hold' in 
> net/ipv4/netfilter/ipt_recent.c::checkentry() when the following
> is true : 
>   if (!curr_table->status_proc) {
>     ...
>     if(!curr_table) {
>     ...
>       return 0;  <-- here we leak.
> Simply moving an existing vfree(hold); up a bit avoids the possible leak.
> 
> 
> (please keep me on CC when replying since I'm not subscribed 
>  to netfilter-devel)
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> ---
> 
>  net/ipv4/netfilter/ipt_recent.c |    2 +-
>  1 files changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.17-rc3-git12-orig/net/ipv4/netfilter/ipt_recent.c	2006-05-07 03:25:38.000000000 +0200
> +++ linux-2.6.17-rc3-git12/net/ipv4/netfilter/ipt_recent.c	2006-05-07 04:16:26.000000000 +0200
> @@ -821,6 +821,7 @@ checkentry(const char *tablename,
>  	/* Create our proc 'status' entry. */
>  	curr_table->status_proc = create_proc_entry(curr_table->name, ip_list_perms, proc_net_ipt_recent);
>  	if (!curr_table->status_proc) {
> +		vfree(hold);
>  		printk(KERN_INFO RECENT_NAME ": checkentry: unable to allocate for /proc entry.\n");
>  		/* Destroy the created table */
>  		spin_lock_bh(&recent_lock);
> @@ -845,7 +846,6 @@ checkentry(const char *tablename,
>  		spin_unlock_bh(&recent_lock);
>  		vfree(curr_table->time_info);
>  		vfree(curr_table->hash_table);
> -		vfree(hold);
>  		vfree(curr_table->table);
>  		vfree(curr_table);
>  		return 0;

Seems valid for 2.4.32 too. I'm queuing it up for Marcelo.

Regards,
Willy
