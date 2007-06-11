From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3] Misc cleanups
Date: Mon, 11 Jun 2007 16:30:34 +0200
Message-ID: <466D5C8A.5000400@trash.net>
References: <Pine.LNX.4.61.0706042108010.20829@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0706042114190.20829@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0706042114190.20829@yvahk01.tjqt.qr>
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

Jan Engelhardt wrote:
> Removes redundant parentheses and braces.
> (And add one pair in a xt_tcpudp.c macro.)


Applied, even though I'm not sure if the risk warants the cleanup.
I tried to carefully review all changes, I trust you did the same.

> @@ -180,11 +180,10 @@ static void ipt_ulog_packet(unsigned int
>  
>  	/* calculate the size of the skb needed */
>  	if ((loginfo->copy_range == 0) ||
> -	    (loginfo->copy_range > skb->len)) {
> +	    (loginfo->copy_range > skb->len))

I removed the unnecessary parentheses here as well.

> --- linux-2.6.22-rc3-git6.orig/net/ipv4/netfilter/ipt_recent.c
> +++ linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_recent.c
> @@ -163,10 +163,9 @@ static void recent_table_flush(struct re
>  	struct recent_entry *e, *next;
>  	unsigned int i;
>  
> -	for (i = 0; i < ip_list_hash_size; i++) {
> +	for (i = 0; i < ip_list_hash_size; i++)
>  		list_for_each_entry_safe(e, next, &t->iphash[i], list)
>  			recent_entry_remove(t, e);
> -	}

Mhh .. some people prefer to have braces here. We don't do it
consistently (not even in the same file), so OK.
