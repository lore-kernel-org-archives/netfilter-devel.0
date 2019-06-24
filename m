Return-Path: <SRS0=O4lm=UX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F3AAC43613
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 08:09:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D52432083D
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 08:08:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="eBLtsyFn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfFXII7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Jun 2019 04:08:59 -0400
Received: from mx1.riseup.net ([198.252.153.129]:53736 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbfFXII6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jun 2019 04:08:58 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 2613A1A2EDB;
        Mon, 24 Jun 2019 01:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1561363738; bh=lWEZ2mpB3X+5urNoc9c5AiaWz7D6SIhVEV/Bx61GaNw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=eBLtsyFn6UIHrMD9bdyhWyNwU/I7Tpc90PtsotCtTG9rlyS5W34YhQMPvvo0dVvw6
         RxPAT2KvKK5IktLG+bVCmwhzZCR6Lr5hfQ6/C4QtL2P4a54oguBxb40C2wYz4pa4dW
         xiw0RWftEDF8VfDKjoCi3htOjH3HatEcQhIHs4kA=
X-Riseup-User-ID: 9644F6437072A9F8D48F4E077D05E5BCAD7F49A3DD8AE23B8F50D1C28422F86C
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id C3E3322229D;
        Mon, 24 Jun 2019 01:08:56 -0700 (PDT)
Subject: Re: Is this possible SYN Proxy bug?
To:     =?UTF-8?Q?=c4=b0brahim_Ercan?= <ibrahim.metu@gmail.com>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
References: <CAK6Qs9mam2U6JdeBnkzX9sfdeWWkLx_+ZgHOTmYjSC2wKfg0cQ@mail.gmail.com>
 <20190618104041.unuonhmuvgnlty3l@breakpoint.cc>
 <CAK6Qs9kmxqOaCjgcBefPR-NKEdGKTcfKUL_tu09CQYp3OT5krA@mail.gmail.com>
 <20190618115905.6kd2hqg2hlbs5frc@breakpoint.cc>
 <CAK6Qs9mTkAaH9+RqzmtrbNps1=NtW4c8wtJy7Kjay=r7VSJwsQ@mail.gmail.com>
 <20190618124026.4kvpdkbstdgaluij@breakpoint.cc>
 <CAK6Qs9nak4Aes9BXGsHC8SGGXmWGGrhPwAPQY5brFXtUzLkd-A@mail.gmail.com>
 <CAK6Qs9=E9r_hPB6QX+P5Dx+fGetM5pcgxBsrDt+XJBeZhUcimQ@mail.gmail.com>
 <20190621111021.2nqtvdq3qq2gbfqy@breakpoint.cc>
 <CAK6Qs9m88cgpFPaVp2qfQsepgtoa02vap1wzkdkgaSuTMm_ELw@mail.gmail.com>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <dbf0c610-7177-a37d-2358-60f091d6f963@riseup.net>
Date:   Mon, 24 Jun 2019 10:09:08 +0200
MIME-Version: 1.0
In-Reply-To: <CAK6Qs9m88cgpFPaVp2qfQsepgtoa02vap1wzkdkgaSuTMm_ELw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Ibrahim,

On 6/24/19 9:55 AM, İbrahim Ercan wrote:
> On Fri, Jun 21, 2019 at 2:10 PM Florian Westphal <fw@strlen.de> wrote:
>>
>> Yes, something like this is needed, i.e. we need to pass two
>> mss values -- one from info->mss ("server") that we need to
>> place in the tcp options sent to client and one containing
>> the clients mss that we should encode into the cookie.
>>
>> I think you can pass "u16 client_mssinfo" instead of u16* pointer.
> 
> Hi Florian.
> 
> We tested fixed code on real environment and we are still getting some
> errors. We have a customer using syn proxy in front of a point of sale
> (POS) application and they reported that about %0.4 of connections are
> erroneous.
> When I examine traffic from pcap file, I saw connections opens
> successfully but somehow something goes wrong after then.
> If we deactivates syn proxy, problem goes away. So we are sure it is
> caused by syn proxy.
> How can I debug syn proxy further? Do you have any suggestion?
> 
> Regards.
> 

I am working on synproxy right now, I am going to test it in different
environments and debug it. Please let me know if you have any
recommended environment on mind.

Thanks,
Fernando.
