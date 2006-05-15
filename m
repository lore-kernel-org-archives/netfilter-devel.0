From: Patrick McHardy <kaber@trash.net>
Subject: Re: ulogd2 and nflog prefix
Date: Mon, 15 May 2006 09:39:43 +0200
Message-ID: <4468303F.4030004@trash.net>
References: <4467EC50.3030907@snapgear.com> <44681346.3000301@trash.net>
	<446826EF.1070004@snapgear.com> <44682889.107@trash.net>
	<44682EE0.6020003@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
In-Reply-To: <44682EE0.6020003@snapgear.com>
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

Philip Craig wrote:
> On 05/15/2006 05:06 PM, Patrick McHardy wrote:
> 
>>Right, I somehow though the prefix was also configured using netlink,
>>which is of course wrong. In that case I think nfnetlink_log should
>>just 0-terminate the string. BTW, Is there any reason why the prefix
>>is truncated to NFULNL_PREFIXLEN?
> 
> 
> It makes calculating the size to allocate simpler, but otherwise it
> looks like a carryover from when log messages were passed via fixed
> size structures.  Giving the full prefix is desirable I think,
> especially for log messages generated internally by netfilter.
> eg the sequence number check in ip_conntrack_proto_tcp.c

I agree. A few nitpicks though ..

> Index: linux-2.6.x/include/linux/netfilter/nfnetlink_log.h
> ===================================================================
> RCS file: /cvs/sw/linux-2.6.x/include/linux/netfilter/nfnetlink_log.h,v
> retrieving revision 1.1.1.1
> diff -u -p -r1.1.1.1 nfnetlink_log.h
> --- linux-2.6.x/include/linux/netfilter/nfnetlink_log.h	28 Oct 2005 04:39:21 -0000	1.1.1.1
> +++ linux-2.6.x/include/linux/netfilter/nfnetlink_log.h	15 May 2006 07:16:22 -0000
> @@ -32,8 +32,6 @@ struct nfulnl_msg_packet_timestamp {
>  	aligned_u64	usec;
>  } __attribute__ ((packed));
>  
> -#define NFULNL_PREFIXLEN	30	/* just like old log target */
> -

Please keep this around, userspace might be using it.


>  enum nfulnl_attr_type {
>  	NFULA_UNSPEC,
>  	NFULA_PACKET_HDR,
> Index: linux-2.6.x/net/netfilter/nfnetlink_log.c
> ===================================================================
> RCS file: /cvs/sw/linux-2.6.x/net/netfilter/nfnetlink_log.c,v
> retrieving revision 1.1.1.3
> diff -u -p -r1.1.1.3 nfnetlink_log.c
> --- linux-2.6.x/net/netfilter/nfnetlink_log.c	21 Mar 2006 01:35:42 -0000	1.1.1.3
> +++ linux-2.6.x/net/netfilter/nfnetlink_log.c	15 May 2006 07:16:22 -0000
> @@ -410,12 +410,8 @@ __build_packet_message(struct nfulnl_ins
>  
>  	NFA_PUT(inst->skb, NFULA_PACKET_HDR, sizeof(pmsg), &pmsg);
>  
> -	if (prefix) {
> -		int slen = strlen(prefix);
> -		if (slen > NFULNL_PREFIXLEN)
> -			slen = NFULNL_PREFIXLEN;
> -		NFA_PUT(inst->skb, NFULA_PREFIX, slen, prefix);
> -	}
> +	if (prefix)
> +		NFA_PUT(inst->skb, NFULA_PREFIX, strlen(prefix) + 1, prefix);
>  
>  	if (indev) {
>  		tmp_uint = htonl(indev->ifindex);
> @@ -585,7 +581,7 @@ nfulnl_log_packet(unsigned int pf,
>  		return;
>  	}
>  
> -	/* all macros expand to constant values at compile time */
> +	/* most macros expand to constant values at compile time */
>  	/* FIXME: do we want to make the size calculation conditional based on
>  	 * what is actually present?  way more branches and checks, but more
>  	 * memory efficient... */
> @@ -599,7 +595,7 @@ nfulnl_log_packet(unsigned int pf,
>  #endif
>  		+ NFA_SPACE(sizeof(u_int32_t))	/* mark */
>  		+ NFA_SPACE(sizeof(u_int32_t))	/* uid */
> -		+ NFA_SPACE(NFULNL_PREFIXLEN)	/* prefix */
> +		+ NFA_SPACE(strlen(prefix) + 1)	/* prefix */
>  		+ NFA_SPACE(sizeof(struct nfulnl_msg_packet_hw))
>  		+ NFA_SPACE(sizeof(struct nfulnl_msg_packet_timestamp));
>  

Please try to avoid multiple strlen calls .. just pass it around as an
argument or something.
