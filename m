Return-Path: <SRS0=v9tr=TU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6C0AC04AAC
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 18:25:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 934F22173E
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 18:25:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="O9Tw/WQA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbfETSZ2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 May 2019 14:25:28 -0400
Received: from mx1.riseup.net ([198.252.153.129]:48774 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbfETSZ2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 May 2019 14:25:28 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 2BF781A33E7;
        Mon, 20 May 2019 11:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1558376727; bh=JQw2wXyzs7TnHToTLfLbRU1DMB2iJr8EksxDgGSAtlA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=O9Tw/WQAIPUdVnS5WB1PT3KnCh50zy1Z/RDyxj53p7Qf5/AFP0FX5neDTXsEq+Emw
         7nwjsprunvIYQIXCWhI10tq12YXur96w5acPt023WfM0rLSl1KHmgbi5SPfUxr80re
         IW7P/xufLrEU4WuunK7q5LYbLsazETmWNjash8kg=
X-Riseup-User-ID: 5A8C4A517D0F6B9E1A9536DE886B29447FDBB69F2385309F63B5FF7880EF465B
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 8A6FE222C2A;
        Mon, 20 May 2019 11:25:26 -0700 (PDT)
Subject: Re: [PATCH nf-next v2 2/4] netfilter: synproxy: remove module
 dependency on IPv6 SYNPROXY
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
References: <20190519205259.2821-1-ffmancera@riseup.net>
 <20190519205259.2821-3-ffmancera@riseup.net>
 <20190519211207.mi3mbgtjcsbijsve@breakpoint.cc>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <0d96ae82-74b8-4c30-d684-1221d8b4fe44@riseup.net>
Date:   Mon, 20 May 2019 20:25:39 +0200
MIME-Version: 1.0
In-Reply-To: <20190519211207.mi3mbgtjcsbijsve@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

On 5/19/19 11:12 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <ffmancera@riseup.net> wrote:
>> This is a prerequisite for the new infrastructure module NF_SYNPROXY. The new
>> module is needed to avoid duplicated code for the SYNPROXY nftables support.
>>
>> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
>> ---
>>  include/linux/netfilter_ipv6.h | 3 +++
>>  net/ipv6/netfilter.c           | 1 +
>>  2 files changed, 4 insertions(+)
>>
>> diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
>> index 12113e502656..f440aaade612 100644
>> --- a/include/linux/netfilter_ipv6.h
>> +++ b/include/linux/netfilter_ipv6.h
>> @@ -8,6 +8,7 @@
>>  #define __LINUX_IP6_NETFILTER_H
>>  
>>  #include <uapi/linux/netfilter_ipv6.h>
>> +#include <net/tcp.h>
>>  
>>  /* Extra routing may needed on local out, as the QUEUE target never returns
>>   * control to the table.
>> @@ -35,6 +36,8 @@ struct nf_ipv6_ops {
>>  	int (*route)(struct net *net, struct dst_entry **dst, struct flowi *fl,
>>  		     bool strict);
>>  #endif
>> +	u32 (*cookie_init_sequence)(const struct ipv6hdr *iph,
>> +				    const struct tcphdr *th, u16 *mssp);
> 
> Could you place this above, in the #endif block?
> 
> You will need to create a helper as well:
> static inline u32 nf_ipv6_cookie_init_sequence(const struct ipv6hdr *iph,
> 					       const struct tcphdr *th,
> 					       u16 *mssp)
> {
> #if IS_MODULE(CONFIG_IPV6)
> 	const struct nf_ipv6_ops *v6_ops = nf_get_ipv6_ops();
> 
> 	if (v6_ops)
> 		return v6_ops->cookie_init_sequence(iph, th, mssp);
> #else
> 	return __cookie_v6_init_sequence(iph, th, mssp);
> #endif
> }
> 

Sure, I am going to do it.

> This way, when ipv6 is built-in, then we don't have the indirection
> if netfilter uses the nf_ipv6_cookie_init_sequence() helper.
> 
> Also, can you check that if using CONFIG_IPV6=m then
> "modinfo nf_synproxy" won't list ipv6 as a a module depencency?
> 

Yes, I will check it. Also, I have some questions about the kbuild robot
reports. Why are it reporting the following errors?

> ERROR: "ipv4_synproxy_hook" [net/ipv6/netfilter/ip6t_SYNPROXY.ko] undefined!
>    ERROR: "synproxy_send_client_synack_ipv6" [net/ipv6/netfilter/ip6t_SYNPROXY.ko] undefined!
>    ERROR: "synproxy_recv_client_ack_ipv6" [net/ipv6/netfilter/ip6t_SYNPROXY.ko] undefined!
>    ERROR: "nf_synproxy_ipv6_init" [net/ipv6/netfilter/ip6t_SYNPROXY.ko] undefined!
>    ERROR: "nf_synproxy_ipv6_fini" [net/ipv6/netfilter/ip6t_SYNPROXY.ko] undefined!
>    ERROR: "ipv4_synproxy_hook" [net/ipv4/netfilter/ipt_SYNPROXY.ko] undefined!
>    ERROR: "synproxy_send_client_synack" [net/ipv4/netfilter/ipt_SYNPROXY.ko] undefined!
>    ERROR: "synproxy_recv_client_ack" [net/ipv4/netfilter/ipt_SYNPROXY.ko] undefined!
>    ERROR: "nf_synproxy_ipv4_init" [net/ipv4/netfilter/ipt_SYNPROXY.ko] undefined!
>    ERROR: "nf_synproxy_ipv4_fini" [net/ipv4/netfilter/ipt_SYNPROXY.ko] undefined!

Why undefined? I have exported them with EXPORT_SYMBOL_GPL(). What am I
missing? Thanks!


> If it does, there is another symbol that pulls in ipv6 (depmod will
> say which one).
> 
> Thanks!
> 
