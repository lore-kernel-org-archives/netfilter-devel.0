From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [netfilter-core] Cannot unload nf_conntrack
Date: Mon, 30 May 2011 18:43:17 +0200
Message-ID: <4DE3C925.2070400@netfilter.org>
References: <4DC0310F.3070004@bull.net> <4DDF7152.3030405@netfilter.org> <4DDF8A65.1070900@netfilter.org> <4DE3B148.9020209@Bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	netfilter-core@lists.netfilter.org
To: Menyhart Zoltan <Zoltan.Menyhart@Bull.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48065 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755353Ab1E3Qn1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2011 12:43:27 -0400
In-Reply-To: <4DE3B148.9020209@Bull.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 30/05/11 17:01, Menyhart Zoltan wrote:
> Pablo Neira Ayuso wrote:
>  
>> Please, would you give a try to this patch?
>>
>> Thanks!
> 
> Have you got a patch for the 2.6.32, please, because this section does
> not apply:
> 
> diff --git a/net/netfilter/nf_conntrack_core.c
> b/net/netfilter/nf_conntrack_core.c
> index 2e1c11f..9421fe4 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -922,6 +922,9 @@ nf_conntrack_in(struct net *net, u_int8_t pf,
> unsigned int hooknum,
>              ret = -ret;
>              goto out;
>          }
> +        /* ICMP[v6] protocol trackers may assign one conntrack. */
> +        if (skb->nfct)
> +            goto out;
>      }
>  
>      ct = resolve_normal_ct(net, tmpl, skb, dataoff, pf, protonum,
> 
> Thanks,

Sorry, no patch for 2.6.32. But I appreciate if you can add that chuck
by yourself, it's quite easy:

 785        if (l4proto->error != NULL) {
 786                ret = l4proto->error(net, skb, dataoff, &ctinfo, pf,
hooknum);
 787                if (ret <= 0) {
 788                        NF_CT_STAT_INC_ATOMIC(net, error);
 789                        NF_CT_STAT_INC_ATOMIC(net, invalid);
 790                        return -ret;
 791                }

add it here.

 792        }

And test it, of course.
