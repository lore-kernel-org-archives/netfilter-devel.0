Return-Path: <SRS0=4EdP=WW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BD88C3A59F
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Aug 2019 13:52:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14E02206E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Aug 2019 13:52:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732141AbfHZNw1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Aug 2019 09:52:27 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:16339 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731774AbfHZNw1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Aug 2019 09:52:27 -0400
Received: from [192.168.1.4] (unknown [116.234.4.202])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 0627941624;
        Mon, 26 Aug 2019 21:52:15 +0800 (CST)
Subject: Re: [PATCH nft v5] meta: add ibrpvid and ibrvproto support
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <1566567928-18121-1-git-send-email-wenxu@ucloud.cn>
 <20190826102615.cqfidve47clkhzdr@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <989de2f9-c66b-aae1-ce39-50baffd98a2b@ucloud.cn>
Date:   Mon, 26 Aug 2019 21:51:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190826102615.cqfidve47clkhzdr@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVQ01NS0tLSUJPTUNOSE1ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OCI6PCo5KTgzPTxCFVE5NDI0
        SQwaFFFVSlVKTk1NQ0lMTkhNSENIVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpKTVVJ
        SE9VT1VJS0lZV1kIAVlBSUNLTTcG
X-HM-Tid: 0a6cce32ded92086kuqy0627941624
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


在 2019/8/26 18:26, Pablo Neira Ayuso 写道:
> On Fri, Aug 23, 2019 at 09:45:28PM +0800, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> This allows you to match the bridge pvid and vlan protocol, for
>> instance:
>>
>> nft add rule bridge firewall zones meta ibrvproto 0x8100
>> nft add rule bridge firewall zones meta ibrpvid 100
> When running python nft-tests.py with -j, I get this here:
>
> bridge/meta.t: WARNING: line 7: '{"nftables": [{"add": {"rule":
> {"table": "test-bridge", "chain": "input", "family": "bridge", "expr":
> [{"match": {"op": "==", "right": "0x8100", "left": {"meta": {"key":
> "ibrvproto"}}}}]}}}]}': '[{"match": {"left": {"meta": {"key":
> "ibrvproto"}}, "op": "==", "right": "0x8100"}}]' mismatches
> '[{"match": {"left": {"meta": {"key": "ibrvproto"}}, "op": "==",
> "right": 33024}}]'
> /tmp/nftables/tests/py/bridge/meta.t.json.output.got:
> WARNING: line 2: Wrote JSON output for rule meta ibrvproto 0x8100
>
> Then, if I type:
>
>         nft rule x y meta protocol vlan
>
> Then, printing shows:
>
> table ip x {
>         chain y {
>                 meta protocol vlan
>         }
> }
>
> However, with:
>
>         nft rule x y meta ibrvproto vlan
>
> I get this:
>
> table bridge x {
>         chain y {
>                 meta ibrvproto 0x8100
>         }
> }
>
> I think the problem the endianess in the new key definitions are not
> correct.
>
> The br_vlan_get_proto() in the kernel returns a value in network byte
> order.
>
> I think this does not match either then? Because bytecode is
> incorrect?

The br_vlan_get_proto returns vlan_proto in host byte order.

>
> Thanks.
>
