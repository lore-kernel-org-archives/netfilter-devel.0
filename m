Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B572C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Jan 2022 14:20:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241606AbiAKOUc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Jan 2022 09:20:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46631 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241424AbiAKOUa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Jan 2022 09:20:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641910829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DLeGoC7PaBq143VYr5AITMLTNpwAc7CdBxFfAI3CL8Y=;
        b=GE03wYIH9CeIQ/fHh1/omOwjFNfa0wgiC+kotoQg9bZ2dFXU8vJspX9jY4zinpi2zCjy2n
        SvWRo363kwk3NeGJLOHb7qnzfGiMqDkn8CGX0qNMKByeDwB0z3RpS1WFLjhuWC7j6wupaI
        mLbSPjmPUANX/rsV1S103dTqXca0Pfg=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-240-sJvUdq6YO6aMuXN89bucyA-1; Tue, 11 Jan 2022 09:20:27 -0500
X-MC-Unique: sJvUdq6YO6aMuXN89bucyA-1
Received: by mail-ot1-f69.google.com with SMTP id t17-20020a0568301e3100b0055c78bc02a2so3158816otr.19
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Jan 2022 06:20:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=DLeGoC7PaBq143VYr5AITMLTNpwAc7CdBxFfAI3CL8Y=;
        b=Slc9PTpix7+hH+94qCa4xPBn2//AAFW2pWjncUjdTLR9E80f1BY9Q9ghDOuLjyp8HQ
         jrP9CHK0SudYtOwA1vTDzrd//x+8hI54789CeRXi9kVO78IQMKcTENLF/jjHqadS2jur
         /AvQAnJemK+xAhkSwzVvmfsdOAE3fm6FyXpEQwce7pIRJi2mNJ4eUvOREWwgXQzq8/7W
         pmdoKLoiJaKsnlwZKGEmiPebJ/r8s4a2l3xI00qU5XcMcwzztIZgGGVDdPiT9tXo+maO
         6n5oxabe8ZRNP3BPDNiDQr+5loK2OzYwJsqWpfUq9Kq2iMXnOD/vXepPKAoDW5YSlj4a
         AkNQ==
X-Gm-Message-State: AOAM530NErECjAj1Od5jULc5WYyPMCvKS5TM8sneGQn2JzYoS6vRLxng
        Rcncr1riQnTuBH7dyWxmJk1d975TTxa4FBA9Ht4QApU2Mi5z6fx4gRXRhixm0oZuGC+r58IHG5d
        0IUhuXkuwlNdxPuDcHVX6SRAy6azx
X-Received: by 2002:a05:6830:924:: with SMTP id v36mr3446331ott.223.1641910827113;
        Tue, 11 Jan 2022 06:20:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy7WmC88LeKTxcunkdMEN5AxzKjcRCjyWscxMjkFN+ASB2E8PFbgPaKf27NYG4IXhxj5clvtg==
X-Received: by 2002:a05:6830:924:: with SMTP id v36mr3446315ott.223.1641910826870;
        Tue, 11 Jan 2022 06:20:26 -0800 (PST)
