Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46FEFC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Apr 2022 12:28:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346338AbiDZMbc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Apr 2022 08:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348682AbiDZMbX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Apr 2022 08:31:23 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49402193C7
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Apr 2022 05:28:16 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id e4so20483517oif.2
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Apr 2022 05:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=v3bfdoTYCuWae+elRWtdpAM5SHIFQ1t/nUu4MJ/uFno=;
        b=JhXkPmUDepJ9uQdT/+pyFqfQ8ubSAmln23MhV9bkf7hud3d0jPSNpnNcmAo2+/5q/x
         MjxroZUDZ0MBULuoaZbzLoAxultdQ0+3sM6bi8KvKQ63Dvc9OYKN+qz6ici0ZFF7z3Jg
         2PORSShZ1ptUymqzI1IwByIloOM9CXTXpVXgVOCwsbTdQe9rfOhTLHWvutjiV1xYESrN
         XO0R0jP0pZ7mmHXUmNGahRVMneh+5ruUhf0hmfo8vmJc5xn2RJNzgJwTht0lSk5toYS9
         JtONsV/a9WHAZEPyYxIKY7lbdBxecn+d41Cr+30kiGbJC/UBOiTNo0BIbfy5xrkVC11y
         UuMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=v3bfdoTYCuWae+elRWtdpAM5SHIFQ1t/nUu4MJ/uFno=;
        b=lz6kSeamBc5TobBPHb244UM1ElTuID52KyZMd9gVDRSsYfabP3HIOgWGr4blJG55lT
         hYmwRE9EP7JK6GTV2MOnzGSN6ZhpzHf33KF62b/tgqYHv7ysZP+06t7TYORgCmnuwEN8
         lZpcuJNUJbE8haDA+eRSBDPXotRfAjpdRTuMIEWVRBWncgbAPEK4h1crDz4tGWU8z9P5
         vNblpNiY/sbPEZ3JjNSmeRNfGf2PBv7GXdA8niuZydWrbTAztLTt1e9daJUwpyA8lWX4
         vCtv9IgemKkZOVDJUNRB3zkv5ohxEASC/SRO3V6EiaYjH6BpDUEC65aOrIn1QlcVfrss
         RuGg==
X-Gm-Message-State: AOAM533+dFG2Bck8Q4+D0K+KAfwtSK9hxPy2enpXHD45IGwvKvnLTv6s
        TtSKX6aJkERSWHrqpwDymALk4vSc+IdmM3JP
X-Google-Smtp-Source: ABdhPJyCFo6b2RQXs6LfPEHbXxZfXyRZQp4gGsKjnzLlBlWtwkuYRkvYydaQepwK5i74h8eQYEpsIw==
X-Received: by 2002:aca:d9c3:0:b0:2fa:6f51:7bfe with SMTP id q186-20020acad9c3000000b002fa6f517bfemr10444198oig.59.1650976095623;
        Tue, 26 Apr 2022 05:28:15 -0700 (PDT)
Received: from [192.168.2.151] (fpa446b85c.tkyc319.ap.nuro.jp. [164.70.184.92])
        by smtp.gmail.com with ESMTPSA id n44-20020a056870822c00b000e686d1388dsm754791oae.39.2022.04.26.05.28.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 05:28:14 -0700 (PDT)
Message-ID: <04e2c223-7936-481d-0032-0a55a21dca7a@gmail.com>
Date:   Tue, 26 Apr 2022 21:28:13 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] nf_flowtable: ensure dst.dev is not blackhole
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <20220425080835.5765-1-ritarot634@gmail.com>
 <YmfVpecE2UuiP6p8@salvia>
From:   Ritaro Takenaka <ritarot634@gmail.com>
In-Reply-To: <YmfVpecE2UuiP6p8@salvia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thanks for your reply.

> In 5.4, this check is only enabled for xfrm.
Packet loss occurs with xmit (xfrm is not confirmed).
I also experienced packet loss with 5.10, which runs dst_check periodically.
Route GC and flowtable GC are not synchronized, so it is
necessary to check each packet.

> dst_check() should deal with this.
When dst_check is used, the performance degradation is not negligible.
From 900 Mbps to 700 Mbps with QCA9563 simple firewall.

I am sorry if you have received this mail twice.

On 2022/04/26 20:21, Pablo Neira Ayuso wrote:
> Hi,
> 
> On Mon, Apr 25, 2022 at 05:08:38PM +0900, Ritaro Takenaka wrote:
>> Fixes sporadic IPv6 packet loss when flow offloading is enabled.
>> IPv6 route GC calls dst_dev_put() which makes dst.dev blackhole_netdev
>> even if dst is cached in flow offload. If a packet passes through this
>> invalid flow, packet loss will occur.
>> This is from Commit 227e1e4d0d6c (netfilter: nf_flowtable: skip device
>> lookup from interface index), as outdev was cached independently before.
>> Packet loss is reported on OpenWrt with Linux 5.4 and later.
> 
> dst_check() should deal with this.
> 
> In 5.4, this check is only enabled for xfrm.
> 
>> Signed-off-by: Ritaro Takenaka <ritarot634@gmail.com>
>> ---
>>  net/netfilter/nf_flow_table_ip.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
>> index 32c0eb1b4..12f81661d 100644
>> --- a/net/netfilter/nf_flow_table_ip.c
>> +++ b/net/netfilter/nf_flow_table_ip.c
>> @@ -624,6 +624,11 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
>>  	if (nf_flow_state_check(flow, ip6h->nexthdr, skb, thoff))
>>  		return NF_ACCEPT;
>>  
>> +	if (unlikely(tuplehash->tuple.dst_cache->dev == blackhole_netdev)) {
>> +		flow_offload_teardown(flow);
>> +		return NF_ACCEPT;
>> +	}
>> +
>>  	if (skb_try_make_writable(skb, thoff + hdrsize))
>>  		return NF_DROP;
>>  
>> -- 
>> 2.25.1
>>
