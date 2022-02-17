Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7786FC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Feb 2022 17:24:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243677AbiBQRZB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Feb 2022 12:25:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236689AbiBQRZB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Feb 2022 12:25:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23E32B04A8;
        Thu, 17 Feb 2022 09:24:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56B18B82383;
        Thu, 17 Feb 2022 17:24:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA6EC340E8;
        Thu, 17 Feb 2022 17:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645118684;
        bh=c7Q3U62Pgt9dUa8A3vbK3+gTpGkYI+kFP7qjwdTB5A0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SQeMyth+HB39KiTJEFABJI32AiWg8jgVWY9dPDuL11J4mYZcYvAnM+vaBRpxXQGLg
         z/Z1jglAPo6SRk2YHiUb2B9x/V1DnQ+CF89vu9RzKjnE9JIQC3loCa+ls8kUM3iyXJ
         aN5bAtFkUmwt/ptIT6EG0259yQ4c5m+e8DQpkcQ93Sj26q7aQVjxAAN671Gpky6MAs
         rSB7WpOKcPqdvKec9Of6pAza0MLajXhFECfL1HmXTWxhVxzwmxLrqTzYduC0p8gHdT
         4FrT18i0B5waFzeAz2WNRLOjpRD7GdHEjdmQMiLTWApX0/RqKWGZuv7loVui85FUos
         e0AqXIwVfbUbA==
Date:   Thu, 17 Feb 2022 09:24:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: Re: [PATCH net-next v1] net: Use csum_replace_... and csum_sub()
 helpers instead of opencoding
Message-ID: <20220217092442.4948b48c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <fe60030b6f674d9bf41f56426a4b0a8a9db0d20f.1645112415.git.christophe.leroy@csgroup.eu>
References: <fe60030b6f674d9bf41f56426a4b0a8a9db0d20f.1645112415.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 17 Feb 2022 16:43:55 +0100 Christophe Leroy wrote:
>  static inline void nft_csum_replace(__sum16 *sum, __wsum fsum, __wsum tsum)
>  {
> -	*sum = csum_fold(csum_add(csum_sub(~csum_unfold(*sum), fsum), tsum));
> +	csum_replace4(sum, fsum, tsum);

Sparse says:

net/netfilter/nft_payload.c:560:28: warning: incorrect type in argument 2 (different base types)
net/netfilter/nft_payload.c:560:28:    expected restricted __be32 [usertype] from
net/netfilter/nft_payload.c:560:28:    got restricted __wsum [usertype] fsum
