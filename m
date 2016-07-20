From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf-next 3/3] netfilter: nft_log: fix snaplen does not
 truncate packets
Date: Wed, 20 Jul 2016 17:00:45 +0800
Message-ID: <CAML_gOd8bYutiMoqAD74vpUh5vGYLWPNN-7Hoz3aAFL7-K6rXw@mail.gmail.com>
References: <1468845857-30291-1-git-send-email-zlpnobody@163.com>
 <1468845857-30291-4-git-send-email-zlpnobody@163.com> <20160719181600.GD6116@salvia>
 <60a932e7.d60.15605635cca.Coremail.zlpnobody@163.com> <20160720082521.GA1336@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>, netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:36423 "EHLO
	mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbcGTJAs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jul 2016 05:00:48 -0400
Received: by mail-vk0-f66.google.com with SMTP id r135so3703106vkf.3
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2016 02:00:47 -0700 (PDT)
In-Reply-To: <20160720082521.GA1336@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

2016-07-20 16:25 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> On Wed, Jul 20, 2016 at 07:00:13AM +0800, Liping Zhang wrote:
>> I find that nftables already support this feature, the following command mean to truncate packets
>> to 100 bytes before logging to the userspace:
>>   #nft add rule filter input log group 0 snaplen 100
>>
>> Before my patch, it does not work.
>> And after apply my patch, it works as expected.
>
> If I git grep NF_LOG_F_COPY_LEN from the nftables.git tree, I don't
> see any reference to this flag being set.
>

I use this NF_LOG_F_COPY_LEN flag as internal, and when the user specify
the NFTA_LOG_SNAPLEN attrribute, it will be enabled automatically.
See my codes:

               if (tb[NFTA_LOG_SNAPLEN] != NULL) {
+                       li->u.ulog.flags |= NF_LOG_F_COPY_LEN;

-               if (li->u.ulog.copy_len) {
+               if (li->u.ulog.flags & NF_LOG_F_COPY_LEN) {
                         if (nla_put_be32(skb, NFTA_LOG_SNAPLEN,
                                         htonl(li->u.ulog.copy_len)))

So this flag will not be setted from userspace explicitly and will not
be dumped to the userspace.

> Then, nft_log kernel has been actually working fine since the
> beginning. It would be good anyway if we set this flag on from
> userspace to leave things in consistent state.

Do you mean this is something similar to "nflog-size" and
"nflog-range" in xt_NFLOG?
"nft log snaplen 100" cannot work since the beginning, so we should
keep it unchanged? And
maybe we should introduce a new option like "nft log snapsize 100"?
