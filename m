Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F2F7C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Mar 2022 10:24:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238768AbiCHKY4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Mar 2022 05:24:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234017AbiCHKYz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Mar 2022 05:24:55 -0500
X-Greylist: delayed 61 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Mar 2022 02:23:58 PST
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52A3403D8
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Mar 2022 02:23:58 -0800 (PST)
X-KPN-MessageId: b2494ed1-9ec9-11ec-8147-005056ab378f
Received: from smtp.kpnmail.nl (unknown [10.31.155.38])
        by ewsoutbound.so.kpn.org (Halon) with ESMTPS
        id b2494ed1-9ec9-11ec-8147-005056ab378f;
        Tue, 08 Mar 2022 11:22:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kpnplanet.nl; s=kpnplanet01;
        h=content-type:from:to:subject:mime-version:date:message-id;
        bh=hmRoX+zMRGqmxDRFTNsXO5Y17dSyv9Ug+p5/Uuh5hvw=;
        b=DGmBLYu1WCjt0mxgrz44MnDtlVtlJbWzkMihka5hgDksmu77AT/CB9/aghxruJ1wnL3oNWucuXt8A
         vjSN7tkdA4u57KsZqJfFepD02wEyFL/pMXm6DzbfqjYZAla8X1TvyD5NqhjWewhQ4xvMQi7rtBp7LL
         ABKegrfG/Omu29s0=
X-KPN-MID: 33|wEWbeEnpQSy6798Ny4InAkJVH2rzhJLc/iqR3dodnzAhJxowKNGEb53XdNF0rje
 KSB/p7vOdlv8F0ULLA7ioagu0S42CV2NsA2XhHXEpbEM=
X-KPN-VerifiedSender: No
X-CMASSUN: 33|Pes/mcH9uSfxi3uXeCKwPHaHnOLYXNUK8k+B5z0gAVt01Xzl7GPcuATc/H3pQ/L
 qW2Zts/TR1N0DJN06UdVoFw==
X-Originating-IP: 62.131.27.220
Received: from [192.168.2.9] (62-131-27-220.fixed.kpn.net [62.131.27.220])
        by smtp.kpnmail.nl (Halon) with ESMTPSA
        id b786041d-9ec9-11ec-9256-005056abf0db;
        Tue, 08 Mar 2022 11:22:55 +0100 (CET)
Message-ID: <0a2b7783-53b8-dbf5-010d-d97acfc465fe@kpnplanet.nl>
Date:   Tue, 8 Mar 2022 11:22:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Reply-To: hmmsjan@kpnplanet.nl
Subject: Re: TCP connection fails in a asymmetric routing situation
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>,
        pablo@netfilter.org, kadlec@netfilter.org
References: <20220225123030.GK28705@breakpoint.cc>
 <20220302105908.GA5852@breakpoint.cc>
From:   "H.Janssen" <hmmsjan@kpnplanet.nl>
Organization: Privat
In-Reply-To: <20220302105908.GA5852@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Dear Mr. Westphal,

The problem seems to be solved with the patch below in kernel 
5.16.12-200.fc35.x86_64. Few lines offset during patch, but it patches 
and compiles.

No idea about possible side effects, but ports are no longer manipulated..

contrack -E --dst 192.168.10.12

     [NEW] tcp      6 300 ESTABLISHED src=192.168.1.47 dst=192.168.10.12 
sport=80 dport=52044 [UNREPLIED] src=192.168.10.12 dst=192.168.1.47 
sport=52044 dport=80
  [UPDATE] tcp      6 120 FIN_WAIT src=192.168.1.47 dst=192.168.10.12 
sport=80 dport=52044 [UNREPLIED] src=192.168.10.12 dst=192.168.1.47 
sport=52044 dport=80
[DESTROY] tcp      6 FIN_WAIT src=192.168.1.47 dst=192.168.10.12 
sport=80 dport=52040 [UNREPLIED] src=192.168.10.12 dst=192.168.1.47 
sport=52040 dport=80
[DESTROY] tcp      6 FIN_WAIT src=192.168.1.47 dst=192.168.10.12 
sport=80 dport=52042 [UNREPLIED] src=192.168.10.12 dst=192.168.1.47 
sport=52042 dport=80

Thanks and kind regards





