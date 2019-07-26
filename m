Return-Path: <SRS0=19L1=VX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49B97C7618B
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Jul 2019 10:23:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 208B8229F9
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Jul 2019 10:23:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbfGZKX3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Jul 2019 06:23:29 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:9424 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfGZKX3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Jul 2019 06:23:29 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id B057941C4B
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Jul 2019 18:23:26 +0800 (CST)
Subject: Re: vrf and flowtable problems
Cc:     netfilter-devel@vger.kernel.org
References: <20190725101044.kkoyziz57iynjmzc@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <d68741d2-9810-41a1-4467-1b6f6820dead@ucloud.cn>
Date:   Fri, 26 Jul 2019 18:23:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190725101044.kkoyziz57iynjmzc@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVTk5LQkJCQkJCS09NSEhZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PlE6MBw4IjgxDEs8MBZDSUs4
        TSpPCyJVSlVKTk1PSkhNTUtMTE1MVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSUJLQjcG
X-HM-Tid: 0a6c2dce8c232086kuqyb057941c4b
To:     unlisted-recipients:; (no To-header on input)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pabo,

I think it's the problem of their iptables offload patch.

https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob;f=target/linux/generic/hack-4.19/650-netfilter-add-xt_OFFLOAD-target.patch

@304,  It gets the this_dst and other_dst according to src ip of tuple. It is not correct. That's why they swap iifdx and oifdx can work around

It should like nftables do.  this_dst=skb_dst and other_dst get route through src ip of tuple in origin dir.

294 +static struct dst_entry *
295 +xt_flowoffload_dst(const struct nf_conn *ct, enum ip_conntrack_dir dir,
296 + const struct xt_action_param *par)
297 +{
298 + struct dst_entry *dst = NULL;
299 + struct flowi fl;
300 +
301 + memset(&fl, 0, sizeof(fl));
302 + switch (xt_family(par)) {
303 + case NFPROTO_IPV4:
304 + fl.u.ip4.daddr = ct->tuplehash[dir].tuple.src.u3.ip;
305 + break;
306 + case NFPROTO_IPV6:
307 + fl.u.ip6.saddr = ct->tuplehash[dir].tuple.dst.u3.in6;
308 + fl.u.ip6.daddr = ct->tuplehash[dir].tuple.src.u3.in6;
309 + break;
310 + }
311 +
312 + nf_route(xt_net(par), &dst, &fl, false, xt_family(par));
313 +
314 + return dst;
315 +}
316 +
317 +static int
318 +xt_flowoffload_route(struct sk_buff *skb, const struct nf_conn *ct,
319 + const struct xt_action_param *par,
320 + struct nf_flow_route *route, enum ip_conntrack_dir dir)
321 +{
322 + struct dst_entry *this_dst, *other_dst;
323 +
324 + this_dst = xt_flowoffload_dst(ct, dir, par);
325 + other_dst = xt_flowoffload_dst(ct, !dir, par);
326 + if (!this_dst || !other_dst)
327 + return -ENOENT;
328 +
329 + if (dst_xfrm(this_dst) || dst_xfrm(other_dst))
330 + return -EINVAL;
331 +
332 + route->tuple[dir].dst = this_dst;
333 + route->tuple[!dir].dst = other_dst;

On 7/25/2019 6:10 PM, Pablo Neira Ayuso wrote:
> Hi,
>
> There are reports
>
> https://github.com/openwrt/openwrt/pull/2266#issuecomment-514681715
>
> This report might not be your fault, but you can probably help fixing
> bugs before we move on anywhere else.
>
