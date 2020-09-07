Return-Path: <SRS0=Y+c4=CQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17CF0C2BB84
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Sep 2020 21:16:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6B39217A0
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Sep 2020 21:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599513401;
	bh=UDqE4koH6uSZouSZ9O9PDcwu3aSRG/Q2oReFsFVUaqU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=q7/6WU0BH1lRRoNU3fVkBtSPKkOGyO4Uhk6dBZUI0SIMz/qPs4HjaHK1CXGbIJ6NW
	 L3S6bwOJoKJIH+8tz/78XsfzS+BC4mzdzfX4MXiTWwaPgVMxUy3l/ZbdBDL+nC88C+
	 GMsHdBGVlkQT42LrTtWZ5WRpkJbpSZbsF/o71tQY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgIGVQk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Sep 2020 17:16:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726871AbgIGVQi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Sep 2020 17:16:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DFC42145D;
        Mon,  7 Sep 2020 21:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599513398;
        bh=UDqE4koH6uSZouSZ9O9PDcwu3aSRG/Q2oReFsFVUaqU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qRGNJDFJIFvnmQY3EWCE+xE8I2o+kw5xS2eqiyVan7gIiwjlxW61NB10UzeRO8q7F
         buAmE6vA/fqCy0KK7s/9Nvs7rfpwWMED2iEUj6+FM9ExMFTUdR4KuCV9pvT/JOIgEq
         63cCbxHURamwdDtbAgVaR/fiTMs/c+SrWCVOAOiM=
Date:   Mon, 7 Sep 2020 14:16:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Fabian Frederick <fabf@skynet.be>, davem@davemloft.net,
        fw@strlen.de, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/1 net-next] selftests/net: replace obsolete NFT_CHAIN
 configuration
Message-ID: <20200907141636.6b61a838@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200907161428.16847-1-fabf@skynet.be>
References: <20200907161428.16847-1-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon,  7 Sep 2020 18:14:28 +0200 Fabian Frederick wrote:
> Replace old parameters with global NFT_NAT from commit db8ab38880e0
> ("netfilter: nf_tables: merge ipv4 and ipv6 nat chain types")
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  tools/testing/selftests/net/config | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
> index 3b42c06b59858..5a57ea02802df 100644
> --- a/tools/testing/selftests/net/config
> +++ b/tools/testing/selftests/net/config
> @@ -24,8 +24,7 @@ CONFIG_IP_NF_NAT=m
>  CONFIG_NF_TABLES=m
>  CONFIG_NF_TABLES_IPV6=y
>  CONFIG_NF_TABLES_IPV4=y
> -CONFIG_NFT_CHAIN_NAT_IPV6=m
> -CONFIG_NFT_CHAIN_NAT_IPV4=m
> +CONFIG_NFT_NAT=m
>  CONFIG_NET_SCH_FQ=m
>  CONFIG_NET_SCH_ETF=m
>  CONFIG_NET_SCH_NETEM=y

Pablo, looks like netfilter business, I'm leaving this patch to you
unless you say otherwise.
