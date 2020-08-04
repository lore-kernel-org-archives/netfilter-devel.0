Return-Path: <SRS0=6lPY=BO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DC0AC433E0
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 15:47:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38B552177B
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 15:47:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="e8EGy3n3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbgHDPrN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Aug 2020 11:47:13 -0400
Received: from mx1.riseup.net ([198.252.153.129]:44808 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726276AbgHDPrN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Aug 2020 11:47:13 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4BLfJb5D8pzDsYT;
        Tue,  4 Aug 2020 08:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1596556031; bh=tLMeHEfUO1k3j+3dXXEoD3l6tvKcO6NJrcSPAopPRDQ=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=e8EGy3n3Hj60OjvXKdft6CwIKbLHDMBu7fK9isStoDHeGDPAqbtCdqliLdG2QR9Ga
         fqc7YY3sNonzG7/3iuITvBARjPlBab9WIsWa6lzB5f1i6KfJfgfMSuTvSFNMjdzc4y
         Jr6Ydya+cV8L+nCp1fGWyQVrJTFGN5S/6zCHwU24=
X-Riseup-User-ID: 2A5A6ED007FB38136B599FF4E1D1E118883BC8AC67F0B26D6786298E5A434D08
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 4BLfJZ3wFTzJqpW;
        Tue,  4 Aug 2020 08:47:10 -0700 (PDT)
Subject: Re: [PATCH nft v4] src: enable json echo output when reading native
 syntax
To:     Phil Sutter <phil@nwl.cc>
References: <20200731104944.21384-1-guigom@riseup.net>
 <20200804103846.58872-1-guigom@riseup.net>
 <20200804123744.GV13697@orbyte.nwl.cc>
 <87971ac3-ed9c-9923-ca3f-df6dfb8b94d9@riseup.net>
 <20200804131423.GW13697@orbyte.nwl.cc>
 <6bf33b55-6439-0ae5-9dbf-e18c01969d42@riseup.net>
 <20200804140454.GA6002@salvia> <20200804142027.GX13697@orbyte.nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, erig@erig.me
From:   "Jose M. Guisado" <guigom@riseup.net>
Message-ID: <09d65ccb-b4ea-986c-d2c2-a035f312d31d@riseup.net>
Date:   Tue, 4 Aug 2020 17:47:09 +0200
MIME-Version: 1.0
In-Reply-To: <20200804142027.GX13697@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 4/8/20 16:20, Phil Sutter wrote:
> Yes, 'nft -j monitor' output has always been like this. Given that
> monitor potentially runs for a while and picks up multiple distinct
> ruleset changes, I wonder how it *should* behave.
> 
>> If it's not wrapped by the top-level nftables root then this is
>> unparseable.
> > We could change monitor code to add the wrapping "nftables" object to
> every line printed:
> 
> --- a/src/json.c
> +++ b/src/json.c
> @@ -1857,7 +1857,8 @@ int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd)
>   static void monitor_print_json(struct netlink_mon_handler *monh,
>                                 const char *cmd, json_t *obj)
>   {
> -       obj = json_pack("{s:o}", cmd, obj);
> +       obj = json_pack("{s:[o, {s:o}]}", "nftables",
> +                       generate_json_metainfo(), cmd, obj);
>          json_dumpf(obj, monh->ctx->nft->output.output_fp, 0);
>          json_decref(obj);
>   }
> 
> Cheers, Phil
>
This would work on a line by line basis.

After giving another read to COMMAND OBJECTS section of 
libnftables-json(5) the only thing that comes to mind is that a line by 
line basis of JSON command objects would not take advantage of batching. 
If I'm not mistaken, each list of cmds is encapsulated inside the 
{nftables : ...} json object and it is then tried to be sent to netlink 
to be batched.

In addition, the output as a whole could not be parseable , only a 
single "nftables" object is expected when nft input is json.

My previous comments assume whole output of echo is expected to be 
admissible as input in nft for reproducibility, but I don't know if that 
is the case.


Regards.
