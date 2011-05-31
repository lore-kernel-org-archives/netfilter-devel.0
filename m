From: Menyhart Zoltan <Zoltan.Menyhart@Bull.net>
Subject: Re: [netfilter-core] Cannot unload nf_conntrack
Date: Tue, 31 May 2011 09:27:16 +0200
Message-ID: <4DE49854.8060306@Bull.net>
References: <4DC0310F.3070004@bull.net> <4DDF7152.3030405@netfilter.org> <4DDF8A65.1070900@netfilter.org> <4DE3B148.9020209@Bull.net> <4DE3C925.2070400@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	netfilter-core@lists.netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:41325 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab1EaH2U (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 May 2011 03:28:20 -0400
In-Reply-To: <4DE3C925.2070400@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:

> Sorry, no patch for 2.6.32. But I appreciate if you can add that chuck
> by yourself, it's quite easy:
>
>   785        if (l4proto->error != NULL) {
>   786                ret = l4proto->error(net, skb, dataoff,&ctinfo, pf, hooknum);
>   787                if (ret<= 0) {
>   788                        NF_CT_STAT_INC_ATOMIC(net, error);
>   789                        NF_CT_STAT_INC_ATOMIC(net, invalid);
>   790                        return -ret;
>   791                }
>
> add it here.
>
>   792        }
>
> And test it, of course.

I *did* try it before I asked for the patch for 2.6.32.
My problem is: there is no "out:" branch in the 2.6.32.

out:
         if (tmpl) {
                 /* Special case: we have to repeat this hook, assign the
                  * template again to this packet. We assume that this packet
                  * has no conntrack assigned. This is used by nf_ct_tcp. */
                 if (ret == NF_REPEAT)
                         skb->nfct = (struct nf_conntrack *)tmpl;
                 else
                         nf_ct_put(tmpl);
         }

There is no "struct nf_conn *tmpl;" either.
What shall I do instead of "goto out;"?

Thanks,

Zoltan
