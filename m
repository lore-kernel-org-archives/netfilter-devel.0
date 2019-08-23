Return-Path: <SRS0=Ar4o=WT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1B06C3A5A2
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Aug 2019 12:36:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD9B921897
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Aug 2019 12:36:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389440AbfHWMgY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 23 Aug 2019 08:36:24 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:34937 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389160AbfHWMgY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Aug 2019 08:36:24 -0400
Received: from [31.4.212.198] (helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <pablo@gnumonks.org>)
        id 1i18ng-0006pj-Ei; Fri, 23 Aug 2019 14:36:22 +0200
Date:   Fri, 23 Aug 2019 14:36:14 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v4] meta: add ibrpvid and ibrvproto support
Message-ID: <20190823123614.qnusroitogrjg74m@salvia>
References: <1566382238-5286-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566382238-5286-1-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 21, 2019 at 06:10:38PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> This allows you to match the bridge pvid and vlan protocol, for
> instance:
> 
> nft add rule bridge firewall zones meta ibrvproto 0x8100
> nft add rule bridge firewall zones meta ibrpvid 100
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  src/meta.c                     |  6 ++++++
>  tests/py/bridge/meta.t         |  2 ++
>  tests/py/bridge/meta.t.json    | 26 ++++++++++++++++++++++++++
>  tests/py/bridge/meta.t.payload |  9 +++++++++
>  4 files changed, 43 insertions(+)
> 
> diff --git a/src/meta.c b/src/meta.c
> index 5901c99..d45d757 100644
> --- a/src/meta.c
> +++ b/src/meta.c
> @@ -442,6 +442,12 @@ const struct meta_template meta_templates[] = {
>  	[NFT_META_OIFKIND]	= META_TEMPLATE("oifkind",   &ifname_type,
>  						IFNAMSIZ * BITS_PER_BYTE,
>  						BYTEORDER_HOST_ENDIAN),
> +	[NFT_META_BRI_IIFPVID]	= META_TEMPLATE("ibrpvid",   &integer_type,

Just notices another nitpick: I think if you use etheraddr_type
instead of integer_type here, you would get a nicer output.