On 3/2/22 11:59, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
>> 1. Change ct->local_origin to "ct->no_srcremap" (or a new status bit)
>> that indicates that this should not have src remap done, just like we
>> do for locally generated connections.
>>
>> 2. Add a new "mid-stream" status bit, then bypass the entire -t nat
>> logic if its set. nf_nat_core would create a null binding for the
>> flow, this also bypasses the "src remap" code.
>>
>> 3. Simpler version: from tcp conntrack, set the nat-done status bits
>> if its a mid-stream pickup.
>>
>> Downside: nat engine (as-is) won't create a null binding, so connection
>> will not be known to nat engine for masquerade source port clash
>> detection.
>>
>> I would go for 2) unless you have a better suggestion/idea.
> Something like this:
>
> diff --git a/include/uapi/linux/netfilter/nf_conntrack_common.h b/include/uapi/linux/netfilter/nf_conntrack_common.h
> --- a/include/uapi/linux/netfilter/nf_conntrack_common.h
> +++ b/include/uapi/linux/netfilter/nf_conntrack_common.h
> @@ -118,15 +118,19 @@ enum ip_conntrack_status {
>   	IPS_HW_OFFLOAD_BIT = 15,
>   	IPS_HW_OFFLOAD = (1 << IPS_HW_OFFLOAD_BIT),
>   
> +	/* Connection started mid-transfer, origin/reply might be inversed */
> +	IPS_MID_STREAM_BIT = 16,
> +	IPS_MID_STREAM = (1 << IPS_MID_STREAM_BIT),
> +
>   	/* Be careful here, modifying these bits can make things messy,
>   	 * so don't let users modify them directly.
>   	 */
>   	IPS_UNCHANGEABLE_MASK = (IPS_NAT_DONE_MASK | IPS_NAT_MASK |
>   				 IPS_EXPECTED | IPS_CONFIRMED | IPS_DYING |
>   				 IPS_SEQ_ADJUST | IPS_TEMPLATE | IPS_UNTRACKED |
> -				 IPS_OFFLOAD | IPS_HW_OFFLOAD),
> +				 IPS_OFFLOAD | IPS_HW_OFFLOAD | IPS_MID_STREAM_BIT),
>   
> -	__IPS_MAX_BIT = 16,
> +	__IPS_MAX_BIT = 17,
>   };
>   
>   /* Connection tracking event types */
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -537,6 +537,8 @@ static bool tcp_in_window(struct nf_conn *ct,
>   			 * its history is lost for us.
>   			 * Let's try to use the data from the packet.
>   			 */
> +			set_bit(IPS_MID_STREAM_BIT, &ct->status);
> +
>   			sender->td_end = end;
>   			swin = win << sender->td_scale;
>   			sender->td_maxwin = (swin == 0 ? 1 : swin);
> @@ -816,6 +818,8 @@ static noinline bool tcp_new(struct nf_conn *ct, const struct sk_buff *skb,
>   		 * its history is lost for us.
>   		 * Let's try to use the data from the packet.
>   		 */
> +		set_bit(IPS_MID_STREAM_BIT, &ct->status);
> +
>   		ct->proto.tcp.seen[0].td_end =
>   			segment_seq_plus_len(ntohl(th->seq), skb->len,
>   					     dataoff, th);
> diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> --- a/net/netfilter/nf_nat_core.c
> +++ b/net/netfilter/nf_nat_core.c
> @@ -545,6 +545,12 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
>   
>   	zone = nf_ct_zone(ct);
>   
> +	if (unlikely(test_bit(IPS_MID_STREAM_BIT, &ct->status))) {
> +		/* Can't NAT if connection was picked up mid-stream (e.g. tcp) */
> +		*tuple = *orig_tuple;
> +		return;
> +	}
> +
>   	if (maniptype == NF_NAT_MANIP_SRC &&
>   	    !random_port &&
>   	    !ct->local_origin)
> @@ -781,7 +787,7 @@ nf_nat_inet_fn(void *priv, struct sk_buff *skb,
>   			unsigned int ret;
>   			int i;
>   
> -			if (!e)
> +			if (!e || unlikely(test_bit(IPS_MID_STREAM_BIT, &ct->status)))
>   				goto null_bind;
>   
>   			for (i = 0; i < e->num_hook_entries; i++) {

-- 
H.Janssen
Lekerwaard 36
1824HC Alkmaar
06-58971047

