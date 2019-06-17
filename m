Return-Path: <SRS0=CDuC=UQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40752C31E5B
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 21:58:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04C4220673
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 21:58:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="I+8Deu4A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfFQV6T (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 17:58:19 -0400
Received: from mx1.riseup.net ([198.252.153.129]:47218 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbfFQV6T (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 17:58:19 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 677C31A5A48;
        Mon, 17 Jun 2019 14:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1560808698; bh=vlLiOB00+j38A7K5cuAIl+TEIMgsVT1R6OmLoWW6JOQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=I+8Deu4AWk3mwboAS5SJdJzxSQAEtjFHOCGnnrb29Ej+6yT8SWvr8bNQOwfDoPnDv
         8MBSr11YpJ5+tbYLKlww5H4cT/Ub61Y03/oz/cwvsMTFoLqrn7uWYRmE011ituQunt
         fvl7I62PaDchfKXhNs/TqvMD6QwnElgvgwtf2mOc=
X-Riseup-User-ID: C3310C9A01B404A86CC4A926F87895ACB3C859F3A22A8D767EEDDF00EEFD1445
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id A5498120894;
        Mon, 17 Jun 2019 14:58:17 -0700 (PDT)
Subject: Re: [PATCH nf-next WIP] netfilter: nf_tables: Add SYNPROXY support
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <20190617103234.1357-1-ffmancera@riseup.net>
 <20190617103234.1357-2-ffmancera@riseup.net>
 <20190617154545.pr2nhk4itydcya3e@salvia>
 <94f3c031-9952-f65a-6f8a-ef58de848217@riseup.net>
 <20190617215514.6zpkgww7a3wjhsj3@salvia>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <a5612bc7-a20e-a1da-fb2f-fbc203f87c9e@riseup.net>
Date:   Mon, 17 Jun 2019 23:58:30 +0200
MIME-Version: 1.0
In-Reply-To: <20190617215514.6zpkgww7a3wjhsj3@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 6/17/19 11:55 PM, Pablo Neira Ayuso wrote:
> On Mon, Jun 17, 2019 at 09:49:43PM +0200, Fernando Fernandez Mancera wrote:
>> Hi Pablo, comments below.
>>
>> On 6/17/19 5:45 PM, Pablo Neira Ayuso wrote:
>>> On Mon, Jun 17, 2019 at 12:32:35PM +0200, Fernando Fernandez Mancera wrote:
>>>> Add SYNPROXY module support in nf_tables. It preserves the behaviour of the
>>>> SYNPROXY target of iptables but structured in a different way to propose
>>>> improvements in the future.
>>>>
>>>> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
>>>> ---
>>>>  include/uapi/linux/netfilter/nf_SYNPROXY.h |   4 +
>>>>  include/uapi/linux/netfilter/nf_tables.h   |  16 +
>>>>  net/netfilter/Kconfig                      |  11 +
>>>>  net/netfilter/Makefile                     |   1 +
>>>>  net/netfilter/nft_synproxy.c               | 328 +++++++++++++++++++++
>>>>  5 files changed, 360 insertions(+)
>>>>  create mode 100644 net/netfilter/nft_synproxy.c
>>>>
>> [...]
>>>> +
>>>> +static void nft_synproxy_eval(const struct nft_expr *expr,
>>>> +			      struct nft_regs *regs,
>>>> +			      const struct nft_pktinfo *pkt)
>>>> +{
>>>
>>> You have to check if this is TCP traffic in first place, otherwise UDP
>>> packets may enter this path :-).
>>>
>>>> +	switch (nft_pf(pkt)) {
>>>> +	case NFPROTO_IPV4:
>>>> +		nft_synproxy_eval_v4(expr, regs, pkt);
>>>> +		return;
>>>> +#if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
>>>> +	case NFPROTO_IPV6:
>>>> +		nft_synproxy_eval_v6(expr, regs, pkt);
>>>> +		return;
>>>> +#endif
>>>
>>> Please, use skb->protocol instead of nft_pf(), I would like we can use
>>> nft_synproxy from NFPROTO_NETDEV (ingress) and NFPROTO_BRIDGE families
>>> too.
>>>
>>
>> If I use skb->protocol no packet enters in the path. What do you
>> recommend me? Other than that, the rest of the suggestions are done and
>> it has been tested and it worked as expected. Thanks :-)
> 
> skb->protocol uses big endian representation, you have to check for:
> 
>         switch (skb->protocol) {
>         case htons(ETH_P_IP):
>                 ...
>                 break;
>         case htons(ETH_P_IPV6):
>                 ...
>                 break;
>         }
> 


Oh, I didn't know that. A patch series including tests and documentation
it is going to be ready soon if everything seem fine to you. After this,
I think we can implement some improvements. Thanks :-)
