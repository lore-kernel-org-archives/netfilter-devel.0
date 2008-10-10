From: "Nir Tzachar" <nir.tzachar@gmail.com>
Subject: Re: WARNING: at net/ipv4/netfilter/nf_nat_standalone.c:89 nf_nat_fn+0x33/0x155()
Date: Fri, 10 Oct 2008 22:50:47 +0200
Message-ID: <9b2db90b0810101350o52d79ecka27409bfd3eaf1f8@mail.gmail.com>
References: <9b2db90b0810101349y7e357ef7g9c53f2ecf19fe3eb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:37564 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758854AbYJJUus (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Oct 2008 16:50:48 -0400
Received: by yw-out-2324.google.com with SMTP id 9so249120ywe.1
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Oct 2008 13:50:47 -0700 (PDT)
In-Reply-To: <9b2db90b0810101349y7e357ef7g9c53f2ecf19fe3eb@mail.gmail.com>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 10, 2008 at 10:49 PM, Nir Tzachar <nir.tzachar@gmail.com> wrote:
> Patrick McHardy wrote:
>> Patrick McHardy wrote:
>>> Nir Tzachar wrote:
>>>> Hello.
>>>>
>>>> The following warning is reproducible with the code below on 2.6.25.6,
>>>> which uses sendmsg on a udp socket using two iovecs:
>>>>
>>>> ....
>>>> And I always get  the following warning twice:
>>>>
>>>> [ 6658.338116] ------------[ cut here ]------------
>>>> [ 6658.338121] WARNING: at net/ipv4/netfilter/nf_nat_standalone.c:89
>>>> nf_nat_fn+0x33/0x155()
>>>
>>> Thanks for the report. Does this patch fix it?
>>
>> Actually, this can't be it. Let me look again.
>
>>Found it - we lost an ifdef during the transition to nf_conntrack
>>guarding an exception from defragmentation on loopback input.
>
>>This patch should fix the warning.
>
>

Yes, the patch below fixes the problem.
10x.

> ["x" (text/plain)]
>
> diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c \
> b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c index 5a955c4..7eb0b61 100644
> --- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
> +++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
> @@ -150,10 +150,12 @@ static unsigned int
> ipv4_conntrack_defrag(unsigned int hooknum,
>                                          const struct net_device *out,
>                                          int (*okfn)(struct sk_buff *))
>  {
> +#if !defined(CONFIG_NF_NAT) && !defined(CONFIG_NF_NAT_MODULE)
>        /* Previously seen (loopback)?  Ignore.  Do this before
>           fragment check. */
>        if (skb->nfct)
>                return NF_ACCEPT;
> +#endif
>
>        /* Gather fragments. */
>        if (ip_hdr(skb)->frag_off & htons(IP_MF | IP_OFFSET)) {
>
