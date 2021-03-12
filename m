Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64CFEC433E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Mar 2021 07:37:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C12164E92
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Mar 2021 07:37:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbhCLHgm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 12 Mar 2021 02:36:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbhCLHgP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Mar 2021 02:36:15 -0500
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20AF5C061574;
        Thu, 11 Mar 2021 23:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=To:References:Message-Id:Date:Cc:In-Reply-To:From:Subject:
        Mime-Version:Content-Transfer-Encoding:Content-Type:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=21e3P3BERZjpr1R1XeAOy+QyHe2lycW7CQHZSQ7ZslI=; b=WK2nlL7+v+sb/INnXZEVRtm7RM
        GtEiaZLyS0Vp6yxA0eDF3x0MzTfJX+Pr2RxFt1jMoKplz+CYWUBHu9BFgbyjomB0yu0ZKm0yJcpyE
        uZSFbe6ssp8lS+1VtdNi2Kx2rVqevUetyPJwu9nsrRUl2mX569fVjCbyX+k42ciDKv0U=;
Received: from [2a01:598:d003:52c:9ccd:8dfb:e6b5:f86a]
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1lKcL5-0006nI-Ft; Fri, 12 Mar 2021 08:36:03 +0100
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH net-next 23/23] net: ethernet: mtk_eth_soc: fix parsing packets in GDM
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <20210311003604.22199-24-pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Date:   Fri, 12 Mar 2021 08:36:02 +0100
Message-Id: <D23EBDC5-71D7-4232-A321-78B39FFBAF77@nbd.name>
References: <20210311003604.22199-24-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
X-Mailer: iPhone Mail (17F75)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


> On 11. Mar 2021, at 01:36, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>=20
> =EF=BB=BFFrom: Felix Fietkau <nbd@nbd.name>
>=20
> When using DSA, set the special tag in GDM ingress control to allow the MA=
C
> to parse packets properly earlier. This affects rx DMA source port reporti=
ng.
>=20
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
In order to avoid regressions within the series, this patch needs to come be=
fore patch 21

- Felix=

