Return-Path: <SRS0=20ch=WJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CE53C433FF
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 10:58:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08A872067D
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 10:58:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbfHMK6M (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Aug 2019 06:58:12 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:36527 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbfHMK6M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Aug 2019 06:58:12 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 62849415E9;
        Tue, 13 Aug 2019 18:58:09 +0800 (CST)
Subject: Re: [PATCH nf-next v3 0/9] netfilter: nf_tables_offload: support more
 expr and obj offload
From:   wenxu <wenxu@ucloud.cn>
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
References: <1564668086-16260-1-git-send-email-wenxu@ucloud.cn>
Message-ID: <e43baf4a-0137-16ca-91cb-ae622b03211c@ucloud.cn>
Date:   Tue, 13 Aug 2019 18:58:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1564668086-16260-1-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVSU5IS0tLSU5CSEJCT0pZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6KxQ6Tio4Ejg6FzowCwsLPQkY
        KUwwC0xVSlVKTk1OTUJIQ0NCTUJNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBT0xCTzcG
X-HM-Tid: 0a6c8aa0cbe52086kuqy62849415e9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi pablo,

How about also for this series?


On 8/1/2019 10:01 PM, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
>
> This series patch support more expr and obj offload: 
> fw_nedev, set payload, tunnel encap/decap action,
> tunnel meta match, objref offload
>
> The follwing is the test sample:
>
> # nft add table netdev firewall
> # nft add tunnel netdev firewall encap tunid 1000 tundst 0xf198a8ac tunsrc 0x4b98a8ac tunrelease 0
> # nft add tunnel netdev firewall decap tunid 0 tundst 0 tunsrc 0  tunrelease 1
> # nft add chain netdev firewall aclout { type filter hook ingress device mlx_pf0vf0 priority - 300 \; }
> # nft --debug=netlink add rule netdev firewall aclout ip daddr 10.0.1.7  @ll,0,48 set 0x00002e9ca06e2596 @ll,48,48 set 0xfaffffffffff tunnel name encap fwd to gretap
>   [ meta load protocol => reg 1 ]
>   [ cmp eq reg 1 0x00000008 ]
>   [ payload load 4b @ network header + 16 => reg 1 ]
>   [ cmp eq reg 1 0x0701000a ]
>   [ immediate reg 1 0x6ea09c2e 0x00009625 ]
>   [ payload write reg 1 => 6b @ link header + 0 csum_type 0 csum_off 0 csum_flags 0x0 ]
>   [ immediate reg 1 0xfffffffa 0x0000ffff ]
>   [ payload write reg 1 => 6b @ link header + 6 csum_type 0 csum_off 0 csum_flags 0x0 ]
>   [ objref type 6 name encap ]
>   [ immediate reg 1 0x00000019 ]
>   [ fwd sreg_dev 1 ]
>
>
> # nft add chain netdev firewall aclin { type filter hook ingress device gretap priority - 300 \; }
> # nft --debug=netlink add rule netdev firewall aclin ip daddr 10.0.0.7 tunnel tunid 1000 tunnel tundst 172.168.152.75 tunnel tunsrc 172.168.152.241 tunnel name decap @ll,0,48 set 0x0000525400001275 @ll,48,48 set 0xfaffffffffff fwd to mlx_pf0vf0
>   [ meta load protocol => reg 1 ]
>   [ cmp eq reg 1 0x00000008 ]
>   [ payload load 4b @ network header + 16 => reg 1 ]
>   [ cmp eq reg 1 0x0700000a ]
>   [ tunnel load id => reg 1 ]
>   [ cmp eq reg 1 0x000003e8 ]
>   [ tunnel load tun_dst => reg 1 ]
>   [ cmp eq reg 1 0xaca8984b ]
>   [ tunnel load tun_src => reg 1 ]
>   [ cmp eq reg 1 0xaca898f1 ]
>   [ objref type 6 name decap ]
>   [ immediate reg 1 0x00005452 0x00007512 ]
>   [ payload write reg 1 => 6b @ link header + 0 csum_type 0 csum_off 0 csum_flags 0x0 ]
>   [ immediate reg 1 0xfffffffa 0x0000ffff ]
>   [ payload write reg 1 => 6b @ link header + 6 csum_type 0 csum_off 0 csum_flags 0x0 ]
>   [ immediate reg 1 0x0000000f ]
>   [ fwd sreg_dev 1 ]
>
> wenxu (9):
>   netfilter: nf_flow_offload: add net in offload_ctx
>   netfilter: nf_tables_offload: add offload_actions callback
>   netfilter: nft_fwd_netdev: add fw_netdev action support
>   netfilter: nft_payload: add nft_set_payload offload support
>   netfilter: nft_tunnel: support NFT_TUNNEL_SRC/DST_IP match
>   netfilter: nft_tunnel: support tunnel meta match offload
>   netfilter: nft_tunnel: add NFTA_TUNNEL_KEY_RELEASE action
>   netfilter: nft_objref: add nft_objref_type offload
>   netfilter: nft_tunnel: support nft_tunnel_obj offload
>
>  include/net/netfilter/nf_tables.h         |  10 ++-
>  include/net/netfilter/nf_tables_offload.h |   7 +-
>  include/uapi/linux/netfilter/nf_tables.h  |   3 +
>  net/netfilter/nf_tables_api.c             |   2 +-
>  net/netfilter/nf_tables_offload.c         |   7 +-
>  net/netfilter/nft_fwd_netdev.c            |  27 +++++++
>  net/netfilter/nft_immediate.c             |   2 +-
>  net/netfilter/nft_objref.c                |  15 ++++
>  net/netfilter/nft_payload.c               |  56 ++++++++++++++
>  net/netfilter/nft_tunnel.c                | 123 ++++++++++++++++++++++++++----
>  10 files changed, 230 insertions(+), 22 deletions(-)
>
