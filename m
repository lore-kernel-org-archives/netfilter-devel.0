From: Willy Tarreau <w@1wt.eu>
Subject: Re: [NETFILTER 2.4]: Fix deadlock on NAT helper unload
Date: Sat, 7 Oct 2006 11:50:11 +0200
Message-ID: <20061007095011.GA2557@1wt.eu>
References: <4509C252.6010504@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	"David S. Miller" <davem@davemloft.net>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <4509C252.6010504@trash.net>
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

Hi Patrick,

I missed this patch, and it seems David did not notice it either.
David, do you have any objection against it ? Otherwise I will
merge it.

Thanks,
Willy

On Thu, Sep 14, 2006 at 10:57:54PM +0200, Patrick McHardy wrote:
> [NETFILTER]: Fix deadlock on NAT helper unload
> When a NAT helper is unlocked conntrack/NAT may deadlock because of
> the following lock sequence:
> 
> .. ip_nat_helper_unregister
> -> ip_ct_selective_cleanup
> -> get_next_corpse		(ip_conntrack_lock)
> -> kill_helper			(ip_nat_lock)
> 
> .. ip_nat_fn			(ip_nat_lock)
> -> ip_nat_setup_info
> -> ip_conntrack_alter_reply	(ip_conntrack_lock)
> 
> Taking ip_nat_lock in kill_helper() is unnecessary since the helper assigned
> to a connection is immutable and new connections can't have the helper that
> is beeing unloaded assigned since it is already removed from the global list.
> 
> Reported by <doublefacer007@gmail.com>.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>
> 
> --- a/net/ipv4/netfilter/ip_nat_helper.c	2006-09-03 16:41:53.000000000 +0200
> +++ b/net/ipv4/netfilter/ip_nat_helper.c	2006-09-03 16:42:04.000000000 +0200
> @@ -522,13 +522,7 @@
>  static int
>  kill_helper(const struct ip_conntrack *i, void *helper)
>  {
> -	int ret;
> -
> -	READ_LOCK(&ip_nat_lock);
> -	ret = (i->nat.info.helper == helper);
> -	READ_UNLOCK(&ip_nat_lock);
> -
> -	return ret;
> +	return (i->nat.info.helper == helper);
>  }
>  
>  void ip_nat_helper_unregister(struct ip_nat_helper *me)
