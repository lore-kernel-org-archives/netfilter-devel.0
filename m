Return-Path: <SRS0=6lPY=BO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1D6FC433DF
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 10:20:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF6442086A
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 10:20:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="kOh7D492"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgHDKU1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Aug 2020 06:20:27 -0400
Received: from mx1.riseup.net ([198.252.153.129]:39858 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725924AbgHDKU0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Aug 2020 06:20:26 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4BLW3G4G00zFdpr;
        Tue,  4 Aug 2020 03:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1596536426; bh=PUErtgLvENB+qCqNXnkQvzk5sq8BHKJ+q8akWdouBDQ=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=kOh7D492wBhVR4yp1IxDPIfTMK4WHV0tG2E6qs3odoA2I4agxpoPvMSMZjlJ1fs53
         vj1zfqSPdwCv1GJQN4vZQ2YXRP0iXMNoznhltT15kKhqZONFmrw+slrfyZ/J0wmVe8
         gz3OvMZrB2lnfTL8Or/7ppj6l7yIVhMZj1pPfFkY=
X-Riseup-User-ID: 7C7A8338933C3D63952954D0276A19D99736451FBD7CAF84B8592D36BEFA3F92
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 4BLW3F1wsCzJnSm;
        Tue,  4 Aug 2020 03:20:06 -0700 (PDT)
Subject: Re: [PATCH nft v2 1/1] src: enable output with "nft --echo --json"
 and nftables syntax
To:     Phil Sutter <phil@nwl.cc>
References: <20200730195337.3627-1-guigom@riseup.net>
 <20200731000020.4230-2-guigom@riseup.net> <20200731092212.GA1850@salvia>
 <20200731123342.GF13697@orbyte.nwl.cc> <20200731125825.GA12545@salvia>
 <20200731134828.GG13697@orbyte.nwl.cc> <20200731173028.GA16302@salvia>
 <20200801000213.GN13697@orbyte.nwl.cc> <20200801192730.GA5485@salvia>
 <20200803125210.GR13697@orbyte.nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Eric Garver <erig@erig.me>
From:   "Jose M. Guisado" <guigom@riseup.net>
Message-ID: <7f2e0b36-bdd4-9de6-8306-cc54e84c8688@riseup.net>
Date:   Tue, 4 Aug 2020 12:20:05 +0200
MIME-Version: 1.0
In-Reply-To: <20200803125210.GR13697@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 3/8/20 14:52, Phil Sutter wrote:
> On Sat, Aug 01, 2020 at 09:27:30PM +0200, Pablo Neira Ayuso wrote:
>> We need an unified way to deal with --json --echo, whether the input
>> is native nft or json syntax.
> 
> We don't need, but seems we want. We have JSON output and JSON echo for
> a while now and code for both is distinct. I fail to see why this was OK
> but is no longer. From my perspective, Jose simply failed to see that
> JSON output code should be used for JSON echo if input is not JSON.

I will send a v4 for this patch honoring separate cases.

Only outputting JSON command objects when input has been native instead 
of JSON, for the latter the behavior is kept intact and no 
json_cmd_assoc is touched. I think that's what we are looking for right 
now. This shouldn't interfere with firewalld, right?.

Regards.


