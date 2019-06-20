Return-Path: <SRS0=UCdS=UT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B41B6C4646C
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jun 2019 11:39:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DE182075E
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jun 2019 11:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731747AbfFTLj1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jun 2019 07:39:27 -0400
Received: from m97179.mail.qiye.163.com ([220.181.97.179]:52956 "EHLO
        m97179.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbfFTLj1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jun 2019 07:39:27 -0400
Received: from [192.168.1.3] (unknown [58.38.4.250])
        by m97179.mail.qiye.163.com (Hmail) with ESMTPA id 7FE3AE014D0;
        Thu, 20 Jun 2019 19:39:24 +0800 (CST)
Subject: Re: [PATCH nf-next] netfilter: bridge: Fix non-untagged fragment
 packet
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
References: <1560954907-20071-1-git-send-email-wenxu@ucloud.cn>
 <20190620104804.cbbodvw2llnt6qcl@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <eba0383f-9089-de4d-c87c-7429443a3014@ucloud.cn>
Date:   Thu, 20 Jun 2019 19:39:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190620104804.cbbodvw2llnt6qcl@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUhXWQgYFAkeWUFZVkpVTU9PS0tLT0pKS0hITUhZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PDY6SQw4UTg8OhcsHyMpMDcs
        ORUKCUpVSlVKTk1KS0hLTE1PTEhMVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWU5DVUhD
        VU9VSU5LWVdZCAFZQUlNSUs3Bg++
X-HM-Tid: 0a6b74af287a20bdkuqy7fe3ae014d0
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


在 2019/6/20 18:48, Pablo Neira Ayuso 写道:
> On Wed, Jun 19, 2019 at 10:35:07PM +0800, wenxu@ucloud.cn wrote:
> [...]
>> So if the first fragment packet don't contain vlan tag, all of the
>> remain should not contain vlan tag..
> If I understand correctly, the problem is this:
>
> * First fragment comes with no vlan tag.
> * Second fragment comes with vlan tag.
>
> If you have a vlan setup, you have to use ct zone to map the vlan id
> to the corresponding ct zone.
>
> nf_ct_br_defrag4() calls:
>
>         err = ip_defrag(state->net, skb,
>                                 IP_DEFRAG_CONNTRACK_BRIDGE_IN + zone_id);
>
> if ct zones are used, first fragment will go to defrag queue
> IP_DEFRAG_CONNTRACK_BRIDGE_IN + 0, while second fragment will go to
> IP_DEFRAG_CONNTRACK_BRIDGE_IN + zone_id.
>
> So they will go to different defrag queues.
>
It's not correct.

The problem is both the first and second fragment comes with vlan tag (It's make sense).

After the defrag(in fast mode), the two skb chains to a one skb.  When the packet send to the veth1 port which with flags "untagged". So the only the first skb clear the vlan tag, but the second one also contain vlan tag.  In the refrag which also in the fast mode only split the chian skb.  So it leads the first skb with no vlan tag which is correct. But the second skb wit vlan tag which is not correct




