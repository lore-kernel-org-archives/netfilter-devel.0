From: Pablo Neira <pablo@netfilter.org>
Subject: Re: [PATCH] message parsing functions for nfqueue
Date: Fri, 12 Aug 2005 03:30:21 +0200
Message-ID: <42FBFBAD.8020807@netfilter.org>
References: <1123794106.4980.11.camel@porky>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	Vincent Deffontaines <vincent@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1123794106.4980.11.camel@porky>
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

Eric Leblond wrote:
> This is a patch against libnfnetlink_queue.
> 
> It adds "high" level functions to access to the data contained in a
> nfqueue message. These are mostly encapsulation of NFA macros.
> 
> -
> -	if (tb[NFQA_PACKET_HDR-1]) {
> -		struct nfqnl_msg_packet_hdr *ph = 
> -					NFA_DATA(tb[NFQA_PACKET_HDR-1]);
> +	struct nfqnl_msg_packet_hdr *ph;
> +	u_int32_t mark,ifi; 
> +	int ret;
> +	unsigned int datalength;
> +	char * data;
> +	
> +	ph = nfqnl_get_msg_packet_hdr(tb);
> +	if (ph){
>  		id = ntohl(ph->packet_id);
>  		printf("hw_protocol=0x%04x hook=%u id=%u ",
>  			ntohs(ph->hw_protocol), ph->hook, id);
>  	}

Instead of adding a function to access every attribute like above, why 
don't we add something more generic in libnfnetlink? Like the following 
macros:

#define nfnl_get_data(tb, attr, type)			\
({	type __ret = 0;					\
  	if (tb[attr-1])					\
  		__ret = *(type *)NFA_DATA(tb[attr-1]);	\
	__ret;						\
})

#define nfnl_get_pointer_to_data(tb, attr, type)	\
({	type *__ret = NULL;				\
  	if (tb[attr-1])					\
  		__ret = NFA_DATA(tb[attr-1]);		\
  	__ret;						\
})

Maybe too generic ?

OTOH, if we add such high level functions we'll have to do the same in 
other libnfnetlink_* libraries to keep homogeneity of the API.

--
Pablo
