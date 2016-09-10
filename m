From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf-next] netfilter: nft_queue: check the validation of
 queues_total and queuenum
Date: Sat, 10 Sep 2016 12:56:06 +0800
Message-ID: <CAML_gOcr9ZytWK19BFx0CcTBWoC_+RtBkRFnYtmPLVV3Oh3RBg@mail.gmail.com>
References: <1473172417-8311-1-git-send-email-zlpnobody@163.com> <20160909140434.GA25982@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>, netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:36144 "EHLO
        mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751066AbcIJE4I (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 10 Sep 2016 00:56:08 -0400
Received: by mail-vk0-f52.google.com with SMTP id m62so30762210vkd.3
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Sep 2016 21:56:07 -0700 (PDT)
In-Reply-To: <20160909140434.GA25982@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2016-09-09 22:04 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> More comments on things I see on nft_queue at this stage:
>
> 1) Another issue, I can see nfqueue_hash() depends on
> CONFIG_IP6_NF_IPTABLES, this is not good since nft_queue
> infrastructure should not depend on iptables. Probably making this
> dependent of CONFIG_IPV6 is enough, unless you find anything better.

Yes, I can send a patch to improve this.

> 2) It would be good if nft_queue takes a _SREG_FROM and _SREG_TO to
> select the queue numbers, in a similar fashion to nft_nat. The idea is
> that we allow plugging nft_queue into nftables mapping, currently this
> is not working given that the queue number is passed as an attribute
> that contains the value.

I will have a look into this. I think _SREG_FROM and _SREG_TO
stands for [startqnum:endqnum], currently queuenum and queue_total
has a restriction, see below.

> 3) It would be good to add py tests with larger range. I remember that
> the range 1-65535 currently doesn't work in both nft_queue and
> xt_NFQUEUE because the queue_total arithmetics are not right.

Cover with large range is necessary. Yes, I find that range 0-65535(not 1-65535)
currently doesn't work in both. This is because queue_total is U16 type,
but 0-65535 means queue_total is 65536, this is overflow, so queue_total is
treated as zero.

A workaround method is that when the queue_total is 0, we treat it as 65536,
but it's a little ugly and tricky. But if we use [startqnum:endqnum],
this problem
will be not exist.

I think for iptables, it's simple, we can introduce a new revision 4
to fix this problem.

But for nftables, if we just convert to use the new attribute _SREG_FROM and
_SREG_TO, when the user use the new nftables and the old kernel, queue expr
cannot work well. It seems that we must handle the compatibility in
the user space
too.

Thanks Pablo!
