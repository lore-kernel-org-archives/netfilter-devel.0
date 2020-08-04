Return-Path: <SRS0=6lPY=BO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89E63C433DF
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 13:44:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52FE82075D
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 13:44:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="IPQU0mpv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725864AbgHDNo2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Aug 2020 09:44:28 -0400
Received: from mx1.riseup.net ([198.252.153.129]:40946 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725826AbgHDNo1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Aug 2020 09:44:27 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4BLbZz2N8nzDqts;
        Tue,  4 Aug 2020 06:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1596548667; bh=aFHvKNxy1LhXgulNfH4WUZH/EFthfTFpwVBNihIkvAg=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=IPQU0mpvDMaKEdtgCIwz6/VaNrtI/wThcK2oMpt1rVaqmISwxp4wzg/bpnBnD4SAG
         d+ufoOBTOG+42GqVEh2NSVqvZ+wSz06z42FJ3mSTnlt6SZq5eJyKhYikFvk39Zy4dm
         Bth594SKlag9DrwrGBeZ2s8MylEE/U5s0j+wyBqA=
X-Riseup-User-ID: E1A0B4FCFE4A1489BA7661D406DC641ADD998DEC5104BA16A3B5E71DEBAF07E7
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 4BLbZy1vZtzJmg8;
        Tue,  4 Aug 2020 06:44:26 -0700 (PDT)
Subject: Re: [PATCH nft v4] src: enable json echo output when reading native
 syntax
To:     Phil Sutter <phil@nwl.cc>
References: <20200731104944.21384-1-guigom@riseup.net>
 <20200804103846.58872-1-guigom@riseup.net>
 <20200804123744.GV13697@orbyte.nwl.cc>
 <87971ac3-ed9c-9923-ca3f-df6dfb8b94d9@riseup.net>
 <20200804131423.GW13697@orbyte.nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, pablo@netfilter.org, erig@erig.me
From:   "Jose M. Guisado" <guigom@riseup.net>
Message-ID: <6bf33b55-6439-0ae5-9dbf-e18c01969d42@riseup.net>
Date:   Tue, 4 Aug 2020 15:44:25 +0200
MIME-Version: 1.0
In-Reply-To: <20200804131423.GW13697@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil.

On 4/8/20 15:14, Phil Sutter wrote:
> Hi,
> 
> On Tue, Aug 04, 2020 at 03:05:25PM +0200, Jose M. Guisado wrote:
>> On 4/8/20 14:37, Phil Sutter wrote:
>>> Why not just:
>>>
>>> --- a/src/monitor.c
>>> +++ b/src/monitor.c
>>> @@ -922,8 +922,11 @@ int netlink_echo_callback(const struct nlmsghdr *nlh, void *data)
>>>           if (!nft_output_echo(&echo_monh.ctx->nft->output))
>>>                   return MNL_CB_OK;
>>>    
>>> -       if (nft_output_json(&ctx->nft->output))
>>> -               return json_events_cb(nlh, &echo_monh);
>>> +       if (nft_output_json(&ctx->nft->output)) {
>>> +               if (ctx->nft->json_root)
>>> +                       return json_events_cb(nlh, &echo_monh);
>>> +               echo_monh.format = NFTNL_OUTPUT_JSON;
>>> +       }
>>>    
>>>           return netlink_events_cb(nlh, &echo_monh);
>>>    }
>>>
>>> At a first glance, this seems to work just fine.
>>>
>>> Cheers, Phil
>>
>> This does not output anything on my machine. This is because json_echo
>> is not initialized before netlink_echo_callback.
> 
> Please try my diff above on upstream's master without your changes. In
> the tree I did above changes, no symbol named 'json_echo' exists.
> 
> Cheers, Phil

Just tested it, it works great on my machine. As it outputs the same 
that would a running nft monitor.

I'm imagining this is preferred if there's no need having the json 
commands in the output be wrapped inside list of a single json object 
with its metainfo. That's the main difference with your patch.

Regards!

