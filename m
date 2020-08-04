Return-Path: <SRS0=6lPY=BO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A05C433DF
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 13:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71774207FC
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 13:05:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="sOisWsUS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgHDNF3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Aug 2020 09:05:29 -0400
Received: from mx1.riseup.net ([198.252.153.129]:51622 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbgHDNF3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Aug 2020 09:05:29 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4BLZk02SsTzDsZ7;
        Tue,  4 Aug 2020 06:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1596546328; bh=poFMUTGMs2Ei/ek7K1VRJy//ylwhqh3kvYId1OaObW0=;
        h=Subject:To:References:From:Cc:Date:In-Reply-To:From;
        b=sOisWsUS4lRR7PM8XnNkd54M79K6AvMP/XMSI7UHRia3UCkGz0UZbWJHYMCnSrPTN
         AkdWZuBGymDW0z27gZy+W6huZWTs+COsCv9SfQBZ2zXIeLmO/XyTi8NcSVQNOcGGO5
         yf4GEeitbE3iZ9JJ2atrxrXpKKxnFExGQ3gRNWEk=
X-Riseup-User-ID: 41ACDB8569040EE771857F083211B80CF0A614330470AE6D0282534DF4CA01AA
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 4BLZjz1zymzJmm0;
        Tue,  4 Aug 2020 06:05:27 -0700 (PDT)
Subject: Re: [PATCH nft v4] src: enable json echo output when reading native
 syntax
To:     Phil Sutter <phil@nwl.cc>
References: <20200731104944.21384-1-guigom@riseup.net>
 <20200804103846.58872-1-guigom@riseup.net>
 <20200804123744.GV13697@orbyte.nwl.cc>
From:   "Jose M. Guisado" <guigom@riseup.net>
Cc:     netfilter-devel@vger.kernel.org, pablo@netfilter.org, erig@erig.me
Message-ID: <87971ac3-ed9c-9923-ca3f-df6dfb8b94d9@riseup.net>
Date:   Tue, 4 Aug 2020 15:05:25 +0200
MIME-Version: 1.0
In-Reply-To: <20200804123744.GV13697@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 4/8/20 14:37, Phil Sutter wrote:
> Why not just:
> 
> --- a/src/monitor.c
> +++ b/src/monitor.c
> @@ -922,8 +922,11 @@ int netlink_echo_callback(const struct nlmsghdr *nlh, void *data)
>          if (!nft_output_echo(&echo_monh.ctx->nft->output))
>                  return MNL_CB_OK;
>   
> -       if (nft_output_json(&ctx->nft->output))
> -               return json_events_cb(nlh, &echo_monh);
> +       if (nft_output_json(&ctx->nft->output)) {
> +               if (ctx->nft->json_root)
> +                       return json_events_cb(nlh, &echo_monh);
> +               echo_monh.format = NFTNL_OUTPUT_JSON;
> +       }
>   
>          return netlink_events_cb(nlh, &echo_monh);
>   }
> 
> At a first glance, this seems to work just fine.
> 
> Cheers, Phil

This does not output anything on my machine. This is because json_echo 
is not initialized before netlink_echo_callback.

The mock monitor is responsible of appending the appropriate json cmd 
object to nft->json_echo, so we need it initialized when the case is as 
we have discussed before, native input and echo+json.

In addition netlink_echo_callback is called each time we receive 
something from the mnl socket. So checking if nft->json_echo is already 
initialized is necessary too, if not checked only the last response is 
shown, and for each past response that means a lost json_t reference to 
an array of cmd objs for that given response.

Regards.
