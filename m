From: Amin Azez <azez@ufomechanic.net>
Subject: Re: lots of oopses
Date: Fri, 18 Aug 2006 08:33:13 +0100
Message-ID: <44E56D39.50806@ufomechanic.net>
References: <44E49911.6080007@ufomechanic.net> <44E4A1AB.3000001@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: l7-filter-developers@lists.sourceforge.net,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44E4A1AB.3000001@trash.net>
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

Patrick McHardy wrote:
> Amin Azez wrote:
>   
>> The most recent oops where I forgot to unload most of the modules, but
>> was running my layer7 load monitor crashed at a rule-add just after a
>> conntrack flush. Layer7 is clearly implicated in this one. There is
>> another oops further down where this is not the case.
>>     
>
> The second one looks like a race in ipt_tables when changing the
> ruleset (the attached patch should fix that). The first one looks
> like a l7 bug.
>
>   
Thanks Patrick, you are top.
> BTW, what is ipt_vlan?
>   
I think I posted it here a year ago, but I'll do so again if you want it.
It matches on vlan-id.

It was said that strictly this is a layer 2 thing and not for iptables; 
I find it useful though;-
which iptables rules should be applied may depend on vlan stuff, and 
sometimes it seems like there isn't enough mark to go around...

I like the iptables/ebtables seperation but sometimes it seems like they 
should be able to share each-others matches, like one big happy table 
with a few extra points of inspection. Anyway...

thanks again.

Sam
> ------------------------------------------------------------------------
>
> [NETFILTER]: ip_tables: fix table locking in ipt_do_table
>
> table->private might change because of ruleset changes, don't use it without
> holding the lock.
>
> Signed-off-by: Patrick McHardy <kaber@trash.net>
>
> ---
> commit 338fe5c67e8fb799c9e3470331db6f3c60a31b1e
> tree 2dc15d63244ed18a8035ae483ae2d722e7fbcf62
> parent 32ce9bc41528c327b1353713b2108d2213128dee
> author Patrick McHardy <kaber@trash.net> Tue, 15 Aug 2006 16:06:57 +0200
> committer Patrick McHardy <kaber@trash.net> Tue, 15 Aug 2006 16:06:57 +0200
>
>  net/ipv4/netfilter/arp_tables.c |    3 ++-
>  net/ipv4/netfilter/ip_tables.c  |    3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
> index df4854c..8d1d7a6 100644
> --- a/net/ipv4/netfilter/arp_tables.c
> +++ b/net/ipv4/netfilter/arp_tables.c
> @@ -236,7 +236,7 @@ unsigned int arpt_do_table(struct sk_buf
>  	struct arpt_entry *e, *back;
>  	const char *indev, *outdev;
>  	void *table_base;
> -	struct xt_table_info *private = table->private;
> +	struct xt_table_info *private;
>  
>  	/* ARP header, plus 2 device addresses, plus 2 IP addresses.  */
>  	if (!pskb_may_pull((*pskb), (sizeof(struct arphdr) +
> @@ -248,6 +248,7 @@ unsigned int arpt_do_table(struct sk_buf
>  	outdev = out ? out->name : nulldevname;
>  
>  	read_lock_bh(&table->lock);
> +	private = table->private;
>  	table_base = (void *)private->entries[smp_processor_id()];
>  	e = get_entry(table_base, private->hook_entry[hook]);
>  	back = get_entry(table_base, private->underflow[hook]);
> diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
> index f316ff5..048514f 100644
> --- a/net/ipv4/netfilter/ip_tables.c
> +++ b/net/ipv4/netfilter/ip_tables.c
> @@ -230,7 +230,7 @@ ipt_do_table(struct sk_buff **pskb,
>  	const char *indev, *outdev;
>  	void *table_base;
>  	struct ipt_entry *e, *back;
> -	struct xt_table_info *private = table->private;
> +	struct xt_table_info *private;
>  
>  	/* Initialization */
>  	ip = (*pskb)->nh.iph;
> @@ -247,6 +247,7 @@ ipt_do_table(struct sk_buff **pskb,
>  
>  	read_lock_bh(&table->lock);
>  	IP_NF_ASSERT(table->valid_hooks & (1 << hook));
> +	private = table->private;
>  	table_base = (void *)private->entries[smp_processor_id()];
>  	e = get_entry(table_base, private->hook_entry[hook]);
>  
>   
