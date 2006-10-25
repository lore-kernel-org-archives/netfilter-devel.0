From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Set mark to 0 from libnetfilter_conntrack
Date: Thu, 26 Oct 2006 01:37:29 +0200
Message-ID: <453FF539.3020107@trash.net>
References: <1161801498.12718.22.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, pablo@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1161801498.12718.22.camel@localhost>
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
> Hi,
> 
> Damien Boucard from INL has discovered a bug in libnetfilter_conntrack :
> Mark can not be set to 0.
> 
> After looking at the code I've found that we only change the mark if it
> is not set to 0 :
> 	if (ct->mark != 0)
> 		nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_MARK, &mark,
> 		       sizeof(u_int32_t));
> 
> What's the cleanest way to solve this. I don't see any mean to correct
> this except adding an IPS_CHANGE_MARK flag.
> 
> Proposed patch is attached to the mail.
> 
> BR,
> 
> 
> ------------------------------------------------------------------------
> 
> Index: include/libnetfilter_conntrack/libnetfilter_conntrack.h
> ===================================================================
> --- include/libnetfilter_conntrack/libnetfilter_conntrack.h	(revision 6689)
> +++ include/libnetfilter_conntrack/libnetfilter_conntrack.h	(working copy)
> @@ -196,6 +196,10 @@
>  	IPS_FIXED_TIMEOUT_BIT = 10,
>  	IPS_FIXED_TIMEOUT = (1 << IPS_FIXED_TIMEOUT_BIT),
>  
> +    /* Connectio must change MARK */
> +	IPS_CHANGE_MARK_BIT = 11,
> +	IPS_CHANGE_MARK = (1 << IPS_FIXED_CHANGE_MARK),
> +
>  };
>  
>  enum {
> Index: src/libnetfilter_conntrack.c
> ===================================================================
> --- src/libnetfilter_conntrack.c	(revision 6689)
> +++ src/libnetfilter_conntrack.c	(working copy)
> @@ -976,7 +976,7 @@
>  	nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_TIMEOUT, &timeout, 
>  		       sizeof(u_int32_t));
>  	
> -	if (ct->mark != 0)
> +	if (ct->status & IPS_CHANGE_MARK)
>  		nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_MARK, &mark,
>  			       sizeof(u_int32_t));
>  

I don't see anything setting this bit and it shouldn't be a conntrack
bit if it doesn't exist in the kernel (and we certainly don't want this
in the kernel). The idea is still the right one, I think the library
should take care of adding a CTA_MARK attribute without any user bitmask
fiddling by including it if the value differs from the mark contained in
the received conntrack. I think Pablo's new API will allow this.
