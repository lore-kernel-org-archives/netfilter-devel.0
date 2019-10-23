Return-Path: <SRS0=QRwA=YQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D5B6CA9EAE
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Oct 2019 03:57:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDF552086D
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Oct 2019 03:57:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732753AbfJWD5h (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Oct 2019 23:57:37 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:12707 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbfJWD5h (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Oct 2019 23:57:37 -0400
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Oct 2019 23:57:35 EDT
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 222215C1874;
        Wed, 23 Oct 2019 11:50:04 +0800 (CST)
Subject: Re: [PATCH nf-next,RFC 0/2] nf_tables encapsulation/decapsulation
 support
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
References: <20191022154733.8789-1-pablo@netfilter.org>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <10ad5a64-f9cb-0ee6-2daa-5b88884fd224@ucloud.cn>
Date:   Wed, 23 Oct 2019 11:49:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191022154733.8789-1-pablo@netfilter.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSENNS0tLSk5NT0tJTkJZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MhQ6Chw6KTg2IR9WSRZJSTg8
        KiEKCQxVSlVKTkxKQ0tJTUtPT0pNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSE5MTTcG
X-HM-Tid: 0a6df6bc63242087kuqy222215c1874
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 10/22/2019 11:47 PM, Pablo Neira Ayuso wrote:
> Hi,
>
> This is a RFC patchset, untested, to introduce new infrastructure to
> specify protocol decapsulation and encapsulation actions. This patchset
> comes with initial support for VLAN, eg.
>
> 1) VLAN decapsulation:
>
> 	... meta iif . vlan id { eth0 . 10, eth1 . 11} decap vlan
>
> The decapsulation is a single statement with no extra options.

Currently there is no vlan meta match expr.  So it is better to extend the meta expr or add new

ntf_vlan_get_expr?

>
> 2) VLAN encapsulation:
>
> 	add vlan "network0" { type push; id 100; proto 0x8100; }
>         add vlan "network1" { type update; id 101; }
> 	... encap vlan set ip daddr map { 192.168.0.0/24 : "network0",
> 					  192.168.1.0/24 : "network1" }
>
> The idea is that the user specifies the vlan policy through object
> definition, eg. "network0" and "network1", then it applies this policy
> via the "encap vlan set" statement.
>
> This infrastructure should allow for more encapsulation protocols
> with little work, eg. MPLS.

So the tunnel already exist in nft_tunnel also can add in this encapsulation protocols

as ip.

like ip-route

encap ip id 100 dst 10.0.0.1?

>
> I have places the encap object and the decap expression in the same
> nft_encap module.
>
> I'm still considering to extend the object infrastructure to specify
> the operation type through the rule, ie.
>
> 	add vlan "network0" { id 100; proto 0x8100; }
>         add vlan "network1" { id 101; }
> 	... encap vlan push ip daddr map { 192.168.0.0/24 : "network0",
> 					   192.168.1.0/24 : "network1" }
>
> So the VLAN object does not come with the operation type, instead this
> is specified through the encap statement, that would require a bit more
> work on the object infrastructure which is probably a good idea.
>
> This is work-in-progress, syntax is tentative, comments welcome.
>
> Thanks.
>
> Pablo Neira Ayuso (2):
>   netfilter: nf_tables: add decapsulation support
>   netfilter: nf_tables: add encapsulation support
>
>  include/uapi/linux/netfilter/nf_tables.h |  56 ++++-
>  net/netfilter/Kconfig                    |   6 +
>  net/netfilter/Makefile                   |   1 +
>  net/netfilter/nft_encap.c                | 341 +++++++++++++++++++++++++++++++
>  4 files changed, 403 insertions(+), 1 deletion(-)
>  create mode 100644 net/netfilter/nft_encap.c
>
> --
> 2.11.0
>
>
