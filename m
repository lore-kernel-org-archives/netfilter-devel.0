From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] cleanup
Date: Fri, 10 Sep 2004 13:08:45 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <41418B3D.3030808@trash.net>
References: <414076C7.7000009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Thomas Woerner <twoerner@redhat.com>
In-Reply-To: <414076C7.7000009@redhat.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Thomas Woerner wrote:
> 
> Hello,
> 
> 
> I got this patch for iptables in bugzilla #131848 from Steve Grubb. Are 
> including it in the next version?

This doesn't look like cleanup and I'm not going to dig
up bugreports from redhat bugzilla. What is this patch
supposed to fix ?

Regards
Patrick

> 
> 
> Thanks in advance,
> Thomas
> 
> 
> ------------------------------------------------------------------------
> 
> diff -ur iptables-1.2.11.orig/extensions/libipt_REJECT.c iptables-1.2.11/extensions/libipt_REJECT.c
> --- iptables-1.2.11.orig/extensions/libipt_REJECT.c	2004-09-05 11:27:49.000000000 -0400
> +++ iptables-1.2.11/extensions/libipt_REJECT.c	2004-09-05 11:28:17.000000000 -0400
> @@ -147,13 +147,16 @@
>  {
>  	const struct ipt_reject_info *reject
>  		= (const struct ipt_reject_info *)target->data;
> -	unsigned int i;
> +	unsigned int i, limit=sizeof(reject_table)/sizeof(struct reject_names);
>  
> -	for (i = 0; i < sizeof(reject_table)/sizeof(struct reject_names); i++) {
> +	for (i = 0; i < limit; i++) {
>  		if (reject_table[i].with == reject->with)
>  			break;
>  	}
> -	printf("reject-with %s ", reject_table[i].name);
> +	if (i < limit)
> +		printf("reject-with %s ", reject_table[i].name);
> +	else
> +		printf("reject-with: error reject->with not found ");
>  }
>  
>  /* Saves ipt_reject in parsable form to stdout. */
> @@ -161,13 +164,15 @@
>  {
>  	const struct ipt_reject_info *reject
>  		= (const struct ipt_reject_info *)target->data;
> -	unsigned int i;
> +	unsigned int i, limit=sizeof(reject_table)/sizeof(struct reject_names);
>  
> -	for (i = 0; i < sizeof(reject_table)/sizeof(struct reject_names); i++)
> +	for (i = 0; i < limit; i++)
>  		if (reject_table[i].with == reject->with)
>  			break;
> -
> -	printf("--reject-with %s ", reject_table[i].name);
> +	if (i < limit)
> +		printf("--reject-with %s ", reject_table[i].name);
> +	else
> +		fprintf(stderr, "--reject-with error reject->with not found");
>  }
>  
>  static
> diff -ur iptables-1.2.11.orig/extensions/libipt_rpc.c iptables-1.2.11/extensions/libipt_rpc.c
> --- iptables-1.2.11.orig/extensions/libipt_rpc.c	2004-09-05 11:27:50.000000000 -0400
> +++ iptables-1.2.11/extensions/libipt_rpc.c	2004-09-05 11:41:11.000000000 -0400
> @@ -252,7 +252,7 @@
>  
>  			idup = 0;
>  			memset(buf, 0, sizeof(buf));
> -			dst = (char *)buf - 1;
> +			dst = (char *)buf;
>  		}
>  	}
>  
