Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D51C77B6C
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Apr 2023 09:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbjDMJ0N (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 13 Apr 2023 05:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjDMJ0L (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2023 05:26:11 -0400
X-Greylist: delayed 75664 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 13 Apr 2023 02:26:08 PDT
Received: from 8.mo511.mail-out.ovh.net (8.mo511.mail-out.ovh.net [46.105.79.208])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328DC2708
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2023 02:26:08 -0700 (PDT)
Received: from ex4.mail.ovh.net (unknown [10.109.146.56])
        by mo511.mail-out.ovh.net (Postfix) with ESMTPS id EE39B268EC;
        Thu, 13 Apr 2023 09:26:03 +0000 (UTC)
Received: from [192.168.1.125] (93.21.160.242) by DAG10EX1.indiv4.local
 (172.16.2.91) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.23; Thu, 13 Apr
 2023 11:26:00 +0200
Message-ID: <53f85025-2516-d50a-c233-95ed273f46fd@naccy.de>
Date:   Thu, 13 Apr 2023 11:26:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH bpf-next 0/6] bpf: add netfilter program type
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <dxu@dxuuu.xyz>
References: <20230405161116.13565-1-fw@strlen.de>
 <7d97222a-36c1-ee77-4ad6-d8d2c6056d4c@naccy.de>
 <20230412094554.GD6670@breakpoint.cc>
From:   Quentin Deslandes <qde@naccy.de>
In-Reply-To: <20230412094554.GD6670@breakpoint.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [93.21.160.242]
X-ClientProxiedBy: CAS9.indiv4.local (172.16.1.9) To DAG10EX1.indiv4.local
 (172.16.2.91)
X-Ovh-Tracer-Id: 14604329170700922478
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrvdekkedgudeiucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgihesthejredttddvjeenucfhrhhomhepsfhuvghnthhinhcuffgvshhlrghnuggvshcuoehquggvsehnrggttgihrdguvgeqnecuggftrfgrthhtvghrnheptdfgveetgfetkeejvefhudeiueeufeeffeeitdffjeevudehveejveegffdvkeefnecukfhppeduvdejrddtrddtrddupdelfedrvddurdduiedtrddvgedvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeoqhguvgesnhgrtggthidruggvqedpnhgspghrtghpthhtohepuddprhgtphhtthhopehffiesshhtrhhlvghnrdguvgdpnhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhnvghtfhhilhhtvghrqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdgsphhfsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdgugihusegugihuuhhurdighiiipdfovfetjfhoshhtpehmohehuddupdhmohguvgepshhmthhpohhuth
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 12/04/2023 11:45, Florian Westphal wrote:
> Quentin Deslandes <qde@naccy.de> wrote:
>> On 05/04/2023 18:11, Florian Westphal wrote:
>>> Add minimal support to hook bpf programs to netfilter hooks, e.g.
>>> PREROUTING or FORWARD.
>>>
>>> For this the most relevant parts for registering a netfilter
>>> hook via the in-kernel api are exposed to userspace via bpf_link.
>>>
>>> The new program type is 'tracing style', i.e. there is no context
>>> access rewrite done by verifier, the function argument (struct bpf_nf_ctx)
>>> isn't stable.
>>> There is no support for direct packet access, dynptr api should be used
>>> instead.
>>
>> Does this mean the verifier will reject any program accessing ctx->skb
>> (e.g. ctx->skb + X)?
> 
> Do you mean access to ctx->skb->data + X?  If so, yes, that won't work.
> 
> Otherwise, then no, it just means that programs might have to be recompiled
> if they lack needed relocation information, but only if bpf_nf_ctx structure is
> changed.
> 
> Initial version used "__sk_buff *skb", like e.g. clsact.  I was told
> to not do that and expose the real kernel-side structure instead and to
> not bother with direct packet access (skb->data access) support.
> 

That's exactly what I meant, thanks.

>>>  #include "vmlinux.h"
>>> extern int bpf_dynptr_from_skb(struct __sk_buff *skb, __u64 flags,
>>>                                struct bpf_dynptr *ptr__uninit) __ksym;
>>> extern void *bpf_dynptr_slice(const struct bpf_dynptr *ptr, uint32_t offset,
>>>                                    void *buffer, uint32_t buffer__sz) __ksym;
>>> SEC("netfilter")
>>> int nf_test(struct bpf_nf_ctx *ctx)
>>> {
>>> 	struct nf_hook_state *state = ctx->state;
>>> 	struct sk_buff *skb = ctx->skb;
> 
> ctx->skb is dereferenced...
> 
>>> 	if (bpf_dynptr_from_skb(skb, 0, &ptr))
>>> 		return NF_DROP;
> 
> ... dynptr is created ...
> 
>>> 	iph = bpf_dynptr_slice(&ptr, 0, &_iph, sizeof(_iph));
>>> 	if (!iph)
>>> 		return NF_DROP;
>>> 	th = bpf_dynptr_slice(&ptr, iph->ihl << 2, &_th, sizeof(_th));
> 
> ip header access.

