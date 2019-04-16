Return-Path: <SRS0=dF0f=SS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91315C10F13
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Apr 2019 06:51:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FAE120675
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Apr 2019 06:51:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FBXztI/4";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WDS6y/Nu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbfDPGvm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Apr 2019 02:51:42 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38080 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbfDPGvm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Apr 2019 02:51:42 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5A2DE60E3F; Tue, 16 Apr 2019 06:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555397501;
        bh=JVpNuDKVbLqhhSEM9RngpsopzQk5mz53YQNJ4RL/wsA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=FBXztI/4KC5lU6S0k3i4XrgrYWH+yifOiEgEBNzH+RDHgpff9LXMzsEIczgohapa7
         e1TepMIxO9LauqzXgqIeF/xbiX7SFkXXOsnpwC3uglbVSxWM1V+fnycTUK4ZZz1gQV
         bvVwEgSz+aJPkx05GUDJ2vNjQinIuELyoLioPbRU=
Received: from [10.204.79.15] (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: mojha@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 42577608D4;
        Tue, 16 Apr 2019 06:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555397500;
        bh=JVpNuDKVbLqhhSEM9RngpsopzQk5mz53YQNJ4RL/wsA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=WDS6y/NumareBY+yZY4aNGbH/2+VeYdjCFU8oNICq15AIW/C3dXCaAdUC9RuZMZJy
         t0Qy1uXXd0YIIebUOnIBuHy7N8a0E9xbNIOtfZM+zylyfKhM2Z6ggMFDqyEzHAzlRZ
         KDu8TMxsbMSAW8gJ0ZuwHJRiEIT1e6t3pbRWB7aU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 42577608D4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=mojha@codeaurora.org
Subject: Re: [PATCH] [NETFILTER]: nf_conntrack_h323: fix spelling mistake
 "authenticaton" -> "authentication"
To:     Colin King <colin.king@canonical.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190415114414.24600-1-colin.king@canonical.com>
From:   Mukesh Ojha <mojha@codeaurora.org>
Message-ID: <90e0d4af-77c5-6e4b-a364-5b9e342c83be@codeaurora.org>
Date:   Tue, 16 Apr 2019 12:21:08 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190415114414.24600-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 4/15/2019 5:14 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> The appears to be a spelling mistake in one of the entries in the
> _SecurityCapabilities array. Fix this.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>

Cheers,
-Mukesh

> ---
>   net/netfilter/nf_conntrack_h323_types.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/netfilter/nf_conntrack_h323_types.c b/net/netfilter/nf_conntrack_h323_types.c
> index d880f3523c1d..95a0b3d6b24d 100644
> --- a/net/netfilter/nf_conntrack_h323_types.c
> +++ b/net/netfilter/nf_conntrack_h323_types.c
> @@ -1109,7 +1109,7 @@ static const struct field_t _SecurityCapabilities[] = {	/* SEQUENCE */
>   	 _NonStandardParameter},
>   	{FNAME("encryption") CHOICE, 2, 3, 3, SKIP | EXT, 0,
>   	 _SecurityServiceMode},
> -	{FNAME("authenticaton") CHOICE, 2, 3, 3, SKIP | EXT, 0,
> +	{FNAME("authentication") CHOICE, 2, 3, 3, SKIP | EXT, 0,
>   	 _SecurityServiceMode},
>   	{FNAME("integrity") CHOICE, 2, 3, 3, SKIP | EXT, 0,
>   	 _SecurityServiceMode},