Received: from localhost.localdomain (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id g50sm1672559oic.25.2022.01.11.06.20.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jan 2022 06:20:26 -0800 (PST)
Subject: Re: [PATCH] netfilter: extend CONFIG_NF_CONNTRACK compile time checks
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211225173744.3318250-1-trix@redhat.com>
 <Yd1SCbvjeXE+ceRo@salvia>
From:   Tom Rix <trix@redhat.com>
Message-ID: <c31ca0e7-2895-eae9-c52d-41c0f187443e@redhat.com>
Date:   Tue, 11 Jan 2022 06:20:24 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <Yd1SCbvjeXE+ceRo@salvia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 1/11/22 1:46 AM, Pablo Neira Ayuso wrote:
> Hi,
>
> On Sat, Dec 25, 2021 at 09:37:44AM -0800, trix@redhat.com wrote:
>> From: Tom Rix <trix@redhat.com>
>>
>> Extends
>> commit 83ace77f5117 ("netfilter: ctnetlink: remove get_ct indirection")
>>
>> Add some compile time checks by following the ct and ctinfo variables
>> that are only set when CONFIG_NF_CONNTRACK is enabled.
>>
>> In nfulnl_log_packet(), ct is only set when CONFIG_NF_CONNTRACK
>> is enabled. ct's later use in __build_packet_message() is only
>> meaningful when CONFIG_NF_CONNTRACK is enabled, so add a check.
>>
>> In nfqnl_build_packet_message(), ct and ctinfo are only set when
>> CONFIG_NF_CONNTRACK is enabled.  Add a check for their decl and use.
>>
>> nfqnl_ct_parse() is a static function, move the check to the whole
>> function.
>>
>> In nfqa_parse_bridge(), ct and ctinfo are only set by the only
>> call to nfqnl_ct_parse(), so add a check for their decl and use.
>>
>> Consistently initialize ctinfo to 0.
> Are compile warning being trigger without this patch, maybe with
> CONFIG_NF_CONNTRACK=n?

No compiler warnings, this was found by visual inspection.

Robot says to entend more, so I want to make sure a human is also 
interested.

Tom

>
>> Signed-off-by: Tom Rix <trix@redhat.com>
>> ---
>>   net/netfilter/nfnetlink_log.c   |  4 +++-
>>   net/netfilter/nfnetlink_queue.c | 18 +++++++++++++-----
>>   2 files changed, 16 insertions(+), 6 deletions(-)
>>
>> diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
>> index ae9c0756bba59..e79d152184b71 100644
>> --- a/net/netfilter/nfnetlink_log.c
>> +++ b/net/netfilter/nfnetlink_log.c
>> @@ -627,9 +627,11 @@ __build_packet_message(struct nfnl_log_net *log,
>>   			 htonl(atomic_inc_return(&log->global_seq))))
>>   		goto nla_put_failure;
>>   
>> +#if IS_ENABLED(CONFIG_NF_CONNTRACK)
>>   	if (ct && nfnl_ct->build(inst->skb, ct, ctinfo,
>>   				 NFULA_CT, NFULA_CT_INFO) < 0)
>>   		goto nla_put_failure;
>> +#endif
>>   
>>   	if ((pf == NFPROTO_NETDEV || pf == NFPROTO_BRIDGE) &&
>>   	    nfulnl_put_bridge(inst, skb) < 0)
>> @@ -689,7 +691,7 @@ nfulnl_log_packet(struct net *net,
>>   	struct nfnl_log_net *log = nfnl_log_pernet(net);
>>   	const struct nfnl_ct_hook *nfnl_ct = NULL;
>>   	struct nf_conn *ct = NULL;
>> -	enum ip_conntrack_info ctinfo;
>> +	enum ip_conntrack_info ctinfo = 0;
>>   
>>   	if (li_user && li_user->type == NF_LOG_TYPE_ULOG)
>>   		li = li_user;
>> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
>> index 44c3de176d186..d59cae7561bf8 100644
>> --- a/net/netfilter/nfnetlink_queue.c
>> +++ b/net/netfilter/nfnetlink_queue.c
>> @@ -386,8 +386,10 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>>   	struct sk_buff *entskb = entry->skb;
>>   	struct net_device *indev;
>>   	struct net_device *outdev;
>> +#if IS_ENABLED(CONFIG_NF_CONNTRACK)
>>   	struct nf_conn *ct = NULL;
>>   	enum ip_conntrack_info ctinfo = 0;
>> +#endif
>>   	struct nfnl_ct_hook *nfnl_ct;
>>   	bool csum_verify;
>>   	char *secdata = NULL;
>> @@ -595,8 +597,10 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>>   	if (seclen && nla_put(skb, NFQA_SECCTX, seclen, secdata))
>>   		goto nla_put_failure;
>>   
>> +#if IS_ENABLED(CONFIG_NF_CONNTRACK)
>>   	if (ct && nfnl_ct->build(skb, ct, ctinfo, NFQA_CT, NFQA_CT_INFO) < 0)
>>   		goto nla_put_failure;
>> +#endif
>>   
>>   	if (cap_len > data_len &&
>>   	    nla_put_be32(skb, NFQA_CAP_LEN, htonl(cap_len)))
>> @@ -1104,13 +1108,13 @@ static int nfqnl_recv_verdict_batch(struct sk_buff *skb,
>>   	return 0;
>>   }
>>   
>> +#if IS_ENABLED(CONFIG_NF_CONNTRACK)
>>   static struct nf_conn *nfqnl_ct_parse(struct nfnl_ct_hook *nfnl_ct,
>>   				      const struct nlmsghdr *nlh,
>>   				      const struct nlattr * const nfqa[],
>>   				      struct nf_queue_entry *entry,
>>   				      enum ip_conntrack_info *ctinfo)
>>   {
>> -#if IS_ENABLED(CONFIG_NF_CONNTRACK)
>>   	struct nf_conn *ct;
>>   
>>   	ct = nf_ct_get(entry->skb, ctinfo);
>> @@ -1125,10 +1129,8 @@ static struct nf_conn *nfqnl_ct_parse(struct nfnl_ct_hook *nfnl_ct,
>>   				      NETLINK_CB(entry->skb).portid,
>>   				      nlmsg_report(nlh));
>>   	return ct;
>> -#else
>> -	return NULL;
>> -#endif
>>   }
>> +#endif
>>   
>>   static int nfqa_parse_bridge(struct nf_queue_entry *entry,
>>   			     const struct nlattr * const nfqa[])
>> @@ -1172,11 +1174,13 @@ static int nfqnl_recv_verdict(struct sk_buff *skb, const struct nfnl_info *info,
>>   	struct nfnl_queue_net *q = nfnl_queue_pernet(info->net);
>>   	u_int16_t queue_num = ntohs(info->nfmsg->res_id);
>>   	struct nfqnl_msg_verdict_hdr *vhdr;
>> -	enum ip_conntrack_info ctinfo;
>>   	struct nfqnl_instance *queue;
>>   	struct nf_queue_entry *entry;
>>   	struct nfnl_ct_hook *nfnl_ct;
>> +#if IS_ENABLED(CONFIG_NF_CONNTRACK)
>>   	struct nf_conn *ct = NULL;
>> +	enum ip_conntrack_info ctinfo = 0;
>> +#endif
>>   	unsigned int verdict;
>>   	int err;
>>   
>> @@ -1198,11 +1202,13 @@ static int nfqnl_recv_verdict(struct sk_buff *skb, const struct nfnl_info *info,
>>   	/* rcu lock already held from nfnl->call_rcu. */
>>   	nfnl_ct = rcu_dereference(nfnl_ct_hook);
>>   
>> +#if IS_ENABLED(CONFIG_NF_CONNTRACK)
>>   	if (nfqa[NFQA_CT]) {
>>   		if (nfnl_ct != NULL)
>>   			ct = nfqnl_ct_parse(nfnl_ct, info->nlh, nfqa, entry,
>>   					    &ctinfo);
>>   	}
>> +#endif
>>   
>>   	if (entry->state.pf == PF_BRIDGE) {
>>   		err = nfqa_parse_bridge(entry, nfqa);
>> @@ -1218,8 +1224,10 @@ static int nfqnl_recv_verdict(struct sk_buff *skb, const struct nfnl_info *info,
>>   				 payload_len, entry, diff) < 0)
>>   			verdict = NF_DROP;
>>   
>> +#if IS_ENABLED(CONFIG_NF_CONNTRACK)
>>   		if (ct && diff)
>>   			nfnl_ct->seq_adjust(entry->skb, ct, ctinfo, diff);
>> +#endif
>>   	}
>>   
>>   	if (nfqa[NFQA_MARK])
>> -- 
>> 2.26.3
>>

