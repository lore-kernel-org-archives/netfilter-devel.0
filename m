From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] datalen variable unused in ftp helper.
Date: Tue, 09 Mar 2004 21:36:21 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <404E2AC5.1080803@trash.net>
References: <404E0A4D.3070303@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
 Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <404E0A4D.3070303@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira wrote:
> Hi,
> 
> I found that the variable datalen in the ftp helper is sometimes used 
> and sometimes not. Attached to this email the patch to fix this.
> 
> regards,
> Pablo
> 
> 
> ------------------------------------------------------------------------
> 
> --- linux-2.6.3/net/ipv4/netfilter/ip_conntrack_ftp.c	2004-03-09 18:49:21.000000000 +0100
> +++ linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_ftp.c	2004-02-18 04:59:06.000000000 +0100
> @@ -281,7 +281,7 @@
>  	datalen = skb->len - dataoff;

^^ Shouldn't the patch remove the variable entirely then ?

Regards
Patrick



>  
>  	LOCK_BH(&ip_ftp_lock);
> -	skb_copy_bits(skb, dataoff, ftp_buffer, datalen);
> +	skb_copy_bits(skb, dataoff, ftp_buffer, skb->len - dataoff);
>  
>  	old_seq_aft_nl_set = ct_ftp_info->seq_aft_nl_set[dir];
>  	old_seq_aft_nl = ct_ftp_info->seq_aft_nl[dir];
> @@ -317,7 +317,7 @@
>  	for (i = 0; i < ARRAY_SIZE(search); i++) {
>  		if (search[i].dir != dir) continue;
>  
> -		found = find_pattern(ftp_buffer, datalen,
> +		found = find_pattern(ftp_buffer, skb->len - dataoff,
>  				     search[i].pattern,
>  				     search[i].plen,
>  				     search[i].skip,
