From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2005@gmx.net>
Subject: Re: [PATCH/RFC/RFT] add "revision" support to arp_tables and
	ip6_tables
Date: Mon, 10 Oct 2005 11:41:15 +0200
Message-ID: <434A373B.1060406@gmx.net>
References: <20051009222628.GC6593@rama.customers.eurospot.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	David Miller <davem@davemloft.net>,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20051009222628.GC6593@rama.customers.eurospot.com>
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

Hi,

Harald Welte schrieb:
> 
> I've added "revision" (i.e. support for multiple match/target versions)
> to arp_tables and ip6_tables.
> 
> At least according to some simple tests, I didn't break anything.  It's
> already in my git tree's 'master' branch, and I intend to submit it
> during early 2.6.15.
> 
> Please test/comment/fix,
> 	Harald
> 
> 
> [NETFILTER] {ip6,arp}_tables: Add support for match/target revisions
> 
> This patch synchronizes {ip6,arp}_tables with recent changes in ip_tables.
> It adds support for multiple revisions per match/target.
> 
> diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
> --- a/include/linux/netfilter_arp/arp_tables.h
> +++ b/include/linux/netfilter_arp/arp_tables.h
> @@ -68,7 +68,8 @@ struct arpt_entry_target
>  			u_int16_t target_size;
>  
>  			/* Used by userspace */
> -			char name[ARPT_FUNCTION_MAXNAMELEN];
> +			char name[ARPT_FUNCTION_MAXNAMELEN-1];
> +			u_int8_t revision;
>  		} user;
>  		struct {
>  			u_int16_t target_size;

This will explode once revision!=0 because the string stored in name is 
not NULL-terminated anymore if it is ARPT_FUNCTION_MAXNAMELEN-1 long.


Regards,
Carl-Daniel
